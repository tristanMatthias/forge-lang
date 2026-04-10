// Bootstrap runtime — clean, minimal, purpose-built.
//
// This is NOT the Rust host compiler's runtime. This file provides
// only what the bootstrap compiler and its compiled programs need:
//   1. Selfhost helpers (file I/O, argv, tracing)
//   2. Signal handler (crash reporting)
//   3. Dynamic arrays (forge_array_*)
//   4. Hash maps (forge_map_*)
//   5. String methods (forge_str_*)
//
// All functions use C-string (const char*) and i64 conventions
// matching the bootstrap's everything-is-i64 value model.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>

// ─── Bump allocator ──────────────────────────────────────────────
//
// STEPPING STONE — will be removed when the real compiler has
// ref-counting (Application level) and ownership (Systems level).
//
// Every allocation gets a fresh, unique, never-recycled address.
// No free. No reuse. No overlap. No corruption. The compiler runs
// for <1 second and uses <20MB — 128MB arena is more than enough.
// The OS reclaims everything on process exit.
//
// This replaces malloc for ALL compiler-internal allocations
// (structs, enums, strings, with-expressions). It does NOT replace
// malloc for runtime data structures (arrays, maps) which need
// realloc — those use the system allocator.

#define BUMP_ARENA_SIZE (512 * 1024 * 1024)  // 512MB
static char *bump_arena = NULL;
static size_t bump_offset = 0;

static void bump_init(void) {
    if (!bump_arena) {
        bump_arena = (char *)malloc(BUMP_ARENA_SIZE);
        if (!bump_arena) {
            fprintf(stderr, "fatal: could not allocate bump arena\n");
            exit(1);
        }
    }
}

void *forge_bump_alloc(size_t size) {
    bump_init();
    size = (size + 7) & ~7;  // align to 8 bytes
    if (bump_offset + size > BUMP_ARENA_SIZE) {
        fprintf(stderr, "fatal: bump arena exhausted (%zu bytes used)\n", bump_offset);
        exit(1);
    }
    void *ptr = &bump_arena[bump_offset];
    bump_offset += size;
    return ptr;
}

// Drop-in replacement for malloc — used by the codegen's `with`
// expressions, struct constructors, and enum constructors.
// The codegen emits `call @malloc(i64 N)` for these; we intercept
// by defining malloc here. Array/map code uses forge_array_*/forge_map_*
// which call the real system malloc internally.
//
// The codegen calls forge_bump_alloc() for struct/enum/with allocations.
// malloc() is still used by array/map code that needs realloc.

// ─── Signal handler ───────────────────────────────────────────────

static void forge_signal_handler(int sig) {
    const char* name = sig == SIGSEGV ? "segmentation fault"
                     : sig == SIGBUS  ? "bus error"
                     : sig == SIGABRT ? "abort"
                     : "unknown signal";
    fprintf(stderr, "\nforge: fatal error — %s\n", name);

    // Print backtrace
    void* frames[32];
    int n = backtrace(frames, 32);
    fprintf(stderr, "\nBacktrace:\n");
    backtrace_symbols_fd(frames, n, STDERR_FILENO);

    _exit(128 + sig);
}

__attribute__((constructor))
static void forge_install_signal_handlers(void) {
    signal(SIGSEGV, forge_signal_handler);
    signal(SIGBUS,  forge_signal_handler);
    signal(SIGABRT, forge_signal_handler);
}

// ─── Selfhost helpers ─────────────────────────────────────────────
// These provide process + filesystem access for the bootstrap binary.
// Signatures use const char* (not ForgeString) to match the bootstrap's
// i64-encoded pointer model.

static int    _argc = 0;
static char** _argv = NULL;

__attribute__((constructor))
static void forge_capture_args(int argc, char** argv) {
    _argc = argc;
    _argv = argv;
}

int64_t forge_selfhost_argc(void) {
    return (int64_t)_argc;
}

const char* forge_selfhost_get_arg_cstr(int64_t idx) {
    if (idx < 0 || idx >= _argc) return "";
    return _argv[idx];
}

void forge_selfhost_trace(const char* s) {
    fprintf(stderr, "[trace] %s\n", s);
}

void forge_selfhost_trace_int(const char* label, int64_t val) {
    fprintf(stderr, "[trace] %s: %lld\n", label, (long long)val);
}

int64_t forge_selfhost_file_exists(const char* path) {
    FILE* f = fopen(path, "r");
    if (!f) return 0;
    fclose(f);
    return 1;
}

