#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <signal.h>
#include <execinfo.h>
#include <setjmp.h>
#include <sys/mman.h>

// Forward declarations for debug tooling
void forge_stack_init(void);
int64_t forge_stack_used(void);
void forge_stack_check(const char* fn_name);
void forge_trace_enter(const char* fn_name);

// ---- Try/catch for LLVM crashes ----
static sigjmp_buf forge_try_jmp;
static volatile int forge_try_active = 0;

static void forge_try_handler(int signum) {
    if (forge_try_active) {
        forge_try_active = 0;
        siglongjmp(forge_try_jmp, 1);
    }
}

// Simple crash guard: returns 1 if code between try_begin/try_end crashed
static sigjmp_buf forge_guard_jmp;
static volatile int forge_guard_active = 0;

static void forge_guard_handler(int signum) {
    if (forge_guard_active) {
        forge_guard_active = 0;
        siglongjmp(forge_guard_jmp, 1);
    }
}

// Call before risky code. Returns 0 normally, 1 if recovering from crash.
int64_t forge_try_begin(void) {
    forge_guard_active = 1;
    struct sigaction sa;
    sa.sa_handler = forge_guard_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGBUS, &sa, NULL);
    return sigsetjmp(forge_guard_jmp, 1);
}

void forge_try_end(void) {
    forge_guard_active = 0;
}

// Returns 1 if the function crashed, 0 if OK
int64_t forge_try_call(void (*fn)(void)) {
    forge_try_active = 1;
    struct sigaction sa, old_segv, old_bus;
    sa.sa_handler = forge_try_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGSEGV, &sa, &old_segv);
    sigaction(SIGBUS, &sa, &old_bus);

    int crashed = 0;
    if (sigsetjmp(forge_try_jmp, 1) != 0) {
        crashed = 1;
    } else {
        fn();
    }

    forge_try_active = 0;
    sigaction(SIGSEGV, &old_segv, NULL);
    sigaction(SIGBUS, &old_bus, NULL);
    return crashed;
}

// ---- Signal handlers ----

static void forge_signal_handler(int signum) {
    const char* name;
    switch (signum) {
        case SIGSEGV: name = "segmentation fault"; break;
        case SIGABRT: name = "abort"; break;
        case SIGBUS:  name = "bus error"; break;
        default:      name = "unknown signal"; break;
    }
    const char* prefix = "forge: fatal error — ";
    write(STDERR_FILENO, prefix, strlen(prefix));
    write(STDERR_FILENO, name, strlen(name));
    write(STDERR_FILENO, "\n", 1);

    // Check if stack overflow
    int64_t used = forge_stack_used();
    if (used > 7 * 1024 * 1024) {
        const char* so_msg = " (likely STACK OVERFLOW)\n";
        write(STDERR_FILENO, so_msg, strlen(so_msg));
    }

    // Print backtrace for debugging
    void* frames[32];
    int nframes = backtrace(frames, 32);
    if (nframes > 0) {
        const char* bt_hdr = "\nBacktrace:\n";
        write(STDERR_FILENO, bt_hdr, strlen(bt_hdr));
        backtrace_symbols_fd(frames, nframes, STDERR_FILENO);
    }

    _exit(128 + signum);
}

__attribute__((constructor)) static void forge_install_signal_handlers(void) {
    struct sigaction sa;
    sa.sa_handler = forge_signal_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGABRT, &sa, NULL);
    sigaction(SIGBUS, &sa, NULL);
    // Init stack tracking
    forge_stack_init();
}

// ---- Reference counting ----

typedef struct {
    int64_t rc;
    // payload follows
} ForgeHeapObj;

void forge_rc_retain(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc++;
}

void forge_rc_release(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc--;
    if (obj->rc <= 0) {
        free(obj);
    }
}

// Arena allocator — bump pointer, never frees (compiler is short-lived)
#define ARENA_SIZE (8LL * 1024 * 1024 * 1024)  // 1GB arena
static char* _arena = NULL;
static int64_t _arena_pos = 0;

static int64_t _alloc_count = 0;
static int64_t _alloc_bytes = 0;
void* forge_alloc(int64_t size) {
    _alloc_count++;
    _alloc_bytes += size;
    // Align to 16 bytes
    size = (size + 15) & ~15;
    if (!_arena) {
        _arena = (char*)mmap(NULL, ARENA_SIZE, PROT_READ | PROT_WRITE,
                             MAP_PRIVATE | MAP_ANON, -1, 0);
        if (_arena == MAP_FAILED) { _arena = NULL; return malloc(size); }
    }
    if (_arena_pos + size > ARENA_SIZE) {
        return malloc(size); // fallback
    }
    void* ptr = _arena + _arena_pos;
    _arena_pos += size;
    return ptr;
}
int64_t forge_arena_used(void) { return _arena_pos; }
void forge_alloc_stats(void) {
    fprintf(stderr, "  [alloc] %lld calls, %lldMB total\n",
        (long long)_alloc_count, (long long)(_alloc_bytes / (1024*1024)));
    fflush(stderr);
}

// ---- Parser watchdog: detects infinite loops ----
static int64_t _wd_pos = -1;
static int64_t _wd_count = 0;
static int64_t _wd_total = 0;
static const char* _wd_last_fn = "";

void forge_watchdog(int64_t pos, const char* fn_name) {
    _wd_total++;
    // Report every 1000 calls with alloc stats
    if (_wd_total % 1000 == 0) {
        fprintf(stderr, "  [wd] %lld calls pos=%lld allocs=%lld/%lldMB\n",
            (long long)_wd_total, (long long)pos,
            (long long)_alloc_count, (long long)(_alloc_bytes/(1024*1024)));
        fflush(stderr);
    }
    if (pos == _wd_pos) {
        _wd_count++;
        if (_wd_count == 5000) {
            fprintf(stderr, "\n!!! PARSER LOOP DETECTED at pos=%lld fn=%s (after %lld total calls) !!!\n",
                (long long)pos, fn_name ? fn_name : "?", (long long)_wd_total);
            fflush(stderr);
            // Print stack trace and abort
            abort();
        }
    } else {
        _wd_pos = pos;
        _wd_count = 0;
    }
    // Progress every 10000 calls
    if (_wd_total % 10000 == 0) {
        fprintf(stderr, "  [wd] %lld calls, pos=%lld\n", (long long)_wd_total, (long long)pos);
        fflush(stderr);
    }
}

void forge_watchdog_reset(void) { _wd_pos = -1; _wd_count = 0; _wd_total = 0; }

// ---- Deep-copy helpers for bootstrap workaround ----
// The bootstrap compiler's codegen corrupts stack locals across extern
// function calls. These functions box values on the heap so they survive.

/// Box a pointer value on the heap. Returns a pointer to the heap slot.
void* forge_box_ptr(void* val) {
    void** slot = (void**)malloc(sizeof(void*));
    *slot = val;
    return (void*)slot;
}

/// Unbox a pointer from a heap slot.
void* forge_unbox_ptr(void* slot) {
    return *((void**)slot);
}

// ---- String allocation (plain malloc, no refcount header) ----
// ForgeString .ptr fields must be compatible with C free() and Rust CString::from_raw.
// forge_alloc adds an 8-byte refcount header which breaks C interop, so string
// buffers use plain malloc instead.

static void* forge_string_alloc(int64_t size) {
    return malloc(size);
}

// ---- String operations ----

typedef struct {
    char* ptr;
    int64_t len;
} ForgeString;

ForgeString forge_string_new(const char* data, int64_t len) {
    char* buf = (char*)forge_string_alloc(len + 1);
    memcpy(buf, data, len);
    buf[len] = '\0';
    return (ForgeString){ .ptr = buf, .len = len };
}

ForgeString forge_string_concat(ForgeString a, ForgeString b) {
    // Fast path: empty + anything = anything (no alloc)
    if (a.len == 0) return b;
    if (b.len == 0) return a;
    // Guard against bad pointers
    if (a.ptr == NULL || (uintptr_t)a.ptr < 4096) return b;
    if (b.ptr == NULL || (uintptr_t)b.ptr < 4096) return a;
    if (a.len < 0 || b.len < 0 || a.len > 10000000 || b.len > 10000000) {
        return (ForgeString){ .ptr = NULL, .len = 0 };
    }
    int64_t new_len = a.len + b.len;
    char* buf = (char*)forge_string_alloc(new_len + 1);
    memcpy(buf, a.ptr, a.len);
    memcpy(buf + a.len, b.ptr, b.len);
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

// ---- Print functions ----

void forge_print_int(int64_t value) {
    printf("%lld", (long long)value);
}

// Format a float, ensuring at least one decimal place (5.0 not 5)
static int fmt_float(char *buf, size_t size, double value) {
    int len = snprintf(buf, size, "%g", value);
    // If no decimal point or exponent, append .0
    int has_dot = 0;
    for (int i = 0; i < len; i++) {
        if (buf[i] == '.' || buf[i] == 'e' || buf[i] == 'E' || buf[i] == 'n' || buf[i] == 'i') {
            has_dot = 1;
            break;
        }
    }
    if (!has_dot && len + 2 < (int)size) {
        buf[len] = '.';
        buf[len+1] = '0';
        buf[len+2] = '\0';
        len += 2;
    }
    return len;
}

void forge_print_float(double value) {
    char buf[64];
    fmt_float(buf, sizeof(buf), value);
    fputs(buf, stdout);
}

void forge_print_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stdout);
}

void forge_print_bool(int8_t value) {
    printf("%s", value ? "true" : "false");
}

void forge_println_string(ForgeString s) {
    if (s.ptr == NULL || (uintptr_t)s.ptr < 4096) {
        fprintf(stderr, "<bad str ptr=%p len=%lld>\n", s.ptr, (long long)s.len);
        fflush(stderr);
        return;
    }
    fwrite(s.ptr, 1, s.len, stdout);
    putchar('\n');
    fflush(stdout);
}

void forge_println_int(int64_t value) {
    printf("%lld\n", (long long)value);
}

void forge_println_float(double value) {
    char buf[64];
    fmt_float(buf, sizeof(buf), value);
    puts(buf);
}

void forge_println_bool(int8_t value) {
    printf("%s\n", value ? "true" : "false");
}

// ---- Stderr ----

void forge_eprint_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stderr);
}

void forge_eprint_int(int64_t value) {
    fprintf(stderr, "%lld", (long long)value);
}

void forge_eprint_float(double value) {
    char buf[64];
    fmt_float(buf, sizeof(buf), value);
    fputs(buf, stderr);
}

void forge_eprint_bool(int8_t value) {
    fprintf(stderr, "%s", value ? "true" : "false");
}

void forge_eprintln_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stderr);
    fputc('\n', stderr);
}

void forge_eprintln_int(int64_t value) {
    fprintf(stderr, "%lld\n", (long long)value);
}

void forge_eprintln_float(double value) {
    char buf[64];
    fmt_float(buf, sizeof(buf), value);
    fputs(buf, stderr);
    fputc('\n', stderr);
}

void forge_eprintln_bool(int8_t value) {
    fprintf(stderr, "%s\n", value ? "true" : "false");
}

// ---- Conversion ----

ForgeString forge_int_to_string(int64_t value) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%lld", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_float_to_string(double value) {
    char buf[64];
    int len = fmt_float(buf, sizeof(buf), value);
    return forge_string_new(buf, len);
}

ForgeString forge_bool_to_string(int8_t value) {
    return value ? forge_string_new("true", 4) : forge_string_new("false", 5);
}

// ---- String methods ----

int64_t forge_string_length(ForgeString s) {
    return s.len;
}

ForgeString forge_string_upper(ForgeString s) {
    char* buf = (char*)forge_string_alloc(s.len + 1);
    for (int64_t i = 0; i < s.len; i++) {
        buf[i] = (s.ptr[i] >= 'a' && s.ptr[i] <= 'z') ? s.ptr[i] - 32 : s.ptr[i];
    }
    buf[s.len] = '\0';
    return (ForgeString){ .ptr = buf, .len = s.len };
}

ForgeString forge_string_lower(ForgeString s) {
    char* buf = (char*)forge_string_alloc(s.len + 1);
    for (int64_t i = 0; i < s.len; i++) {
        buf[i] = (s.ptr[i] >= 'A' && s.ptr[i] <= 'Z') ? s.ptr[i] + 32 : s.ptr[i];
    }
    buf[s.len] = '\0';
    return (ForgeString){ .ptr = buf, .len = s.len };
}

int8_t forge_string_contains(ForgeString haystack, ForgeString needle) {
    if (needle.len > haystack.len) return 0;
    if (needle.len == 0) return 1;
    for (int64_t i = 0; i <= haystack.len - needle.len; i++) {
        if (memcmp(haystack.ptr + i, needle.ptr, needle.len) == 0) {
            return 1;
        }
    }
    return 0;
}

ForgeString forge_string_trim(ForgeString s) {
    int64_t start = 0;
    int64_t end = s.len;
    while (start < end && (s.ptr[start] == ' ' || s.ptr[start] == '\t' || s.ptr[start] == '\n' || s.ptr[start] == '\r')) start++;
    while (end > start && (s.ptr[end-1] == ' ' || s.ptr[end-1] == '\t' || s.ptr[end-1] == '\n' || s.ptr[end-1] == '\r')) end--;
    int64_t new_len = end - start;
    return forge_string_new(s.ptr + start, new_len);
}

