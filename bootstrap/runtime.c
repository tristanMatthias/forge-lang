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
#include <stdarg.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/mman.h>
#if defined(__APPLE__) && (defined(__aarch64__) || defined(__arm64__))
#define _XOPEN_SOURCE
#include <ucontext.h>
#undef _XOPEN_SOURCE
#include <mach/mach.h>
#include <mach-o/dyld.h>
#endif

// ─── Forward declarations for error reporting ────────────────────
static void forge_runtime_error(const char* msg);
static void forge_runtime_errorf(const char* fmt, ...);

// ─── Result tagging (debug only) ─────────────────────────────────
// forge_tag_as_result is called from codegen helpers (ok_emit, err_emit, etc.)
// to tag pointers for optional debug validation via FORGE_TRACK_RESULTS env var.
// In production (no env var), this is a no-op that returns ptr unchanged.

void* forge_tag_as_result(void* ptr) {
    return ptr;
}

// ─── Reference counting ──────────────────────────────────────────
//
// RC header layout (8 bytes, placed BEFORE the user pointer):
//   [ int32_t refcount | int32_t type_tag ]
//   ^                                      ^
//   header_ptr                             user_ptr (what callers see)
//
// forge_rc_alloc returns user_ptr. The header is at user_ptr - 8.
// Non-atomic counters (spec Axis 9.4) — single-threaded v1.0.

#define RC_HEADER_SIZE 8
#define RC_MAGIC 0x5243  // "RC" in little-endian

typedef struct {
    int32_t refcount;
    int32_t type_tag;   // RC_MAGIC sentinel + reserved for cycle detection
} RcHeader;

static inline RcHeader* rc_header(void* ptr) {
    return (RcHeader*)((char*)ptr - RC_HEADER_SIZE);
}

static int rc_trace = 0;

__attribute__((constructor))
static void auto_enable_rc_trace(void) {
    if (getenv("FORGE_RC_TRACE")) {
        rc_trace = 1;
        fprintf(stderr, "[RC_TRACE] enabled\n");
    }
}

// ─── RC pointer set (open-addressing hash set) ──────────────────
// Tracks all live RC-managed pointers so is_rc_managed can safely
// distinguish RC objects from bump/stack/literal pointers.
#define RC_SET_INITIAL_CAP 4096
static void** rc_set_buckets = NULL;
static size_t rc_set_cap = 0;
static size_t rc_set_count = 0;

static void rc_set_init(void) {
    if (rc_set_buckets) return;
    rc_set_cap = RC_SET_INITIAL_CAP;
    rc_set_buckets = (void**)calloc(rc_set_cap, sizeof(void*));
}

static size_t rc_set_hash(void* ptr) {
    uintptr_t v = (uintptr_t)ptr;
    v = ((v >> 3) ^ (v >> 17)) * 0x9E3779B97F4A7C15ULL;
    return (size_t)v;
}

static void rc_set_insert_into(void** buckets, size_t cap, void* ptr) {
    size_t idx = rc_set_hash(ptr) & (cap - 1);
    while (buckets[idx] != NULL && buckets[idx] != ptr) {
        idx = (idx + 1) & (cap - 1);
    }
    buckets[idx] = ptr;
}

static void rc_set_grow(void) {
    size_t new_cap = rc_set_cap * 2;
    void** new_buckets = (void**)calloc(new_cap, sizeof(void*));
    for (size_t i = 0; i < rc_set_cap; i++) {
        if (rc_set_buckets[i]) {
            rc_set_insert_into(new_buckets, new_cap, rc_set_buckets[i]);
        }
    }
    free(rc_set_buckets);
    rc_set_buckets = new_buckets;
    rc_set_cap = new_cap;
}

static void rc_set_add(void* ptr) {
    rc_set_init();
    if (rc_set_count * 4 >= rc_set_cap * 3) rc_set_grow();  // 75% load factor
    size_t idx = rc_set_hash(ptr) & (rc_set_cap - 1);
    while (rc_set_buckets[idx] != NULL && rc_set_buckets[idx] != ptr) {
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    if (rc_set_buckets[idx] == NULL) {
        rc_set_buckets[idx] = ptr;
        rc_set_count++;
    }
}

static int rc_set_contains(void* ptr) {
    if (!rc_set_buckets || rc_set_count == 0) return 0;
    size_t idx = rc_set_hash(ptr) & (rc_set_cap - 1);
    while (rc_set_buckets[idx] != NULL) {
        if (rc_set_buckets[idx] == ptr) return 1;
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    return 0;
}

static void rc_set_remove(void* ptr) {
    if (!rc_set_buckets) return;
    size_t idx = rc_set_hash(ptr) & (rc_set_cap - 1);
    while (rc_set_buckets[idx] != NULL) {
        if (rc_set_buckets[idx] == ptr) {
            // Backward-shift deletion: move entries back to fill the gap.
            // Each subsequent entry in the cluster is checked: if it's at
            // its home position (PSL=0), stop; otherwise shift it back one
            // slot. This avoids tombstones and maintains probe ordering.
            rc_set_buckets[idx] = NULL;
            rc_set_count--;
            size_t next = (idx + 1) & (rc_set_cap - 1);
            while (rc_set_buckets[next] != NULL) {
                size_t home = rc_set_hash(rc_set_buckets[next]) & (rc_set_cap - 1);
                if (home == next) break;  // entry is at home position (PSL=0), stop
                rc_set_buckets[idx] = rc_set_buckets[next];
                rc_set_buckets[next] = NULL;
                idx = next;
                next = (idx + 1) & (rc_set_cap - 1);
            }
            return;
        }
        idx = (idx + 1) & (rc_set_cap - 1);
    }
}

// Allocate an RC-managed object via system malloc.
// Returns pointer to payload (past header).
void* forge_rc_alloc(int64_t payload_size) {
    size_t total = RC_HEADER_SIZE + (size_t)payload_size;
    total = (total + 7) & ~7;  // align to 8
    void* raw = malloc(total);
    if (!raw) {
        forge_runtime_errorf("out of memory (rc_alloc %lld bytes)", (long long)payload_size);
        exit(1);
    }
    RcHeader* hdr = (RcHeader*)raw;
    hdr->refcount = 1;
    hdr->type_tag = RC_MAGIC;
    void* user_ptr = (char*)raw + RC_HEADER_SIZE;
    rc_set_add(user_ptr);
    if (rc_trace) {
        fprintf(stderr, "[RC] alloc %p (payload=%lld, rc=1)\n", user_ptr, (long long)payload_size);
    }
    return user_ptr;
}

// Check if a pointer is an RC-managed object using the pointer set.
static inline int is_rc_managed(void* ptr) {
    return rc_set_contains(ptr);
}

// Increment reference count.
void forge_rc_retain(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return;
    hdr->refcount++;
    if (rc_trace) {
        fprintf(stderr, "[RC] retain %p (rc=%d)\n", ptr, hdr->refcount);
    }
}

// Decrement reference count. Frees the object when refcount reaches 0.
void forge_rc_release(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return;
    hdr->refcount--;
    if (rc_trace) {
        fprintf(stderr, "[RC] release %p (rc=%d)\n", ptr, hdr->refcount);
    }
    if (hdr->refcount == 0) {
        if (rc_trace) {
            fprintf(stderr, "[RC] free %p\n", ptr);
        }
        hdr->type_tag = 0;  // Clear magic to prevent double-free
        rc_set_remove(ptr);
        free((char*)ptr - RC_HEADER_SIZE);
    }
}

// Decrement refcount and return 1 if the object should be freed (refcount hit 0).
// Does NOT free the memory — the caller is responsible for releasing fields
// first, then calling forge_rc_free. Used by generated __release_TypeName
// functions for recursive field release.
int64_t forge_rc_should_free(void* ptr) {
    if (!ptr) return 0;
    if (!is_rc_managed(ptr)) return 0;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return 0;
    hdr->refcount--;
    if (rc_trace) {
        fprintf(stderr, "[RC] should_free %p (rc=%d)\n", ptr, hdr->refcount);
    }
    return hdr->refcount == 0 ? 1 : 0;
}

// Free an RC object without decrementing. Called after forge_rc_should_free
// returned 1 and the caller has released all inner fields.
void forge_rc_free(void* ptr) {
    if (!ptr) return;
    RcHeader* hdr = rc_header(ptr);
    if (rc_trace) {
        fprintf(stderr, "[RC] free %p\n", ptr);
    }
    hdr->type_tag = 0;  // Clear magic to prevent double-free
    rc_set_remove(ptr);
    free((char*)ptr - RC_HEADER_SIZE);
}

// ─── RC cycle detection (spec Axis 9.5) ─────────────────────────
//
// Targeted cycle collection for reference-counted objects.
// Cycle-capable types (identified at compile time via static analysis)
// call forge_rc_suspect() when their refcount decrements to non-zero.
// forge_rc_collect() at program exit frees any remaining suspects,
// breaking cycles that pure refcounting cannot reclaim.

#define SUSPECT_INITIAL_CAP 256
static void** suspect_list = NULL;
static size_t suspect_count = 0;
static size_t suspect_cap = 0;

// Add a pointer to the suspect list. Called from generated __release_TypeName
// when refcount decrements to non-zero for cycle-capable types.
void forge_rc_suspect(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    // Lazy init
    if (!suspect_list) {
        suspect_cap = SUSPECT_INITIAL_CAP;
        suspect_list = (void**)calloc(suspect_cap, sizeof(void*));
    }
    // Deduplicate: don't add if already in list
    for (size_t i = 0; i < suspect_count; i++) {
        if (suspect_list[i] == ptr) return;
    }
    // Grow if needed
    if (suspect_count >= suspect_cap) {
        suspect_cap *= 2;
        suspect_list = (void**)realloc(suspect_list, suspect_cap * sizeof(void*));
    }
    suspect_list[suspect_count++] = ptr;
    if (rc_trace) {
        fprintf(stderr, "[RC] suspect %p (rc=%d)\n", ptr, rc_header(ptr)->refcount);
    }
}

// Collect cycles at program exit. Frees any RC objects that are still
// alive and were suspected of being in cycles. Since this runs at exit,
// it's safe to force-free without recursive field release — the process
// is terminating and all memory will be reclaimed by the OS anyway.
// The purpose is to run destructors and report leaks accurately.
void forge_rc_collect(void) {
    if (!suspect_list || suspect_count == 0) return;
    if (rc_trace) {
        fprintf(stderr, "[RC] cycle collect: %zu suspects\n", suspect_count);
    }
    size_t freed = 0;
    for (size_t i = 0; i < suspect_count; i++) {
        void* ptr = suspect_list[i];
        if (!ptr) continue;
        // Check if still alive in the RC set
        if (!rc_set_contains(ptr)) continue;
        RcHeader* hdr = rc_header(ptr);
        if (hdr->type_tag != RC_MAGIC) continue;
        if (hdr->refcount > 0) {
            // Still alive with positive refcount — part of a cycle.
            // Force-free it.
            if (rc_trace) {
                fprintf(stderr, "[RC] cycle-free %p (rc=%d)\n", ptr, hdr->refcount);
            }
            hdr->type_tag = 0;
            rc_set_remove(ptr);
            free((char*)ptr - RC_HEADER_SIZE);
            freed++;
        }
    }
    if (rc_trace && freed > 0) {
        fprintf(stderr, "[RC] cycle collect freed %zu objects\n", freed);
    }
    free(suspect_list);
    suspect_list = NULL;
    suspect_count = 0;
    suspect_cap = 0;
}

// ─── Scope-aware arena allocation (spec Axis 9.6) ───────────────
//
// Per-scope bump allocators for short-lived allocations. The compiler
// detects loops with non-escaping struct allocations and wraps them
// in an arena scope. All allocations within the scope use O(1) bump
// allocation, and the entire arena is freed in O(1) at scope exit.
//
// Arena layout: linked list of pages. Each page is a contiguous
// allocation with a bump pointer. When a page fills, a new page
// is allocated and linked.

#define ARENA_PAGE_SIZE (64 * 1024)  // 64KB per page

typedef struct ArenaPage {
    struct ArenaPage* next;
    size_t offset;
    size_t capacity;
    char data[];  // flexible array member
} ArenaPage;

typedef struct {
    ArenaPage* current;   // current page for allocations
    ArenaPage* first;     // first page (for freeing)
} Arena;

static ArenaPage* arena_page_new(size_t capacity) {
    ArenaPage* page = (ArenaPage*)malloc(sizeof(ArenaPage) + capacity);
    if (!page) {
        fprintf(stderr, "\nerror: arena page allocation failed\n");
        exit(1);
    }
    page->next = NULL;
    page->offset = 0;
    page->capacity = capacity;
    return page;
}

// Create a new per-scope arena.
void* forge_arena_new(void) {
    Arena* arena = (Arena*)malloc(sizeof(Arena));
    if (!arena) {
        fprintf(stderr, "\nerror: arena allocation failed\n");
        exit(1);
    }
    ArenaPage* page = arena_page_new(ARENA_PAGE_SIZE);
    arena->current = page;
    arena->first = page;
    return arena;
}

// Bump-allocate within an arena. O(1) fast path.
// Objects allocated here do NOT get RC headers — they are freed
// in bulk when the arena is destroyed.
void* forge_arena_alloc(void* arena_ptr, int64_t size) {
    Arena* arena = (Arena*)arena_ptr;
    size_t aligned = ((size_t)size + 7) & ~7;  // 8-byte align

    // Fast path: fits in current page
    if (arena->current->offset + aligned <= arena->current->capacity) {
        void* ptr = &arena->current->data[arena->current->offset];
        arena->current->offset += aligned;
        return ptr;
    }

    // Slow path: allocate new page (at least big enough for this request)
    size_t page_cap = aligned > ARENA_PAGE_SIZE ? aligned : ARENA_PAGE_SIZE;
    ArenaPage* new_page = arena_page_new(page_cap);
    new_page->next = NULL;
    arena->current->next = new_page;
    arena->current = new_page;

    void* ptr = &new_page->data[new_page->offset];
    new_page->offset += aligned;
    return ptr;
}

// Destroy an arena, freeing all pages in O(1) amortized. Called at scope exit.
void forge_arena_destroy(void* arena_ptr) {
    if (!arena_ptr) return;
    Arena* arena = (Arena*)arena_ptr;
    ArenaPage* page = arena->first;
    while (page) {
        ArenaPage* next = page->next;
        free(page);
        page = next;
    }
    free(arena);
}

// ─── Central error reporting ──────────────────────────────────────
//
// All runtime errors go through these two functions. This ensures
// consistent formatting ("\nerror: ...\n") and a single place to
// change the output behavior.
//
// forge_runtime_error  — async-signal-safe (uses write() only)
// forge_runtime_errorf — formatted (NOT async-signal-safe)

static void safe_write(const char* s) {
    write(STDERR_FILENO, s, strlen(s));
}

static void safe_write_int(long long n) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%lld", n);
    write(STDERR_FILENO, buf, len);
}

static void safe_write_ptr(const void* p) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%p", p);
    write(STDERR_FILENO, buf, len);
}