const char* forge_selfhost_read_file(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) return "";
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = (char*)malloc(size + 1);
    fread(buf, 1, size, f);
    buf[size] = '\0';
    fclose(f);
    return buf;
}

int64_t forge_selfhost_write_file(const char* path, const char* content) {
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    size_t len = strlen(content);
    fwrite(content, 1, len, f);
    fclose(f);
    return 1;
}

// ─── libforge_llvm compatibility stubs ────────────────────────────
// The Rust LLVM wrapper (libforge_llvm.a) calls back into the runtime
// for alloca caching and variable tracking. The bootstrap doesn't use
// these features — it manages its own allocas via the Ctx struct.
// These no-op stubs satisfy the linker.

void  forge_alloca_cache_set_builder(void* b) { (void)b; }
void  forge_alloca_cache_set_context(void* c) { (void)c; }
void  forge_alloca_cache_set_fn(void* f) { (void)f; }
void  forge_alloca_cache_set_raw(const char* n, int64_t nl, void* v) { (void)n; (void)nl; (void)v; }
int64_t forge_check_pending_alloca(void) { return 0; }
const char* forge_pending_alloca_name(void) { return ""; }
int64_t forge_pending_alloca_name_len(void) { return 0; }
void  forge_ptr_var_add_raw(const char* n, int64_t nl) { (void)n; (void)nl; }
void  forge_str_var_add_raw(const char* n, int64_t nl) { (void)n; (void)nl; }
void  forge_set_alloca_name_c_raw(const char* n, int64_t nl) { (void)n; (void)nl; }
double forge_selfhost_string_to_float(const char* s) { return strtod(s, NULL); }

// ─── Dynamic Array ────────────────────────────────────────────────
// Resizable array of i64 values. Used by List<T> in Forge source.
//
// Layout: { int64_t* data; int64_t len; int64_t cap; }
// All values stored as i64 (pointers are ptrtoint'd by the compiler).

typedef struct {
    int64_t* data;
    int64_t  len;
    int64_t  cap;
} ForgeArray;

void* forge_array_new(void) {
    ForgeArray* a = (ForgeArray*)malloc(sizeof(ForgeArray));
    a->cap = 8;
    a->len = 0;
    a->data = (int64_t*)malloc(a->cap * sizeof(int64_t));
    return a;
}

void forge_array_push(void* arr, int64_t value) {
    ForgeArray* a = (ForgeArray*)arr;
    if (a->len >= a->cap) {
        a->cap *= 2;
        a->data = (int64_t*)realloc(a->data, a->cap * sizeof(int64_t));
    }
    a->data[a->len++] = value;
}

int64_t forge_array_get(void* arr, int64_t idx) {
    ForgeArray* a = (ForgeArray*)arr;
    if (idx < 0 || idx >= a->len) return 0;
    return a->data[idx];
}

void forge_array_set(void* arr, int64_t idx, int64_t value) {
    ForgeArray* a = (ForgeArray*)arr;
    if (idx < 0 || idx >= a->len) return;
    a->data[idx] = value;
}

int64_t forge_array_len(void* arr) {
    if (!arr) return 0;
    return ((ForgeArray*)arr)->len;
}

int64_t forge_array_pop(void* arr) {
    ForgeArray* a = (ForgeArray*)arr;
    if (a->len <= 0) return 0;
    return a->data[--a->len];
}

// Create a new array from a slice of an existing one.
void* forge_array_slice(void* arr, int64_t start, int64_t end) {
    ForgeArray* src = (ForgeArray*)arr;
    if (start < 0) start = 0;
    if (end > src->len) end = src->len;
    if (start >= end) return forge_array_new();

    int64_t count = end - start;
    ForgeArray* dst = (ForgeArray*)malloc(sizeof(ForgeArray));
    dst->cap = count > 8 ? count : 8;
    dst->len = count;
    dst->data = (int64_t*)malloc(dst->cap * sizeof(int64_t));
    memcpy(dst->data, src->data + start, count * sizeof(int64_t));
    return dst;
}

// ─── Hash Map ─────────────────────────────────────────────────────
// String-keyed, i64-valued hash map. Linear probing for simplicity.
// Used by Map<string, T> in Forge source and internally by the
// compiler for fast symbol lookup.

#define FORGE_MAP_INIT_CAP 32
#define FORGE_MAP_LOAD_FACTOR 0.75

