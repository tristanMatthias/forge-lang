#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <signal.h>

// ---- Signal handlers ----

static void forge_signal_handler(int signum) {
    const char* name;
    switch (signum) {
        case SIGSEGV: name = "segmentation fault"; break;
        case SIGABRT: name = "abort"; break;
        case SIGBUS:  name = "bus error"; break;
        default:      name = "unknown signal"; break;
    }
    // Use write() instead of fprintf to be async-signal-safe
    const char* prefix = "forge: fatal error — ";
    write(STDERR_FILENO, prefix, strlen(prefix));
    write(STDERR_FILENO, name, strlen(name));
    write(STDERR_FILENO, "\n", 1);
    _exit(128 + signum);
}

__attribute__((constructor)) static void forge_install_signal_handlers(void) {
    signal(SIGSEGV, forge_signal_handler);
    signal(SIGABRT, forge_signal_handler);
    signal(SIGBUS, forge_signal_handler);
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

void* forge_alloc(int64_t size) {
    ForgeHeapObj* obj = (ForgeHeapObj*)malloc(sizeof(int64_t) + size);
    obj->rc = 1;
    return (void*)((char*)obj + sizeof(int64_t));
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
    fwrite(s.ptr, 1, s.len, stdout);
    putchar('\n');
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

int8_t forge_string_eq(ForgeString a, ForgeString b) {
    if (a.len != b.len) return 0;
    return memcmp(a.ptr, b.ptr, a.len) == 0 ? 1 : 0;
}

// ---- String byte/char access ----

// Shared bounds check helper — prints error and exits if index is out of range
static void forge_string_bounds_check(ForgeString s, int64_t index, const char* method) {
    if (index < 0 || index >= s.len) {
        fprintf(stderr, "error: %s index %lld out of bounds for string of length %lld\n",
                method, (long long)index, (long long)s.len);
        fprintf(stderr, "  hint: valid indices are 0..%lld\n", (long long)(s.len - 1));
        exit(1);
    }
}

ForgeString forge_string_char_at(ForgeString s, int64_t index) {
    forge_string_bounds_check(s, index, "char_at");
    unsigned char c = (unsigned char)s.ptr[index];
    // ASCII byte — single-byte character
    if (c < 0x80) {
        return forge_string_new(s.ptr + index, 1);
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

int64_t forge_string_byte_at(ForgeString s, int64_t index) {
    forge_string_bounds_check(s, index, "byte_at");
    return (int64_t)(unsigned char)s.ptr[index];
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