static void safe_write_hex(unsigned long long v) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%016llx", v);
    write(STDERR_FILENO, buf, len);
}

// Async-signal-safe: uses write() only. Safe in signal handlers.
static void forge_runtime_error(const char* msg) {
    safe_write("\nerror: ");
    safe_write(msg);
    safe_write("\n");
}

// Formatted version: uses fprintf. NOT async-signal-safe.
static void forge_runtime_errorf(const char* fmt, ...) {
    fprintf(stderr, "\nerror: ");
    va_list args;
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fprintf(stderr, "\n");
}

// ─── Signal handler ───────────────────────────────────────────────

static void forge_signal_handler(int sig, siginfo_t *si, void *context) {
    // This entire handler uses only async-signal-safe functions:
    // write(), _exit(), backtrace(), dladdr(), snprintf() into stack buffers.
    // NO fprintf, NO malloc, NO stdio.

    const char* name = sig == SIGSEGV ? "segmentation fault"
                     : sig == SIGBUS  ? "bus error"
                     : sig == SIGABRT ? "abort"
                     : sig == SIGFPE  ? "arithmetic error"
                     : sig == SIGILL  ? "illegal instruction"
                     : sig == SIGTRAP ? "debug trap"
                     : "unknown signal";

    // Distinguish stack overflow from null dereference by checking fault address.
    if (sig == SIGSEGV && si && si->si_addr) {
        uintptr_t addr = (uintptr_t)si->si_addr;
        // Addresses near zero suggest null pointer dereference.
        if (addr < 0x10000) {
            safe_write("\nerror: null pointer dereference (accessed address ");
            safe_write_ptr(si->si_addr);
            safe_write(")\n");
            safe_write("A value was null when a field access, method call, or dereference was attempted.\n");
            _exit(128 + sig);
        }
#if defined(__APPLE__) && (defined(__aarch64__) || defined(__arm64__))
        if (context) {
            ucontext_t *uc = (ucontext_t *)context;
            arm_thread_state64_t *ts = (arm_thread_state64_t *)&uc->uc_mcontext->__ss;
            uintptr_t sp = (uintptr_t)arm_thread_state64_get_sp(*ts);
            // If the fault address is within 64KB of the stack pointer, it's likely stack overflow.
            if (addr >= sp - 0x10000 && addr <= sp + 0x10000) {
                forge_runtime_error("stack overflow (possible infinite recursion)");
                safe_write("Check for recursive functions that lack a proper base case.\n");
                _exit(128 + sig);
            }
        }
#endif
    }

    // For SIGABRT from our own trap functions, the error message was already
    // printed. Exit cleanly without the full crash dump.
    if (sig == SIGABRT) {
        _exit(1);
    }

    // SIGFPE: arithmetic exception (rare on ARM64 but possible)
    if (sig == SIGFPE) {
        forge_runtime_error("arithmetic error (possible integer overflow or hardware fault)");
        _exit(128 + sig);
    }

    // SIGILL: illegal instruction (usually a codegen bug, not user's fault)
    if (sig == SIGILL) {
        forge_runtime_error("illegal instruction — this is a compiler bug, not your code");
        safe_write("  Please report at https://github.com/forge-lang/forge/issues\n");
        _exit(128 + sig);
    }

    // ── User-friendly crash report ──
    // Find the first user function (skip signal handler + system frames)
    void* frames[64];
    int n = backtrace(frames, 64);
    const char* crash_fn = NULL;
    const char* caller_fn = NULL;
    for (int i = 0; i < n; i++) {
        Dl_info info;
        if (dladdr(frames[i], &info) && info.dli_sname) {
            // Skip signal handler, system libs, forge_ runtime fns
            if (strstr(info.dli_sname, "signal") || strstr(info.dli_sname, "sigtramp") ||
                strstr(info.dli_sname, "pthread") || strstr(info.dli_sname, "libsystem")) continue;
            if (strncmp(info.dli_sname, "forge_", 6) == 0) continue;
            if (!crash_fn) { crash_fn = info.dli_sname; }
            else if (!caller_fn) { caller_fn = info.dli_sname; break; }
        }
    }

    safe_write("\nerror: unexpected runtime error");
    if (crash_fn) {
        safe_write(" in function `");
        safe_write(crash_fn);
        safe_write("`");
    }
    safe_write("\n");

    if (si && sig == SIGSEGV) {
        uintptr_t addr = (uintptr_t)si->si_addr;
        if (addr < 0x10000) {
            safe_write("  A null value was used where an object was expected.\n");
        } else {
            safe_write("  Memory access violation at address ");
            safe_write_ptr(si->si_addr);
            safe_write(".\n");
        }
    } else if (sig == SIGBUS) {
        safe_write("  Invalid memory access (bus error).\n");
    } else {
        char buf[64];
        int len = snprintf(buf, sizeof(buf), "  Signal %d (%s).\n", sig, name);
        write(STDERR_FILENO, buf, len);
    }

    if (caller_fn) {
        safe_write("  Called from: ");
        safe_write(caller_fn);
        safe_write("\n");
    }

    safe_write("\n");
    safe_write("  Suggestions:\n");
    safe_write("    - Check for null values passed to functions\n");
    safe_write("    - Recompile with --debug-null to find the exact null argument\n");
    safe_write("    - Run with FORGE_CRASH_DETAIL=1 for the full technical dump\n");
    safe_write("\n");

    // Full technical dump only with FORGE_CRASH_DETAIL=1
    if (getenv("FORGE_CRASH_DETAIL")) {
        char buf[256];
        int len;
        safe_write("  --- Technical details ---\n");
        len = snprintf(buf, sizeof(buf), "  Signal: %d (%s)\n", sig, name);
        write(STDERR_FILENO, buf, len);
        if (si) {
            safe_write("  Address: ");
            safe_write_ptr(si->si_addr);
            safe_write("\n");
        }
#if defined(__APPLE__) && (defined(__aarch64__) || defined(__arm64__))
        if (context) {
            ucontext_t *uc = (ucontext_t *)context;
            arm_thread_state64_t *ts = (arm_thread_state64_t *)&uc->uc_mcontext->__ss;
            safe_write("  x0="); safe_write_hex((unsigned long long)ts->__x[0]);
            safe_write(" x1="); safe_write_hex((unsigned long long)ts->__x[1]);
            safe_write(" x2="); safe_write_hex((unsigned long long)ts->__x[2]);
            safe_write(" x3="); safe_write_hex((unsigned long long)ts->__x[3]);
            safe_write("\n");
            safe_write("  sp="); safe_write_hex((unsigned long long)arm_thread_state64_get_sp(*ts));
            safe_write(" lr="); safe_write_hex((unsigned long long)arm_thread_state64_get_lr(*ts));
            safe_write(" pc="); safe_write_hex((unsigned long long)arm_thread_state64_get_pc(*ts));
            safe_write("\n");
        }
#endif
        safe_write("  Backtrace:\n");
        for (int i = 0; i < n; i++) {
            Dl_info info;
            if (dladdr(frames[i], &info) && info.dli_sname) {
                long long offset = (long long)((char*)frames[i] - (char*)info.dli_saddr);
                len = snprintf(buf, sizeof(buf), "    %2d  %s + %lld\n", i, info.dli_sname, offset);
                write(STDERR_FILENO, buf, len);
            }
        }
        safe_write("\n");
    }

    _exit(128 + sig);
}

__attribute__((constructor))
static void forge_install_signal_handlers(void) {
    // Alternate signal stack so handler works during stack overflow
    static char alt_stack[SIGSTKSZ + 65536];
    stack_t ss = { .ss_sp = alt_stack, .ss_size = sizeof(alt_stack), .ss_flags = 0 };
    sigaltstack(&ss, NULL);

    struct sigaction sa;
    sa.sa_sigaction = forge_signal_handler;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGBUS,  &sa, NULL);
    sigaction(SIGABRT, &sa, NULL);
    sigaction(SIGFPE,  &sa, NULL);
    sigaction(SIGILL,  &sa, NULL);
    sigaction(SIGTRAP, &sa, NULL);
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