ForgeString forge_string_repeat(ForgeString s, int64_t count) {
    if (count <= 0 || s.len == 0) {
        return forge_string_new("", 0);
    }
    int64_t new_len = s.len * count;
    char* buf = (char*)forge_string_alloc(new_len + 1);
    for (int64_t i = 0; i < count; i++) {
        memcpy(buf + i * s.len, s.ptr, s.len);
    }
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

int8_t forge_string_starts_with(ForgeString s, ForgeString prefix) {
    if (prefix.len > s.len) return 0;
    if (prefix.len == 0) return 1;
    return memcmp(s.ptr, prefix.ptr, prefix.len) == 0 ? 1 : 0;
}

int8_t forge_string_ends_with(ForgeString s, ForgeString suffix) {
    if (suffix.len > s.len) return 0;
    if (suffix.len == 0) return 1;
    return memcmp(s.ptr + s.len - suffix.len, suffix.ptr, suffix.len) == 0 ? 1 : 0;
}

ForgeString forge_string_substring(ForgeString s, int64_t start, int64_t end) {
    if (start < 0) start = 0;
    if (end > s.len) end = s.len;
    if (start >= end) return forge_string_new("", 0);
    int64_t new_len = end - start;
    char* buf = (char*)forge_string_alloc(new_len + 1);
    memcpy(buf, s.ptr + start, new_len);
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

int64_t forge_string_index_of(ForgeString s, ForgeString sub) {
    if (sub.len == 0) return 0;
    if (sub.len > s.len) return -1;
    for (int64_t i = 0; i <= s.len - sub.len; i++) {
        if (memcmp(s.ptr + i, sub.ptr, sub.len) == 0) return i;
    }
    return -1;
}

int64_t forge_string_last_index_of(ForgeString s, ForgeString sub) {
    if (sub.len == 0) return s.len;
    if (sub.len > s.len) return -1;
    for (int64_t i = s.len - sub.len; i >= 0; i--) {
        if (memcmp(s.ptr + i, sub.ptr, sub.len) == 0) return i;
    }
    return -1;
}

ForgeString forge_string_replace(ForgeString s, ForgeString find, ForgeString replace) {
    if (find.len == 0) return forge_string_new(s.ptr, s.len);

    // Count occurrences
    int64_t count = 0;
    for (int64_t i = 0; i <= s.len - find.len; i++) {
        if (memcmp(s.ptr + i, find.ptr, find.len) == 0) {
            count++;
            i += find.len - 1;
        }
    }
    if (count == 0) return forge_string_new(s.ptr, s.len);

    int64_t new_len = s.len + count * (replace.len - find.len);
    char* buf = (char*)forge_string_alloc(new_len + 1);
    int64_t j = 0;
    for (int64_t i = 0; i < s.len; ) {
        if (i <= s.len - find.len && memcmp(s.ptr + i, find.ptr, find.len) == 0) {
            memcpy(buf + j, replace.ptr, replace.len);
            j += replace.len;
            i += find.len;
        } else {
            buf[j++] = s.ptr[i++];
        }
    }
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

int64_t forge_string_parse_int(ForgeString s) {
    // Simple atoi - skip whitespace, handle sign, parse digits
    int64_t i = 0;
    while (i < s.len && (s.ptr[i] == ' ' || s.ptr[i] == '\t')) i++;
    int64_t sign = 1;
    if (i < s.len && s.ptr[i] == '-') { sign = -1; i++; }
    else if (i < s.len && s.ptr[i] == '+') { i++; }
    int64_t result = 0;
    while (i < s.len && s.ptr[i] >= '0' && s.ptr[i] <= '9') {
        result = result * 10 + (s.ptr[i] - '0');
        i++;
    }
    return sign * result;
}

double forge_string_parse_float(ForgeString s) {
    // Null-terminate for strtod
    char buf[64];
    int64_t copy_len = s.len < 63 ? s.len : 63;
    memcpy(buf, s.ptr, copy_len);
    buf[copy_len] = '\0';
    return strtod(buf, NULL);
}

// ---- String comparison ----

static int eq_call_count = 0;
int8_t forge_string_eq(ForgeString a, ForgeString b) {
    if (a.len != b.len) return 0;
    if (a.ptr == NULL || b.ptr == NULL) return a.ptr == b.ptr ? 1 : 0;
    if ((uintptr_t)a.ptr < 4096 || (uintptr_t)b.ptr < 4096) return 0;
    if (a.len == 1) return a.ptr[0] == b.ptr[0] ? 1 : 0;
    return memcmp(a.ptr, b.ptr, a.len) == 0 ? 1 : 0;
}

// Lexicographic comparison: returns -1, 0, or 1
static int cmp_call_count = 0;
int64_t forge_string_compare(ForgeString a, ForgeString b) {
    if (a.ptr == NULL && b.ptr == NULL) return a.len == b.len ? 0 : (a.len < b.len ? -1 : 1);
    if (a.ptr == NULL) return b.len == 0 ? 0 : -1;
    if (b.ptr == NULL) return a.len == 0 ? 0 : 1;
    // Self-hosting workaround: i64 values stored as ForgeString due to type tracking bugs.
    // When comparing with 0: treat the ForgeString as an i64 if it looks like a small number.
    // An i64 stored as ForgeString: ptr field = the value, len field = uninitialized.
    // A valid ForgeString: ptr is a heap pointer (> 0x1000), len is non-negative and < 1M.
    if (b.ptr == NULL && b.len == 0) {
        // b is zero. Check if a is a misinterpreted i64.
        int64_t a_as_i64 = (int64_t)(intptr_t)a.ptr;
        // If a.ptr looks like a small integer (-1000..1000) or is clearly not a heap pointer,
        // treat it as numeric comparison
        if (a_as_i64 >= -10000 && a_as_i64 <= 10000) {
            return a_as_i64 < 0 ? -1 : (a_as_i64 > 0 ? 1 : 0);
        }
    }
    if ((uintptr_t)a.ptr < 4096 || (uintptr_t)b.ptr < 4096) {
        return a.ptr == b.ptr ? 0 : -1;
    }
    if (a.len < 0 || b.len < 0 || a.len > 1000000 || b.len > 1000000) {
        return a.len == b.len ? 0 : -1;
    }
    int64_t min_len = a.len < b.len ? a.len : b.len;
    int result = memcmp(a.ptr, b.ptr, min_len);
    if (result < 0) return -1;
    if (result > 0) return 1;
    if (a.len < b.len) return -1;
    if (a.len > b.len) return 1;
    return 0;
}

// ---- String byte/char access ----

// Shared bounds check helper — prints error and exits if index is out of range
static void forge_string_bounds_check(ForgeString s, int64_t index, const char* method) {
    if (index < 0 || index >= s.len) {
        fprintf(stderr, "error: %s index %lld out of bounds for string of length %lld\n",
                method, (long long)index, (long long)s.len);
        fprintf(stderr, "  hint: valid indices are 0..%lld\n", (long long)(s.len - 1));
        if (s.ptr && s.len > 0 && s.len < 200) {
            fprintf(stderr, "  string content: \"%.*s\"\n", (int)s.len, s.ptr);
        }
        exit(1);
    }
}

// Static lookup table for single ASCII characters — avoids malloc per char_at
static char ascii_chars[128][2]; // [char][0] = char, [1] = '\0'
static int ascii_chars_init = 0;
static void ensure_ascii_chars(void) {
    if (ascii_chars_init) return;
    for (int i = 0; i < 128; i++) {
        ascii_chars[i][0] = (char)i;
        ascii_chars[i][1] = '\0';
    }
    ascii_chars_init = 1;
}

// Fast byte access — returns ASCII code as int (no string allocation)
int64_t forge_string_byte_at(ForgeString s, int64_t index) {
    if (index < 0 || index >= s.len) return 0;
    return (int64_t)(unsigned char)s.ptr[index];
}

// C-side character classification (bypasses all Forge codegen issues)
int64_t forge_is_alpha(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    unsigned char c = (unsigned char)ch.ptr[0];
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}
int64_t forge_is_digit(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    unsigned char c = (unsigned char)ch.ptr[0];
    return c >= '0' && c <= '9';
}
int64_t forge_is_alnum(ForgeString ch) {
    return forge_is_alpha(ch) || forge_is_digit(ch);
}
int64_t forge_is_ident_start(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    return forge_is_alpha(ch) || ch.ptr[0] == '$';
}
int64_t forge_is_ident_continue(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    return forge_is_alnum(ch) || ch.ptr[0] == '$';
}
int64_t forge_is_hex_digit(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    unsigned char c = (unsigned char)ch.ptr[0];
    return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}
int64_t forge_is_whitespace_not_newline(ForgeString ch) {
    if (!ch.ptr || ch.len <= 0) return 0;
    unsigned char c = (unsigned char)ch.ptr[0];
    return c == ' ' || c == '\t';
}

// C-side keyword ID lookup (bypasses Statement.If tag corruption)
int64_t forge_kind_id_for_keyword(ForgeString text) {
    if (!text.ptr || text.len <= 0) return 0;
    #define KW(s, id) if (text.len == sizeof(s)-1 && memcmp(text.ptr, s, sizeof(s)-1) == 0) return id;
    KW("let", 20) KW("mut", 21) KW("const", 22) KW("fn", 23)
    KW("return", 24) KW("if", 25) KW("else", 26) KW("match", 27)
    KW("for", 28) KW("in", 29) KW("while", 30) KW("loop", 31)
    KW("break", 32) KW("continue", 33) KW("enum", 34) KW("type", 35)
    KW("use", 36) KW("mod", 37) KW("as", 38) KW("export", 39)
    KW("emit", 40) KW("on", 41) KW("trait", 42) KW("impl", 43)
    KW("defer", 44) KW("errdefer", 45) KW("spawn", 46) KW("parallel", 47)
    KW("with", 48) KW("catch", 49) KW("select", 50) KW("component", 51)
    KW("without", 52) KW("only", 53) KW("partial", 54) KW("is", 55)
    KW("table", 56) KW("Ok", 58) KW("Err", 59) KW("_", 60)
    KW("true", 5) KW("false", 5) KW("null", 8)
    #undef KW
    return 0;
}

// C-side parser position tracking
static int64_t _c_parser_pos = 0;
static void* _c_parser_ptr = NULL;  // pointer to Parser struct
void forge_parser_set_pos(int64_t pos) { _c_parser_pos = pos; }
int64_t forge_parser_get_pos(void) {
    return _c_parser_pos;
}
static int _adv_trace = 1;
void forge_parser_advance_pos(void) {
    _c_parser_pos++;
    if (_adv_trace && _c_parser_pos <= 20) {
        fprintf(stderr, "  [adv] cpos=%lld\n", (long long)_c_parser_pos);
    }
}
void forge_parser_set_ptr(void* ptr) {
    _c_parser_ptr = ptr;
    if (ptr) {
        // Parser layout: {List<Token>{ptr,i64}=16, pos:i64, List<Diagnostic>{ptr,i64}, string{ptr,i64}}
        int64_t* pos_ptr = (int64_t*)((char*)ptr + 16);
        fprintf(stderr, "[parser_ptr] ptr=%p pos_at_16=%lld\n", ptr, (long long)*pos_ptr);
    }
}

// C-side token list storage (immune to Token struct return value corruption)
static ForgeString _c_token_list = {NULL, 0};
static ForgeString _current_scan_source = {NULL, 0};
void forge_set_scan_source(ForgeString src) { _current_scan_source = src; }
void forge_set_token_list(ForgeString list) { _c_token_list = list; }
// Access token fields by index from C-side stored list
// Token layout: {TokenKind{i8,ptr}=16, Span{i64,i64,i64,i64}=32, ForgeString{ptr,i64}=16, i64=8} = 72
int64_t forge_token_kind_id(ForgeString token_list, int64_t index) {
    if (!token_list.ptr || index < 0 || index >= token_list.len) return 99; // EOF
    char* base = token_list.ptr + index * 72;
    return *(int64_t*)(base + 64);
}
ForgeString forge_token_text(ForgeString token_list, int64_t index) {
    if (!token_list.ptr || index < 0 || index >= token_list.len) return (ForgeString){NULL, 0};
    char* base = token_list.ptr + index * 72;
    return *(ForgeString*)(base + 48);
}
int64_t forge_token_span_start(ForgeString token_list, int64_t index) {
    if (!token_list.ptr || index < 0 || index >= token_list.len) return 0;
    char* base = token_list.ptr + index * 72;
    return *(int64_t*)(base + 16);
}
int64_t forge_token_span_end(ForgeString token_list, int64_t index) {
    if (!token_list.ptr || index < 0 || index >= token_list.len) return 0;
    char* base = token_list.ptr + index * 72;
    return *(int64_t*)(base + 24);
}
// Quick kind_id lookup from C-side stored token list (no struct return needed)
static int _peek_trace = 0;
int64_t forge_peek_kind_id(int64_t pos) {
    int64_t kid = forge_token_kind_id(_c_token_list, pos);
    if (_peek_trace && pos < 20) {
        fprintf(stderr, "  [peek_kid] pos=%lld kid=%lld\n", (long long)pos, (long long)kid);
    }
    return kid;
}
void forge_enable_peek_trace(void) { _peek_trace = 1; }
// C-side expect_id: check kind_id at current pos, advance if match
int64_t forge_parser_expect_id(int64_t kid) {
    if (forge_token_kind_id(_c_token_list, _c_parser_pos) == kid) {
        _c_parser_pos++;
        return 1;
    }
    return 0;
}

// C-side check_id: check kind_id at current pos (no advance)
int64_t forge_parser_check_id(int64_t kid) {
    return forge_token_kind_id(_c_token_list, _c_parser_pos) == kid;
}

// C-side consume_empty_params: consume () with no params, returns 1 if successful
int64_t forge_parser_consume_empty_params(void) {
    if (forge_token_kind_id(_c_token_list, _c_parser_pos) == 100) { // (
        _c_parser_pos++;
        if (forge_token_kind_id(_c_token_list, _c_parser_pos) == 101) { // )
            _c_parser_pos++;
            return 1;
        }
    }
    return 0;
}

// C-side consume_block: consume { ... } block, returns body text
ForgeString forge_parser_consume_block(ForgeString source) {
    int64_t start_pos = _c_parser_pos;
    int64_t kid = forge_token_kind_id(_c_token_list, _c_parser_pos);
    fprintf(stderr, "  [consume_block] pos=%lld kid=%lld src_len=%lld\n", (long long)_c_parser_pos, (long long)kid, (long long)source.len);
    if (kid != 102) { // {
        return (ForgeString){NULL, 0};
    }
    int64_t open_span = forge_token_span_start(_c_token_list, _c_parser_pos);
    _c_parser_pos++; // consume {
    int depth = 1;
    while (depth > 0 && _c_parser_pos < _c_token_list.len) {
        int64_t kid = forge_token_kind_id(_c_token_list, _c_parser_pos);
        if (kid == 102) depth++; // {
        else if (kid == 103) depth--; // }
        if (depth > 0) _c_parser_pos++;
    }
    int64_t close_span = forge_token_span_end(_c_token_list, _c_parser_pos);
    if (_c_parser_pos < _c_token_list.len) _c_parser_pos++; // consume }
    // Extract body text from source
    if (source.ptr && open_span >= 0 && close_span > open_span && close_span <= source.len) {
        return forge_string_new(source.ptr + open_span, close_span - open_span + 1);
    }
    return (ForgeString){NULL, 0};
}

// C-side is_at_rparen: returns 1 if current token is ) (kind_id 101)
int64_t forge_parser_is_at_rparen(void) {
    return forge_token_kind_id(_c_token_list, _c_parser_pos) == 101 ||
           _c_parser_pos >= _c_token_list.len;
}

// C-side is_at_end check
int64_t forge_parser_is_at_end(void) {
    return _c_parser_pos >= _c_token_list.len ||
           forge_token_kind_id(_c_token_list, _c_parser_pos) == 99;
}

// C-side skip_newlines: skip all tokens with kind_id 120
void forge_parser_skip_newlines(void) {
    while (_c_parser_pos < _c_token_list.len &&
           forge_token_kind_id(_c_token_list, _c_parser_pos) == 120) {
        _c_parser_pos++;
    }
}

// C-side expect_ident: advances parser, returns ident text
// Completely bypasses Forge let/return/if statement corruption
ForgeString forge_expect_ident(void) {
    int64_t pos = _c_parser_pos;
    int64_t kid = forge_token_kind_id(_c_token_list, pos);
    if (kid == 1 || kid == 60) {
        _c_parser_pos++;
        if (kid == 60) return forge_string_new("_", 1);
        return forge_token_text(_c_token_list, pos);
    }
    // Check for keyword identifiers (is=55, table=56)
    if (kid == 55) { _c_parser_pos++; return forge_string_new("is", 2); }
    if (kid == 56) { _c_parser_pos++; return forge_string_new("table", 5); }
    return (ForgeString){NULL, 0};
}
ForgeString forge_peek_text(int64_t pos) {
    return forge_token_text(_c_token_list, pos);
}
int64_t forge_token_list_len(void) {
    return _c_token_list.len;
}
// Extract payload ptr from any enum {i64, ptr} regardless of tag
// Used to get Expr from Statement.Expr when tag is corrupted
void* forge_enum_get_payload(void* enum_ptr) {
    if (!enum_ptr) return NULL;
    // Enum layout: {i64 tag, ptr payload} — payload is at offset 8
    return *(void**)((char*)enum_ptr + 8);
}

// Extract function body source between open_pos and close_pos token indices
// Uses C-side token span access (immune to Forge struct field extraction bugs)
ForgeString forge_extract_body_source(ForgeString source, int64_t open_pos, int64_t close_pos) {
    if (!source.ptr || source.len <= 0) return (ForgeString){NULL, 0};
    int64_t open_span = forge_token_span_start(_c_token_list, open_pos);
    int64_t close_span = forge_token_span_end(_c_token_list, close_pos);
    fprintf(stderr, "  [extract_body] open_pos=%lld close_pos=%lld open_span=%lld close_span=%lld src_len=%lld tl_len=%lld\n",
        (long long)open_pos, (long long)close_pos, (long long)open_span, (long long)close_span,
        (long long)source.len, (long long)_c_token_list.len);
    if (open_span < 0 || close_span <= open_span || close_span > source.len) {
        fprintf(stderr, "  [extract_body] FAIL — returning empty\n");
        return (ForgeString){NULL, 0};
    }
    ForgeString result = forge_string_new(source.ptr + open_span, close_span - open_span + 1);
    fprintf(stderr, "  [extract_body] result_len=%lld first_char='%c'\n", (long long)result.len, result.ptr[0]);
    return result;
}

void forge_debug_parser_state(ForgeString label) {
    fprintf(stderr, "  [%.*s] cpos=%lld kid=%lld\n",
        (int)label.len, label.ptr,
        (long long)_c_parser_pos,
        (long long)forge_token_kind_id(_c_token_list, _c_parser_pos));
}

static int char_at_count = 0;
static int _char_at_diag = 0;
ForgeString forge_string_char_at(ForgeString s, int64_t index) {
    if (_char_at_diag < 5 || (!s.ptr || index < 0 || index >= s.len)) {
        fprintf(stderr, "[char_at #%d] ptr=%p len=%lld idx=%lld\n", _char_at_diag, s.ptr, (long long)s.len, (long long)index);
        _char_at_diag++;
    }
    forge_string_bounds_check(s, index, "char_at");
    unsigned char c = (unsigned char)s.ptr[index];
    char_at_count++;
    // ASCII byte — return pointer to static char (no malloc!)
    if (c < 0x80) {
        ensure_ascii_chars();
        return (ForgeString){ ascii_chars[c], 1 };
    }
    // UTF-8 multi-byte: determine sequence length from leading byte
    int64_t seq_len = 1;
    if ((c & 0xE0) == 0xC0) seq_len = 2;
    else if ((c & 0xF0) == 0xE0) seq_len = 3;
    else if ((c & 0xF8) == 0xF0) seq_len = 4;
    // Clamp to remaining string length
    if (index + seq_len > s.len) seq_len = s.len - index;
    return forge_string_new(s.ptr + index, seq_len);
}



int64_t forge_string_bytes(ForgeString s, void** out_data) {
    int64_t* arr = (int64_t*)malloc(s.len * sizeof(int64_t));
    for (int64_t i = 0; i < s.len; i++) {
        arr[i] = (int64_t)(unsigned char)s.ptr[i];
    }
    *out_data = arr;
    return s.len;
}

int64_t forge_string_chars(ForgeString s, void** out_data) {
    // Worst case: every byte is a character
    ForgeString* arr = (ForgeString*)malloc(s.len * sizeof(ForgeString));
    int64_t count = 0;
    for (int64_t i = 0; i < s.len; ) {
        unsigned char c = (unsigned char)s.ptr[i];
        int64_t seq_len = 1;
        if (c < 0x80) seq_len = 1;
        else if ((c & 0xE0) == 0xC0) seq_len = 2;
        else if ((c & 0xF0) == 0xE0) seq_len = 3;
        else if ((c & 0xF8) == 0xF0) seq_len = 4;
        if (i + seq_len > s.len) seq_len = s.len - i;
        arr[count] = forge_string_new(s.ptr + i, seq_len);
        count++;
        i += seq_len;
    }
    *out_data = arr;
    return count;
}

int64_t forge_char_code(ForgeString s) {
    if (s.len == 0) return 0;
    unsigned char c = (unsigned char)s.ptr[0];
    if (c < 0x80) return (int64_t)c;
    // Decode UTF-8 code point
    int64_t cp = 0;
    int64_t seq_len = 1;
    if ((c & 0xE0) == 0xC0) { cp = c & 0x1F; seq_len = 2; }
    else if ((c & 0xF0) == 0xE0) { cp = c & 0x0F; seq_len = 3; }
    else if ((c & 0xF8) == 0xF0) { cp = c & 0x07; seq_len = 4; }
    else return (int64_t)c;
    for (int64_t i = 1; i < seq_len && i < s.len; i++) {
        cp = (cp << 6) | ((unsigned char)s.ptr[i] & 0x3F);
    }
    return cp;
}

// ---- String split ----

int64_t forge_string_split(ForgeString s, ForgeString sep, void** out_data) {
    if (sep.len == 0) {
        ForgeString* arr = (ForgeString*)malloc(sizeof(ForgeString));
        arr[0] = s;
        *out_data = arr;
        return 1;
    }
    // Count parts
    int64_t count = 1;
    for (int64_t i = 0; i <= s.len - sep.len; i++) {
        if (memcmp(s.ptr + i, sep.ptr, sep.len) == 0) {
            count++;
            i += sep.len - 1;
        }
    }
    ForgeString* arr = (ForgeString*)malloc(count * sizeof(ForgeString));
    int64_t part = 0;
    int64_t start = 0;
    for (int64_t i = 0; i <= s.len - sep.len; i++) {
        if (memcmp(s.ptr + i, sep.ptr, sep.len) == 0) {
            int64_t plen = i - start;
            arr[part] = forge_string_new(s.ptr + start, plen);
            part++;
            start = i + sep.len;
            i += sep.len - 1;
        }
    }
    // Last part
    arr[part] = forge_string_new(s.ptr + start, s.len - start);
    *out_data = arr;
    return count;
}

// ---- List to JSON ----

// Serialize a list of ForgeStrings to a JSON array string: ["a","b","c"]
ForgeString forge_list_to_json(ForgeString* data, int64_t len) {
    // Calculate total size needed
    int64_t total = 2; // [ and ]
    for (int64_t i = 0; i < len; i++) {
        total += 2 + data[i].len; // quotes around each
        // Account for escaping
        for (int64_t j = 0; j < data[i].len; j++) {
            if (data[i].ptr[j] == '"' || data[i].ptr[j] == '\\') total++;
        }
        if (i < len - 1) total++; // comma
    }

    char* buf = (char*)forge_string_alloc(total + 1);
    int64_t pos = 0;
    buf[pos++] = '[';
    for (int64_t i = 0; i < len; i++) {
        buf[pos++] = '"';
        for (int64_t j = 0; j < data[i].len; j++) {
            char c = data[i].ptr[j];
            if (c == '"' || c == '\\') buf[pos++] = '\\';
            buf[pos++] = c;
        }
        buf[pos++] = '"';
        if (i < len - 1) buf[pos++] = ',';
    }
    buf[pos++] = ']';
    buf[pos] = '\0';
    return (ForgeString){ .ptr = buf, .len = pos };
}

ForgeString forge_list_int_to_json(int64_t* data, int64_t len) {
    // Each int64 can be up to 20 digits + sign + comma
    int64_t buf_cap = 2 + len * 22;
    char* buf = (char*)forge_string_alloc(buf_cap);
    int64_t pos = 0;
    buf[pos++] = '[';
    for (int64_t i = 0; i < len; i++) {
        if (i > 0) buf[pos++] = ',';
        pos += snprintf(buf + pos, buf_cap - pos, "%lld", (long long)data[i]);
    }
    buf[pos++] = ']';
    buf[pos] = '\0';
    return (ForgeString){ .ptr = buf, .len = pos };
}

// ---- List slice ----

typedef struct {
    void* ptr;
    int64_t len;
} ForgeListSlice;

ForgeListSlice forge_list_slice(void* data, int64_t list_len, int64_t start, int64_t end, int64_t elem_size) {
    if (start < 0) start = 0;
    if (end > list_len) end = list_len;
    if (start >= end) {
        void* empty = forge_alloc(0);
        return (ForgeListSlice){ .ptr = empty, .len = 0 };
    }
    int64_t count = end - start;
    int64_t total = count * elem_size;
    void* buf = forge_alloc(total);
    memcpy(buf, (char*)data + start * elem_size, total);
    return (ForgeListSlice){ .ptr = buf, .len = count };
}

// ---- List sort ----

void forge_list_sort_int(int64_t* data, int64_t len) {
    // Insertion sort
    for (int64_t i = 1; i < len; i++) {
        int64_t key = data[i];
        int64_t j = i - 1;
        while (j >= 0 && data[j] > key) {
            data[j + 1] = data[j];
            j--;
        }
        data[j + 1] = key;
    }
}

// ---- Sleep ----

void forge_sleep(int64_t ms) {
    usleep((useconds_t)(ms * 1000));
}

// ---- Exit ----

void forge_exit(int64_t code) {
    exit((int)code);
}

// ---- Memory helpers ----

void forge_memcpy(void* dst, void* src, int64_t size) {
    if (size > 0 && src != NULL && dst != NULL) {
        memcpy(dst, src, (size_t)size);
    }
}

// ---- Map helpers ----
// Simple linear-scan map: {ForgeString* keys, int64_t* values, int64_t count}
// Used by the self-hosted compiler for variable/function lookup.

// Pointer-based map: heap-allocated, passed by ptr.
// {ForgeString* keys, int64_t* values, int64_t count, int64_t capacity}
typedef struct {
    ForgeString* keys;
    int64_t* values;
    int64_t count;
    int64_t capacity;
} ForgeMap;

// Create an empty map (returns heap pointer)
void* forge_map_new() {
    ForgeMap* m = (ForgeMap*)malloc(sizeof(ForgeMap));
    m->capacity = 16;
    m->keys = (ForgeString*)malloc(m->capacity * sizeof(ForgeString));
    m->values = (int64_t*)malloc(m->capacity * sizeof(int64_t));
    m->count = 0;
    return (void*)m;
}

// Check if a key exists
int8_t forge_map_has(void* map_ptr, ForgeString key) {
    if (!map_ptr) { return 0; }
    ForgeMap* m = (ForgeMap*)map_ptr;
    for (int64_t i = 0; i < m->count; i++) {
        if (m->keys[i].len == key.len && memcmp(m->keys[i].ptr, key.ptr, key.len) == 0) {
            return 1;
        }
    }
    return 0;
}

// Get value by key (returns 0 if not found)
int64_t forge_map_get(void* map_ptr, ForgeString key) {
    if (!map_ptr) { return 0; }
    ForgeMap* m = (ForgeMap*)map_ptr;
    for (int64_t i = 0; i < m->count; i++) {
        if (m->keys[i].len == key.len && memcmp(m->keys[i].ptr, key.ptr, key.len) == 0) {
            return m->values[i];
        }
    }
    return 0;
}

// Set value by key (inserts or updates)
void forge_map_set(void* map_ptr, ForgeString key, int64_t value) {
    if (!map_ptr) { return; }
    ForgeMap* m = (ForgeMap*)map_ptr;
    for (int64_t i = 0; i < m->count; i++) {
        if (m->keys[i].len == key.len && memcmp(m->keys[i].ptr, key.ptr, key.len) == 0) {
            m->values[i] = value;
            return;
        }
    }
    if (m->count >= m->capacity) {
        m->capacity *= 2;
        m->keys = (ForgeString*)realloc(m->keys, m->capacity * sizeof(ForgeString));
        m->values = (int64_t*)realloc(m->values, m->capacity * sizeof(int64_t));
    }
    m->keys[m->count] = key;
    m->values[m->count] = value;
    m->count++;
}

// ---- Panic ----

void forge_panic(const char* msg, int64_t msg_len) {
    fprintf(stderr, "panic: ");
    fwrite(msg, 1, msg_len, stderr);
    fprintf(stderr, "\n");
    exit(1);
}

// ---- Assert ----

void forge_assert(int8_t cond, const char* msg, int64_t msg_len,
                  const char* file, int64_t file_len,
                  int64_t line, int64_t col) {
    if (!cond) {
        fprintf(stderr, "\n");
        // Print file:line location
        if (file && file_len > 0) {
            fprintf(stderr, "  assertion failed at ");
            fwrite(file, 1, file_len, stderr);
            fprintf(stderr, " line %lld, col %lld\n", (long long)line, (long long)col);
        } else {
            fprintf(stderr, "  assertion failed\n");
        }
        fprintf(stderr, "  message: ");
        fwrite(msg, 1, msg_len, stderr);
        fprintf(stderr, "\n\n");
        exit(1);
    }
}

// ---- JSON parsing (for model query results) ----

// Skip whitespace
static const char* json_skip_ws(const char* p) {
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') p++;
    return p;
}

// Count objects in a JSON array
int64_t forge_json_array_count(const char* json) {
    if (!json) return 0;
    const char* p = json_skip_ws(json);
    if (*p != '[') return 0;
    p = json_skip_ws(p + 1);
    if (*p == ']') return 0;

    int64_t count = 0;
    int depth = 0;
    while (*p) {
        if (*p == '{') {
            if (depth == 0) count++;
            depth++;
        } else if (*p == '}') {
            depth--;
        } else if (*p == ']' && depth == 0) {
            break;
        }
        p++;
    }
    return count;
}

// Find the i-th object in a JSON array (or a single top-level object), return pointer to its '{'
static const char* json_find_object(const char* json, int64_t index) {
    if (!json) return NULL;
    const char* p = json_skip_ws(json);
    // Support single top-level object (not wrapped in array)
    if (*p == '{' && index == 0) return p;
    if (*p != '[') return NULL;
    p++;

    int64_t count = 0;
    int depth = 0;
    while (*p) {
        p = json_skip_ws(p);
        if (*p == ']') return NULL;
        if (*p == '{') {
            if (count == index) return p;
            // Skip this object
            depth = 1;
            p++;
            while (*p && depth > 0) {
                if (*p == '{') depth++;
                else if (*p == '}') depth--;
                else if (*p == '"') {
                    p++;
                    while (*p && *p != '"') { if (*p == '\\') p++; p++; }
                }
                p++;
            }
            count++;
            p = json_skip_ws(p);
            if (*p == ',') p++;
            continue;
        }
        p++;
    }
    return NULL;
}

// Find a field value in a JSON object (pointer to '{'), return pointer to value start
static const char* json_find_field(const char* obj, const char* field_name) {
    if (!obj || *obj != '{') return NULL;
    const char* p = obj + 1;
    int field_len = strlen(field_name);

    while (*p) {
        p = json_skip_ws(p);
        if (*p == '}') return NULL;
        if (*p == '"') {
            p++;
            const char* key_start = p;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
            int key_len = (int)(p - key_start);
            p++; // skip closing "
            p = json_skip_ws(p);
            if (*p == ':') p++;
            p = json_skip_ws(p);

            if (key_len == field_len && memcmp(key_start, field_name, field_len) == 0) {
                return p; // pointer to value
            }

            // Skip value
            if (*p == '"') {
                p++;
                while (*p && *p != '"') { if (*p == '\\') p++; p++; }
                p++;
            } else if (*p == '{') {
                int d = 1; p++;
                while (*p && d > 0) {
                    if (*p == '{') d++;
                    else if (*p == '}') d--;
                    else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                    p++;
                }
            } else if (*p == '[') {
                int d = 1; p++;
                while (*p && d > 0) {
                    if (*p == '[') d++;
                    else if (*p == ']') d--;
                    else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                    p++;
                }
            } else {
                while (*p && *p != ',' && *p != '}') p++;
            }
            if (*p == ',') p++;
        } else {
            p++;
        }
    }
    return NULL;
}

// Get string field from i-th object
ForgeString forge_json_get_string(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return forge_string_new("", 0);

    if (*val == '"') {
        val++;
        const char* start = val;
        // Calculate unescaped length
        const char* p = start;
        int64_t len = 0;
        while (*p && *p != '"') {
            if (*p == '\\') { p++; }
            len++;
            p++;
        }
        // Build unescaped string
        char* buf = (char*)forge_string_alloc(len + 1);
        int64_t j = 0;
        p = start;
        while (*p && *p != '"') {
            if (*p == '\\') {
                p++;
                if (*p == 'n') buf[j++] = '\n';
                else if (*p == 't') buf[j++] = '\t';
                else buf[j++] = *p;
            } else {
                buf[j++] = *p;
            }
            p++;
        }
        buf[j] = '\0';
        return (ForgeString){ .ptr = buf, .len = j };
    }
    return forge_string_new("", 0);
}

// Get nested object/array field as raw JSON c-string pointer
const char* forge_json_get_object(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return "{}";
    // val points to the start of the value in the JSON buffer
    // Find the end of the nested object/array
    if (*val == '{' || *val == '[') {
        char open = *val;
        char close = (open == '{') ? '}' : ']';
        int depth = 1;
        const char* p = val + 1;
        while (*p && depth > 0) {
            if (*p == open) depth++;
            else if (*p == close) depth--;
            else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
            p++;
        }
        int64_t len = p - val;
        char* buf = (char*)malloc(len + 1);
        memcpy(buf, val, len);
        buf[len] = '\0';
        return buf;
    }
    return "{}";
}

// Get int field from i-th object
int64_t forge_json_get_int(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return 0;
    return strtoll(val, NULL, 10);
}

// Get bool field from i-th object (handles 0/1 and true/false)
int8_t forge_json_get_bool(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return 0;
    if (*val == 't') return 1;  // "true"
    if (*val == '1') return 1;
    return 0;
}

// Count all elements (strings, numbers, bools, objects, arrays) in a JSON array
int64_t forge_json_array_count_elements(const char* json) {
    if (!json) return 0;
    const char* p = json_skip_ws(json);
    if (*p != '[') return 0;
    p = json_skip_ws(p + 1);
    if (*p == ']') return 0;

    int64_t count = 0;
    int depth = 0;
    while (*p) {
        p = json_skip_ws(p);
        if (*p == ']' && depth == 0) break;
        if (depth == 0) count++;
        // Skip this element
        if (*p == '"') {
            p++;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
            p++; // closing quote
        } else if (*p == '{' || *p == '[') {
            char open = *p;
            char close = (open == '{') ? '}' : ']';
            depth = 1; p++;
            while (*p && depth > 0) {
                if (*p == open) depth++;
                else if (*p == close) depth--;
                else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                p++;
            }
        } else {
            // number, bool, null
            while (*p && *p != ',' && *p != ']') p++;
        }
        p = json_skip_ws(p);
        if (*p == ',') p++;
    }
    return count;
}

// Find the i-th element in a JSON array, return pointer to value start
static const char* json_find_element(const char* json, int64_t index) {
    if (!json) return NULL;
    const char* p = json_skip_ws(json);
    if (*p != '[') return NULL;
    p = json_skip_ws(p + 1);

    int64_t count = 0;
    while (*p) {
        p = json_skip_ws(p);
        if (*p == ']') return NULL;
        if (count == index) return p;
        // Skip this element
        if (*p == '"') {
            p++;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
            p++;
        } else if (*p == '{' || *p == '[') {
            char open = *p;
            char close = (open == '{') ? '}' : ']';
            int depth = 1; p++;
            while (*p && depth > 0) {
                if (*p == open) depth++;
                else if (*p == close) depth--;
                else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                p++;
            }
        } else {
            while (*p && *p != ',' && *p != ']') p++;
        }
        count++;
        p = json_skip_ws(p);
        if (*p == ',') p++;
    }
    return NULL;
}

// Get the i-th string element from a JSON array
ForgeString forge_json_array_get_string(const char* json, int64_t index) {
    const char* val = json_find_element(json, index);
    if (!val || *val != '"') return forge_string_new("", 0);

    val++; // skip opening quote
    const char* start = val;
    const char* p = start;
    int64_t len = 0;
    while (*p && *p != '"') {
        if (*p == '\\') { p++; }
        len++;
        p++;
    }
    char* buf = (char*)forge_string_alloc(len + 1);
    int64_t j = 0;
    p = start;
    while (*p && *p != '"') {
        if (*p == '\\') {
            p++;
            if (*p == 'n') buf[j++] = '\n';
            else if (*p == 't') buf[j++] = '\t';
            else buf[j++] = *p;
        } else {
            buf[j++] = *p;
        }
        p++;
    }
    buf[j] = '\0';
    return (ForgeString){ .ptr = buf, .len = j };
}

// Get the i-th int element from a JSON array
int64_t forge_json_array_get_int(const char* json, int64_t index) {
    const char* val = json_find_element(json, index);
    if (!val) return 0;
    return strtoll(val, NULL, 10);
}

// Get the i-th bool element from a JSON array
int8_t forge_json_array_get_bool(const char* json, int64_t index) {
    const char* val = json_find_element(json, index);
    if (!val) return 0;
    if (*val == 't') return 1;
    if (*val == '1') return 1;
    return 0;
}

// Get the i-th float element from a JSON array
double forge_json_array_get_float(const char* json, int64_t index) {
    const char* val = json_find_element(json, index);
    if (!val) return 0.0;
    return strtod(val, NULL);
}

// Serialize a struct to JSON - helper for HTTP responses
// Write a JSON key-value string field
void forge_json_write_string_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, const char* val, int64_t val_len) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":\"", key);
    // Copy with escaping
    for (int64_t i = 0; i < val_len && *pos < buf_len - 2; i++) {
        if (val[i] == '"' || val[i] == '\\') {
            buf[(*pos)++] = '\\';
        }
        buf[(*pos)++] = val[i];
    }
    buf[(*pos)++] = '"';
    buf[*pos] = '\0';
}