typedef struct {
    char**   keys;     // NULL = empty slot
    int64_t* values;
    int64_t  count;
    int64_t  cap;
} ForgeHashMap;

static uint64_t forge_hash_str(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    while (*s) {
        h ^= (uint8_t)*s++;
        h *= 1099511628211ULL;
    }
    return h;
}

static void forge_map_grow(ForgeHashMap* m);

void* forge_map_new_cstr(void) {
    ForgeHashMap* m = (ForgeHashMap*)malloc(sizeof(ForgeHashMap));
    m->cap = FORGE_MAP_INIT_CAP;
    m->count = 0;
    m->keys = (char**)calloc(m->cap, sizeof(char*));
    m->values = (int64_t*)calloc(m->cap, sizeof(int64_t));
    return m;
}

void forge_map_set_cstr(void* map, const char* key, int64_t value) {
    ForgeHashMap* m = (ForgeHashMap*)map;
    if ((double)m->count / m->cap >= FORGE_MAP_LOAD_FACTOR) {
        forge_map_grow(m);
    }
    uint64_t idx = forge_hash_str(key) % m->cap;
    while (m->keys[idx]) {
        if (strcmp(m->keys[idx], key) == 0) {
            m->values[idx] = value;  // update existing
            return;
        }
        idx = (idx + 1) % m->cap;
    }
    m->keys[idx] = strdup(key);
    m->values[idx] = value;
    m->count++;
}

int64_t forge_map_get_cstr(void* map, const char* key) {
    ForgeHashMap* m = (ForgeHashMap*)map;
    uint64_t idx = forge_hash_str(key) % m->cap;
    while (m->keys[idx]) {
        if (strcmp(m->keys[idx], key) == 0) {
            return m->values[idx];
        }
        idx = (idx + 1) % m->cap;
    }
    return 0;
}

int64_t forge_map_has_cstr(void* map, const char* key) {
    ForgeHashMap* m = (ForgeHashMap*)map;
    uint64_t idx = forge_hash_str(key) % m->cap;
    while (m->keys[idx]) {
        if (strcmp(m->keys[idx], key) == 0) return 1;
        idx = (idx + 1) % m->cap;
    }
    return 0;
}

int64_t forge_map_len_cstr(void* map) {
    if (!map) return 0;
    return ((ForgeHashMap*)map)->count;
}

// Return an array of all keys.
void* forge_map_keys_cstr(void* map) {
    ForgeHashMap* m = (ForgeHashMap*)map;
    void* arr = forge_array_new();
    for (int64_t i = 0; i < m->cap; i++) {
        if (m->keys[i]) {
            forge_array_push(arr, (int64_t)m->keys[i]);
        }
    }
    return arr;
}

static void forge_map_grow(ForgeHashMap* m) {
    int64_t old_cap = m->cap;
    char** old_keys = m->keys;
    int64_t* old_values = m->values;

    m->cap *= 2;
    m->keys = (char**)calloc(m->cap, sizeof(char*));
    m->values = (int64_t*)calloc(m->cap, sizeof(int64_t));
    m->count = 0;

    for (int64_t i = 0; i < old_cap; i++) {
        if (old_keys[i]) {
            forge_map_set_cstr(m, old_keys[i], old_values[i]);
            free(old_keys[i]);
        }
    }
    free(old_keys);
    free(old_values);
}

// ─── String Methods ───────────────────────────────────────────────
// All take const char* and return const char* or int64_t.
// Returned strings are heap-allocated (caller doesn't free in
// the bootstrap's GC-free model — acceptable for a compiler).

int64_t forge_str_contains(const char* haystack, const char* needle) {
    return strstr(haystack, needle) != NULL;
}

int64_t forge_str_starts_with(const char* s, const char* prefix) {
    size_t plen = strlen(prefix);
    return strncmp(s, prefix, plen) == 0;
}

int64_t forge_str_ends_with(const char* s, const char* suffix) {
    size_t slen = strlen(s);
    size_t xlen = strlen(suffix);
    if (xlen > slen) return 0;
    return strcmp(s + slen - xlen, suffix) == 0;
}

int64_t forge_str_index_of(const char* s, const char* needle) {
    const char* p = strstr(s, needle);
    if (!p) return -1;
    return (int64_t)(p - s);
}