void forge_process_exit(int64_t code) {
    exit((int)code);
}

void forge_selfhost_trace(const char* s) {
    fprintf(stderr, "[trace] %s\n", s);
}

void forge_selfhost_trace_int(const char* label, int64_t val) {
    fprintf(stderr, "[trace] %s: %lld\n", label, (long long)val);
}

// Debug: dump an Expr's tag and first payload field

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

// forge_selfhost_string_to_float is used by the bootstrap's float() builtin.
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
    if (!arr) {
        forge_runtime_error("index on null list");
        abort();
    }
    ForgeArray* a = (ForgeArray*)arr;
    if (idx < 0 || idx >= a->len) {
        forge_runtime_errorf("index %lld out of bounds (length %lld)",
                (long long)idx, (long long)a->len);
        abort();
    }
    return a->data[idx];
}

void forge_array_set(void* arr, int64_t idx, int64_t value) {
    if (!arr) {
        forge_runtime_error("index assignment on null list");
        abort();
    }
    ForgeArray* a = (ForgeArray*)arr;
    if (idx < 0 || idx >= a->len) {
        forge_runtime_errorf("index %lld out of bounds for assignment (length %lld)",
                (long long)idx, (long long)a->len);
        abort();
    }
    a->data[idx] = value;
}

int64_t forge_array_len(void* arr) {
    if (!arr) return 0;
    return ((ForgeArray*)arr)->len;
}

int64_t forge_array_pop(void* arr) {
    if (!arr) {
        forge_runtime_error("pop on null list");
        abort();
    }
    ForgeArray* a = (ForgeArray*)arr;
    if (a->len <= 0) {
        forge_runtime_error("pop on empty list");
        abort();
    }
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

// ─── Filesystem APIs ─────────────────────────────────────────────
// Native replacements for forge_shell_exec("find ...").

#include <dirent.h>
#include <sys/stat.h>

// List directory entries. Returns a ForgeArray of string pointers.
void* forge_readdir(const char* path) {
    ForgeArray* arr = forge_array_new();
    DIR* d = opendir(path);
    if (!d) return arr;
    struct dirent* entry;
    while ((entry = readdir(d)) != NULL) {
        if (entry->d_name[0] == '.' && (entry->d_name[1] == '\0' ||
            (entry->d_name[1] == '.' && entry->d_name[2] == '\0'))) continue;
        size_t len = strlen(entry->d_name);
        char* name = (char*)malloc(len + 1);
        memcpy(name, entry->d_name, len + 1);
        forge_array_push(arr, (int64_t)(uintptr_t)name);
    }
    closedir(d);
    return arr;
}

// Check if path is a directory.
int64_t forge_is_dir(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
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

// Return an array of all values.
void* forge_map_values_cstr(void* map) {
    ForgeHashMap* m = (ForgeHashMap*)map;
    void* arr = forge_array_new();
    for (int64_t i = 0; i < m->cap; i++) {
        if (m->keys[i]) {
            forge_array_push(arr, m->values[i]);
        }
    }
    return arr;
}

// Remove a key from the map. Returns 1 if found, 0 if not.
int64_t forge_map_remove_cstr(void* map, const char* key) {
    if (!map || !key) return 0;
    ForgeHashMap* m = (ForgeHashMap*)map;
    uint64_t h = 5381;
    for (const char* p = key; *p; p++) h = h * 33 + (unsigned char)*p;
    int64_t idx = (int64_t)(h % (uint64_t)m->cap);
    for (int64_t i = 0; i < m->cap; i++) {
        int64_t probe = (idx + i) % m->cap;
        if (!m->keys[probe]) return 0;
        if (strcmp(m->keys[probe], key) == 0) {
            free(m->keys[probe]);
            m->keys[probe] = NULL;
            m->values[probe] = 0;
            m->count--;
            return 1;
        }
    }
    return 0;
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

// ─── Int-keyed Map ────────────────────────────────────────────────
// Flat array indexed by int key. Perfect for enum tag → handler
// dispatch where keys are small sequential integers (0-63).
// Values are i64 (function pointers, struct pointers, etc.).

#define FORGE_INTMAP_CAP 256

typedef struct {
    int64_t keys[FORGE_INTMAP_CAP];
    int64_t values[FORGE_INTMAP_CAP];
    int8_t  occupied[FORGE_INTMAP_CAP];
} ForgeIntMap;

void* forge_intmap_new(void) {
    ForgeIntMap* m = (ForgeIntMap*)calloc(1, sizeof(ForgeIntMap));
    return m;
}

void forge_intmap_set(void* map, int64_t key, int64_t value) {
    ForgeIntMap* m = (ForgeIntMap*)map;
    uint64_t idx = (uint64_t)key % FORGE_INTMAP_CAP;
    for (int i = 0; i < FORGE_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % FORGE_INTMAP_CAP;
        if (!m->occupied[slot] || m->keys[slot] == key) {
            m->keys[slot] = key;
            m->values[slot] = value;
            m->occupied[slot] = 1;
            return;
        }
    }
}

int64_t forge_intmap_get(void* map, int64_t key) {
    ForgeIntMap* m = (ForgeIntMap*)map;
    uint64_t idx = (uint64_t)key % FORGE_INTMAP_CAP;
    for (int i = 0; i < FORGE_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % FORGE_INTMAP_CAP;
        if (!m->occupied[slot]) return 0;
        if (m->keys[slot] == key) return m->values[slot];
    }
    return 0;
}

// Get value as a string pointer (for storing strings in intmap).
const char* forge_intmap_get_as_string(void* map, int64_t key) {
    return (const char*)(uintptr_t)forge_intmap_get(map, key);
}

// Read current value at key and increment it. Returns the OLD value.
int64_t forge_intmap_inc(void* map, int64_t key) {
    int64_t old = forge_intmap_get(map, key);
    forge_intmap_set(map, key, old + 1);
    return old;
}

int64_t forge_intmap_has(void* map, int64_t key) {
    ForgeIntMap* m = (ForgeIntMap*)map;
    uint64_t idx = (uint64_t)key % FORGE_INTMAP_CAP;
    for (int i = 0; i < FORGE_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % FORGE_INTMAP_CAP;
        if (!m->occupied[slot]) return 0;
        if (m->keys[slot] == key) return 1;
    }
    return 0;
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

// Reverse a string.
const char* forge_str_reverse(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)forge_rc_alloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        r[i] = s[len - 1 - i];
    }
    r[len] = '\0';
    return r;
}

// Repeat a string n times.
const char* forge_str_repeat(const char* s, int64_t n) {
    if (n <= 0) return "";
    size_t len = strlen(s);
    size_t total = len * (size_t)n;
    char* r = (char*)forge_rc_alloc(total + 1);
    for (int64_t i = 0; i < n; i++) {
        memcpy(r + i * len, s, len);
    }
    r[total] = '\0';
    return r;
}

// Return a single-character string at index idx.
const char* forge_str_char_at(const char* s, int64_t idx) {
    size_t len = strlen(s);
    if (idx < 0 || (size_t)idx >= len) return "";
    char* r = (char*)forge_rc_alloc(2);
    r[0] = s[idx];
    r[1] = '\0';
    return r;
}

// Return a substring from index start (inclusive) to end (exclusive).
const char* forge_str_substring(const char* s, int64_t start, int64_t end) {
    size_t len = strlen(s);
    if (start < 0) start = 0;
    if (end < start) end = start;
    if ((size_t)end > len) end = (int64_t)len;
    int64_t sub_len = end - start;
    char* r = (char*)forge_rc_alloc(sub_len + 1);
    memcpy(r, s + start, sub_len);
    r[sub_len] = '\0';
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

// Check if array contains a value. For strings, does pointer/strcmp comparison.
int64_t forge_array_contains(void* arr, int64_t value) {
    ForgeArray* a = (ForgeArray*)arr;
    for (int64_t i = 0; i < a->len; i++) {
        if (a->data[i] == value) return 1;
    }
    return 0;
}

// Find index of value in array. Returns -1 if not found.
int64_t forge_array_index_of(void* arr, int64_t value) {
    ForgeArray* a = (ForgeArray*)arr;
    for (int64_t i = 0; i < a->len; i++) {
        if (a->data[i] == value) return i;
    }
    return -1;
}

// Reverse an array in-place. Returns the same array.
void* forge_array_reverse(void* arr) {
    ForgeArray* a = (ForgeArray*)arr;
    for (int64_t i = 0, j = a->len - 1; i < j; i++, j--) {
        int64_t tmp = a->data[i];
        a->data[i] = a->data[j];
        a->data[j] = tmp;
    }
    return arr;
}

// Join a list of strings with a separator.
const char* forge_str_join(void* arr, const char* sep) {
    ForgeArray* a = (ForgeArray*)arr;
    if (a->len == 0) return "";
    size_t sep_len = strlen(sep);
    size_t total = 0;
    for (int64_t i = 0; i < a->len; i++) {
        const char* s = (const char*)a->data[i];
        total += s ? strlen(s) : 0;
        if (i > 0) total += sep_len;
    }
    char* buf = (char*)malloc(total + 1);
    char* p = buf;
    for (int64_t i = 0; i < a->len; i++) {
        if (i > 0) { memcpy(p, sep, sep_len); p += sep_len; }
        const char* s = (const char*)a->data[i];
        if (s) { size_t l = strlen(s); memcpy(p, s, l); p += l; }
    }
    *p = '\0';
    return buf;
}

// ── File I/O (public API) ──
// These alias the selfhost_ versions for user programs.
const char* forge_file_read(const char* path) {
    return forge_selfhost_read_file(path);
}

int64_t forge_file_write(const char* path, const char* content) {
    return forge_selfhost_write_file(path, content);
}

int64_t forge_file_exists(const char* path) {
    return forge_selfhost_file_exists(path);
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

// ── Closure representation ────────────────────────────────────────
// ALL callable values are ForgeArrays: [TAG, fn_ptr, cap1, cap2, ...]
//   data[0] = FORGE_CLOSURE_TAG (sentinel for safety checks)
//   data[1] = fn_ptr (intptr_t of the function)
//   data[2..] = captured values (0 or more)
//
// Named function references, non-capturing lambdas, and capturing
// closures all use the same layout. The codegen wraps every callable
// in this format. No bare function pointers exist at runtime.
#define FORGE_CLOSURE_TAG ((int64_t)-559038737)

// Extract the function pointer from a closure array.
int64_t forge_closure_get_fn(int64_t closure_val) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
    if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[1];
    }
    // Should never happen — all callables are arrays. Log and return
    // the value itself as a last resort (better than silent crash).
    forge_runtime_errorf("closure call on non-closure value 0x%llx",
            (unsigned long long)closure_val);
    return closure_val;
}

// Get a captured value by index (0-based, captures start at data[2]).
int64_t forge_closure_get_capture(int64_t closure_val, int64_t idx) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
    if (arr && arr->len > idx + 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[idx + 2];
    }
    return 0;
}

// Get the number of captured values.
int64_t forge_closure_num_captures(int64_t closure_val) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_val;
    if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->len - 2;
    }
    return 0;
}

// ── Generic closure calls ─────────────────────────────────────────
// Used by C-side higher-order list operations (forge_array_map, etc.)
// that receive closures as i64 values. These extract fn_ptr + captures
// and call with the combined argument list.
//
// The codegen's direct LLVM calls handle the common case. These
// trampolines only exist for the C-side list operations.