void forge_json_write_int_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, int64_t val) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":%lld", key, (long long)val);
}

void forge_json_write_bool_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, int8_t val) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":%s", key, val ? "true" : "false");
}

// Escape a string for JSON embedding (returns malloc'd C string)
char* forge_json_escape(const char* str, int64_t len) {
    // Worst case: every char needs escaping (6 chars for \uXXXX)
    char* buf = (char*)malloc(len * 6 + 1);
    int64_t pos = 0;
    for (int64_t i = 0; i < len; i++) {
        unsigned char c = (unsigned char)str[i];
        switch (c) {
            case '"':  buf[pos++] = '\\'; buf[pos++] = '"'; break;
            case '\\': buf[pos++] = '\\'; buf[pos++] = '\\'; break;
            case '\n': buf[pos++] = '\\'; buf[pos++] = 'n'; break;
            case '\t': buf[pos++] = '\\'; buf[pos++] = 't'; break;
            case '\r': buf[pos++] = '\\'; buf[pos++] = 'r'; break;
            default:
                if (c < 0x20) {
                    pos += snprintf(buf + pos, 7, "\\u%04x", c);
                } else {
                    buf[pos++] = c;
                }
                break;
        }
    }
    buf[pos] = '\0';
    return buf;
}

// Map get from JSON params - used by HTTP handlers
ForgeString forge_params_get(const char* params_json, const char* key) {
    // params_json is like {"name":"value",...}
    if (!params_json || *params_json != '{') return forge_string_new("", 0);
    const char* val = json_find_field(params_json, key);
    if (!val || *val != '"') return forge_string_new("", 0);
    val++;
    const char* start = val;
    while (*val && *val != '"') val++;
    int64_t len = val - start;
    return forge_string_new(start, len);
}