const char* forge_str_replace(const char* s, const char* from, const char* to) {
    size_t slen = strlen(s);
    size_t flen = strlen(from);
    size_t tlen = strlen(to);
    if (flen == 0) {
        char* r = (char*)malloc(slen + 1);
        memcpy(r, s, slen + 1);
        return r;
    }

    // Count occurrences
    int count = 0;
    const char* p = s;
    while ((p = strstr(p, from))) { count++; p += flen; }

    size_t rlen = slen + count * (tlen - flen);
    char* result = (char*)malloc(rlen + 1);
    char* w = result;
    p = s;
    while (*p) {
        if (strncmp(p, from, flen) == 0) {
            memcpy(w, to, tlen);
            w += tlen;
            p += flen;
        } else {
            *w++ = *p++;
        }
    }
    *w = '\0';
    return result;
}

const char* forge_str_trim(const char* s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t len = strlen(s);
    while (len > 0 && (s[len-1] == ' ' || s[len-1] == '\t' || s[len-1] == '\n' || s[len-1] == '\r')) len--;
    char* r = (char*)malloc(len + 1);
    memcpy(r, s, len);
    r[len] = '\0';
    return r;
}

const char* forge_str_to_upper(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)malloc(len + 1);
    for (size_t i = 0; i <= len; i++) {
        r[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
    }
    return r;
}

const char* forge_str_to_lower(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)malloc(len + 1);
    for (size_t i = 0; i <= len; i++) {
        r[i] = (s[i] >= 'A' && s[i] <= 'Z') ? s[i] + 32 : s[i];
    }
    return r;
}

int64_t forge_str_char_code(const char* s, int64_t idx) {
    size_t len = strlen(s);
    if (idx < 0 || (size_t)idx >= len) return 0;
    return (int64_t)(unsigned char)s[idx];
}

const char* forge_str_from_char_code(int64_t code) {
    char* r = (char*)malloc(2);
    r[0] = (char)code;
    r[1] = '\0';
    return r;
}

// Split string by separator, returns a ForgeArray of string pointers.
void* forge_str_split(const char* s, const char* sep) {
    void* arr = forge_array_new();
    size_t seplen = strlen(sep);
    if (seplen == 0) {
        // Split into characters
        size_t len = strlen(s);
        for (size_t i = 0; i < len; i++) {
            char* ch = (char*)malloc(2);
            ch[0] = s[i];
            ch[1] = '\0';
            forge_array_push(arr, (int64_t)ch);
        }
        return arr;
    }
    const char* p = s;
    while (*p) {
        const char* found = strstr(p, sep);
        if (!found) {
            char* chunk = strdup(p);
            forge_array_push(arr, (int64_t)chunk);
            break;
        }
        size_t chunk_len = found - p;
        char* chunk = (char*)malloc(chunk_len + 1);
        memcpy(chunk, p, chunk_len);
        chunk[chunk_len] = '\0';
        forge_array_push(arr, (int64_t)chunk);
        p = found + seplen;
    }
    return arr;
}

// ─── Higher-order list operations ─────────────────────────────────

typedef int64_t (*ForgeFn1)(int64_t);
typedef int64_t (*ForgeFn2)(int64_t, int64_t);

// Forward declarations for closure trampolines
int64_t forge_closure_call_1(int64_t closure, int64_t a0);
int64_t forge_closure_call_2(int64_t closure, int64_t a0, int64_t a1);

void* forge_array_map(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    void* dst = forge_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        forge_array_push(dst, forge_closure_call_1(fn_ptr, src->data[i]));
    }
    return dst;
}

void* forge_array_filter(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    void* dst = forge_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        if (forge_closure_call_1(fn_ptr, src->data[i])) {
            forge_array_push(dst, src->data[i]);
        }
    }
    return dst;
}

int64_t forge_array_reduce(void* arr, int64_t initial, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    int64_t acc = initial;
    for (int64_t i = 0; i < src->len; i++) {
        acc = forge_closure_call_2(fn_ptr, acc, src->data[i]);
    }
    return acc;
}

void forge_array_foreach(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    for (int64_t i = 0; i < src->len; i++) {
        forge_closure_call_1(fn_ptr, src->data[i]);
    }
}

// ─── Closure support ──────────────────────────────────────────────
// A closure with captures is stored as a ForgeArray:
//   [0] = fn_ptr (intptr_t)
//   [1..N] = captured values
// A non-capturing closure is a bare function pointer (int64_t).
//
// forge_closure_call dispatches: if the value looks like a ForgeArray
// (has a valid length field), unpack fn_ptr + captures and call with
// both user args and captures. Otherwise call directly.