// Helper: unpack closure and call with user_args + captures.
// Supports up to 8 total args (user + captures).
static int64_t forge_closure_dispatch(int64_t closure, int64_t* user_args, int64_t user_argc) {
    int64_t fn = forge_closure_get_fn(closure);
    int64_t n_caps = forge_closure_num_captures(closure);
    int64_t total = user_argc + n_caps;

    // Build combined arg array: [user_args..., captures...]
    int64_t args[8];
    for (int64_t i = 0; i < user_argc && i < 8; i++) args[i] = user_args[i];
    for (int64_t i = 0; i < n_caps && user_argc + i < 8; i++) args[user_argc + i] = forge_closure_get_capture(closure, i);

    // Dispatch by total arg count
    typedef int64_t (*Fn0)(void);
    typedef int64_t (*Fn1)(int64_t);
    typedef int64_t (*Fn2)(int64_t, int64_t);
    typedef int64_t (*Fn3)(int64_t, int64_t, int64_t);
    typedef int64_t (*Fn4)(int64_t, int64_t, int64_t, int64_t);
    typedef int64_t (*Fn5)(int64_t, int64_t, int64_t, int64_t, int64_t);
    typedef int64_t (*Fn6)(int64_t, int64_t, int64_t, int64_t, int64_t, int64_t);
    typedef int64_t (*Fn7)(int64_t, int64_t, int64_t, int64_t, int64_t, int64_t, int64_t);
    typedef int64_t (*Fn8)(int64_t, int64_t, int64_t, int64_t, int64_t, int64_t, int64_t, int64_t);

    switch (total) {
        case 0: return ((Fn0)(uintptr_t)fn)();
        case 1: return ((Fn1)(uintptr_t)fn)(args[0]);
        case 2: return ((Fn2)(uintptr_t)fn)(args[0], args[1]);
        case 3: return ((Fn3)(uintptr_t)fn)(args[0], args[1], args[2]);
        case 4: return ((Fn4)(uintptr_t)fn)(args[0], args[1], args[2], args[3]);
        case 5: return ((Fn5)(uintptr_t)fn)(args[0], args[1], args[2], args[3], args[4]);
        case 6: return ((Fn6)(uintptr_t)fn)(args[0], args[1], args[2], args[3], args[4], args[5]);
        case 7: return ((Fn7)(uintptr_t)fn)(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
        case 8: return ((Fn8)(uintptr_t)fn)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
        default:
            forge_runtime_errorf("closure call with %lld args exceeds limit of 8", (long long)total);
            return 0;
    }
}

int64_t forge_closure_call_0(int64_t closure) {
    return forge_closure_dispatch(closure, NULL, 0);
}

int64_t forge_closure_call_1(int64_t closure, int64_t a0) {
    int64_t args[] = { a0 };
    return forge_closure_dispatch(closure, args, 1);
}

int64_t forge_closure_call_2(int64_t closure, int64_t a0, int64_t a1) {
    int64_t args[] = { a0, a1 };
    return forge_closure_dispatch(closure, args, 2);
}

int64_t forge_closure_call_3(int64_t closure, int64_t a0, int64_t a1, int64_t a2) {
    int64_t args[] = { a0, a1, a2 };
    return forge_closure_dispatch(closure, args, 3);
}
int64_t forge_closure_call_4(int64_t closure, int64_t a0, int64_t a1, int64_t a2, int64_t a3) {
    int64_t args[] = { a0, a1, a2, a3 };
    return forge_closure_dispatch(closure, args, 4);
}
int64_t forge_closure_call_5(int64_t closure, int64_t a0, int64_t a1, int64_t a2, int64_t a3, int64_t a4) {
    int64_t args[] = { a0, a1, a2, a3, a4 };
    return forge_closure_dispatch(closure, args, 5);
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
    forge_signal_handler(sig, NULL, NULL);
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

    // (Global bump arena removed — all allocations use RC or per-scope arenas)
    // Check stack (rough heuristic — stack is near sp)
    {
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
// Debug: dump IR for a named function. Not currently used but
// available for debugging via extern fn in Forge source.

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

// Format a float with a printf-style format spec (e.g. ".2f", ".4e").
// The spec should NOT include the leading '%'.
// Takes float bits as int64 (same convention as forge_float_to_string).
const char* forge_format_float(int64_t bits, const char* spec) {
    double d;
    memcpy(&d, &bits, sizeof(d));
    char fmt[32];
    snprintf(fmt, sizeof(fmt), "%%%s", spec);
    char* buf = (char*)malloc(128);
    snprintf(buf, 128, fmt, d);
    return buf;
}

// Format an int with a printf-style format spec (e.g. "d", "x", "08x").
const char* forge_format_int(int64_t n, const char* spec) {
    char fmt[32];
    snprintf(fmt, sizeof(fmt), "%%%s", spec);
    // Replace 'd' with 'lld', 'x' with 'llx', etc. for 64-bit
    char* buf = (char*)malloc(128);
    // Build a proper format with the right length modifier
    char fmt2[32];
    int flen = strlen(fmt);
    char last = fmt[flen - 1];
    if (last == 'd' || last == 'i' || last == 'x' || last == 'X' || last == 'o') {
        memcpy(fmt2, fmt, flen - 1);
        fmt2[flen - 1] = 'l';
        fmt2[flen] = 'l';
        fmt2[flen + 1] = last;
        fmt2[flen + 2] = '\0';
    } else {
        memcpy(fmt2, fmt, flen + 1);
    }
    snprintf(buf, 128, fmt2, n);
    return buf;
}

// ── Feature registry helpers ──
// Extract the enum discriminant tag (first byte) from an enum value.
// Enums are heap-allocated structs with {i8 tag, i64 field1, ...}.
int64_t forge_expr_tag(int64_t expr_val) {
    int64_t* p = (int64_t*)(uintptr_t)expr_val;
    return p[0];
}

int64_t forge_stmt_tag(int64_t stmt_val) {
    int64_t* p = (int64_t*)(uintptr_t)stmt_val;
    return p[0];
}

// ── Ptr byte write ──
void forge_ptr_store_byte(int64_t ptr_val, int64_t offset, int64_t byte_val) {
    uint8_t* p = (uint8_t*)(uintptr_t)ptr_val;
    p[offset] = (uint8_t)byte_val;
}

// ── Ptr ↔ String ──
const char* forge_string_from_ptr(int64_t ptr_val, int64_t len) {
    char* buf = (char*)malloc(len + 1);
    memcpy(buf, (void*)(uintptr_t)ptr_val, len);
    buf[len] = '\0';
    return buf;
}

// ── Process timing ──
#include <time.h>
#include <pthread.h>

static struct timespec forge_start_time;

__attribute__((constructor))
static void forge_init_timer(void) {
    clock_gettime(CLOCK_MONOTONIC, &forge_start_time);
}

int64_t forge_uptime_ms(void) {
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    int64_t secs = now.tv_sec - forge_start_time.tv_sec;
    int64_t nsecs = now.tv_nsec - forge_start_time.tv_nsec;
    return secs * 1000 + nsecs / 1000000;
}

// ── DateTime ──
int64_t forge_datetime_now(void) {
    return (int64_t)time(NULL);
}

const char* forge_datetime_format(int64_t epoch, const char* fmt) {
    time_t t = (time_t)epoch;
    struct tm* tm = localtime(&t);
    char* buf = (char*)malloc(256);
    strftime(buf, 256, fmt, tm);
    return buf;
}

int64_t forge_datetime_year(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_year + 1900;
}
int64_t forge_datetime_month(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_mon + 1;
}
int64_t forge_datetime_day(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_mday;
}
int64_t forge_datetime_hour(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_hour;
}
int64_t forge_datetime_minute(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_min;
}
int64_t forge_datetime_second(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_sec;
}

// ── JSON ──
// Minimal JSON: stringify maps/lists/primitives, parse field extraction.

// Stringify an integer to JSON.
const char* forge_json_stringify_int(int64_t value) {
    char* buf = (char*)malloc(32);
    snprintf(buf, 32, "%lld", (long long)value);
    return buf;
}

// Stringify a string to JSON (with escaping).
const char* forge_json_stringify_string(const char* s) {
    if (!s) return "null";
    // Worst case: every char needs escaping + quotes + null
    size_t len = strlen(s);
    char* buf = (char*)malloc(len * 2 + 3);
    char* p = buf;
    *p++ = '"';
    for (size_t i = 0; i < len; i++) {
        char c = s[i];
        if (c == '"') { *p++ = '\\'; *p++ = '"'; }
        else if (c == '\\') { *p++ = '\\'; *p++ = '\\'; }
        else if (c == '\n') { *p++ = '\\'; *p++ = 'n'; }
        else if (c == '\r') { *p++ = '\\'; *p++ = 'r'; }
        else if (c == '\t') { *p++ = '\\'; *p++ = 't'; }
        else *p++ = c;
    }
    *p++ = '"';
    *p = '\0';
    return buf;
}

// Stringify a boolean to JSON.
const char* forge_json_stringify_bool(int64_t value) {
    return value ? "true" : "false";
}

// Parse a JSON string and extract an integer field by key.
int64_t forge_json_get_int(const char* json, const char* key) {
    if (!json || !key) return 0;
    // Simple string search for "key":
    char needle[256];
    snprintf(needle, sizeof(needle), "\"%s\"", key);
    const char* pos = strstr(json, needle);
    if (!pos) return 0;
    pos += strlen(needle);
    // Skip whitespace and colon
    while (*pos == ' ' || *pos == ':' || *pos == '\t') pos++;
    return atoll(pos);
}

// Parse a JSON string and extract a string field by key.
const char* forge_json_get_string(const char* json, const char* key) {
    if (!json || !key) return "";
    char needle[256];
    snprintf(needle, sizeof(needle), "\"%s\"", key);
    const char* pos = strstr(json, needle);
    if (!pos) return "";
    pos += strlen(needle);
    while (*pos == ' ' || *pos == ':' || *pos == '\t') pos++;
    if (*pos != '"') return "";
    pos++; // skip opening quote
    const char* end = pos;
    while (*end && *end != '"') {
        if (*end == '\\') end++; // skip escaped char
        end++;
    }
    size_t len = end - pos;
    char* result = (char*)malloc(len + 1);
    memcpy(result, pos, len);
    result[len] = '\0';
    return result;
}

// Parse a JSON string and extract a boolean field by key.
int64_t forge_json_get_bool(const char* json, const char* key) {
    if (!json || !key) return 0;
    char needle[256];
    snprintf(needle, sizeof(needle), "\"%s\"", key);
    const char* pos = strstr(json, needle);
    if (!pos) return 0;
    pos += strlen(needle);
    while (*pos == ' ' || *pos == ':' || *pos == '\t') pos++;
    return (strncmp(pos, "true", 4) == 0) ? 1 : 0;
}

// ── Semver ──
int64_t forge_semver_major(const char* version) {
    if (!version) return 0;
    return atoi(version);
}
int64_t forge_semver_minor(const char* version) {
    if (!version) return 0;
    const char* dot = strchr(version, '.');
    return dot ? atoi(dot + 1) : 0;
}
int64_t forge_semver_patch(const char* version) {
    if (!version) return 0;
    const char* dot1 = strchr(version, '.');
    if (!dot1) return 0;
    const char* dot2 = strchr(dot1 + 1, '.');
    return dot2 ? atoi(dot2 + 1) : 0;
}
// Returns -1, 0, or 1 for version comparison.
int64_t forge_semver_compare(const char* a, const char* b) {
    int64_t am = forge_semver_major(a), bm = forge_semver_major(b);
    if (am != bm) return am < bm ? -1 : 1;
    int64_t ai = forge_semver_minor(a), bi = forge_semver_minor(b);
    if (ai != bi) return ai < bi ? -1 : 1;
    int64_t ap = forge_semver_patch(a), bp = forge_semver_patch(b);
    if (ap != bp) return ap < bp ? -1 : 1;
    return 0;
}

// ── TOML (minimal) ──
// Extracts string values from simple key = "value" TOML.
const char* forge_toml_get_string(const char* toml, const char* key) {
    if (!toml || !key) return "";
    size_t klen = strlen(key);
    const char* pos = toml;
    while ((pos = strstr(pos, key)) != NULL) {
        // Check it's at line start or after whitespace
        if (pos != toml && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        // Skip whitespace and =
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '"') { pos++; continue; }
        after++; // skip opening quote
        const char* end = strchr(after, '"');
        if (!end) return "";
        size_t vlen = end - after;
        char* result = (char*)malloc(vlen + 1);
        memcpy(result, after, vlen);
        result[vlen] = '\0';
        return result;
    }
    return "";
}

int64_t forge_toml_get_int(const char* toml, const char* key) {
    if (!toml || !key) return 0;
    size_t klen = strlen(key);
    const char* pos = toml;
    while ((pos = strstr(pos, key)) != NULL) {
        if (pos != toml && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        return atoll(after);
    }
    return 0;
}

int64_t forge_toml_get_bool(const char* toml, const char* key) {
    if (!toml || !key) return 0;
    size_t klen = strlen(key);
    const char* pos = toml;
    while ((pos = strstr(pos, key)) != NULL) {
        if (pos != toml && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        return (strncmp(after, "true", 4) == 0) ? 1 : 0;
    }
    return 0;
}

// Section-aware TOML get: finds key within [section].
// Searches for [section] header, then looks for key = "value" within it
// (stops at the next [section] or end of string).
const char* forge_toml_get_section_string(const char* toml, const char* section, const char* key) {
    if (!toml || !section || !key) return "";
    // Find [section]
    size_t slen = strlen(section);
    char header[256];
    snprintf(header, sizeof(header), "[%s]", section);
    const char* sec_start = strstr(toml, header);
    if (!sec_start) return "";
    // Move past the header line
    sec_start = strchr(sec_start, '\n');
    if (!sec_start) return "";
    sec_start++;
    // Find end of section (next [ at start of line, or end of string)
    const char* sec_end = sec_start;
    while (*sec_end) {
        if (*sec_end == '[' && (sec_end == sec_start || sec_end[-1] == '\n')) break;
        sec_end++;
    }
    // Search for key within this section
    size_t klen = strlen(key);
    const char* pos = sec_start;
    while (pos < sec_end && (pos = strstr(pos, key)) != NULL && pos < sec_end) {
        if (pos != sec_start && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '"') { pos++; continue; }
        after++; // skip opening quote
        const char* end = strchr(after, '"');
        if (!end || end > sec_end) return "";
        size_t vlen = end - after;
        char* result = (char*)malloc(vlen + 1);
        memcpy(result, after, vlen);
        result[vlen] = '\0';
        return result;
    }
    return "";
}

// Section-aware: check if a [section] exists in the TOML.
int64_t forge_toml_has_section(const char* toml, const char* section) {
    if (!toml || !section) return 0;
    char header[256];
    snprintf(header, sizeof(header), "[%s]", section);
    return strstr(toml, header) != NULL ? 1 : 0;
}

// ── Validation ──
// Basic runtime validation: assert conditions, check non-null.
int64_t forge_validate_not_null(int64_t value, const char* name) {
    if (value == 0) {
        forge_runtime_errorf("%s must not be null", name);
        exit(1);
    }
    return value;
}

int64_t forge_validate_positive(int64_t value, const char* name) {
    if (value <= 0) {
        forge_runtime_errorf("%s must be positive, got %lld", name, (long long)value);
        exit(1);
    }
    return value;
}

int64_t forge_validate_range(int64_t value, int64_t min, int64_t max, const char* name) {
    if (value < min || value > max) {
        forge_runtime_errorf("%s must be between %lld and %lld, got %lld",
                name, (long long)min, (long long)max, (long long)value);
        exit(1);
    }
    return value;
}

int64_t forge_validate_not_empty(const char* s, const char* name) {
    if (!s || strlen(s) == 0) {
        forge_runtime_errorf("%s must not be empty", name);
        exit(1);
    }
    return (int64_t)(uintptr_t)s;
}

int64_t forge_parse_int(const char* s) {
    return (int64_t)atoll(s);
}

// ── Shell execution ──
const char* forge_shell_exec(const char* cmd) {
    FILE* fp = popen(cmd, "r");
    if (!fp) return "";
    char* buf = (char*)malloc(4096);
    size_t total = 0;
    size_t cap = 4096;
    while (1) {
        size_t n = fread(buf + total, 1, cap - total - 1, fp);
        if (n == 0) break;
        total += n;
        if (total >= cap - 1) {
            cap *= 2;
            buf = (char*)realloc(buf, cap);
        }
    }
    buf[total] = '\0';
    // Strip trailing newline
    if (total > 0 && buf[total - 1] == '\n') buf[total - 1] = '\0';
    pclose(fp);
    return buf;
}

int64_t forge_shell_exec_status(const char* cmd) {
    int status = system(cmd);
    return (int64_t)((status >> 8) & 0xff);
}

// ── Process management (@std/process port) ──
// Full port of the Rust std-process package. Provides:
// - forge_process_run: synchronous exec with stdout/stderr capture + timeout
// - forge_process_spawn/wait/kill: async process management
// - forge_process_read_line: line-by-line stdout streaming
// - forge_process_forward: passthrough (inherited stdio)
// - forge_process_pipe: stdin piping
// - forge_process_env_get/args/self_dir: environment utilities

#include <spawn.h>
#include <signal.h>
#include <sys/wait.h>
#include <poll.h>

// Simple JSON escaping for result strings
static char* escape_json_str(const char* s) {
    size_t cap = strlen(s) * 2 + 1;
    char* out = (char*)malloc(cap);
    size_t j = 0;
    for (size_t i = 0; s[i]; i++) {
        if (j + 6 >= cap) { cap *= 2; out = (char*)realloc(out, cap); }
        switch (s[i]) {
            case '"':  out[j++] = '\\'; out[j++] = '"'; break;
            case '\\': out[j++] = '\\'; out[j++] = '\\'; break;
            case '\n': out[j++] = '\\'; out[j++] = 'n'; break;
            case '\r': out[j++] = '\\'; out[j++] = 'r'; break;
            case '\t': out[j++] = '\\'; out[j++] = 't'; break;
            default:
                if ((unsigned char)s[i] < 0x20) {
                    j += snprintf(out + j, cap - j, "\\u%04x", (unsigned char)s[i]);
                } else {
                    out[j++] = s[i];
                }
        }
    }
    out[j] = '\0';
    return out;
}

static const char* make_result_json(const char* stdout_str, const char* stderr_str, int code) {
    char* esc_out = escape_json_str(stdout_str);
    char* esc_err = escape_json_str(stderr_str);
    size_t len = strlen(esc_out) + strlen(esc_err) + 64;
    char* buf = (char*)malloc(len);
    snprintf(buf, len, "{\"stdout\":\"%s\",\"stderr\":\"%s\",\"code\":%d}", esc_out, esc_err, code);
    free(esc_out);
    free(esc_err);
    return buf;
}

// Read all data from a file descriptor into a malloc'd string
static char* read_fd_all(int fd) {
    size_t cap = 4096;
    char* buf = (char*)malloc(cap);
    size_t total = 0;
    while (1) {
        ssize_t n = read(fd, buf + total, cap - total - 1);
        if (n <= 0) break;
        total += n;
        if (total >= cap - 1) { cap *= 2; buf = (char*)realloc(buf, cap); }
    }
    buf[total] = '\0';
    return buf;
}

// Parse a simple JSON string array: ["arg1","arg2"] → NULL-terminated argv
// Minimal parser — handles quoted strings, no nested objects
static char** parse_args_json(const char* json, int* out_count) {
    *out_count = 0;
    if (!json || !json[0] || json[0] != '[') return NULL;
    // Count strings
    int count = 0;
    for (const char* p = json; *p; p++) { if (*p == '"') { count++; p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } } }
    // count already holds number of strings (one per opening quote)
    if (count == 0) return NULL;
    char** args = (char**)malloc((count + 1) * sizeof(char*));
    int idx = 0;
    const char* p = json + 1; // skip '['
    while (*p && idx < count) {
        while (*p && *p != '"') p++;
        if (!*p) break;
        p++; // skip opening quote
        const char* start = p;
        size_t len = 0;
        while (*p && *p != '"') {
            if (*p == '\\') { p++; len++; }
            p++; len++;
        }
        char* arg = (char*)malloc(len + 1);
        size_t j = 0;
        const char* s = start;
        while (s < p) {
            if (*s == '\\') { s++; }
            arg[j++] = *s++;
        }
        arg[j] = '\0';
        args[idx++] = arg;
        if (*p) p++; // skip closing quote
    }
    args[idx] = NULL;
    *out_count = idx;
    return args;
}

// Parse "cwd" from opts JSON (minimal: looks for "cwd":"value")
static const char* parse_opt_cwd(const char* opts) {
    if (!opts || !opts[0]) return NULL;
    const char* p = strstr(opts, "\"cwd\"");
    if (!p) return NULL;
    p += 5;
    while (*p && (*p == ':' || *p == ' ')) p++;
    if (*p != '"') return NULL;
    p++;
    const char* start = p;
    while (*p && *p != '"') p++;
    size_t len = p - start;
    char* cwd = (char*)malloc(len + 1);
    memcpy(cwd, start, len);
    cwd[len] = '\0';
    return cwd;
}

// Parse "env" from opts JSON (minimal: looks for "env":{...})
// Returns array of "KEY=VALUE" strings, NULL-terminated
static char** parse_opt_env(const char* opts, int* count) {
    *count = 0;
    if (!opts || !opts[0]) return NULL;
    const char* p = strstr(opts, "\"env\"");
    if (!p) return NULL;
    p = strchr(p, '{');
    if (!p) return NULL;
    p++; // skip {
    // Count pairs
    int n = 0;
    for (const char* q = p; *q && *q != '}'; q++) { if (*q == ':') n++; }
    if (n == 0) return NULL;
    char** envs = (char**)malloc((n + 1) * sizeof(char*));
    int idx = 0;
    while (*p && *p != '}' && idx < n) {
        while (*p && *p != '"') p++;
        if (!*p) break;
        p++;
        const char* key_start = p;
        while (*p && *p != '"') p++;
        size_t key_len = p - key_start;
        if (*p) p++; // close quote
        while (*p && *p != '"') p++;
        if (!*p) break;
        p++;
        const char* val_start = p;
        while (*p && *p != '"') p++;
        size_t val_len = p - val_start;
        if (*p) p++;
        char* entry = (char*)malloc(key_len + val_len + 2);
        memcpy(entry, key_start, key_len);
        entry[key_len] = '=';
        memcpy(entry + key_len + 1, val_start, val_len);
        entry[key_len + 1 + val_len] = '\0';
        envs[idx++] = entry;
    }
    envs[idx] = NULL;
    *count = idx;
    return envs;
}

// Parse "timeout_ms" from opts JSON
static int64_t parse_opt_timeout(const char* opts) {
    if (!opts || !opts[0]) return 0;
    const char* p = strstr(opts, "\"timeout_ms\"");
    if (!p) return 0;
    p += 12;
    while (*p && (*p == ':' || *p == ' ')) p++;
    return atoll(p);
}

// Process registry for spawn/wait/kill
typedef struct ProcessEntry {
    pid_t pid;
    int stdout_fd;
    int stderr_fd;
    int alive;
} ProcessEntry;

#define MAX_PROCESSES 256
static ProcessEntry process_registry[MAX_PROCESSES];
static int64_t next_process_id = 1;

static int64_t registry_add(pid_t pid, int stdout_fd, int stderr_fd) {
    int64_t id = next_process_id++;
    int slot = (int)(id % MAX_PROCESSES);
    process_registry[slot].pid = pid;
    process_registry[slot].stdout_fd = stdout_fd;
    process_registry[slot].stderr_fd = stderr_fd;
    process_registry[slot].alive = 1;
    return id;
}

static ProcessEntry* registry_get(int64_t id) {
    int slot = (int)(id % MAX_PROCESSES);
    if (process_registry[slot].pid != 0) return &process_registry[slot];
    return NULL;
}

static void registry_remove(int64_t id) {
    int slot = (int)(id % MAX_PROCESSES);
    process_registry[slot].pid = 0;
    process_registry[slot].alive = 0;
}

// Core: fork + exec with pipes. Returns pid, sets stdout_fd/stderr_fd.
static pid_t spawn_process(const char* cmd, char** argv, const char* cwd, char** extra_env, int extra_env_count,
                           int* out_stdout_fd, int* out_stderr_fd, int pipe_stdin, int* out_stdin_fd) {
    int stdout_pipe[2], stderr_pipe[2], stdin_pipe[2];
    if (pipe(stdout_pipe) < 0) return -1;
    if (pipe(stderr_pipe) < 0) { close(stdout_pipe[0]); close(stdout_pipe[1]); return -1; }
    if (pipe_stdin) {
        if (pipe(stdin_pipe) < 0) { close(stdout_pipe[0]); close(stdout_pipe[1]); close(stderr_pipe[0]); close(stderr_pipe[1]); return -1; }
    }

    pid_t pid = fork();
    if (pid < 0) {
        close(stdout_pipe[0]); close(stdout_pipe[1]);
        close(stderr_pipe[0]); close(stderr_pipe[1]);
        if (pipe_stdin) { close(stdin_pipe[0]); close(stdin_pipe[1]); }
        return -1;
    }

    if (pid == 0) {
        // Child
        close(stdout_pipe[0]);
        close(stderr_pipe[0]);
        dup2(stdout_pipe[1], STDOUT_FILENO);
        dup2(stderr_pipe[1], STDERR_FILENO);
        close(stdout_pipe[1]);
        close(stderr_pipe[1]);
        if (pipe_stdin) {
            close(stdin_pipe[1]);
            dup2(stdin_pipe[0], STDIN_FILENO);
            close(stdin_pipe[0]);
        }
        if (cwd) chdir(cwd);
        // Set extra env vars
        for (int i = 0; i < extra_env_count; i++) {
            putenv(extra_env[i]);
        }
        execvp(cmd, argv);
        _exit(127); // exec failed
    }

    // Parent
    close(stdout_pipe[1]);
    close(stderr_pipe[1]);
    *out_stdout_fd = stdout_pipe[0];
    *out_stderr_fd = stderr_pipe[0];
    if (pipe_stdin) {
        close(stdin_pipe[0]);
        if (out_stdin_fd) *out_stdin_fd = stdin_pipe[1];
    }
    return pid;
}

// Build argv from cmd + args_json
static char** build_argv(const char* cmd, const char* args_json, int* total) {
    int arg_count = 0;
    char** parsed = parse_args_json(args_json, &arg_count);
    *total = arg_count + 2;
    char** argv = (char**)malloc((*total) * sizeof(char*));
    argv[0] = (char*)cmd;
    for (int i = 0; i < arg_count; i++) argv[i + 1] = parsed[i];
    argv[arg_count + 1] = NULL;
    if (parsed) free(parsed);
    return argv;
}

/// Run a process synchronously. Returns JSON: {"stdout":"...","stderr":"...","code":N}
const char* forge_process_run(const char* cmd, const char* args_json, const char* opts_json) {
    int argc;
    char** argv = build_argv(cmd, args_json, &argc);
    const char* cwd = parse_opt_cwd(opts_json);
    int env_count;
    char** extra_env = parse_opt_env(opts_json, &env_count);
    int64_t timeout_ms = parse_opt_timeout(opts_json);

    int stdout_fd, stderr_fd;
    pid_t pid = spawn_process(cmd, argv, cwd, extra_env, env_count, &stdout_fd, &stderr_fd, 0, NULL);
    if (pid < 0) {
        free(argv);
        return make_result_json("", "spawn error", -1);
    }

    if (timeout_ms > 0) {
        // Poll with timeout
        struct pollfd fds[2] = {{stdout_fd, POLLIN, 0}, {stderr_fd, POLLIN, 0}};
        char* out_buf = (char*)calloc(1, 4096); size_t out_cap = 4096, out_len = 0;
        char* err_buf = (char*)calloc(1, 4096); size_t err_cap = 4096, err_len = 0;
        int64_t remaining = timeout_ms;
        int open_fds = 2;

        while (open_fds > 0 && remaining > 0) {
            struct timespec start;
            clock_gettime(CLOCK_MONOTONIC, &start);
            int ret = poll(fds, 2, (int)(remaining > INT32_MAX ? INT32_MAX : remaining));
            struct timespec end;
            clock_gettime(CLOCK_MONOTONIC, &end);
            int64_t elapsed = (end.tv_sec - start.tv_sec) * 1000 + (end.tv_nsec - start.tv_nsec) / 1000000;
            remaining -= elapsed;

            if (ret == 0) break; // timeout
            for (int i = 0; i < 2; i++) {
                if (fds[i].revents & (POLLIN | POLLHUP)) {
                    char** buf = (i == 0) ? &out_buf : &err_buf;
                    size_t* cap = (i == 0) ? &out_cap : &err_cap;
                    size_t* len = (i == 0) ? &out_len : &err_len;
                    ssize_t n = read(fds[i].fd, *buf + *len, *cap - *len - 1);
                    if (n <= 0) { fds[i].fd = -1; open_fds--; }
                    else { *len += n; if (*len >= *cap - 1) { *cap *= 2; *buf = (char*)realloc(*buf, *cap); } }
                }
            }
        }
        out_buf[out_len] = '\0';
        err_buf[err_len] = '\0';

        if (remaining <= 0) {
            kill(pid, SIGKILL);
            waitpid(pid, NULL, 0);
            close(stdout_fd); close(stderr_fd);
            char msg[64]; snprintf(msg, sizeof(msg), "process timed out after %lldms", (long long)timeout_ms);
            const char* result = make_result_json(out_buf, msg, -1);
            free(out_buf); free(err_buf); free(argv);
            return result;
        }

        close(stdout_fd); close(stderr_fd);
        int status;
        waitpid(pid, &status, 0);
        int code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
        const char* result = make_result_json(out_buf, err_buf, code);
        free(out_buf); free(err_buf); free(argv);
        return result;
    }

    // No timeout: read all then wait
    char* out_str = read_fd_all(stdout_fd);
    char* err_str = read_fd_all(stderr_fd);
    close(stdout_fd); close(stderr_fd);
    int status;
    waitpid(pid, &status, 0);
    int code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    const char* result = make_result_json(out_str, err_str, code);
    free(out_str); free(err_str); free(argv);
    return result;
}

/// Spawn a background process. Returns handle ID or -1.
int64_t forge_process_spawn_bg(const char* cmd, const char* args_json, const char* opts_json) {
    int argc;
    char** argv = build_argv(cmd, args_json, &argc);
    const char* cwd = parse_opt_cwd(opts_json);
    int env_count;
    char** extra_env = parse_opt_env(opts_json, &env_count);
    int stdout_fd, stderr_fd;
    pid_t pid = spawn_process(cmd, argv, cwd, extra_env, env_count, &stdout_fd, &stderr_fd, 0, NULL);
    free(argv);
    if (pid < 0) return -1;
    return registry_add(pid, stdout_fd, stderr_fd);
}

/// Kill a spawned process. Returns 1 on success, 0 on failure.
int64_t forge_process_kill(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e || !e->alive) return 0;
    kill(e->pid, SIGKILL);
    waitpid(e->pid, NULL, 0);
    close(e->stdout_fd);
    close(e->stderr_fd);
    e->alive = 0;
    registry_remove(handle);
    return 1;
}

/// Wait for a spawned process. Returns JSON result.
const char* forge_process_wait(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e) return make_result_json("", "process not found", -1);
    char* out_str = read_fd_all(e->stdout_fd);
    char* err_str = read_fd_all(e->stderr_fd);
    close(e->stdout_fd);
    close(e->stderr_fd);
    int status;
    waitpid(e->pid, &status, 0);
    int code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    registry_remove(handle);
    const char* result = make_result_json(out_str, err_str, code);
    free(out_str); free(err_str);
    return result;
}

/// Read a line from a spawned process's stdout. Returns "\0EOF" at end.
const char* forge_process_read_line(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e) return "\0EOF";
    char buf[4096];
    size_t pos = 0;
    while (pos < sizeof(buf) - 1) {
        ssize_t n = read(e->stdout_fd, &buf[pos], 1);
        if (n <= 0) { if (pos == 0) return "\0EOF"; break; }
        if (buf[pos] == '\n') break;
        pos++;
    }
    buf[pos] = '\0';
    // Trim \r
    if (pos > 0 && buf[pos - 1] == '\r') buf[pos - 1] = '\0';
    char* result = (char*)malloc(pos + 1);
    memcpy(result, buf, pos + 1);
    return result;
}

/// Wait for a pattern in stdout. Returns 1 if found, 0 if timeout.
int64_t forge_process_wait_for_output(int64_t handle, const char* pattern, int64_t timeout_ms) {
    ProcessEntry* e = registry_get(handle);
    if (!e) return 0;
    struct timespec deadline;
    clock_gettime(CLOCK_MONOTONIC, &deadline);
    deadline.tv_sec += timeout_ms / 1000;
    deadline.tv_nsec += (timeout_ms % 1000) * 1000000;
    if (deadline.tv_nsec >= 1000000000) { deadline.tv_sec++; deadline.tv_nsec -= 1000000000; }

    char line[4096];
    size_t pos = 0;
    while (1) {
        struct timespec now;
        clock_gettime(CLOCK_MONOTONIC, &now);
        if (now.tv_sec > deadline.tv_sec || (now.tv_sec == deadline.tv_sec && now.tv_nsec >= deadline.tv_nsec)) return 0;

        struct pollfd pfd = {e->stdout_fd, POLLIN, 0};
        int64_t remaining = (deadline.tv_sec - now.tv_sec) * 1000 + (deadline.tv_nsec - now.tv_nsec) / 1000000;
        if (remaining <= 0) return 0;
        int ret = poll(&pfd, 1, (int)(remaining > 1000 ? 1000 : remaining));
        if (ret <= 0) continue;

        ssize_t n = read(e->stdout_fd, &line[pos], 1);
        if (n <= 0) return 0;
        if (line[pos] == '\n') {
            line[pos] = '\0';
            if (strstr(line, pattern)) return 1;
            pos = 0;
        } else {
            pos++;
            if (pos >= sizeof(line) - 1) pos = 0;
        }
    }
}

/// Check if process is alive. Returns 1 if running, 0 if exited.
int64_t forge_process_is_alive(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e || !e->alive) return 0;
    int status;
    pid_t result = waitpid(e->pid, &status, WNOHANG);
    if (result == 0) return 1; // still running
    e->alive = 0;
    return 0;
}