// snprintf into a C string for SQL building
void forge_write_cstring(char* buf, int64_t buf_len, const char* src, int64_t src_len) {
    int64_t copy_len = src_len < buf_len - 1 ? src_len : buf_len - 1;
    memcpy(buf, src, copy_len);
    buf[copy_len] = '\0';
}

// Extract a string field from a flat JSON object body, return malloc'd C string (caller must free with stdlib free)
// Returns empty string if not found
char* forge_body_get_string(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(1); r[0] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val || *val != '"') {
        char* r = (char*)malloc(1); r[0] = '\0'; return r;
    }
    val++; // skip opening quote
    const char* start = val;
    // Calculate unescaped length
    const char* p = start;
    int64_t len = 0;
    while (*p && *p != '"') {
        if (*p == '\\') p++;
        len++;
        p++;
    }
    char* buf = (char*)malloc(len + 1);
    int64_t j = 0;
    p = start;
    while (*p && *p != '"') {
        if (*p == '\\') {
            p++;
            if (*p == 'n') buf[j++] = '\n';
            else if (*p == 't') buf[j++] = '\t';
            else buf[j++] = *p;
        } else {
            buf[j++] = *p;
        }
        p++;
    }
    buf[j] = '\0';
    return buf;
}

// Extract an int field from a flat JSON object body, return as C string (caller must free)
char* forge_body_get_int_str(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val) {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    // val points to the number
    char buf[32];
    int64_t v = strtoll(val, NULL, 10);
    int len = snprintf(buf, sizeof(buf), "%lld", (long long)v);
    char* r = (char*)malloc(len + 1);
    memcpy(r, buf, len + 1);
    return r;
}

// Extract a bool field from a flat JSON object body, return "0" or "1" (caller must free)
char* forge_body_get_bool_str(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val) {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    char* r = (char*)malloc(2);
    r[1] = '\0';
    if (*val == 't' || *val == '1') {
        r[0] = '1';
    } else {
        r[0] = '0';
    }
    return r;
}

// Check if a field exists in a flat JSON object body
int8_t forge_body_has_field(const char* body, const char* field_name) {
    if (!body || *body != '{') return 0;
    const char* val = json_find_field(body, field_name);
    return val ? 1 : 0;
}

// Fix boolean fields in a JSON string: replace "field":0 with "field":false, "field":1 with "field":true
// bool_fields is a comma-separated list of field names, e.g. "done,active"
// Modifies the string in-place if possible, or writes to a new malloc'd buffer.
// Returns a malloc'd string (caller frees with free()).
char* forge_json_fix_bools(const char* json, const char* bool_fields) {
    if (!json || !bool_fields) {
        int64_t len = json ? strlen(json) : 0;
        char* r = (char*)malloc(len + 1);
        if (json) memcpy(r, json, len);
        r[len] = '\0';
        return r;
    }

    // Parse bool field names
    const char* bf = bool_fields;
    char field_names[16][64]; // max 16 bool fields, 64 chars each
    int num_fields = 0;
    while (*bf && num_fields < 16) {
        const char* start = bf;
        while (*bf && *bf != ',') bf++;
        int flen = (int)(bf - start);
        if (flen > 63) flen = 63;
        memcpy(field_names[num_fields], start, flen);
        field_names[num_fields][flen] = '\0';
        num_fields++;
        if (*bf == ',') bf++;
    }

    // Allocate output buffer (may be larger due to "false" being longer than "0")
    int64_t json_len = strlen(json);
    int64_t out_size = json_len * 2 + 1; // generous
    char* out = (char*)malloc(out_size);
    int64_t oi = 0;
    const char* p = json;

    while (*p) {
        // Check for "fieldname":0 or "fieldname":1
        if (*p == '"') {
            const char* key_start = p + 1;
            const char* q = key_start;
            while (*q && *q != '"') q++;
            int key_len = (int)(q - key_start);

            // Check if this key is a bool field
            int is_bool = 0;
            for (int fi = 0; fi < num_fields; fi++) {
                if ((int)strlen(field_names[fi]) == key_len && memcmp(key_start, field_names[fi], key_len) == 0) {
                    is_bool = 1;
                    break;
                }
            }

            if (is_bool && *q == '"') {
                // Copy "fieldname"
                int64_t kpart = q + 1 - p; // includes closing "
                memcpy(out + oi, p, kpart);
                oi += kpart;
                p = q + 1;

                // Skip whitespace and colon
                while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') {
                    out[oi++] = *p++;
                }
                if (*p == ':') {
                    out[oi++] = *p++;
                }
                while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') {
                    out[oi++] = *p++;
                }

                // Now replace 0->false, 1->true
                if (*p == '0' && (p[1] == ',' || p[1] == '}' || p[1] == ']' || p[1] == '\0' || p[1] == ' ' || p[1] == '\n')) {
                    memcpy(out + oi, "false", 5);
                    oi += 5;
                    p++; // skip '0'
                } else if (*p == '1' && (p[1] == ',' || p[1] == '}' || p[1] == ']' || p[1] == '\0' || p[1] == ' ' || p[1] == '\n')) {
                    memcpy(out + oi, "true", 4);
                    oi += 4;
                    p++; // skip '1'
                } else {
                    // Not 0 or 1, just copy as-is
                }
                continue;
            }
        }
        out[oi++] = *p++;
    }
    out[oi] = '\0';
    return out;
}

// Extract first object from a JSON array "[{...},{...}]" -> "{...}"
// Writes to output buffer. Returns length written (0 if empty array).
int64_t forge_json_unwrap_first(const char* json_array, char* out_buf, int64_t out_len) {
    if (!json_array) { out_buf[0] = '\0'; return 0; }
    const char* p = json_skip_ws(json_array);
    if (*p != '[') { out_buf[0] = '\0'; return 0; }
    p = json_skip_ws(p + 1);
    if (*p == ']') { out_buf[0] = '\0'; return 0; }
    if (*p != '{') { out_buf[0] = '\0'; return 0; }
    // Find the end of this object
    const char* start = p;
    int depth = 1;
    p++;
    while (*p && depth > 0) {
        if (*p == '{') depth++;
        else if (*p == '}') depth--;
        else if (*p == '"') {
            p++;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
        }
        p++;
    }
    // p now points past the closing '}'
    int64_t obj_len = p - start;
    if (obj_len >= out_len) obj_len = out_len - 1;
    memcpy(out_buf, start, obj_len);
    out_buf[obj_len] = '\0';
    return obj_len;
}

// Check if a JSON string represents null (or is empty/missing)
int8_t forge_json_is_null(const char* json) {
    if (!json) return 1;
    const char* p = json;
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') p++;
    return (*p == 'n' || *p == '\0') ? 1 : 0;
}

// ── Concurrency ──

#include <pthread.h>

typedef void (*forge_fn_ptr)(void);

struct spawn_arg {
    forge_fn_ptr fn;
};

static void* spawn_thread_fn(void* arg) {
    struct spawn_arg* sa = (struct spawn_arg*)arg;
    sa->fn();
    free(sa);
    return NULL;
}

void forge_spawn(forge_fn_ptr fn) {
    pthread_t thread;
    struct spawn_arg* arg = (struct spawn_arg*)malloc(sizeof(struct spawn_arg));
    arg->fn = fn;
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&thread, &attr, spawn_thread_fn, arg);
    pthread_attr_destroy(&attr);
}

void forge_sleep_ms(int64_t ms) {
    usleep((useconds_t)(ms * 1000));
}

// ---- Datetime helpers ----

#include <sys/time.h>
#include <time.h>

// Returns current time as epoch milliseconds
long long forge_datetime_now() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (long long)tv.tv_sec * 1000LL + (long long)tv.tv_usec / 1000LL;
}

// Format epoch ms to ISO string (YYYY-MM-DD HH:MM:SS)
ForgeString forge_datetime_format(long long epoch_ms) {
    time_t secs = (time_t)(epoch_ms / 1000);
    struct tm* tm_info = localtime(&secs);
    char buf[20];
    int len = (int)strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm_info);
    return forge_string_new(buf, len);
}

// Parse ISO string to epoch ms
long long forge_datetime_parse(const char* str, long long str_len) {
    struct tm tm_info;
    memset(&tm_info, 0, sizeof(tm_info));
    // Copy to null-terminated buffer
    char buf[64];
    long long copy_len = str_len < 63 ? str_len : 63;
    memcpy(buf, str, copy_len);
    buf[copy_len] = '\0';
    strptime(buf, "%Y-%m-%d %H:%M:%S", &tm_info);
    tm_info.tm_isdst = -1; // let mktime figure it out
    return (long long)mktime(&tm_info) * 1000LL;
}

// ---- Process uptime ----

static struct timeval _forge_start_time;
__attribute__((constructor)) void _forge_init_start_time() {
    gettimeofday(&_forge_start_time, NULL);
}

long long forge_process_uptime() {
    struct timeval now;
    gettimeofday(&now, NULL);
    long long start_ms = (long long)_forge_start_time.tv_sec * 1000LL + _forge_start_time.tv_usec / 1000LL;
    long long now_ms = (long long)now.tv_sec * 1000LL + now.tv_usec / 1000LL;
    return now_ms - start_ms;
}

// ---- Validation helpers ----

// Check if string is a valid email (basic check: contains @ and .)
int64_t forge_validate_email(ForgeString s) {
    if (s.len == 0) return 0;
    const char* at = memchr(s.ptr, '@', s.len);
    if (!at) return 0;
    int64_t after_at = s.len - (at - s.ptr) - 1;
    if (after_at <= 0) return 0;
    const char* dot = memchr(at + 1, '.', after_at);
    if (!dot) return 0;
    // Must have at least 1 char before @, 1 char between @ and ., 1 char after .
    if (at == s.ptr) return 0;
    if (dot == at + 1) return 0;
    if (dot == s.ptr + s.len - 1) return 0;
    return 1;
}

// Check if string is a valid URL (basic check: starts with http:// or https://)
int64_t forge_validate_url(ForgeString s) {
    if (s.len >= 7 && strncmp(s.ptr, "http://", 7) == 0) return 1;
    if (s.len >= 8 && strncmp(s.ptr, "https://", 8) == 0) return 1;
    return 0;
}

// Check if string is a valid UUID (8-4-4-4-12 hex format)
int64_t forge_validate_uuid(ForgeString s) {
    if (s.len != 36) return 0;
    for (int i = 0; i < 36; i++) {
        if (i == 8 || i == 13 || i == 18 || i == 23) {
            if (s.ptr[i] != '-') return 0;
        } else {
            char c = s.ptr[i];
            if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')))
                return 0;
        }
    }
    return 1;
}

// Check if string matches a regex pattern (basic: uses strstr for simple cases)
// For full regex support, this would need a regex library
int64_t forge_validate_pattern(ForgeString s, ForgeString pattern) {
    // Simple implementation: exact match for now
    // A full implementation would use POSIX regex or similar
    // For patterns like "^[a-z0-9-]+$", we do character-by-character checking
    if (pattern.len < 2) return 1;

    // Handle ^[charset]+$ patterns
    if (pattern.ptr[0] == '^' && pattern.ptr[pattern.len-1] == '$') {
        // Extract charset from [...]
        const char* bracket_start = memchr(pattern.ptr, '[', pattern.len);
        const char* bracket_end = memchr(pattern.ptr, ']', pattern.len);
        if (bracket_start && bracket_end && bracket_end > bracket_start) {
            int64_t set_len = bracket_end - bracket_start - 1;
            const char* set = bracket_start + 1;
            for (int64_t i = 0; i < s.len; i++) {
                char c = s.ptr[i];
                int found = 0;
                for (int64_t j = 0; j < set_len; j++) {
                    if (j + 2 < set_len && set[j+1] == '-') {
                        // Range: a-z
                        if (c >= set[j] && c <= set[j+2]) { found = 1; break; }
                        j += 2;
                    } else {
                        if (c == set[j]) { found = 1; break; }
                    }
                }
                if (!found) return 0;
            }
            return 1;
        }
    }
    return 1; // Default: pass if pattern not understood
}

// ---- Query comparison helpers ----