// Tagged closure: first element of ForgeArray is a magic sentinel.
// Non-capturing lambdas: bare function pointer (positive code address).
// Capturing closures: ForgeArray with data[0] = CLOSURE_TAG, data[1] = fn_ptr, data[2..] = captures.
#define FORGE_CLOSURE_TAG ((int64_t)-559038737)

int64_t forge_closure_get_fn(int64_t closure_val) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
        if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[1]; // fn_ptr is second element (after tag)
    }
    return closure_val; // bare fn pointer
}

int64_t forge_closure_get_capture(int64_t closure_val, int64_t idx) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
    if (arr && arr->len > idx + 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[idx + 2]; // captures start at index 2
    }
    return 0;
}

int64_t forge_closure_num_captures(int64_t closure_val) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
        if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->len - 2; // total elements minus tag and fn_ptr
    }
    return 0;
}

// Generic closure call: handles both bare fn pointers and closure arrays.
// Supports up to 8 user args and 8 captured values.
int64_t forge_closure_call_1(int64_t closure, int64_t a0) {
    int64_t n = forge_closure_num_captures(closure);
    int64_t fn = forge_closure_get_fn(closure);
    typedef int64_t (*Fn1)(int64_t);
    typedef int64_t (*Fn2)(int64_t, int64_t);
    typedef int64_t (*Fn3)(int64_t, int64_t, int64_t);
    if (n == 0) return ((Fn1)(uintptr_t)fn)(a0);
    if (n == 1) return ((Fn2)(uintptr_t)fn)(a0, forge_closure_get_capture(closure, 0));
    if (n == 2) return ((Fn3)(uintptr_t)fn)(a0, forge_closure_get_capture(closure, 0), forge_closure_get_capture(closure, 1));
    return ((Fn1)(uintptr_t)fn)(a0); // fallback
}

int64_t forge_closure_call_2(int64_t closure, int64_t a0, int64_t a1) {
    int64_t n = forge_closure_num_captures(closure);
    int64_t fn = forge_closure_get_fn(closure);
    typedef int64_t (*Fn2)(int64_t, int64_t);
    typedef int64_t (*Fn3)(int64_t, int64_t, int64_t);
    typedef int64_t (*Fn4)(int64_t, int64_t, int64_t, int64_t);
    if (n == 0) return ((Fn2)(uintptr_t)fn)(a0, a1);
    if (n == 1) return ((Fn3)(uintptr_t)fn)(a0, a1, forge_closure_get_capture(closure, 0));
    if (n == 2) return ((Fn4)(uintptr_t)fn)(a0, a1, forge_closure_get_capture(closure, 0), forge_closure_get_capture(closure, 1));
    return ((Fn2)(uintptr_t)fn)(a0, a1); // fallback
}

int64_t forge_closure_call_0(int64_t closure) {
    int64_t n = forge_closure_num_captures(closure);
    int64_t fn = forge_closure_get_fn(closure);
    typedef int64_t (*Fn0)(void);
    typedef int64_t (*Fn1)(int64_t);
    if (n == 0) return ((Fn0)(uintptr_t)fn)();
    if (n == 1) return ((Fn1)(uintptr_t)fn)(forge_closure_get_capture(closure, 0));
    if (n == 2) { typedef int64_t (*Fn2x)(int64_t, int64_t); return ((Fn2x)(uintptr_t)fn)(forge_closure_get_capture(closure, 0), forge_closure_get_capture(closure, 1)); }
    return ((Fn0)(uintptr_t)fn)(); // fallback
}

int64_t forge_closure_call_3(int64_t closure, int64_t a0, int64_t a1, int64_t a2) {
    int64_t n = forge_closure_num_captures(closure);
    int64_t fn = forge_closure_get_fn(closure);
    typedef int64_t (*Fn3)(int64_t, int64_t, int64_t);
    typedef int64_t (*Fn4)(int64_t, int64_t, int64_t, int64_t);
    typedef int64_t (*Fn5)(int64_t, int64_t, int64_t, int64_t, int64_t);
    if (n == 0) return ((Fn3)(uintptr_t)fn)(a0, a1, a2);
    if (n == 1) return ((Fn4)(uintptr_t)fn)(a0, a1, a2, forge_closure_get_capture(closure, 0));
    if (n == 2) return ((Fn5)(uintptr_t)fn)(a0, a1, a2, forge_closure_get_capture(closure, 0), forge_closure_get_capture(closure, 1));
    return ((Fn3)(uintptr_t)fn)(a0, a1, a2); // fallback
}