/// Execute with inherited stdio (passthrough). Returns exit code.
int64_t forge_process_forward(const char* cmd, const char* args_json, const char* opts_json) {
    int argc;
    char** argv = build_argv(cmd, args_json, &argc);
    const char* cwd = parse_opt_cwd(opts_json);
    int env_count;
    char** extra_env = parse_opt_env(opts_json, &env_count);

    pid_t pid = fork();
    if (pid < 0) { free(argv); return -1; }
    if (pid == 0) {
        if (cwd) chdir(cwd);
        for (int i = 0; i < env_count; i++) putenv(extra_env[i]);
        execvp(cmd, argv);
        _exit(127);
    }
    free(argv);
    int status;
    waitpid(pid, &status, 0);
    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}

/// Run with stdin piped from input string. Returns JSON result.
const char* forge_process_pipe(const char* input, const char* cmd, const char* args_json) {
    int argc;
    char** argv = build_argv(cmd, args_json, &argc);
    int stdout_fd, stderr_fd, stdin_fd;
    pid_t pid = spawn_process(cmd, argv, NULL, NULL, 0, &stdout_fd, &stderr_fd, 1, &stdin_fd);
    free(argv);
    if (pid < 0) return make_result_json("", "spawn error", -1);

    // Write input then close stdin
    if (input && input[0]) {
        write(stdin_fd, input, strlen(input));
    }
    close(stdin_fd);

    char* out_str = read_fd_all(stdout_fd);
    char* err_str = read_fd_all(stderr_fd);
    close(stdout_fd); close(stderr_fd);
    int status;
    waitpid(pid, &status, 0);
    int code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    const char* result = make_result_json(out_str, err_str, code);
    free(out_str); free(err_str);
    return result;
}