ForgeString forge_query_gt(int64_t value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "{\"$gt\":%lld}", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_query_gte(int64_t value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "{\"$gte\":%lld}", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_query_lt(int64_t value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "{\"$lt\":%lld}", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_query_lte(int64_t value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "{\"$lte\":%lld}", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_query_between(int64_t low, int64_t high) {
    char buf[128];
    int len = snprintf(buf, sizeof(buf), "{\"$gte\":%lld,\"$lte\":%lld}", (long long)low, (long long)high);
    return forge_string_new(buf, len);
}

// ---- File I/O ----

ForgeString forge_read_file(ForgeString path) {
    // Null-terminate path for fopen
    char* cpath = (char*)malloc(path.len + 1);
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';

    FILE* f = fopen(cpath, "rb");
    free(cpath);
    if (!f) {
        return forge_string_new("", 0);
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (size <= 0) {
        fclose(f);
        return forge_string_new("", 0);
    }

    char* buf = (char*)malloc(size + 1);
    size_t read = fread(buf, 1, size, f);
    fclose(f);
    buf[read] = '\0';

    ForgeString result = forge_string_new(buf, (int64_t)read);
    free(buf);
    // Auto-store as scan source for body extraction fallback
    _current_scan_source = result;
    return result;
}

int8_t forge_write_file(ForgeString path, ForgeString content) {
    char* cpath = (char*)malloc(path.len + 1);
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';

    FILE* f = fopen(cpath, "wb");
    free(cpath);
    if (!f) {
        return 0;
    }

    size_t written = fwrite(content.ptr, 1, content.len, f);
    fclose(f);
    return (written == (size_t)content.len) ? 1 : 0;
}

int8_t forge_file_exists(ForgeString path) {
    char* cpath = (char*)malloc(path.len + 1);
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';

    int result = access(cpath, F_OK);
    free(cpath);
    return (result == 0) ? 1 : 0;
}

ForgeString forge_query_like(ForgeString pattern) {
    int64_t buf_len = pattern.len + 32;
    char* buf = (char*)malloc(buf_len);
    int len = snprintf(buf, buf_len, "{\"$like\":\"%.*s\"}", (int)pattern.len, pattern.ptr);
    ForgeString result = forge_string_new(buf, len);
    free(buf);
    return result;
}

// ---- Mini compiler helpers ----
// These support the self-hosted mini compiler directly.

static int g_argc = 0;
static char** g_argv = NULL;

void forge_mini_set_args(int argc, char** argv) {
    g_argc = argc;
    g_argv = argv;
}

int64_t forge_mini_argc() {
    return (int64_t)g_argc;
}

ForgeString forge_mini_argv(int64_t idx) {
    if (idx < 0 || idx >= g_argc) return forge_string_new("", 0);
    return forge_string_new(g_argv[idx], strlen(g_argv[idx]));
}

ForgeString forge_mini_run(ForgeString cmd, ForgeString args_json) {
    // Simple: build command string and run with popen
    char cmd_buf[4096];
    int off = snprintf(cmd_buf, sizeof(cmd_buf), "%.*s", (int)cmd.len, cmd.ptr);
    // Parse JSON array of args: ["a","b","c"]
    const char* p = args_json.ptr;
    int64_t plen = args_json.len;
    int64_t i = 0;
    while (i < plen) {
        if (p[i] == '"') {
            i++;
            int start = i;
            while (i < plen && p[i] != '"') {
                if (p[i] == '\\') i++; // skip escape
                i++;
            }
            off += snprintf(cmd_buf + off, sizeof(cmd_buf) - off, " %.*s", (int)(i - start), p + start);
            i++; // skip closing "
        } else {
            i++;
        }
    }
    FILE* fp = popen(cmd_buf, "r");
    if (!fp) {
        char err[] = "{\"stdout\":\"\",\"stderr\":\"popen failed\",\"code\":1}";
        return forge_string_new(err, strlen(err));
    }
    char out[65536] = {0};
    int total = 0;
    while (total < (int)sizeof(out) - 1) {
        int n = fread(out + total, 1, sizeof(out) - 1 - total, fp);
        if (n <= 0) break;
        total += n;
    }
    int code = pclose(fp);
    int exit_code = WEXITSTATUS(code);
    // Build JSON result
    char result[131072];
    int rlen = snprintf(result, sizeof(result), 
        "{\"stdout\":\"%.*s\",\"stderr\":\"\",\"code\":%d}",
        total, out, exit_code);
    return forge_string_new(result, rlen);
}

// Run command with list of ForgeString args (not JSON)
typedef struct { void* ptr; int64_t len; } ForgeList;
ForgeString forge_mini_run_list(ForgeString cmd, ForgeList args) {
    char cmd_buf[8192];
    int off = snprintf(cmd_buf, sizeof(cmd_buf), "%.*s", (int)cmd.len, cmd.ptr);
    ForgeString* items = (ForgeString*)args.ptr;
    for (int64_t i = 0; i < args.len; i++) {
        // Shell-escape: wrap in single quotes
        off += snprintf(cmd_buf + off, sizeof(cmd_buf) - off, " '%.*s'",
            (int)items[i].len, items[i].ptr);
    }
    cmd_buf[off] = '\0';
    // Redirect stderr to stdout so we capture both
    strncat(cmd_buf, " 2>&1", sizeof(cmd_buf) - strlen(cmd_buf) - 1);
    FILE* fp = popen(cmd_buf, "r");
    if (!fp) {
        char err[] = "{\"stdout\":\"\",\"stderr\":\"popen failed\",\"code\":1}";
        return forge_string_new(err, strlen(err));
    }
    char out[65536] = {0};
    int total = 0;
    while (total < (int)sizeof(out) - 1) {
        int n = fread(out + total, 1, sizeof(out) - 1 - total, fp);
        if (n <= 0) break;
        total += n;
    }
    int code = pclose(fp);
    int exit_code = WEXITSTATUS(code);
    char result[131072];
    int rlen = snprintf(result, sizeof(result),
        "{\"stdout\":\"%.*s\",\"stderr\":\"\",\"code\":%d}",
        total, out, exit_code);
    return forge_string_new(result, rlen);
}

// Convert ForgeString to int64
int64_t forge_string_to_int(ForgeString s) {
    char buf[64];
    int64_t len = s.len < 63 ? s.len : 63;
    memcpy(buf, s.ptr, len);
    buf[len] = '\0';
    return strtoll(buf, NULL, 10);
}

double forge_string_to_float(ForgeString s) {
    char buf[64];
    int64_t len = s.len < 63 ? s.len : 63;
    memcpy(buf, s.ptr, len);
    buf[len] = '\0';
    return strtod(buf, NULL);
}

// Join a list of ForgeStrings with newline separator
ForgeString forge_join_lines(ForgeList lines) {
    ForgeString* items = (ForgeString*)lines.ptr;
    // Calculate total length
    int64_t total = 0;
    for (int64_t i = 0; i < lines.len; i++) {
        total += items[i].len + 1; // +1 for newline
    }
    char* buf = (char*)forge_alloc(total + 1);
    int64_t off = 0;
    for (int64_t i = 0; i < lines.len; i++) {
        if (items[i].len > 0) {
            memcpy(buf + off, items[i].ptr, items[i].len);
            off += items[i].len;
        }
        buf[off++] = '\n';
    }
    buf[off] = '\0';
    return forge_string_new(buf, off);
}

// Write a list of ForgeStrings to file, one per line
void forge_write_lines(ForgeString path, ForgeList lines) {
    char cpath[4096];
    if (path.len >= sizeof(cpath)) return;
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';
    FILE* f = fopen(cpath, "wb");
    if (!f) return;
    ForgeString* items = (ForgeString*)lines.ptr;
    for (int64_t i = 0; i < lines.len; i++) {
        if (items[i].len > 0) {
            fwrite(items[i].ptr, 1, items[i].len, f);
        }
        fputc('\n', f);
    }
    fclose(f);
}

void forge_write_lines_append(ForgeString path, ForgeList lines) {
    char cpath[4096];
    if (path.len >= sizeof(cpath)) return;
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';
    FILE* f = fopen(cpath, "ab");
    if (!f) return;
    ForgeString* items = (ForgeString*)lines.ptr;
    for (int64_t i = 0; i < lines.len; i++) {
        if (items[i].len > 0) {
            fwrite(items[i].ptr, 1, items[i].len, f);
        }
        fputc('\n', f);
    }
    fclose(f);
}

// Write a large ForgeString to file — workaround for potential ABI issues
void forge_mini_write_file(ForgeString path, ForgeString content) {
    char cpath[4096];
    if (path.len >= sizeof(cpath)) return;
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';
    FILE* f = fopen(cpath, "wb");
    if (!f) return;
    if (content.ptr && content.len > 0) {
        fwrite(content.ptr, 1, content.len, f);
    }
    fclose(f);
}

// ---- Efficient list push (amortized O(1) via capacity doubling) ----
// Capacity is stored in 8 bytes BEFORE the data pointer.
// Layout: [cap:i64][elem0][elem1]...  data_ptr points to elem0.

static int _list_push_count = 0;
static int _list_push_diag = 0;  // set to 1 to enable diagnostics

ForgeList forge_list_push(ForgeList list, void* elem, int64_t elem_size) {
    _list_push_count++;
    // Guard: reject null elements or unreasonable sizes
    if (!elem || elem_size <= 0 || elem_size > 1000000) {
        fprintf(stderr, "[list_push #%d] BAD: elem=%p size=%lld — skipping\n", _list_push_count, elem, (long long)elem_size);
        return list;
    }
    // Detect struct values passed as pointers (common ABI bug):
    // If elem looks like it's NOT a valid pointer (e.g., small integer), warn
    if ((uintptr_t)elem < 4096) {
        fprintf(stderr, "[list_push #%d] WARN: elem=%p looks like integer, not pointer — size=%lld\n",
                _list_push_count, elem, (long long)elem_size);
    }
    int64_t len = list.len;
    if (_list_push_diag && (_list_push_count <= 50 || _list_push_count % 100 == 0)) {
        fprintf(stderr, "[list_push #%d] ptr=%p len=%lld elem_size=%lld\n", _list_push_count, list.ptr, (long long)len, (long long)elem_size);
    }
    if (len < 0 || len > 10000000) {
        if (_list_push_diag) fprintf(stderr, "[list_push #%d] BAD len=%lld, resetting to 0\n", _list_push_count, (long long)len);
        len = 0;
    }
    int64_t cap = 0;
    char* raw = NULL;

    if (list.ptr && len > 0) {
        // Read capacity from before data pointer
        raw = (char*)list.ptr - sizeof(int64_t);
        cap = *(int64_t*)raw;
        // Validate: cap must be >= len and reasonable
        if (cap < len || cap > len * 4 + 16 || cap > 1000000) {
            cap = 0;
            raw = NULL;
        }
    }

    if (len >= cap) {
        // Grow: double capacity (min 8)
        int64_t new_cap = cap < 8 ? 8 : cap * 2;
        char* new_raw = (char*)malloc(sizeof(int64_t) + new_cap * elem_size);
        if (!new_raw) {
            fprintf(stderr, "[list_push #%d] FATAL: malloc(%lld) failed\n", _list_push_count, (long long)(sizeof(int64_t) + new_cap * elem_size));
            return list;
        }
        *(int64_t*)new_raw = new_cap;
        char* new_data = new_raw + sizeof(int64_t);
        if (list.ptr && len > 0) {
            memcpy(new_data, list.ptr, len * elem_size);
        }
        list.ptr = new_data;
        raw = new_raw;
    }

    // Append element
    memcpy((char*)list.ptr + len * elem_size, elem, elem_size);
    list.len = len + 1;
    return list;
}

void forge_list_push_diag(int64_t enable) { _list_push_diag = (int)enable; }

// ---- Self-hosted compiler support ----
// These provide process.args(), fs.read(), process.exit(), process.run()
// directly in the runtime, without the @std.process/@std.fs package layer.

static int _forge_argc = 0;
static char** _forge_argv = NULL;

void forge_set_args(int argc, char** argv) {
    _forge_argc = argc;
    _forge_argv = argv;
}

// Auto-capture args via macOS/Linux __attribute__((section)) trick
// The real main() calls this before Forge's main
__attribute__((constructor))
static void _forge_capture_args(int argc, char** argv) {
    _forge_argc = argc;
    _forge_argv = argv;
}

// process.args() → List<string> (ForgeString elements)
// Get a specific arg by index (avoids list indexing issues in codegen)
ForgeString forge_selfhost_get_arg(int64_t idx) {
    if (idx < 0 || idx >= _forge_argc || !_forge_argv) {
        return forge_string_new("", 0);
    }
    return forge_string_new(_forge_argv[idx], strlen(_forge_argv[idx]));
}

ForgeList forge_selfhost_process_args(void) {
    if (_forge_argc == 0 || _forge_argv == NULL) {
        return (ForgeList){ .ptr = NULL, .len = 0 };
    }
    ForgeString* items = (ForgeString*)malloc(sizeof(ForgeString) * _forge_argc);
    for (int i = 0; i < _forge_argc; i++) {
        items[i] = forge_string_new(_forge_argv[i], strlen(_forge_argv[i]));
    }
    return (ForgeList){ .ptr = items, .len = _forge_argc };
}

// fs.read(path) → string
ForgeString forge_selfhost_fs_read(ForgeString path) {
    char cpath[4096];
    int64_t plen = path.len < 4095 ? path.len : 4095;
    memcpy(cpath, path.ptr, plen);
    cpath[plen] = '\0';
    FILE* f = fopen(cpath, "rb");
    if (!f) return forge_string_new("", 0);
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = (char*)malloc(size + 1);
    fread(buf, 1, size, f);
    fclose(f);
    buf[size] = '\0';
    ForgeString result = { .ptr = buf, .len = size };
    // Auto-store as scan source for body extraction fallback
    _current_scan_source = result;
    return result;
}

// process.exit(code)
void forge_selfhost_process_exit(int64_t code) {
    exit((int)code);
}

// process.run(cmd, args) → string (JSON result)
ForgeString forge_selfhost_process_run(ForgeString cmd, ForgeString args_json) {
    // Simplified: just return empty for now
    return forge_string_new("{\"code\":0}", 10);
}

// span stub removed — conflicts with @span global in full compiler IR

// ---- C-side IR line accumulator (avoids O(n²) Forge list push for 56K+ lines) ----
static FILE* _ir_file = NULL;
void forge_ir_open(ForgeString path) {
    char cpath[4096];
    if (path.len >= sizeof(cpath)) return;
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';
    _ir_file = fopen(cpath, "wb");
}
// Forward declare shared pending alloca name (defined near forge_param_name_get)
extern char forge_pending_alloca_name[64];
extern int64_t forge_pending_alloca_name_len;

// Last parsed let-variable name — set during parsing, used during emission
static char _last_let_name[64] = "";
static int64_t _last_let_name_len = 0;
static int _lln_dbg = 0;
void forge_set_last_let_name(ForgeString name) {
    if (0) {
        fprintf(stderr, "  [lln] ptr=%p len=%lld text='%.*s'\n", name.ptr, (long long)name.len,
            (name.ptr && name.len > 0 && name.len < 30) ? (int)name.len : 0,
            (name.ptr && name.len > 0 && name.len < 30) ? (char*)name.ptr : "");
        _lln_dbg++;
    }
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(_last_let_name, name.ptr, name.len);
        _last_let_name[name.len] = '\0';
        _last_let_name_len = name.len;
    }
}
// Copy last let name to pending alloca name
void forge_let_to_alloca_name(void) {
    if (_last_let_name_len > 0) {
        memcpy(forge_pending_alloca_name, _last_let_name, _last_let_name_len + 1);
        forge_pending_alloca_name_len = _last_let_name_len;
    }
}

// forge_let_needs_alloca defined below (needs _ac declarations)

// "Use pending" flag — armed by define_var RIGHT BEFORE its build_alloca call.
// This ensures ONLY define_var's build_alloca uses the pending name,
// not temp allocas created during expression evaluation.
static int _use_pending_for_next_alloca = 0;
void forge_clear_last_let_name(void) {
    _last_let_name[0] = '\0';
    _last_let_name_len = 0;
    forge_pending_alloca_name[0] = '\0';
    forge_pending_alloca_name_len = 0;
    _use_pending_for_next_alloca = 0;
}

void forge_arm_pending_alloca(void) {
    if (_last_let_name_len > 0) {
        _use_pending_for_next_alloca = 1;
    }
}

int forge_check_pending_alloca(void) {
    int v = _use_pending_for_next_alloca;
    _use_pending_for_next_alloca = 0;
    return v;
}

// C-side pending alloca name setter (called from Forge define_var)
void forge_set_alloca_name_c(ForgeString name) {
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(forge_pending_alloca_name, name.ptr, name.len);
        forge_pending_alloca_name[name.len] = '\0';
        forge_pending_alloca_name_len = name.len;
    } else {
        forge_pending_alloca_name[0] = '\0';
        forge_pending_alloca_name_len = 0;
    }
}

// Alloca hoisting: when active, alloca lines are buffered and emitted
// at the entry block (right after "entry:" label) instead of inline.
#define IR_ALLOCA_BUF_SIZE 2048
#define IR_ALLOCA_LINE_SIZE 128
static char _ir_alloca_buf[IR_ALLOCA_BUF_SIZE][IR_ALLOCA_LINE_SIZE];
static int _ir_alloca_count = 0;
static int _ir_alloca_hoist = 0;  // 1 = hoisting active

void forge_ir_hoist_begin(void) {
    _ir_alloca_count = 0;
    _ir_alloca_hoist = 1;
}

void forge_ir_hoist_flush(void) {
    // Emit all buffered allocas
    if (!_ir_file) return;
    for (int i = 0; i < _ir_alloca_count; i++) {
        fputs(_ir_alloca_buf[i], _ir_file);
        fputc('\n', _ir_file);
    }
    _ir_alloca_count = 0;
}

void forge_ir_hoist_end(void) {
    _ir_alloca_hoist = 0;
    _ir_alloca_count = 0;
}

void forge_ir_line(ForgeString line) {
    if (!_ir_file) return;
    if (line.ptr && line.len > 0) {
        // Detect alloca lines and buffer them when hoisting is active
        // Pattern: "  %rN = alloca TYPE"
        if (_ir_alloca_hoist && line.len > 12 && line.len < IR_ALLOCA_LINE_SIZE - 1) {
            // Check for "  %r" prefix followed by "= alloca "
            const char* p = line.ptr;
            if (p[0] == ' ' && p[1] == ' ' && p[2] == '%' && p[3] == 'r') {
                // Find "= alloca "
                const char* eq = NULL;
                for (int i = 4; i < line.len - 8; i++) {
                    if (p[i] == '=' && p[i+1] == ' ' && p[i+2] == 'a' && p[i+3] == 'l' && p[i+4] == 'l') {
                        eq = p + i;
                        break;
                    }
                }
                if (eq && memcmp(eq, "= alloca ", 9) == 0) {
                    // Buffer this alloca line
                    if (_ir_alloca_count < IR_ALLOCA_BUF_SIZE) {
                        memcpy(_ir_alloca_buf[_ir_alloca_count], p, line.len);
                        _ir_alloca_buf[_ir_alloca_count][line.len] = '\0';
                        _ir_alloca_count++;
                        return;  // Don't write inline
                    }
                }
            }
        }
        // Detect "entry:" label and flush buffered allocas
        if (line.len >= 6 && memcmp(line.ptr, "entry:", 6) == 0) {
            fwrite(line.ptr, 1, line.len, _ir_file);
            fputc('\n', _ir_file);
            forge_ir_hoist_flush();
            return;
        }
        fwrite(line.ptr, 1, line.len, _ir_file);
    }
    fputc('\n', _ir_file);
}
void forge_ir_close(void) {
    if (_ir_file) { fclose(_ir_file); _ir_file = NULL; }
}

// ---- C-side module path CSV accumulator ----
// Bypasses Forge global variable assignment corruption in Stage 2
static char _mod_csv[65536];
static int _mod_csv_len = 0;
void forge_mod_csv_clear(void) { _mod_csv_len = 0; _mod_csv[0] = '\0'; }
// Scan CSV and call a callback for each line — callback set at runtime
typedef void (*scan_callback_t)(ForgeString filepath, int64_t idx);
static scan_callback_t _scan_cb = NULL;
void forge_scan_csv_set_cb(void* cb) { _scan_cb = (scan_callback_t)cb; }
// Two-phase scan: first split CSV into paths (in C), then call callback for each
// This prevents scan_one_file from corrupting the CSV scanner's stack
#define MAX_SCAN_FILES 256
static ForgeString _scan_paths[MAX_SCAN_FILES];
static int _scan_path_count = 0;

int64_t forge_scan_csv(ForgeString csv) {
    if (!_scan_cb || !csv.ptr) return 0;
    // Phase 1: split CSV into paths array (pure C, no callbacks)
    _scan_path_count = 0;
    int64_t line_start = 0;
    for (int64_t pos = 0; pos <= csv.len; pos++) {
        if (pos == csv.len || csv.ptr[pos] == '\n') {
            if (pos > line_start && _scan_path_count < MAX_SCAN_FILES) {
                _scan_paths[_scan_path_count++] = forge_string_new(csv.ptr + line_start, pos - line_start);
            }
            line_start = pos + 1;
        }
    }
    // Phase 2: call callback for each path
    // Use explicit index tracking to survive any stack corruption
    int total = _scan_path_count;
    int idx = 0;
next_file:
    if (idx >= total) return total;
    {
        ForgeString path = _scan_paths[idx];
        int64_t cur_idx = idx;
        idx++;
        fprintf(stderr, "  [CSV] %d/%d: %.*s\n", (int)cur_idx, total, (int)path.len, path.ptr);
        fflush(stderr);
        _scan_cb(path, cur_idx);
        fprintf(stderr, "  [CSV] %d done\n", (int)cur_idx);
        fflush(stderr);
    }
    goto next_file;
}

// Save CSV string in C-side static storage so it survives stack corruption
static char* _saved_csv_ptr = NULL;
static int64_t _saved_csv_len = 0;

void forge_save_csv(ForgeString csv) {
    // Copy to heap (immune to stack corruption)
    _saved_csv_ptr = (char*)malloc(csv.len + 1);
    memcpy(_saved_csv_ptr, csv.ptr, csv.len);
    _saved_csv_ptr[csv.len] = '\0';
    _saved_csv_len = csv.len;
}

// Stateful CSV iterator — state lives in C (immune to Forge stack corruption)
static int64_t _csv_scan_pos = 0;
static int64_t _csv_scan_idx = 0;

// Returns next filepath from CSV, or empty string when done
ForgeString forge_csv_next(void) {
    while (_csv_scan_pos < _saved_csv_len) {
        int64_t line_start = _csv_scan_pos;
        while (_csv_scan_pos < _saved_csv_len && _saved_csv_ptr[_csv_scan_pos] != '\n')
            _csv_scan_pos++;
        if (_csv_scan_pos > line_start) {
            ForgeString path = forge_string_new(_saved_csv_ptr + line_start, _csv_scan_pos - line_start);
            _csv_scan_pos++; // skip newline
            _csv_scan_idx++;
            return path;
        }
        _csv_scan_pos++; // skip empty line
    }
    return (ForgeString){NULL, 0};
}

void forge_csv_scan_reset(void) { _csv_scan_pos = 0; _csv_scan_idx = 0; }
int64_t forge_csv_scan_idx(void) { return _csv_scan_idx - 1; }
int64_t forge_csv_has_next(void) {
    return _csv_scan_pos < _saved_csv_len ? 1 : 0;
}

int64_t forge_csv_byte_at(int64_t idx) {
    if (idx < 0 || idx >= _saved_csv_len || !_saved_csv_ptr) return -1;
    return (int64_t)(unsigned char)_saved_csv_ptr[idx];
}

int64_t forge_csv_length(void) { return _saved_csv_len; }

ForgeString forge_csv_substr(int64_t start, int64_t end) {
    if (!_saved_csv_ptr || start < 0 || end > _saved_csv_len || start >= end)
        return (ForgeString){NULL, 0};
    return forge_string_new(_saved_csv_ptr + start, end - start);
}

ForgeString forge_scan_csv_path(int64_t idx) {
    if (idx < 0 || idx >= _scan_path_count) return (ForgeString){NULL, 0};
    return _scan_paths[idx];
}

void forge_mod_csv_add(ForgeString path) {
    if (!path.ptr || path.len <= 0 || _mod_csv_len + path.len + 2 > 65535) return;
    memcpy(_mod_csv + _mod_csv_len, path.ptr, path.len);
    _mod_csv_len += path.len;
    _mod_csv[_mod_csv_len++] = '\n';
    _mod_csv[_mod_csv_len] = '\0';
}
ForgeString forge_mod_csv_get(void) {
    return forge_string_new(_mod_csv, _mod_csv_len);
}

// ---- C-side function name/return-type registry (immune to Forge list corruption) ----
// This is the ROOT FIX for type tracking bugs: FN_NAMES/FN_RETURN_TYPES stored in C.
#define FN_REG_MAX 1024
static struct { char name[128]; char ret_type[64]; } _fn_reg[FN_REG_MAX];
static int _fn_reg_count = 0;

void forge_fn_reg_clear(void) { _fn_reg_count = 0; }

void forge_fn_reg_add(ForgeString name, ForgeString ret_type) {
    if (_fn_reg_count >= FN_REG_MAX) return;
    if (!name.ptr || name.len <= 0 || name.len > 127) return;
    memcpy(_fn_reg[_fn_reg_count].name, name.ptr, name.len);
    _fn_reg[_fn_reg_count].name[name.len] = '\0';
    if (ret_type.ptr && ret_type.len > 0 && ret_type.len < 64) {
        memcpy(_fn_reg[_fn_reg_count].ret_type, ret_type.ptr, ret_type.len);
        _fn_reg[_fn_reg_count].ret_type[ret_type.len] = '\0';
    } else {
        _fn_reg[_fn_reg_count].ret_type[0] = '\0';
    }
    _fn_reg_count++;
}

// Look up return type by function name. Returns empty string if not found.
ForgeString forge_fn_reg_get_ret(ForgeString name) {
    if (!name.ptr || name.len <= 0) return (ForgeString){NULL, 0};
    for (int i = _fn_reg_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_fn_reg[i].name) == name.len &&
            memcmp(_fn_reg[i].name, name.ptr, name.len) == 0) {
            int64_t rlen = strlen(_fn_reg[i].ret_type);
            if (rlen == 0) return (ForgeString){NULL, 0};
            // Return pointer to static string (no allocation — avoids heap pressure)
            return (ForgeString){_fn_reg[i].ret_type, rlen};
        }
    }
    return (ForgeString){NULL, 0};
}

int64_t forge_fn_reg_count(void) { return _fn_reg_count; }

// ─── C-side struct type registry (immune to Forge list corruption) ───
#define STRUCT_REG_MAX 256
static struct {
    char name[64];
    char fields[256];       // comma-separated field names
    char field_types[512];  // comma-separated field type names
    void* llvm_type;        // LLVM struct type pointer (set during materialization)
} _struct_reg[STRUCT_REG_MAX];
static int _struct_reg_count = 0;

void forge_struct_reg_clear(void) { _struct_reg_count = 0; }

void forge_struct_reg_add(ForgeString name, ForgeString fields, ForgeString field_types) {
    if (_struct_reg_count >= STRUCT_REG_MAX) return;
    if (!name.ptr || name.len <= 0 || name.len > 63) return;
    // Check if already exists — update instead of adding
    for (int i = 0; i < _struct_reg_count; i++) {
        if ((int64_t)strlen(_struct_reg[i].name) == name.len &&
            memcmp(_struct_reg[i].name, name.ptr, name.len) == 0) {
            // Update existing entry
            if (fields.ptr && fields.len > 0 && fields.len < 255) {
                memcpy(_struct_reg[i].fields, fields.ptr, fields.len);
                _struct_reg[i].fields[fields.len] = '\0';
            }
            if (field_types.ptr && field_types.len > 0 && field_types.len < 511) {
                memcpy(_struct_reg[i].field_types, field_types.ptr, field_types.len);
                _struct_reg[i].field_types[field_types.len] = '\0';
            }
            return;
        }
    }
    memcpy(_struct_reg[_struct_reg_count].name, name.ptr, name.len);
    _struct_reg[_struct_reg_count].name[name.len] = '\0';
    if (fields.ptr && fields.len > 0 && fields.len < 255) {
        memcpy(_struct_reg[_struct_reg_count].fields, fields.ptr, fields.len);
        _struct_reg[_struct_reg_count].fields[fields.len] = '\0';
    } else {
        _struct_reg[_struct_reg_count].fields[0] = '\0';
    }
    if (field_types.ptr && field_types.len > 0 && field_types.len < 511) {
        memcpy(_struct_reg[_struct_reg_count].field_types, field_types.ptr, field_types.len);
        _struct_reg[_struct_reg_count].field_types[field_types.len] = '\0';
    } else {
        _struct_reg[_struct_reg_count].field_types[0] = '\0';
    }
    _struct_reg[_struct_reg_count].llvm_type = NULL;
    _struct_reg_count++;
}

void forge_struct_reg_set_llvm_type(ForgeString name, void* ty) {
    if (!name.ptr || name.len <= 0) return;
    for (int i = _struct_reg_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_struct_reg[i].name) == name.len &&
            memcmp(_struct_reg[i].name, name.ptr, name.len) == 0) {
            _struct_reg[i].llvm_type = ty;
            return;
        }
    }
}