// ── Levenshtein distance ──
// Used by "did you mean?" suggestions in the compiler.
int64_t forge_selfhost_levenshtein(const char *a, const char *b, int64_t len_a, int64_t len_b) {
    if (len_a == 0) return len_b;
    if (len_b == 0) return len_a;
    // Use a single row of the DP matrix (O(min(m,n)) space).
    int64_t *row = (int64_t *)malloc((len_b + 1) * sizeof(int64_t));
    for (int64_t j = 0; j <= len_b; j++) row[j] = j;
    for (int64_t i = 1; i <= len_a; i++) {
        int64_t prev = row[0];
        row[0] = i;
        for (int64_t j = 1; j <= len_b; j++) {
            int64_t cost = (a[i-1] == b[j-1]) ? 0 : 1;
            int64_t del = row[j] + 1;
            int64_t ins = row[j-1] + 1;
            int64_t sub = prev + cost;
            prev = row[j];
            int64_t best = del < ins ? del : ins;
            row[j] = best < sub ? best : sub;
        }
    }
    int64_t result = row[len_b];
    free(row);
    return result;
}

// ── Hex escape: \xHH → single-byte C string ──
static int hex_val(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return 10 + c - 'a';
    if (c >= 'A' && c <= 'F') return 10 + c - 'A';
    return 0;
}
const char* forge_char_from_hex(const char* hi, const char* lo) {
    char* buf = (char*)malloc(2);
    buf[0] = (char)((hex_val(hi[0]) << 4) | hex_val(lo[0]));
    buf[1] = 0;
    return buf;
}

// ═══════════════════════════════════════════════════════════════════
// Developer tooling — debugging, crash guards, tracing
// ═══════════════════════════════════════════════════════════════════

#include <setjmp.h>

// ── 1. Crash guard ──────────────────────────────────────────────
// Wraps a function call in setjmp/longjmp so a segfault inside
// becomes a return value instead of a process-killing signal.
// Usage: if (forge_try_call(fn, arg1, arg2)) { /* crashed */ }

static jmp_buf forge_crash_jmp;
static volatile sig_atomic_t forge_crash_guard_active = 0;

static void forge_crash_guard_handler(int sig) {
    if (forge_crash_guard_active) {
        forge_crash_guard_active = 0;
        longjmp(forge_crash_jmp, sig);
    }
    // Not guarded — fall through to normal handler
    forge_signal_handler(sig);
}

// Returns 0 on success, signal number on crash.
int64_t forge_try_call_1(int64_t (*fn)(int64_t), int64_t a) {
    struct sigaction old_segv, old_bus;
    struct sigaction sa = { .sa_handler = forge_crash_guard_handler };
    sigaction(SIGSEGV, &sa, &old_segv);
    sigaction(SIGBUS, &sa, &old_bus);

    forge_crash_guard_active = 1;
    int sig = setjmp(forge_crash_jmp);
    if (sig == 0) {
        fn(a);
        forge_crash_guard_active = 0;
        sigaction(SIGSEGV, &old_segv, NULL);
        sigaction(SIGBUS, &old_bus, NULL);
        return 0;
    }
    // Crashed
    sigaction(SIGSEGV, &old_segv, NULL);
    sigaction(SIGBUS, &old_bus, NULL);
    return (int64_t)sig;
}

// ── 2. Value tracer ─────────────────────────────────────────────
// Prints a label + pointer value + validates which memory region
// it belongs to (bump arena, system heap, stack, text).

void forge_trace_ptr(const char* label, int64_t val) {
    uintptr_t p = (uintptr_t)val;
    const char* region = "unknown";

    // Check bump arena
    if (bump_arena && p >= (uintptr_t)bump_arena &&
        p < (uintptr_t)bump_arena + BUMP_ARENA_SIZE) {
        region = "bump";
    }
    // Check stack (rough heuristic — stack is near sp)
    else {
        uintptr_t sp;
        __asm__ volatile("mov %0, sp" : "=r"(sp));
        if (p > sp - 1024*1024 && p < sp + 1024*1024) {
            region = "stack";
        }
        // System heap is typically in 0x600000000000 range on macOS
        else if (p >= 0x100000000ULL && p < 0x700000000000ULL) {
            region = "heap";
        }
        // Text segment
        else if (p < 0x100000000ULL && p > 0x100000ULL) {
            region = "text";
        }
        else if (p < 0x100000ULL) {
            region = "INVALID(low)";
        }
    }
    fprintf(stderr, "[trace] %s = 0x%llx (%s)\n", label, (unsigned long long)val, region);
}