/// Get environment variable. Returns "\0NULL" if not set.
const char* forge_process_env_get(const char* key) {
    const char* val = getenv(key);
    if (!val) return "\0NULL";
    // Return a copy
    size_t len = strlen(val);
    char* copy = (char*)malloc(len + 1);
    memcpy(copy, val, len + 1);
    return copy;
}

/// Get the directory containing the current executable.
const char* forge_process_self_dir(void) {
    char path[4096];
    uint32_t size = sizeof(path);
    if (_NSGetExecutablePath(path, &size) == 0) {
        // Find last /
        char* last_slash = strrchr(path, '/');
        if (last_slash) {
            *last_slash = '\0';
            char* result = (char*)malloc(strlen(path) + 1);
            strcpy(result, path);
            return result;
        }
    }
    return ".";
}

// ── Trait objects (dynamic dispatch) ──
// A trait object is a 2-element struct: { concrete_value, vtable_ptr }
// The vtable is a ForgeArray of function pointers (closure arrays).
// vtable[i] = closure array for the i-th trait method.
// Method dispatch: load vtable[method_index], call with concrete_value as self.

void* forge_trait_object_new(int64_t value, void* vtable) {
    int64_t* obj = (int64_t*)forge_rc_alloc(16);
    obj[0] = value;
    obj[1] = (int64_t)(uintptr_t)vtable;
    return obj;
}