// Sync all registry entries with canonical LLVM type pointers.
// Call after materialize_struct_types to fix stale pointers.
// Use dlsym to avoid linker dependency on LLVM symbols from runtime.c
#include <dlfcn.h>
typedef void* (*llvm_get_type_fn)(void*, const char*);
static void* _current_llvm_ctx = NULL;
void forge_struct_reg_sync_types(void* ctx) {
    _current_llvm_ctx = ctx;
    if (!ctx) return;
    // Resolve LLVMGetTypeByName2 at runtime (avoids static LLVM dependency)
    static llvm_get_type_fn get_type = NULL;
    if (!get_type) {
        get_type = (llvm_get_type_fn)dlsym(RTLD_DEFAULT, "LLVMGetTypeByName2");
        if (!get_type) return;
    }
    int updated = 0;
    for (int i = 0; i < _struct_reg_count; i++) {
        void* canonical = get_type(ctx, _struct_reg[i].name);
        if (canonical && canonical != _struct_reg[i].llvm_type) {
            _struct_reg[i].llvm_type = canonical;
            updated++;
        }
    }
    if (updated > 0) fprintf(stderr, "  [sync] updated %d/%d type pointers\n", updated, _struct_reg_count);
}

int64_t forge_struct_reg_count(void) { return _struct_reg_count; }

ForgeString forge_struct_reg_get_name(int64_t idx) {
    if (idx < 0 || idx >= _struct_reg_count) return (ForgeString){NULL, 0};
    return (ForgeString){_struct_reg[idx].name, strlen(_struct_reg[idx].name)};
}

ForgeString forge_struct_reg_get_fields(int64_t idx) {
    if (idx < 0 || idx >= _struct_reg_count) return (ForgeString){NULL, 0};
    return (ForgeString){_struct_reg[idx].fields, strlen(_struct_reg[idx].fields)};
}

ForgeString forge_struct_reg_get_field_types(int64_t idx) {
    if (idx < 0 || idx >= _struct_reg_count) return (ForgeString){NULL, 0};
    return (ForgeString){_struct_reg[idx].field_types, strlen(_struct_reg[idx].field_types)};
}

void* forge_struct_reg_get_llvm_type(int64_t idx) {
    if (idx < 0 || idx >= _struct_reg_count) return NULL;
    return _struct_reg[idx].llvm_type;
}

// Reverse lookup: given an LLVM type pointer, find the struct name
// Returns a ForgeString (for Forge callers) with pointer to static storage
ForgeString forge_struct_reg_name_for_type(void* ty) {
    if (!ty) return (ForgeString){NULL, 0};
    for (int i = 0; i < _struct_reg_count; i++) {
        if (_struct_reg[i].llvm_type == ty) {
            int64_t len = strlen(_struct_reg[i].name);
            return (ForgeString){_struct_reg[i].name, len};
        }
    }
    return (ForgeString){NULL, 0};
}

// Same but returns i64 length and writes name to a static buffer accessible via forge_struct_reg_last_name
static char _struct_name_buf[64];
static int64_t _struct_name_len = 0;
int64_t forge_struct_reg_name_for_type_i64(void* ty) {
    _struct_name_buf[0] = '\0';
    _struct_name_len = 0;
    if (!ty) return 0;
    static int _nft_dbg = 0;
    for (int i = 0; i < _struct_reg_count; i++) {
        if (_struct_reg[i].llvm_type == ty) {
            _struct_name_len = strlen(_struct_reg[i].name);
            memcpy(_struct_name_buf, _struct_reg[i].name, _struct_name_len);
            _struct_name_buf[_struct_name_len] = '\0';
            return _struct_name_len;
        }
    }
    // Fallback: resync and retry (handles types created after initial sync)
    if (_current_llvm_ctx) {
        static llvm_get_type_fn _get_type = NULL;
        if (!_get_type) _get_type = (llvm_get_type_fn)dlsym(RTLD_DEFAULT, "LLVMGetTypeByName2");
        if (_get_type) {
            for (int i = 0; i < _struct_reg_count; i++) {
                void* canonical = _get_type(_current_llvm_ctx, _struct_reg[i].name);
                if (canonical == ty) {
                    _struct_reg[i].llvm_type = ty;
                    _struct_name_len = strlen(_struct_reg[i].name);
                    memcpy(_struct_name_buf, _struct_reg[i].name, _struct_name_len);
                    _struct_name_buf[_struct_name_len] = '\0';
                    return _struct_name_len;
                }
            }
        }
    }
    return 0;
}
ForgeString forge_struct_reg_last_name(void) {
    return (ForgeString){_struct_name_buf, _struct_name_len};
}

void forge_struct_var_add(ForgeString name, ForgeString type_name); // forward decl
// Combined: look up struct name by LLVM type pointer AND register the variable.
// Avoids ForgeString intermediate that gets corrupted by mini's i64 alloca storage.
void forge_struct_var_add_by_type(ForgeString var_name, void* llvm_ty) {
    if (!var_name.ptr || var_name.len <= 0 || !llvm_ty) return;
    static int _abt_dbg = 0;
    if (_abt_dbg < 5) {
        fprintf(stderr, "  [abt] %.*s ty=%p\n", (int)var_name.len, var_name.ptr, llvm_ty);
        _abt_dbg++;
    }
    // Direct pointer match
    for (int i = 0; i < _struct_reg_count; i++) {
        if (_struct_reg[i].llvm_type == llvm_ty) {
            forge_struct_var_add(var_name, (ForgeString){_struct_reg[i].name, strlen(_struct_reg[i].name)});
            return;
        }
    }
    // Canonical pointer fallback
    if (_current_llvm_ctx) {
        static llvm_get_type_fn _gtn = NULL;
        if (!_gtn) _gtn = (llvm_get_type_fn)dlsym(RTLD_DEFAULT, "LLVMGetTypeByName2");
        if (_gtn) {
            for (int i = 0; i < _struct_reg_count; i++) {
                void* canonical = _gtn(_current_llvm_ctx, _struct_reg[i].name);
                if (canonical == llvm_ty) {
                    _struct_reg[i].llvm_type = llvm_ty;
                    forge_struct_var_add(var_name, (ForgeString){_struct_reg[i].name, strlen(_struct_reg[i].name)});
                    return;
                }
            }
        }
    }
}

// C-side ptr variable tracking (for LLVM Value* globals like CG_MOD, CG_B, etc.)
#define PTR_VAR_CACHE_SIZE 128
static char _ptr_var_names[PTR_VAR_CACHE_SIZE][64];
static int _ptr_var_count = 0;
static int _ptr_var_global_count = 0;
void forge_ptr_var_add(ForgeString name) {
    if (_ptr_var_count >= PTR_VAR_CACHE_SIZE) return;
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(_ptr_var_names[_ptr_var_count], name.ptr, name.len);
        _ptr_var_names[_ptr_var_count][name.len] = '\0';
        _ptr_var_count++;
    }
}
int64_t forge_ptr_var_check(ForgeString name) {
    if (!name.ptr || name.len <= 0) return 0;
    for (int i = _ptr_var_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_ptr_var_names[i]) == name.len &&
            memcmp(_ptr_var_names[i], name.ptr, name.len) == 0)
            return 1;
    }
    return 0;
}
void forge_ptr_var_add_raw(const char* name_ptr, int64_t name_len) {
    if (_ptr_var_count >= PTR_VAR_CACHE_SIZE) return;
    if (name_ptr && name_len > 0 && name_len < 64) {
        memcpy(_ptr_var_names[_ptr_var_count], name_ptr, name_len);
        _ptr_var_names[_ptr_var_count][name_len] = '\0';
        _ptr_var_count++;
    }
}
void forge_ptr_var_clear(void) { _ptr_var_count = _ptr_var_global_count; }
void forge_ptr_var_set_global(void) { _ptr_var_global_count = _ptr_var_count; }

// C-side list variable tracking
#define LIST_VAR_CACHE_SIZE 256
static char _list_var_names[LIST_VAR_CACHE_SIZE][64];
static int _list_var_count = 0;
static int _list_var_global_count = 0;
void forge_list_var_add(ForgeString name) {
    if (_list_var_count >= LIST_VAR_CACHE_SIZE) return;
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(_list_var_names[_list_var_count], name.ptr, name.len);
        _list_var_names[_list_var_count][name.len] = '\0';
        _list_var_count++;
    }
}
int64_t forge_list_var_check(ForgeString name) {
    if (!name.ptr || name.len <= 0) return 0;
    for (int i = _list_var_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_list_var_names[i]) == name.len &&
            memcmp(_list_var_names[i], name.ptr, name.len) == 0)
            return 1;
    }
    return 0;
}
void forge_list_var_clear(void) { _list_var_count = _list_var_global_count; }
void forge_list_var_set_global(void) { _list_var_global_count = _list_var_count; }

// Check function return type from registry
// Returns: 0=int/unknown, 1=string, 2=list, 3=ptr
int64_t forge_fn_is_str_return(ForgeString fn_name) {
    if (!fn_name.ptr || fn_name.len <= 0) return 0;
    // All forge_llvm_* functions return ptr
    if (fn_name.len > 10 && memcmp(fn_name.ptr, "forge_llvm", 10) == 0) return 3;
    // All llvm_* wrapper functions return ptr
    if (fn_name.len > 4 && memcmp(fn_name.ptr, "llvm_", 5) == 0) return 3;
    // C-side functions that return ForgeString (must be registered for correct call type)
    #define STR_RET(s) if (fn_name.len == sizeof(s)-1 && memcmp(fn_name.ptr, s, sizeof(s)-1) == 0) return 1;
    STR_RET("forge_peek_text")
    // Ptr-returning C-side functions
    #define PTR_RET(s) if (fn_name.len == sizeof(s)-1 && memcmp(fn_name.ptr, s, sizeof(s)-1) == 0) return 3;
    PTR_RET("forge_alloca_cache_get")
    PTR_RET("forge_alloca_cache_get_type")
    PTR_RET("resolve_type_to_llvm")
    PTR_RET("cg_get_enum_ty_for")
    PTR_RET("cg_make_enum_type")
    #undef PTR_RET
    STR_RET("forge_parser_consume_block")
    STR_RET("forge_expect_ident")
    STR_RET("forge_fn_store_get_name")
    STR_RET("forge_fn_store_get_body")
    STR_RET("forge_fn_reg_get_ret")
    STR_RET("forge_param_type_get")
    STR_RET("forge_param_name_get")
    STR_RET("forge_selfhost_get_arg")
    STR_RET("forge_get_self_type")
    STR_RET("forge_struct_var_get")
    STR_RET("forge_struct_reg_last_name")
    STR_RET("forge_csv_next")
    STR_RET("forge_csv_substr")
    STR_RET("forge_scan_csv_path")
    STR_RET("forge_mod_csv_get")
    STR_RET("forge_sh_substr")
    #undef STR_RET
    // Check registry
    for (int i = 0; i < _fn_reg_count; i++) {
        if ((int64_t)strlen(_fn_reg[i].name) == fn_name.len &&
            memcmp(_fn_reg[i].name, fn_name.ptr, fn_name.len) == 0) {
            const char* ret = _fn_reg[i].ret_type;
            if (strcmp(ret, "string") == 0) return 1;
            if (strncmp(ret, "List", 4) == 0) return 2;
            if (strcmp(ret, "ptr") == 0) return 3;
            return 0;
        }
    }
    return 0;
}