// ── 3. IR function dumper ───────────────────────────────────────
// Already exists as forge_dump_function in the LLVM wrapper.
// This adds a name-based lookup + dump for any function in the module.

// (forge_dump_function is already declared via libforge_llvm.a)

// ── 4. AST dumper ───────────────────────────────────────────────
// Prints Stmt/Expr enum tag + pointer for debugging AST traversal.

void forge_dump_stmt(const char* label, int64_t stmt_ptr) {
    if (stmt_ptr == 0) {
        fprintf(stderr, "[ast] %s: NULL\n", label);
        return;
    }
    uint8_t* p = (uint8_t*)(uintptr_t)stmt_ptr;
    uint8_t tag = p[0];
    const char* names[] = {
        "Let", "Mut", "Expr", "Block", "If", "While", "For", "ForIn",
        "Function", "Return", "ReturnEmpty", "TypeDecl", "EnumDecl",
        "Match", "Impl", "NoOp", "ExternFn", "Break", "Continue",
        "TraitDecl", "LetDestructure", "Defer"
    };
    const char* name = tag < 22 ? names[tag] : "???";
    // Read fields as i64
    int64_t* fields = (int64_t*)(p + 8); // skip tag + padding
    fprintf(stderr, "[ast] %s: Stmt.%s (tag=%d) at %p fields=[%llx, %llx, %llx, %llx]\n",
        label, name, tag, p,
        (unsigned long long)fields[0], (unsigned long long)fields[1],
        (unsigned long long)fields[2], (unsigned long long)fields[3]);
}

void forge_dump_stmt_list(const char* label, int64_t list_ptr) {
    if (list_ptr == 0) {
        fprintf(stderr, "[ast] %s: NULL\n", label);
        return;
    }
    uint8_t* p = (uint8_t*)(uintptr_t)list_ptr;
    uint8_t tag = p[0];
    if (tag == 0) {
        fprintf(stderr, "[ast] %s: StmtList.End\n", label);
        return;
    }
    int64_t* fields = (int64_t*)(p + 8);
    fprintf(stderr, "[ast] %s: StmtList.Node at %p stmt=%llx next=%llx\n",
        label, p, (unsigned long long)fields[0], (unsigned long long)fields[1]);
    // Dump the stmt
    forge_dump_stmt("  stmt", fields[0]);
}

// ── eprintln: write string + newline to stderr ──
void forge_eprintln(const char* s) {
    fputs(s, stderr);
    fputc('\n', stderr);
}

// ── Float support ──
int64_t forge_float_parse(const char* s) {
    double d = strtod(s, NULL);
    int64_t result;
    memcpy(&result, &d, sizeof(result));
    return result;
}

const char* forge_float_to_string(int64_t bits) {
    double d;
    memcpy(&d, &bits, sizeof(d));
    char* buf = (char*)malloc(64);
    // Use shortest representation that round-trips: try %g first,
    // fall back to %.15g if precision is lost.
    snprintf(buf, 64, "%g", d);
    double check;
    sscanf(buf, "%lf", &check);
    if (check != d) {
        snprintf(buf, 64, "%.15g", d);
    }
    // Find decimal point
    char* dot = strchr(buf, '.');
    if (dot) {
        char* end = buf + strlen(buf) - 1;
        while (end > dot && *end == '0') end--;
        if (end == dot) end++;  // keep at least one digit after dot
        *(end + 1) = '\0';
    }
    return buf;
}

// ── Feature registry helpers ──
// Extract the enum discriminant tag (first byte) from an enum value.
// Enums are heap-allocated structs with {i8 tag, i64 field1, ...}.
int64_t forge_expr_tag(int64_t expr_val) {
    uint8_t* p = (uint8_t*)(uintptr_t)expr_val;
    return (int64_t)p[0];
}

int64_t forge_stmt_tag(int64_t stmt_val) {
    uint8_t* p = (uint8_t*)(uintptr_t)stmt_val;
    return (int64_t)p[0];
}