int64_t forge_trait_object_value(void* obj) {
    return ((int64_t*)obj)[0];
}

void* forge_trait_object_vtable(void* obj) {
    return (void*)(uintptr_t)((int64_t*)obj)[1];
}

// ── Codegen counters ──
// Monotonic counters for unique name generation during codegen.
// Kept in C to avoid mutable globals in Forge source.
static int64_t g_lambda_counter = 0;
int64_t forge_next_lambda_id(void) { return g_lambda_counter++; }

// ── Error trace support ──
// Format a source location as "file:line" string for error traces.
const char* forge_format_location(const char* file, int64_t line) {
    char buf[512];
    snprintf(buf, sizeof(buf), "%s:%lld", file ? file : "<unknown>", (long long)line);
    size_t len = strlen(buf);
    char* result = (char*)forge_rc_alloc(len + 1);
    memcpy(result, buf, len + 1);
    return result;
}

// Forward declare capture state (used by test flush + capture)
static pthread_mutex_t _capture_mutex = PTHREAD_MUTEX_INITIALIZER;
static int _capture_fd_backup = -1;

// ── Spec test runtime (thread-safe) ──
// Atomic counters for parallel test execution.
// Per-thread output buffering prevents interleaved spec results.

#include <stdatomic.h>

static _Atomic int64_t forge_test_pass_count = 0;
static _Atomic int64_t forge_test_fail_count = 0;

// Per-thread output buffer — each thread accumulates output here,
// then flushes atomically when the module completes.
static __thread char* _test_buf = NULL;
static __thread size_t _test_buf_len = 0;
static __thread size_t _test_buf_cap = 0;
static pthread_mutex_t _test_output_mutex = PTHREAD_MUTEX_INITIALIZER;

static void test_buf_ensure(size_t needed) {
    if (!_test_buf) {
        _test_buf_cap = 4096;
        _test_buf = (char*)malloc(_test_buf_cap);
        _test_buf_len = 0;
    }
    while (_test_buf_len + needed >= _test_buf_cap) {
        _test_buf_cap *= 2;
        _test_buf = (char*)realloc(_test_buf, _test_buf_cap);
    }
}

static void test_printf(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);
    char tmp[1024];
    int n = vsnprintf(tmp, sizeof(tmp), fmt, args);
    va_end(args);
    if (n > 0) {
        test_buf_ensure(n + 1);
        memcpy(_test_buf + _test_buf_len, tmp, n);
        _test_buf_len += n;
        _test_buf[_test_buf_len] = '\0';
    }
}

// Flush buffered output atomically (called at end of each module's init).
// Uses stderr if stdout is currently captured (avoids writing into the capture pipe).
void forge_test_flush(void) {
    if (_test_buf && _test_buf_len > 0) {
        pthread_mutex_lock(&_test_output_mutex);
        // If another thread is capturing stdout, write to stderr instead
        // so our output doesn't contaminate the capture buffer.
        FILE* out = (_capture_fd_backup >= 0) ? stderr : stdout;
        fwrite(_test_buf, 1, _test_buf_len, out);
        fflush(out);
        pthread_mutex_unlock(&_test_output_mutex);
        _test_buf_len = 0;
    }
}

void forge_test_start_spec(const char* name) {
    test_printf("spec %s\n", name);
}

void forge_test_end_spec(void) {
    forge_test_flush();
}

void forge_test_start_given(const char* name) {
    test_printf("  given %s\n", name);
}

void forge_test_end_given(void) {
}

void forge_test_run_then(const char* name, int64_t result) {
    if (result) {
        test_printf("    then %s: PASS\n", name);
        atomic_fetch_add(&forge_test_pass_count, 1);
    } else {
        test_printf("    then %s: FAIL\n", name);
        atomic_fetch_add(&forge_test_fail_count, 1);
    }
}

void forge_test_skip(const char* name) {
    test_printf("    then %s: SKIP\n", name);
}

void forge_test_todo(const char* name) {
    test_printf("    then %s: TODO\n", name);
}

int64_t forge_test_roughly(double actual, double expected, double tolerance) {
    double diff = actual - expected;
    if (diff < 0) diff = -diff;
    return diff <= tolerance ? 1 : 0;
}

int64_t forge_test_summary(void) {
    int64_t pass = atomic_load(&forge_test_pass_count);
    int64_t fail = atomic_load(&forge_test_fail_count);
    int64_t total = pass + fail;
    if (total == 0) return 0;
    printf("\n%lld/%lld tests passed", pass, total);
    if (fail > 0) {
        printf(" (%lld failed)", fail);
    }
    printf("\n");
    return fail > 0 ? 1 : 0;
}

// ── Stdout capture (for testing output-producing code) ──
// Thread-safe: uses a mutex so only one thread can capture at a time.
// This is inherently serial (dup2 is process-wide) but prevents corruption.

static char* _capture_buf = NULL;
static size_t _capture_len = 0;
static size_t _capture_cap = 0;
// _capture_fd_backup declared earlier (forward declaration)
static int _capture_pipe[2] = {-1, -1};

void forge_test_capture_start(void) {
    // Flush our own output buffer before capturing
    forge_test_flush();
    pthread_mutex_lock(&_capture_mutex);
    fflush(stdout);
    _capture_fd_backup = dup(STDOUT_FILENO);
    pipe(_capture_pipe);
    dup2(_capture_pipe[1], STDOUT_FILENO);
    close(_capture_pipe[1]);
    _capture_cap = 4096;
    _capture_buf = (char*)malloc(_capture_cap);
    _capture_len = 0;
}

const char* forge_test_capture_stop(void) {
    fflush(stdout);
    dup2(_capture_fd_backup, STDOUT_FILENO);
    close(_capture_fd_backup);
    _capture_fd_backup = -1;

    // Read everything from the pipe
    while (1) {
        if (_capture_len >= _capture_cap - 1) {
            _capture_cap *= 2;
            _capture_buf = (char*)realloc(_capture_buf, _capture_cap);
        }
        struct pollfd pfd = {_capture_pipe[0], POLLIN, 0};
        if (poll(&pfd, 1, 0) <= 0) break;
        ssize_t n = read(_capture_pipe[0], _capture_buf + _capture_len, _capture_cap - _capture_len - 1);
        if (n <= 0) break;
        _capture_len += n;
    }
    close(_capture_pipe[0]);
    _capture_buf[_capture_len] = '\0';
    // Strip trailing newline (puts adds one)
    if (_capture_len > 0 && _capture_buf[_capture_len - 1] == '\n') {
        _capture_buf[_capture_len - 1] = '\0';
    }
    pthread_mutex_unlock(&_capture_mutex);
    return _capture_buf;
}

// ── Concurrency ──
// Thread spawning via pthreads. spawn takes a closure (ForgeArray)
// and runs it in a new thread. Returns a task handle for .await.

typedef struct {
    pthread_t thread;
    int64_t closure;
    int64_t result;     // captured return value from closure
    int joined;         // set to 1 after pthread_join (prevents double-join)
} ForgeTask;

static void* forge_thread_entry(void* arg) {
    ForgeTask* task = (ForgeTask*)arg;
    task->result = forge_closure_call_0(task->closure);
    return NULL;
}

// Spawn a closure in a new thread. Returns a task handle (ptr to ForgeTask).
int64_t forge_spawn(int64_t closure) {
    ForgeTask* task = (ForgeTask*)malloc(sizeof(ForgeTask));
    task->closure = closure;
    task->result = 0;
    task->joined = 0;
    pthread_create(&task->thread, NULL, forge_thread_entry, task);
    return (int64_t)(uintptr_t)task;
}

// Wait for a spawned task to finish and return its result value.
// Does NOT free the task — the task group frees all tasks at scope exit.
// When no task group is active (legacy usage), caller is responsible.
int64_t forge_task_await(int64_t handle) {
    ForgeTask* task = (ForgeTask*)(uintptr_t)handle;
    if (!task->joined) {
        pthread_join(task->thread, NULL);
        task->joined = 1;
    }
    return task->result;
}

// Cancel a spawned task. Sends SIGCANCEL (pthread_cancel) then joins.
// Returns 0 on success, -1 if already joined.
int64_t forge_task_cancel(int64_t handle) {
    ForgeTask* task = (ForgeTask*)(uintptr_t)handle;
    if (task->joined) return -1;
    pthread_cancel(task->thread);
    pthread_join(task->thread, NULL);
    task->joined = 1;
    return 0;
}