// ---- C-side param type storage (immune to Forge list corruption) ----
#define PARAM_REG_MAX 4096
static char _param_types[PARAM_REG_MAX][64];
static int _param_type_count = 0;

void forge_param_type_clear(void) { _param_type_count = 0; }
void forge_param_type_add(ForgeString type_name) {
    if (_param_type_count >= PARAM_REG_MAX) return;
    if (type_name.ptr && type_name.len > 0 && type_name.len < 64) {
        memcpy(_param_types[_param_type_count], type_name.ptr, type_name.len);
        _param_types[_param_type_count][type_name.len] = '\0';
    } else {
        strcpy(_param_types[_param_type_count], "int");
    }
    _param_type_count++;
}
static int _ptr_param_count = 0;
ForgeString forge_param_type_get(int64_t idx) {
    if (idx < 0 || idx >= _param_type_count) return forge_string_new("int", 3);
    int64_t len = strlen(_param_types[idx]);
    if (len == 3 && memcmp(_param_types[idx], "ptr", 3) == 0) _ptr_param_count++;
    return forge_string_new(_param_types[idx], len);
}
void forge_param_type_stats(void) {
    fprintf(stderr, "  [param_type_stats] total=%d ptr_lookups=%d\n", _param_type_count, _ptr_param_count);
}

// ---- C-side current self type (for method desugaring) ----
static char _current_self_type[128] = "";
void forge_set_self_type(ForgeString type_name) {
    if (type_name.ptr && type_name.len > 0 && type_name.len < 128) {
        memcpy(_current_self_type, type_name.ptr, type_name.len);
        _current_self_type[type_name.len] = '\0';
    } else {
        _current_self_type[0] = '\0';
    }
}
ForgeString forge_get_self_type(void) {
    int64_t len = strlen(_current_self_type);
    return forge_string_new(_current_self_type, len);
}

// ---- C-side param name storage (immune to Forge list corruption) ----
static char _param_names[PARAM_REG_MAX][64];
static int _param_name_count = 0;

void forge_param_name_clear(void) { _param_name_count = 0; }
void forge_param_name_add(ForgeString name) {
    if (_param_name_count >= PARAM_REG_MAX) return;
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(_param_names[_param_name_count], name.ptr, name.len);
        _param_names[_param_name_count][name.len] = '\0';
    } else {
        _param_names[_param_name_count][0] = '\0';
    }
    _param_name_count++;
}
// Shared pending alloca name — set by param_name_get, read by build_alloca auto-cache
char forge_pending_alloca_name[64] = "";
int64_t forge_pending_alloca_name_len = 0;

ForgeString forge_param_name_get(int64_t idx) {
    if (idx < 0 || idx >= _param_name_count) {
        forge_pending_alloca_name[0] = '\0';
        forge_pending_alloca_name_len = 0;
        return forge_string_new("", 0);
    }
    int64_t len = strlen(_param_names[idx]);
    // Also set pending alloca name for build_alloca auto-cache fallback
    if (len > 0 && len < 64) {
        memcpy(forge_pending_alloca_name, _param_names[idx], len);
        forge_pending_alloca_name[len] = '\0';
        forge_pending_alloca_name_len = len;
    }
    return forge_string_new(_param_names[idx], len);
}

// ---- C-side function body storage (immune to Forge list push corruption) ----
#define FN_STORE_MAX 1024
static struct { char name[128]; char* body; int64_t body_len; int64_t param_count; } _fn_store[FN_STORE_MAX];
static int _fn_store_count = 0;

void forge_fn_store_clear(void) { _fn_store_count = 0; }

// Current file source — declared near top, defined here for body extraction fallback
// (forward declared because forge_read_file also sets it)
void forge_set_scan_source(ForgeString src);

void forge_fn_store_add(ForgeString name, ForgeString body) {
    if (_fn_store_count >= FN_STORE_MAX) return;
    if (!name.ptr || name.len <= 0 || name.len > 127) return;
    // If body is empty/corrupt, try to re-extract from source using C-side token spans
    ForgeString actual_body = body;
    fprintf(stderr, "  [fn_store_add] body.ptr=%p body.len=%lld scan_src.ptr=%p scan_src.len=%lld\n",
        body.ptr, (long long)body.len, _current_scan_source.ptr, (long long)_current_scan_source.len);
    if ((!body.ptr || body.len <= 0 || body.len > 100000) && _current_scan_source.ptr) {
        // Walk backwards from current parser position to find the { } block
        // The last consumed block should be the function body
        // Use _c_parser_pos (set by forge_parser_advance_pos) to find the closing }
        int64_t close_pos = _c_parser_pos - 1;  // last consumed token
        if (close_pos >= 0 && close_pos < _c_token_list.len) {
            // Walk backwards to find matching {
            int depth = 0;
            int64_t open_pos = close_pos;
            for (int64_t i = close_pos; i >= 0; i--) {
                int64_t kid = forge_token_kind_id(_c_token_list, i);
                if (kid == 103) depth++;  // }
                else if (kid == 102) {    // {
                    depth--;
                    if (depth == 0) { open_pos = i; break; }
                }
            }
            int64_t open_span = forge_token_span_start(_c_token_list, open_pos);
            int64_t close_span = forge_token_span_end(_c_token_list, close_pos);
            if (open_span >= 0 && close_span > open_span && close_span <= _current_scan_source.len) {
                actual_body = forge_string_new(_current_scan_source.ptr + open_span, close_span - open_span + 1);
                fprintf(stderr, "  [fn_store #%d] AUTO-EXTRACT name=\"%.*s\" body_len=%lld (was %lld)\n",
                    _fn_store_count, (int)name.len, name.ptr, (long long)actual_body.len, (long long)body.len);
            }
        }
    }
    fprintf(stderr, "  [fn_store #%d] name=\"%.*s\" body_len=%lld\n", _fn_store_count, (int)name.len, name.ptr, (long long)actual_body.len);
    memcpy(_fn_store[_fn_store_count].name, name.ptr, name.len);
    _fn_store[_fn_store_count].name[name.len] = '\0';
    // Copy body
    char* b = (char*)malloc(actual_body.len + 1);
    if (actual_body.ptr && actual_body.len > 0) memcpy(b, actual_body.ptr, actual_body.len);
    b[actual_body.len] = '\0';
    _fn_store[_fn_store_count].body = b;
    _fn_store[_fn_store_count].body_len = actual_body.len;
    _fn_store_count++;
}

ForgeString forge_fn_store_get_body(int64_t idx) {
    if (idx < 0 || idx >= _fn_store_count) return (ForgeString){NULL, 0};
    return (ForgeString){_fn_store[idx].body, _fn_store[idx].body_len};
}

ForgeString forge_fn_store_get_name(int64_t idx) {
    if (idx < 0 || idx >= _fn_store_count) return (ForgeString){NULL, 0};
    int64_t nlen = strlen(_fn_store[idx].name);
    return forge_string_new(_fn_store[idx].name, nlen);
}

int64_t forge_fn_store_count(void) { return _fn_store_count; }

void forge_fn_store_dump_param_counts(void) {
    for (int i = 0; i < _fn_store_count; i++) {
        if (_fn_store[i].param_count == 0 && strlen(_fn_store[i].name) > 5) {
            fprintf(stderr, "  [pc0] #%d %s pc=%lld\n", i, _fn_store[i].name, (long long)_fn_store[i].param_count);
        }
    }
}

void forge_fn_store_set_param_count(int64_t idx, int64_t count) {
    if (idx >= 0 && idx < _fn_store_count) _fn_store[idx].param_count = count;
}

int64_t forge_fn_store_get_param_count(int64_t idx) {
    if (idx < 0 || idx >= _fn_store_count) return 0;
    return _fn_store[idx].param_count;
}

// Dump token list for debugging — Token = {TokenKind{i8,ptr}, Span{i64,i64,i64,i64}, ForgeString{ptr,i64}, i64}
// Token size = 72 bytes on aarch64
void forge_dump_token_list(ForgeString list) {
    int token_size = 72;
    fprintf(stderr, "[dump_tokens] count=%lld ptr=%p token_size=%d\n", (long long)list.len, list.ptr, token_size);
    if (!list.ptr || list.len <= 0) return;
    int max = list.len > 30 ? 30 : (int)list.len;
    for (int i = 0; i < max; i++) {
        char* base = list.ptr + i * token_size;
        int8_t kind_tag = *(int8_t*)base;
        void* kind_ptr = *(void**)(base + 8);
        int64_t kind_id = *(int64_t*)(base + 64);
        char* text_ptr = *(char**)(base + 48);
        int64_t text_len = *(int64_t*)(base + 56);
        int64_t span_start = *(int64_t*)(base + 16);
        int64_t span_end = *(int64_t*)(base + 24);
        fprintf(stderr, "  tok[%d] tag=%d kptr=%p kid=%lld span=%lld-%lld txt_ptr=%p txt_len=%lld",
            i, (int)kind_tag, kind_ptr, (long long)kind_id,
            (long long)span_start, (long long)span_end, text_ptr, (long long)text_len);
        if (text_ptr && text_len > 0 && text_len < 200) {
            fprintf(stderr, " text=\"%.*s\"", (int)text_len, text_ptr);
        }
        // Also dump raw hex for first few bytes
        if (i < 5) {
            fprintf(stderr, " raw=[");
            for (int j = 0; j < token_size && j < 72; j += 8) {
                fprintf(stderr, "%016llx ", *(unsigned long long*)(base + j));
            }
            fprintf(stderr, "]");
        }
        fprintf(stderr, "\n");
    }
}

// List push for ForgeString elements: returns new list with item appended
ForgeString forge_list_push_str(ForgeString list, ForgeString item) {
    // Amortized O(1) push with realloc — no memory leak
    int64_t old_count = list.len;
    int64_t elem_size = sizeof(ForgeString);
    ForgeString* data = (ForgeString*)list.ptr;

    // Use realloc for in-place growth when possible
    data = (ForgeString*)realloc(data, (old_count + 1) * elem_size);
    if (!data) {
        // realloc failed — allocate fresh
        data = (ForgeString*)malloc((old_count + 1) * elem_size);
        if (list.ptr && old_count > 0) memcpy(data, list.ptr, old_count * elem_size);
    }
    data[old_count] = item;
    return (ForgeString){ .ptr = (char*)data, .len = old_count + 1 };
}

// Debug: write ForgeString to file, print debug info
void forge_mini_write_debug(ForgeString path, ForgeString content) {
    char cpath[4096];
    memcpy(cpath, path.ptr, path.len);
    cpath[path.len] = '\0';
    fprintf(stderr, "  [write_debug] path='%s' ptr=%p len=%lld\n", cpath, content.ptr, (long long)content.len);
    FILE* f = fopen(cpath, "wb");
    if (!f) { fprintf(stderr, "  [write_debug] fopen failed\n"); return; }
    size_t w = fwrite(content.ptr, 1, content.len, f);
    fclose(f);
    fprintf(stderr, "  [write_debug] wrote %zu bytes\n", w);
}

// ===== Debug Tooling =====

// 1. Debug print to stderr (always flushed)
void forge_debug_print(const char* msg) {
    fprintf(stderr, "%s\n", msg);
    fflush(stderr);
}

void forge_debug_print_int(const char* label, int64_t val) {
    fprintf(stderr, "%s%lld\n", label, (long long)val);
    fflush(stderr);
}

void forge_debug_print_str(const char* label, ForgeString s) {
    if (s.ptr && (uintptr_t)s.ptr > 4096 && s.len > 0 && s.len < 10000) {
        fprintf(stderr, "%s\"%.*s\" (len=%lld)\n", label, (int)s.len, s.ptr, (long long)s.len);
    } else {
        fprintf(stderr, "%sptr=%p len=%lld\n", label, (void*)s.ptr, (long long)s.len);
    }
    fflush(stderr);
}

// 2. Stack usage tracking
static void* forge_stack_base = NULL;
void forge_stack_init(void) {
    volatile int x;
    forge_stack_base = (void*)&x;
}

int64_t forge_stack_used(void) {
    volatile int x;
    if (!forge_stack_base) return -1;
    ptrdiff_t diff = (char*)forge_stack_base - (char*)&x;
    return (int64_t)(diff > 0 ? diff : -diff);
}

void forge_stack_check(const char* fn_name) {
    // Debug logging disabled for performance
}

// 3. Function tracing (controlled by env var FORGE_TRACE=1)
static int forge_trace_enabled = -1;  // -1 = unchecked
static int forge_trace_depth = 0;
static const char* forge_trace_last[8] = {0};

void forge_trace_enter(const char* fn_name) {
    if (forge_trace_enabled == -1) {
        forge_trace_enabled = getenv("FORGE_TRACE") != NULL;
    }
    if (!forge_trace_enabled) return;
    forge_trace_depth++;
    // Store last 8 function names for crash diagnosis
    forge_trace_last[forge_trace_depth & 7] = fn_name;
    if (forge_trace_depth < 20) {  // Only print first 20 levels
        fprintf(stderr, "%*s> %s\n", forge_trace_depth * 2, "", fn_name);
        fflush(stderr);
    }
    // Auto-detect stack overflow risk
    int64_t used = forge_stack_used();
    if (used > 6 * 1024 * 1024) {
        fprintf(stderr, "STACK OVERFLOW IMMINENT in %s — %lld bytes used!\n", fn_name, (long long)used);
        fprintf(stderr, "Call chain: ");
        for (int i = 0; i < 8; i++) {
            const char* f = forge_trace_last[(forge_trace_depth - i) & 7];
            if (f) fprintf(stderr, "%s <- ", f);
        }
        fprintf(stderr, "...\n");
        fflush(stderr);
        _exit(99);
    }
}

void forge_trace_exit(const char* fn_name) {
    if (forge_trace_enabled > 0) forge_trace_depth--;
}

// 4. Memory dump utility
void forge_debug_hexdump(void* ptr, int64_t len) {
    if (!ptr || len <= 0 || len > 256) return;
    unsigned char* p = (unsigned char*)ptr;
    for (int64_t i = 0; i < len; i++) {
        if (i > 0 && i % 16 == 0) fprintf(stderr, "\n");
        fprintf(stderr, "%02x ", p[i]);
    }
    fprintf(stderr, "\n");
    fflush(stderr);
}

// 5. Struct field dump
void forge_debug_lexer(void* ptr) {
    if (!ptr) { fprintf(stderr, "  [dbg] lexer ptr=NULL\n"); fflush(stderr); return; }
    long long* p = (long long*)ptr;
    fprintf(stderr, "  [dbg] lexer@%p: src.ptr=%p src.len=%lld pos=%lld line=%lld col=%lld start=%lld tok.ptr=%p tok.len=%lld\n",
        ptr, (void*)p[0], p[1], p[2], p[3], p[4], p[5], (void*)p[6], p[7]);
    fflush(stderr);
}

// ---- Alloca cache (immune to Forge-level ptr corruption) ----
#define ALLOCA_CACHE_SIZE 512
static void* _ac_fn_ptr = NULL; // current LLVM function pointer — entries from other functions are stale
static struct { char name[64]; void* ptr; void* fn; void* alloca_type; } _ac[ALLOCA_CACHE_SIZE];
static int _ac_count = 0;

// Clear cache AND record current function pointer for staleness detection
int64_t forge_alloca_cache_clear(void) {
    // Preserve global entries (fn == NULL) — only clear function-scoped entries
    int write = 0;
    for (int i = 0; i < _ac_count; i++) {
        if (_ac[i].fn == NULL) {
            if (write != i) _ac[write] = _ac[i];
            write++;
        }
    }
    _ac_count = write;
    return 0;
}

// Raw C-string version of cache_set — called from Rust side where name ptr is still valid
int64_t forge_alloca_cache_set_raw(const char* name_ptr, int64_t name_len, void* ptr) {
    if (!name_ptr || name_len <= 0 || name_len > 63) return 0;
    // Update existing entry if same name AND same function
    for (int i = 0; i < _ac_count; i++) {
        if (_ac[i].fn == _ac_fn_ptr &&
            (int64_t)strlen(_ac[i].name) == name_len &&
            memcmp(_ac[i].name, name_ptr, name_len) == 0) {
            _ac[i].ptr = ptr;
            return 0;
        }
    }
    if (_ac_count < ALLOCA_CACHE_SIZE) {
        memcpy(_ac[_ac_count].name, name_ptr, name_len);
        _ac[_ac_count].name[name_len] = '\0';
        _ac[_ac_count].ptr = ptr;
        _ac[_ac_count].fn = _ac_fn_ptr;
        _ac[_ac_count].alloca_type = NULL;
        _ac_count++;
    }
    return 0;
}

// Set current function — called at start of each function body emission
// All entries not matching this fn ptr are considered stale
void forge_alloca_cache_set_fn(void* fn) { _ac_fn_ptr = fn; }