// Legacy join — kept for backward compat with existing tests.
// Does NOT free the task — the task group handles cleanup.
void forge_thread_join(int64_t handle) {
    ForgeTask* task = (ForgeTask*)(uintptr_t)handle;
    if (!task->joined) {
        pthread_join(task->thread, NULL);
        task->joined = 1;
    }
}

// ── Task Groups (structured concurrency) ──
// A task group collects spawned task handles so they can all be
// awaited when the enclosing scope exits. This prevents task leaks.

typedef struct {
    int64_t* handles;
    int count;
    int capacity;
} ForgeTaskGroup;

void* forge_task_group_new(void) {
    ForgeTaskGroup* g = (ForgeTaskGroup*)malloc(sizeof(ForgeTaskGroup));
    g->capacity = 8;
    g->count = 0;
    g->handles = (int64_t*)malloc(g->capacity * sizeof(int64_t));
    return g;
}

void forge_task_group_add(void* group, int64_t handle) {
    ForgeTaskGroup* g = (ForgeTaskGroup*)group;
    if (g->count >= g->capacity) {
        g->capacity *= 2;
        g->handles = (int64_t*)realloc(g->handles, g->capacity * sizeof(int64_t));
    }
    g->handles[g->count++] = handle;
}

void forge_task_group_await_all(void* group) {
    ForgeTaskGroup* g = (ForgeTaskGroup*)group;
    for (int i = 0; i < g->count; i++) {
        ForgeTask* task = (ForgeTask*)(uintptr_t)g->handles[i];
        if (!task->joined) {
            pthread_join(task->thread, NULL);
            task->joined = 1;
        }
        free(task);
    }
    free(g->handles);
    free(g);
}

// Yield the current fiber. No-op in v1.0 (pthreads-based).
void forge_yield(void) {
    // v1.0: no-op — real cooperative scheduling comes later
}

// Run the scheduler until all tasks complete. No-op in v1.0
// because tasks are OS threads that run to completion.
void forge_scheduler_run(void) {
    // v1.0: no-op — pthreads run independently
}

// ── Channels ──
// Unbuffered channel: send blocks until recv, recv blocks until send.

typedef struct {
    int64_t value;
    int has_value;
    pthread_mutex_t mutex;
    pthread_cond_t send_cond;
    pthread_cond_t recv_cond;
} ForgeChannel;

void* forge_channel_new(void) {
    ForgeChannel* ch = (ForgeChannel*)calloc(1, sizeof(ForgeChannel));
    pthread_mutex_init(&ch->mutex, NULL);
    pthread_cond_init(&ch->send_cond, NULL);
    pthread_cond_init(&ch->recv_cond, NULL);
    return ch;
}

void forge_channel_send(void* channel, int64_t value) {
    ForgeChannel* ch = (ForgeChannel*)channel;
    pthread_mutex_lock(&ch->mutex);
    while (ch->has_value) {
        pthread_cond_wait(&ch->send_cond, &ch->mutex);
    }
    ch->value = value;
    ch->has_value = 1;
    pthread_cond_signal(&ch->recv_cond);
    pthread_mutex_unlock(&ch->mutex);
}

int64_t forge_channel_recv(void* channel) {
    ForgeChannel* ch = (ForgeChannel*)channel;
    pthread_mutex_lock(&ch->mutex);
    while (!ch->has_value) {
        pthread_cond_wait(&ch->recv_cond, &ch->mutex);
    }
    int64_t value = ch->value;
    ch->has_value = 0;
    pthread_cond_signal(&ch->send_cond);
    pthread_mutex_unlock(&ch->mutex);
    return value;
}

// Select: poll multiple channels, block until one has data.
// channels is a ForgeArray of channel pointers.
// Returns: (index << 32) | (value & 0xFFFFFFFF) packed into i64.
// Better approach: write index + value to out params.
typedef struct {
    int64_t index;  // which channel fired
    int64_t value;  // the received value
} ForgeSelectResult;

// Polls channels in round-robin until one has data.
// Returns pointer to heap-allocated ForgeSelectResult.
void* forge_select(void* channel_array, int64_t count) {
    ForgeSelectResult* result = (ForgeSelectResult*)malloc(sizeof(ForgeSelectResult));
    ForgeArray* arr = (ForgeArray*)(uintptr_t)channel_array;
    if (!arr || arr->len == 0) {
        result->index = -1;
        result->value = 0;
        return result;
    }
    // Spin-poll with backoff until one channel has data.
    // This is simple but correct. A production implementation
    // would use condition variables or epoll.
    while (1) {
        for (int64_t i = 0; i < arr->len && i < count; i++) {
            ForgeChannel* ch = (ForgeChannel*)(uintptr_t)arr->data[i];
            if (!ch) continue;
            pthread_mutex_lock(&ch->mutex);
            if (ch->has_value) {
                int64_t val = ch->value;
                ch->has_value = 0;
                pthread_cond_signal(&ch->send_cond);
                pthread_mutex_unlock(&ch->mutex);
                result->index = i;
                result->value = val;
                return result;
            }
            pthread_mutex_unlock(&ch->mutex);
        }
        // Brief sleep to avoid busy-waiting
        usleep(100);  // 100 microseconds
    }
}

int64_t forge_select_index(void* result) {
    ForgeSelectResult* r = (ForgeSelectResult*)result;
    return r->index;
}

int64_t forge_select_value(void* result) {
    ForgeSelectResult* r = (ForgeSelectResult*)result;
    return r->value;
}

// Run an array of closures in parallel threads, join all before returning.
void forge_parallel_run(void* closure_array) {
    ForgeArray* arr = (ForgeArray*)(uintptr_t)closure_array;
    if (!arr || arr->len == 0) return;
    int64_t n = arr->len;
    pthread_t* threads = (pthread_t*)malloc(n * sizeof(pthread_t));
    ForgeTask** args = (ForgeTask**)malloc(n * sizeof(ForgeTask*));
    for (int64_t i = 0; i < n; i++) {
        args[i] = (ForgeTask*)malloc(sizeof(ForgeTask));
        args[i]->closure = arr->data[i];
        args[i]->result = 0;
        pthread_create(&threads[i], NULL, forge_thread_entry, args[i]);
    }
    for (int64_t i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }
    free(threads);
    free(args);
}

void forge_channel_close(void* channel) {
    ForgeChannel* ch = (ForgeChannel*)channel;
    pthread_mutex_destroy(&ch->mutex);
    pthread_cond_destroy(&ch->send_cond);
    pthread_cond_destroy(&ch->recv_cond);
    free(ch);
}

// ── Debug: enum tag validation ──
//
// Call before matching on an enum to catch corrupt tags early with a
// clear error instead of segfaulting in the generated switch dispatch.
// Usage from Forge: forge_validate_tag(expr, 35, "Expr")
//   - ptr: pointer to the enum value
//   - max_tag: highest valid tag number for this enum type
//   - type_name: name for the error message
void forge_validate_tag(void *ptr, int64_t max_tag, const char *type_name) {
    if (!ptr) {
        forge_runtime_errorf("null %s pointer passed to match", type_name);
        exit(99);
    }
    uint8_t tag = *(uint8_t *)ptr;
    if (tag > max_tag) {
        forge_runtime_errorf("%s tag %d exceeds max %lld (ptr=%p)",
                type_name, tag, (long long)max_tag, ptr);
        // Check if ptr looks like a valid address
        if ((uintptr_t)ptr < 0x100000) {
            fprintf(stderr, "  pointer %p is suspiciously low — likely a corrupt integer, not a real pointer\n", ptr);
        }
        exit(99);
    }
}

// ── Null argument trap ──
//
// Called by --debug-null compiled code when a null argument is detected
// at function entry. Prints the function and parameter name, then aborts.
// The is_null flag is checked at runtime to avoid branching in the IR
// (which would require creating basic blocks in the correct function).
void forge_null_arg_trap(const char *fn_name, int64_t fn_len,
                         const char *param_name, int64_t param_len) {
    fprintf(stderr, "\nerror: null argument `");
    fwrite(param_name, 1, (size_t)param_len, stderr);
    fprintf(stderr, "` in function `");
    fwrite(fn_name, 1, (size_t)fn_len, stderr);
    fprintf(stderr, "`\n");
    abort();
}

// Conditional version: only traps if is_null != 0.
void forge_null_arg_check(const char *fn_name, int64_t fn_len,
                          const char *param_name, int64_t param_len,
                          int64_t is_null) {
    if (!is_null) return;
    forge_null_arg_trap(fn_name, fn_len, param_name, param_len);
}

// ── Match fallthrough trap ──
//
// Called when a match expression falls through all arms without finding
// a match. This should never happen with correct enum tags. If it does,
// the data is corrupt. Prints the function name and tag value so the
// developer knows exactly where and why.
void forge_match_unreachable(const char *fn_name, int64_t tag, const char *file, int64_t line) {
    forge_runtime_errorf("non-exhaustive match in function `%s` — unmatched tag %lld (0x%llx)", fn_name, (long long)tag, (unsigned long long)tag);
    if (file && file[0]) {
        fprintf(stderr, "  --> %s:%lld\n", file, (long long)line);
    }
    if (tag > 0x100000000LL) {
        fprintf(stderr, "  tag looks like ptr, *tag = [0x%llx, 0x%llx]\n",
            (unsigned long long)((int64_t*)tag)[0], (unsigned long long)((int64_t*)tag)[1]);
    }
    fprintf(stderr, "This means an enum value has a corrupt or unexpected tag byte.\n");
    fprintf(stderr, "Common causes:\n");
    fprintf(stderr, "  - Enum variant was added but match arms weren't updated\n");
    fprintf(stderr, "  - Struct field read at wrong offset (enum layout mismatch)\n");
    fprintf(stderr, "  - Use-after-free or memory corruption\n");
    exit(99);
}

// ── Null pointer dereference trap ──
//
// Called when a field access or method call is attempted on a null pointer.
// Uses the branchless pattern: codegen passes is_null (0 or 1) and the
// C function checks internally, avoiding basic block creation in the IR.
void forge_null_deref_trap(const char *field, int64_t field_len,
                           const char *type_name, int64_t type_len,
                           int64_t is_null,
                           const char *file, int64_t file_len,
                           int64_t line) {
    if (!is_null) return;
    fprintf(stderr, "\nerror: null pointer dereference accessing field `");
    fwrite(field, 1, (size_t)field_len, stderr);
    fprintf(stderr, "`");
    if (type_len > 0) {
        fprintf(stderr, " on null `");
        fwrite(type_name, 1, (size_t)type_len, stderr);
        fprintf(stderr, "` value");
    }
    fprintf(stderr, "\n");
    if (file_len > 0) {
        fprintf(stderr, "  --> ");
        fwrite(file, 1, (size_t)file_len, stderr);
        fprintf(stderr, ":%lld\n", (long long)line);
    }
    abort();
}

// ── Division by zero trap ──
//
// Called before every sdiv/srem. Uses the branchless pattern: codegen
// passes is_zero (0 or 1) and the C function checks internally.
void forge_div_by_zero_trap(int64_t is_zero, const char *file, int64_t file_len, int64_t line) {
    if (!is_zero) return;
    forge_runtime_error("division by zero");
    if (file_len > 0) {
        fprintf(stderr, "  --> ");
        fwrite(file, 1, (size_t)file_len, stderr);
        fprintf(stderr, ":%lld\n", (long long)line);
    }
    abort();
}

// djb2 hash of a string → i64. Used for stable enum variant tags.
int64_t forge_variant_hash(const char* name) {
    uint64_t hash = 5381;
    while (*name) {
        hash = hash * 33 + (unsigned char)*name;
        name++;

    }
    return (int64_t)hash;
}