static int _ac_set_trace = 0;
int64_t forge_alloca_cache_set(ForgeString name, void* ptr) {
    if (!name.ptr || name.len <= 0 || name.len > 63 || (uintptr_t)name.ptr < 4096) return 0;
    // Update existing entry if same name AND same function
    for (int i = 0; i < _ac_count; i++) {
        if (_ac[i].fn == _ac_fn_ptr &&
            (int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            _ac[i].ptr = ptr;
            return 0;
        }
    }
    if (_ac_count < ALLOCA_CACHE_SIZE) {
        memcpy(_ac[_ac_count].name, name.ptr, name.len);
        _ac[_ac_count].name[name.len] = '\0';
        _ac[_ac_count].ptr = ptr;
        _ac[_ac_count].fn = _ac_fn_ptr;
        _ac_count++;
    }
    return 0;
}

// Store alloca type alongside the cached ptr
// Called from define_var after creating the alloca with the correct type
void forge_alloca_cache_set_type(ForgeString name, void* type_ptr) {
    if (!name.ptr || name.len <= 0) return;
    for (int i = _ac_count - 1; i >= 0; i--) {
        if (_ac[i].fn == _ac_fn_ptr &&
            (int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            _ac[i].alloca_type = type_ptr;
            return;
        }
    }
}

// Set type for the most recently cached entry
void forge_alloca_cache_set_last_type(void* type_ptr) {
    if (_ac_count > 0) {
        _ac[_ac_count - 1].alloca_type = type_ptr;
    }
}

// Get the stored alloca type for a variable
// Returns the LLVM type pointer, or NULL if not set
void* forge_alloca_cache_get_type(ForgeString name) {
    if (!name.ptr || name.len <= 0) return NULL;
    for (int i = _ac_count - 1; i >= 0; i--) {
        if (_ac[i].fn == _ac_fn_ptr &&
            (int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            return _ac[i].alloca_type;
        }
    }
    // Global scope fallback
    for (int i = _ac_count - 1; i >= 0; i--) {
        if (_ac[i].fn == NULL &&
            (int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            return _ac[i].alloca_type;
        }
    }
    return NULL;
}

// Debug: print Expr tag (for tracing enum dispatch)
typedef struct { int64_t tag; void* payload; } ForgeEnum;
void forge_debug_enum(ForgeEnum e) {
    fprintf(stderr, "  [enum] tag=%lld payload=%p\n", (long long)e.tag, e.payload);
}
void forge_debug_str(ForgeString s) {
    static int _ds_count = 0;
    if (_ds_count < 10) {
        if (s.ptr && s.len > 0 && s.len < 100) {
            fprintf(stderr, "  [str] len=%lld text='%.*s'\n", (long long)s.len, (int)s.len, (char*)s.ptr);
        } else {
            fprintf(stderr, "  [str] len=%lld ptr=%p (invalid)\n", (long long)s.len, s.ptr);
        }
        _ds_count++;
    }
}

// C-side pending Statement for parse-emit cycle
// Avoids ABI corruption when returning { i8, ptr } from mini-built functions
typedef struct { uint8_t tag; char _pad[7]; void* payload; } Statement;
static Statement _pending_stmt;
static int _has_pending_stmt = 0;
void forge_stmt_store(Statement s) {
    _pending_stmt = s;
    _has_pending_stmt = 1;
}
Statement forge_stmt_load(void) {
    _has_pending_stmt = 0;
    return _pending_stmt;
}
int64_t forge_stmt_has(void) { return _has_pending_stmt; }
void forge_stmt_clear(void) { _has_pending_stmt = 0; }

// C-side struct var type tracking (immune to global string assignment corruption)
#define STRUCT_VAR_MAX 128
static struct { char name[64]; char type[64]; } _struct_vars[STRUCT_VAR_MAX];
static int _struct_var_count = 0;

void forge_struct_var_clear(void) { _struct_var_count = 0; }
void forge_struct_var_add(ForgeString name, ForgeString type_name) {
    if (_struct_var_count >= STRUCT_VAR_MAX) return;
    static int _sva_dbg = 0;
    if (_sva_dbg < 10 && name.ptr && name.len > 0 && name.len < 20) {
        fprintf(stderr, "  [sva] %.*s = %.*s\n", (int)name.len, name.ptr,
                (int)(type_name.ptr ? type_name.len : 0), type_name.ptr ? type_name.ptr : "(null)");
        _sva_dbg++;
    }
    if (name.ptr && name.len > 0 && name.len < 64 && type_name.ptr && type_name.len > 0 && type_name.len < 64) {
        memcpy(_struct_vars[_struct_var_count].name, name.ptr, name.len);
        _struct_vars[_struct_var_count].name[name.len] = '\0';
        memcpy(_struct_vars[_struct_var_count].type, type_name.ptr, type_name.len);
        _struct_vars[_struct_var_count].type[type_name.len] = '\0';
        _struct_var_count++;
    }
}
ForgeString forge_struct_var_get(ForgeString name) {
    if (!name.ptr || name.len <= 0) return forge_string_new("", 0);
    for (int i = _struct_var_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_struct_vars[i].name) == name.len &&
            memcmp(_struct_vars[i].name, name.ptr, name.len) == 0) {
            int64_t len = strlen(_struct_vars[i].type);
            return forge_string_new(_struct_vars[i].type, len);
        }
    }
    return forge_string_new("", 0);
}

// C-side variable name tracking (immune to Forge list corruption)
// Tracks variable names pushed during emit_fn_body_from_source param setup
#define VAR_NAME_MAX 256
static char _var_names[VAR_NAME_MAX][64];
static int _var_name_count = 0;
static int _var_name_scope_start = 0;

void forge_var_name_clear(void) { _var_name_count = 0; _var_name_scope_start = 0; }
void forge_var_name_set_scope(int64_t start) { _var_name_scope_start = (int)start; }
void forge_var_name_push(ForgeString name) {
    if (_var_name_count >= VAR_NAME_MAX) return;
    if (name.ptr && name.len > 0 && name.len < 64) {
        memcpy(_var_names[_var_name_count], name.ptr, name.len);
        _var_names[_var_name_count][name.len] = '\0';
    } else {
        _var_names[_var_name_count][0] = '\0';
    }
    _var_name_count++;
}
// Returns 1 if name found in current scope, 0 otherwise
int64_t forge_var_name_exists(ForgeString name) {
    if (!name.ptr || name.len <= 0) return 0;
    for (int i = _var_name_count - 1; i >= _var_name_scope_start; i--) {
        if ((int64_t)strlen(_var_names[i]) == name.len &&
            memcmp(_var_names[i], name.ptr, name.len) == 0) {
            return 1;
        }
    }
    return 0;
}

static int _ac_dbg_fn = 0;  // 1 = debugging active
void forge_ac_debug_on(void) { _ac_dbg_fn = 1; }
void forge_ac_debug_off(void) { _ac_dbg_fn = 0; }

static int _ac_miss_count = 0;
static int _ac_hit_count = 0;
void forge_alloca_cache_stats(void) {
    fprintf(stderr, "  [ac_stats] hits=%d misses=%d ptr_params=%d total_params=%d\n", _ac_hit_count, _ac_miss_count, _ptr_param_count, _param_type_count);
}

// Check if the last-set let name exists in the alloca cache
int64_t forge_let_needs_alloca(void) {
    if (_last_let_name_len <= 0) return 0;
    for (int i = _ac_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_ac[i].name) == _last_let_name_len &&
            memcmp(_ac[i].name, _last_let_name, _last_let_name_len) == 0) {
            return 0;  // Already in cache
        }
    }
    return 1;  // Not in cache — needs alloca
}
static int _ac_trace = 0;
void forge_alloca_cache_trace(int64_t enable) { _ac_trace = (int)enable; _ac_set_trace = (int)enable; }
void* forge_alloca_cache_get(ForgeString name) {
    if (!name.ptr || name.len <= 0 || (uintptr_t)name.ptr < 4096) {
        _ac_miss_count++;
        return NULL;
    }
    // First pass: search current function scope
    for (int i = _ac_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            if (_ac[i].fn == _ac_fn_ptr) {
                _ac_hit_count++;
                return _ac[i].ptr;
            }
        }
    }
    // Second pass: search ANY scope (the fn_ptr might be wrong due to clobbering)
    for (int i = _ac_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_ac[i].name) == name.len &&
            memcmp(_ac[i].name, name.ptr, name.len) == 0) {
            _ac_hit_count++;
            return _ac[i].ptr;
        }
    }
    _ac_miss_count++;
    if (_ac_miss_count <= 10 && name.ptr && name.len > 0 && name.len < 60) {
        fprintf(stderr, "  [ac_miss #%d] name=\"%.*s\"\n", _ac_miss_count, (int)name.len, name.ptr);
    }
    return NULL;
}

// ---- Per-variable type name cache ----
// Stores Forge-level type names (e.g., "string", "int", "Token", "List<Expr>")
// Populated from type annotations during parsing. Used by codegen for correct alloca types.
// Parallels forge_param_type_add/get for function parameters.
#define VAR_TYPE_CACHE_SIZE 512
static struct { char name[64]; char type_name[64]; } _var_types[VAR_TYPE_CACHE_SIZE];
static int _var_type_count = 0;
static int _var_type_global_count = 0;

void forge_var_type_set(ForgeString name, ForgeString type_name) {
    if (!name.ptr || name.len <= 0 || name.len > 63) return;
    if (!type_name.ptr || type_name.len <= 0 || type_name.len > 63) return;
    // Update existing entry (search backwards for most recent)
    for (int i = _var_type_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_var_types[i].name) == name.len &&
            memcmp(_var_types[i].name, name.ptr, name.len) == 0) {
            memcpy(_var_types[i].type_name, type_name.ptr, type_name.len);
            _var_types[i].type_name[type_name.len] = '\0';
            return;
        }
    }
    // Add new entry
    if (_var_type_count < VAR_TYPE_CACHE_SIZE) {
        memcpy(_var_types[_var_type_count].name, name.ptr, name.len);
        _var_types[_var_type_count].name[name.len] = '\0';
        memcpy(_var_types[_var_type_count].type_name, type_name.ptr, type_name.len);
        _var_types[_var_type_count].type_name[type_name.len] = '\0';
        _var_type_count++;
    }
}

ForgeString forge_var_type_get(ForgeString name) {
    if (!name.ptr || name.len <= 0) return (ForgeString){NULL, 0};
    for (int i = _var_type_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_var_types[i].name) == name.len &&
            memcmp(_var_types[i].name, name.ptr, name.len) == 0) {
            int64_t tlen = strlen(_var_types[i].type_name);
            return (ForgeString){_var_types[i].type_name, tlen};
        }
    }
    return (ForgeString){NULL, 0};
}

void forge_var_type_clear(void) { _var_type_count = _var_type_global_count; }
void forge_var_type_set_global_count(void) { _var_type_global_count = _var_type_count; }

// ---- String var name cache (immune to Forge list corruption) ----
#define STR_CACHE_SIZE 256
static char _str_names[STR_CACHE_SIZE][64];
static int _str_count = 0;
static int _str_global_count = 0;
static int _str_check_trace = 0;

int64_t forge_str_var_add_raw(const char* name_ptr, int64_t name_len) {
    if (!name_ptr || name_len <= 0 || name_len > 63) return 0;
    if (_str_count < STR_CACHE_SIZE) {
        memcpy(_str_names[_str_count], name_ptr, name_len);
        _str_names[_str_count][name_len] = '\0';
        _str_count++;
    }
    return 0;
}

int64_t forge_str_var_add(ForgeString name) {
    if (!name.ptr || name.len <= 0 || name.len > 63 || (uintptr_t)name.ptr < 4096) return 0;
    if (_str_count < STR_CACHE_SIZE) {
        memcpy(_str_names[_str_count], name.ptr, name.len);
        _str_names[_str_count][name.len] = '\0';
        if (_str_check_trace && name.len > 10) {
            fprintf(stderr, "  [str_add] %.*s (#%d)\n", (int)name.len, name.ptr, _str_count);
        }
        _str_count++;
    }
    return 0;
}

int64_t forge_str_var_check(ForgeString name) {
    if (!name.ptr || name.len <= 0 || (uintptr_t)name.ptr < 4096) return 0;
    for (int i = _str_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_str_names[i]) == name.len && memcmp(_str_names[i], name.ptr, name.len) == 0) {
            if (_str_check_trace && name.len > 10) {
                fprintf(stderr, "  [str_check HIT] %.*s\n", (int)name.len, name.ptr);
            }
            return 1;
        }
    }
    if (_str_check_trace && name.len > 10 && name.len < 30) {
        fprintf(stderr, "  [str_check MISS] %.*s (count=%d global=%d)\n", (int)name.len, name.ptr, _str_count, _str_global_count);
    }
    return 0;
}
void forge_str_var_check_trace(int64_t enable) { _str_check_trace = (int)enable; }

// Track how many string vars are globals (preserved across clear)
void forge_str_var_set_global_count(void) { _str_global_count = _str_count; }
int64_t forge_str_var_clear(void) { _str_count = _str_global_count; return 0; }

// ---- Index-based alloca cache (no string args needed) ----
#define IDX_CACHE_SIZE 512
static void* _idx_cache[IDX_CACHE_SIZE];
static int _idx_cache_count = 0;

int64_t forge_idx_cache_clear(void) { _idx_cache_count = 0; memset(_idx_cache, 0, sizeof(_idx_cache)); return 0; }
int64_t forge_idx_cache_set(int64_t idx, void* ptr) { if (idx >= 0 && idx < IDX_CACHE_SIZE) _idx_cache[idx] = ptr; return 0; }
void* forge_idx_cache_get(int64_t idx) { if (idx >= 0 && idx < IDX_CACHE_SIZE) return _idx_cache[idx]; return NULL; }

// ---- Global var counter (immune to Forge length corruption) ----
static int64_t _var_counter = 0;
int64_t forge_var_counter_get(void) { return _var_counter; }
int64_t forge_var_counter_inc(void) { return _var_counter++; }
int64_t forge_var_counter_reset(int64_t val) { _var_counter = val; return 0; }

// ---- C-side string helpers for Stage 2 bootstrap ----
// These bypass LLVM Value* corruption in the Forge-compiled codegen.
// Stage 2 calls these directly instead of forge_string_* via MemberAccess.
int64_t forge_sh_indexof(ForgeString s, ForgeString needle) {
    return forge_string_index_of(s, needle);
}
ForgeString forge_sh_substr(ForgeString s, int64_t start, int64_t end) {
    return forge_string_substring(s, start, end);
}
int64_t forge_sh_length(ForgeString s) {
    return s.len;
}
int64_t forge_sh_byteat(ForgeString s, int64_t idx) {
    return forge_string_byte_at(s, idx);
}
// scan_mods helper: find "\nmod " in source, return position or -1
// This replaces forge_string_index_of for the self-hosting scan phase
int64_t forge_find_nmod(ForgeString src) {
    if (!src.ptr || src.len < 5) return -1;
    for (int64_t i = 0; i <= src.len - 5; i++) {
        if (src.ptr[i] == '\n' && src.ptr[i+1] == 'm' && src.ptr[i+2] == 'o' && src.ptr[i+3] == 'd' && src.ptr[i+4] == ' ')
            return i;
    }
    return -1;
}
// scan_mods helper: find "\n" in source
int64_t forge_find_nl(ForgeString src) {
    if (!src.ptr) return -1;
    for (int64_t i = 0; i < src.len; i++) {
        if (src.ptr[i] == '\n') return i;
    }
    return -1;
}
// scan_mods helper: find "/" in source
int64_t forge_find_slash(ForgeString src) {
    if (!src.ptr) return -1;
    for (int64_t i = 0; i < src.len; i++) {
        if (src.ptr[i] == '/') return i;
    }
    return -1;
}

// ---- C-side token accumulator for mini compiler ----
// Avoids O(n²) list push in tokenizer. Stores tokens as flat array of {i64, ForgeString, i64}.
typedef struct { int64_t kind; ForgeString text; int64_t line; } MiniTok;
static MiniTok* _tok_buf = NULL;
static int64_t _tok_count = 0;
static int64_t _tok_cap = 0;

void forge_tok_clear(void) {
    _tok_count = 0;
}
void forge_tok_push(int64_t kind, ForgeString text, int64_t line) {
    if (_tok_count >= _tok_cap) {
        int64_t new_cap = _tok_cap < 1024 ? 1024 : _tok_cap * 2;
        MiniTok* new_buf = (MiniTok*)malloc(new_cap * sizeof(MiniTok));
        if (_tok_buf && _tok_count > 0) {
            memcpy(new_buf, _tok_buf, _tok_count * sizeof(MiniTok));
        }
        free(_tok_buf);
        _tok_buf = new_buf;
        _tok_cap = new_cap;
    }
    _tok_buf[_tok_count++] = (MiniTok){kind, text, line};
}
int64_t forge_tok_count(void) { return _tok_count; }
// Build a Forge List<Tok> from the accumulated tokens
ForgeString forge_tok_to_list(void) {
    // List<Tok> is {ptr, i64} where ptr→array of Tok structs
    int64_t elem_size = sizeof(MiniTok);
    char* data = (char*)malloc(sizeof(int64_t) + _tok_count * elem_size);
    *(int64_t*)data = _tok_count; // capacity header
    char* elems = data + sizeof(int64_t);
    memcpy(elems, _tok_buf, _tok_count * elem_size);
    return (ForgeString){elems, _tok_count};
}

// Look up LLVM type by struct name in C-side registry
void* forge_struct_reg_find_type(ForgeString name) {
    if (!name.ptr || name.len <= 0) return NULL;
    for (int i = _struct_reg_count - 1; i >= 0; i--) {
        if ((int64_t)strlen(_struct_reg[i].name) == name.len &&
            memcmp(_struct_reg[i].name, name.ptr, name.len) == 0) {
            return _struct_reg[i].llvm_type;
        }
    }
    return NULL;
}

// Last emit result (C-side, immune to Forge global corruption)
static void* _last_emit_result = NULL;
void forge_set_last_emit_result(void* val) { _last_emit_result = val; }
void* forge_get_last_emit_result(void) { return _last_emit_result; }

