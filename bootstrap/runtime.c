// Bootstrap runtime — clean, minimal, purpose-built.
//
// This is NOT the Rust host compiler's runtime. This file provides
// only what the bootstrap compiler and its compiled programs need:
//   1. Selfhost helpers (file I/O, argv, tracing)
//   2. Signal handler (crash reporting)
//   3. Dynamic arrays (avra_array_*)
//   4. Hash maps (avra_map_*)
//   5. String methods (avra_str_*)
//
// All functions use C-string (const char*) and i64 conventions
// matching the bootstrap's everything-is-i64 value model.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdint.h>
#include <limits.h>
#include <signal.h>
#include <setjmp.h>
#include <execinfo.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/mman.h>
#include <pthread.h>
#include <stdatomic.h>
#include <sys/wait.h>
#if defined(__APPLE__) && (defined(__aarch64__) || defined(__arm64__))
#define _XOPEN_SOURCE
#include <ucontext.h>
#undef _XOPEN_SOURCE
#include <mach/mach.h>
#include <mach-o/dyld.h>
#endif

// ─── Forward declarations for error reporting ────────────────────
static void avra_runtime_error(const char* msg);
static void avra_runtime_errorf(const char* fmt, ...);

// ─── Result tagging (debug only) ─────────────────────────────────
// avra_tag_as_result is called from codegen helpers (ok_emit, err_emit, etc.)
// to tag pointers for optional debug validation via AVRA_TRACK_RESULTS env var.
// In production (no env var), this is a no-op that returns ptr unchanged.

void* avra_tag_as_result(void* ptr) {
    return ptr;
}

// ─── Reference counting ──────────────────────────────────────────
//
// RC header layout (8 bytes, placed BEFORE the user pointer):
//   [ _Atomic int32_t refcount | int32_t type_tag ]
//   ^                                              ^
//   header_ptr                                     user_ptr
//
// avra_rc_alloc returns user_ptr. The header is at user_ptr - 8.
// Refcount is atomic so spawn { } can share RC objects across threads
// without retain/release races. The rc_set hash table that tracks
// live RC pointers is protected by rc_set_mutex below.

#define RC_HEADER_SIZE 8
#define RC_MAGIC 0x5243  // "RC" in little-endian

typedef struct {
    _Atomic int32_t refcount;
    int32_t type_tag;   // RC_MAGIC sentinel + reserved for cycle detection
} RcHeader;

static inline RcHeader* rc_header(void* ptr) {
    return (RcHeader*)((char*)ptr - RC_HEADER_SIZE);
}

static int rc_trace = 0;

__attribute__((constructor))
static void auto_enable_rc_trace(void) {
    if (getenv("AVRA_RC_TRACE")) {
        rc_trace = 1;
        fprintf(stderr, "[RC_TRACE] enabled\n");
    }
}

// ─── RC pointer set (open-addressing hash set) ──────────────────
// Tracks all live RC-managed pointers so is_rc_managed can safely
// distinguish RC objects from bump/stack/literal pointers.
//
// All rc_set_* mutators and lookups must hold rc_set_mutex — Avra
// programs spawn pthreads (avra_spawn) that share heap pointers.
#define RC_SET_INITIAL_CAP 4096
static void** rc_set_buckets = NULL;
static size_t rc_set_cap = 0;
static size_t rc_set_count = 0;
static pthread_mutex_t rc_set_mutex = PTHREAD_MUTEX_INITIALIZER;

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
    pthread_mutex_lock(&rc_set_mutex);
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
    pthread_mutex_unlock(&rc_set_mutex);
}

static int rc_set_contains(void* ptr) {
    pthread_mutex_lock(&rc_set_mutex);
    if (!rc_set_buckets || rc_set_count == 0) {
        pthread_mutex_unlock(&rc_set_mutex);
        return 0;
    }
    size_t idx = rc_set_hash(ptr) & (rc_set_cap - 1);
    int found = 0;
    while (rc_set_buckets[idx] != NULL) {
        if (rc_set_buckets[idx] == ptr) { found = 1; break; }
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    pthread_mutex_unlock(&rc_set_mutex);
    return found;
}

static void rc_set_remove(void* ptr) {
    pthread_mutex_lock(&rc_set_mutex);
    if (!rc_set_buckets) {
        pthread_mutex_unlock(&rc_set_mutex);
        return;
    }
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
            pthread_mutex_unlock(&rc_set_mutex);
            return;
        }
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    pthread_mutex_unlock(&rc_set_mutex);
}

// Allocate an RC-managed object via system malloc.
// Returns pointer to payload (past header).
void* avra_rc_alloc(int64_t payload_size) {
    size_t total = RC_HEADER_SIZE + (size_t)payload_size;
    total = (total + 7) & ~7;  // align to 8
    void* raw = malloc(total);
    if (!raw) {
        avra_runtime_errorf("out of memory (rc_alloc %lld bytes)", (long long)payload_size);
        exit(1);
    }
    RcHeader* hdr = (RcHeader*)raw;
    atomic_store(&hdr->refcount, 1);
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
void avra_rc_retain(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return;
    int32_t new_rc = atomic_fetch_add(&hdr->refcount, 1) + 1;
    if (rc_trace) {
        fprintf(stderr, "[RC] retain %p (rc=%d)\n", ptr, new_rc);
    }
}

// Decrement reference count. Frees the object when refcount reaches 0.
void avra_rc_release(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return;
    int32_t new_rc = atomic_fetch_sub(&hdr->refcount, 1) - 1;
    if (rc_trace) {
        fprintf(stderr, "[RC] release %p (rc=%d)\n", ptr, new_rc);
    }
    if (new_rc == 0) {
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
// first, then calling avra_rc_free. Used by generated __release_TypeName
// functions for recursive field release.
int64_t avra_rc_should_free(void* ptr) {
    if (!ptr) return 0;
    if (!is_rc_managed(ptr)) return 0;
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) return 0;
    int32_t new_rc = atomic_fetch_sub(&hdr->refcount, 1) - 1;
    if (rc_trace) {
        fprintf(stderr, "[RC] should_free %p (rc=%d)\n", ptr, new_rc);
    }
    return new_rc == 0 ? 1 : 0;
}

// Free an RC object without decrementing. Called after avra_rc_should_free
// returned 1 and the caller has released all inner fields.
void avra_rc_free(void* ptr) {
    if (!ptr) return;
    RcHeader* hdr = rc_header(ptr);
    if (rc_trace) {
        fprintf(stderr, "[RC] free %p\n", ptr);
    }
    hdr->type_tag = 0;  // Clear magic to prevent double-free
    rc_set_remove(ptr);
    free((char*)ptr - RC_HEADER_SIZE);
}

// Introspection for spec tests / leak checks. Returns the number
// of currently live RC-managed allocations across the whole heap.
// NOT for production code paths — held under rc_set_mutex.
int64_t avra_rc_live_count(void) {
    pthread_mutex_lock(&rc_set_mutex);
    int64_t n = (int64_t)rc_set_count;
    pthread_mutex_unlock(&rc_set_mutex);
    return n;
}

// ─── RC cycle detection (spec Axis 9.5) ─────────────────────────
//
// Targeted cycle collection for reference-counted objects.
// Cycle-capable types (identified at compile time via static analysis)
// call avra_rc_suspect() when their refcount decrements to non-zero.
// avra_rc_collect() at program exit frees any remaining suspects,
// breaking cycles that pure refcounting cannot reclaim.

#define SUSPECT_INITIAL_CAP 256
static void** suspect_list = NULL;
static size_t suspect_count = 0;
static size_t suspect_cap = 0;
static pthread_mutex_t suspect_mutex = PTHREAD_MUTEX_INITIALIZER;

// Add a pointer to the suspect list. Called from generated __release_TypeName
// when refcount decrements to non-zero for cycle-capable types.
void avra_rc_suspect(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) return;
    pthread_mutex_lock(&suspect_mutex);
    // Lazy init
    if (!suspect_list) {
        suspect_cap = SUSPECT_INITIAL_CAP;
        suspect_list = (void**)calloc(suspect_cap, sizeof(void*));
    }
    // Deduplicate: don't add if already in list
    for (size_t i = 0; i < suspect_count; i++) {
        if (suspect_list[i] == ptr) {
            pthread_mutex_unlock(&suspect_mutex);
            return;
        }
    }
    // Grow if needed
    if (suspect_count >= suspect_cap) {
        suspect_cap *= 2;
        suspect_list = (void**)realloc(suspect_list, suspect_cap * sizeof(void*));
    }
    suspect_list[suspect_count++] = ptr;
    if (rc_trace) {
        fprintf(stderr, "[RC] suspect %p (rc=%d)\n", ptr, atomic_load(&rc_header(ptr)->refcount));
    }
    pthread_mutex_unlock(&suspect_mutex);
}

// Collect cycles at program exit. Frees any RC objects that are still
// alive and were suspected of being in cycles. Since this runs at exit,
// it's safe to force-free without recursive field release — the process
// is terminating and all memory will be reclaimed by the OS anyway.
// The purpose is to run destructors and report leaks accurately.
void avra_rc_collect(void) {
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
void* avra_arena_new(void) {
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
void* avra_arena_alloc(void* arena_ptr, int64_t size) {
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
void avra_arena_destroy(void* arena_ptr) {
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
// avra_runtime_error  — async-signal-safe (uses write() only)
// avra_runtime_errorf — formatted (NOT async-signal-safe)

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
static void avra_runtime_error(const char* msg) {
    safe_write("\nerror: ");
    safe_write(msg);
    safe_write("\n");
}

// Formatted version: uses fprintf. NOT async-signal-safe.
static void avra_runtime_errorf(const char* fmt, ...) {
    fprintf(stderr, "\nerror: ");
    va_list args;
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fprintf(stderr, "\n");
}

// ─── Per-spec crash guard (hkms.3) ────────────────────────────────
// Thread-local sigsetjmp checkpoint installed by
// `avra_test_run_spec_guarded` for the duration of one spec block's
// invocation. When the signal handler sees `_spec_guard_active` set,
// it siglongjmps back to the guarded call site instead of dumping a
// crash report — the runner advances to the next spec.
//
// Per-thread state: SIGSEGV/SIGBUS/SIGFPE/SIGILL/SIGABRT are
// synchronous and delivered to the offending thread, so `_Thread_local`
// gives the handler the right jmp_buf without coordination.
static _Thread_local sigjmp_buf _spec_guard_jmp;
static _Thread_local volatile sig_atomic_t _spec_guard_active = 0;

// ─── Signal naming ────────────────────────────────────────────────
// Used by both the unguarded crash dump (avra_signal_handler) and
// the spec-guard's crash record (avra_signal_label). Centralising
// the table here keeps the two views from drifting.

static const char* avra_signal_short_name(int sig) {
    switch (sig) {
        case SIGSEGV: return "SIGSEGV";
        case SIGBUS:  return "SIGBUS";
        case SIGABRT: return "SIGABRT";
        case SIGFPE:  return "SIGFPE";
        case SIGILL:  return "SIGILL";
        case SIGTRAP: return "SIGTRAP";
        default:      return "unknown";
    }
}

static const char* avra_signal_description(int sig) {
    switch (sig) {
        case SIGSEGV: return "segmentation fault";
        case SIGBUS:  return "bus error";
        case SIGABRT: return "abort";
        case SIGFPE:  return "arithmetic error";
        case SIGILL:  return "illegal instruction";
        case SIGTRAP: return "debug trap";
        default:      return "unknown signal";
    }
}

// ─── Signal handler ───────────────────────────────────────────────

static void avra_signal_handler(int sig, siginfo_t *si, void *context) {
    // Spec-guard fast path: a spec block is mid-flight and a fatal
    // signal arrived; jump back to the guarded call site so the
    // runner records the crash and continues with the next spec.
    if (_spec_guard_active) {
        _spec_guard_active = 0;
        siglongjmp(_spec_guard_jmp, sig);
    }
    // This entire handler uses only async-signal-safe functions:
    // write(), _exit(), backtrace(), dladdr(), snprintf() into stack buffers.
    // NO fprintf, NO malloc, NO stdio.

    const char* name = avra_signal_description(sig);

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
                avra_runtime_error("stack overflow (possible infinite recursion)");
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
        avra_runtime_error("arithmetic error (possible integer overflow or hardware fault)");
        _exit(128 + sig);
    }

    // SIGILL: illegal instruction (usually a codegen bug, not user's fault)
    if (sig == SIGILL) {
        avra_runtime_error("illegal instruction — this is a compiler bug, not your code");
        safe_write("  Please report at https://github.com/forge-lang/avra/issues\n");
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
            // Skip signal handler, system libs, avra_ runtime fns
            if (strstr(info.dli_sname, "signal") || strstr(info.dli_sname, "sigtramp") ||
                strstr(info.dli_sname, "pthread") || strstr(info.dli_sname, "libsystem")) continue;
            if (strncmp(info.dli_sname, "avra_", 6) == 0) continue;
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
    safe_write("    - Run with AVRA_CRASH_DETAIL=1 for the full technical dump\n");
    safe_write("\n");

    // Full technical dump only with AVRA_CRASH_DETAIL=1
    if (getenv("AVRA_CRASH_DETAIL")) {
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

// hkms.3: when `avra_isolated_run` (or any other site) forks, the
// child inherits the parent's `_spec_guard_active` flag. If the
// child then crashes — which `isolated_*` tests deliberately do —
// our signal handler would siglongjmp into a sigjmp_buf set up in
// the parent's address space, which after CoW lives at the same VA
// in the child but represents a stack frame the child never entered.
// The atfork-child hook clears the flag so a crash in the child
// proceeds to the normal "_exit(128+sig)" path instead.
static void avra_clear_spec_guard_in_child(void) {
    _spec_guard_active = 0;
}

__attribute__((constructor))
static void avra_install_signal_handlers(void) {
    // Alternate signal stack so handler works during stack overflow
    static char alt_stack[SIGSTKSZ + 65536];
    stack_t ss = { .ss_sp = alt_stack, .ss_size = sizeof(alt_stack), .ss_flags = 0 };
    sigaltstack(&ss, NULL);

    struct sigaction sa;
    sa.sa_sigaction = avra_signal_handler;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGBUS,  &sa, NULL);
    sigaction(SIGABRT, &sa, NULL);
    sigaction(SIGFPE,  &sa, NULL);
    sigaction(SIGILL,  &sa, NULL);
    sigaction(SIGTRAP, &sa, NULL);

    pthread_atfork(NULL, NULL, avra_clear_spec_guard_in_child);
}

// ─── Selfhost helpers ─────────────────────────────────────────────
// These provide process + filesystem access for the bootstrap binary.
// Signatures use const char* (not AvraString) to match the bootstrap's
// i64-encoded pointer model.

static int    _argc = 0;
static char** _argv = NULL;

__attribute__((constructor))
static void avra_capture_args(int argc, char** argv) {
    _argc = argc;
    _argv = argv;
}

int64_t avra_selfhost_argc(void) {
    return (int64_t)_argc;
}

const char* avra_selfhost_get_arg_cstr(int64_t idx) {
    if (idx < 0 || idx >= _argc) return "";
    return _argv[idx];
}

void avra_process_exit(int64_t code) {
    exit((int)code);
}

void avra_selfhost_trace(const char* s) {
    fprintf(stderr, "[trace] %s\n", s);
}

void avra_selfhost_trace_int(const char* label, int64_t val) {
    fprintf(stderr, "[trace] %s: %lld\n", label, (long long)val);
}

// Debug: dump an Expr's tag and first payload field

int64_t avra_selfhost_file_exists(const char* path) {
    FILE* f = fopen(path, "r");
    if (!f) return 0;
    fclose(f);
    return 1;
}

const char* avra_selfhost_read_file(const char* path) {
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

int64_t avra_selfhost_write_file(const char* path, const char* content) {
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    size_t len = strlen(content);
    fwrite(content, 1, len, f);
    fclose(f);
    return 1;
}

// Append-mode write — text-only, no embedded NULs. Used by the
// resolver's xtvc fast-path to record each substituted producer
// path into a sidecar deps file so downstream linkers can pick up
// the matching .o without coordination.
int64_t avra_selfhost_append_file(const char* path, const char* content) {
    FILE* f = fopen(path, "ab");
    if (!f) return 0;
    size_t len = strlen(content);
    fwrite(content, 1, len, f);
    fclose(f);
    return 1;
}

// Binary-safe read/write for `bytes` values (length-prefixed buffers,
// see the bytes-layout block earlier in this file). Plain
// avra_selfhost_{read,write}_file use strlen and silently truncate
// at the first 0x00 — fine for source files, fatal for metadata.bin
// or any other binary artifact.

const char* avra_selfhost_read_file_bytes(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) {
        char* empty = (char*)avra_rc_alloc(8);
        *(int64_t*)empty = 0;
        return empty;
    }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (size < 0) size = 0;
    char* buf = (char*)avra_rc_alloc(8 + (size_t)size);
    *(int64_t*)buf = (int64_t)size;
    if (size > 0) fread(buf + 8, 1, (size_t)size, f);
    fclose(f);
    return buf;
}

int64_t avra_selfhost_write_file_bytes(const char* path, const char* b) {
    if (!b) return 0;
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    int64_t len = *(int64_t*)b;
    if (len < 0) len = 0;
    if (len > 0) fwrite(b + 8, 1, (size_t)len, f);
    fclose(f);
    return 1;
}

// avra_selfhost_string_to_float is used by the bootstrap's float() builtin.
double avra_selfhost_string_to_float(const char* s) { return strtod(s, NULL); }

// Parse a base-10 integer from a C string. Used by features/eval to
// evaluate Number literals correctly — see the comment in
// features/eval/mod.av on why `float()` was unsafe for arithmetic.
int64_t avra_selfhost_string_to_int(const char* s) { return strtoll(s, NULL, 10); }

// ─── Dynamic Array ────────────────────────────────────────────────
// Resizable array of i64 values. Used by List<T> in Avra source.
//
// Layout: { int64_t* data; int64_t len; int64_t cap; }
// All values stored as i64 (pointers are ptrtoint'd by the compiler).

typedef struct {
    int64_t* data;
    int64_t  len;
    int64_t  cap;
} AvraArray;

void* avra_array_new(void) {
    AvraArray* a = (AvraArray*)malloc(sizeof(AvraArray));
    a->cap = 8;
    a->len = 0;
    a->data = (int64_t*)malloc(a->cap * sizeof(int64_t));
    return a;
}

void avra_array_push(void* arr, int64_t value) {
    AvraArray* a = (AvraArray*)arr;
    if (a->len >= a->cap) {
        a->cap *= 2;
        a->data = (int64_t*)realloc(a->data, a->cap * sizeof(int64_t));
    }
    a->data[a->len++] = value;
}

int64_t avra_array_get(void* arr, int64_t idx) {
    if (!arr) {
        avra_runtime_error("index on null list");
        abort();
    }
    AvraArray* a = (AvraArray*)arr;
    if (idx < 0 || idx >= a->len) {
        avra_runtime_errorf("index %lld out of bounds (length %lld)",
                (long long)idx, (long long)a->len);
        abort();
    }
    return a->data[idx];
}

void avra_array_set(void* arr, int64_t idx, int64_t value) {
    if (!arr) {
        avra_runtime_error("index assignment on null list");
        abort();
    }
    AvraArray* a = (AvraArray*)arr;
    if (idx < 0 || idx >= a->len) {
        avra_runtime_errorf("index %lld out of bounds for assignment (length %lld)",
                (long long)idx, (long long)a->len);
        abort();
    }
    a->data[idx] = value;
}

int64_t avra_array_len(void* arr) {
    if (!arr) return 0;
    return ((AvraArray*)arr)->len;
}

int64_t avra_array_pop(void* arr) {
    if (!arr) {
        avra_runtime_error("pop on null list");
        abort();
    }
    AvraArray* a = (AvraArray*)arr;
    if (a->len <= 0) {
        avra_runtime_error("pop on empty list");
        abort();
    }
    return a->data[--a->len];
}

// Create a new array from a slice of an existing one.
void* avra_array_slice(void* arr, int64_t start, int64_t end) {
    AvraArray* src = (AvraArray*)arr;
    if (start < 0) start = 0;
    if (end > src->len) end = src->len;
    if (start >= end) return avra_array_new();

    int64_t count = end - start;
    AvraArray* dst = (AvraArray*)malloc(sizeof(AvraArray));
    dst->cap = count > 8 ? count : 8;
    dst->len = count;
    dst->data = (int64_t*)malloc(dst->cap * sizeof(int64_t));
    memcpy(dst->data, src->data + start, count * sizeof(int64_t));
    return dst;
}

// ─── Filesystem APIs ─────────────────────────────────────────────
// Native replacements for avra_shell_exec("find ...").

#include <dirent.h>
#include <sys/stat.h>

// Return the on-disk file size for `path`, or -1 when the file is
// missing/inaccessible. Faster than avra_selfhost_read_file when
// callers only need a non-empty check (test-runner's log_alive
// reads the entire log content just to compare against ""; this
// extern lets it ask `size > 0` instead).
int64_t avra_file_size(const char* path) {
    if (!path) return -1;
    struct stat st;
    if (stat(path, &st) != 0) return -1;
    return (int64_t)st.st_size;
}

// List directory entries. Returns a AvraArray of string pointers.
void* avra_readdir(const char* path) {
    AvraArray* arr = avra_array_new();
    DIR* d = opendir(path);
    if (!d) return arr;
    struct dirent* entry;
    while ((entry = readdir(d)) != NULL) {
        if (entry->d_name[0] == '.' && (entry->d_name[1] == '\0' ||
            (entry->d_name[1] == '.' && entry->d_name[2] == '\0'))) continue;
        size_t len = strlen(entry->d_name);
        char* name = (char*)malloc(len + 1);
        memcpy(name, entry->d_name, len + 1);
        avra_array_push(arr, (int64_t)(uintptr_t)name);
    }
    closedir(d);
    return arr;
}

// Check if path is a directory.
int64_t avra_is_dir(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

// Write a string to stdout exactly as-is — no trailing newline,
// no buffering tricks. Used by @std/lsp's JSON-RPC writer where the
// framing protocol requires precise byte counts.
void avra_stdout_write(const char* s) {
    if (!s) return;
    fputs(s, stdout);
    fflush(stdout);
}

// Read up to `n` bytes from stdin, blocking until data arrives or
// EOF. Returns the bytes as a length-correct C string (NUL terminator
// appended; embedded NULs are preserved as far as the runtime is
// concerned, but Avra's string operations are NUL-bounded so callers
// should avoid reading binary data this way). On EOF returns "".
//
// Used by @std/lsp's JSON-RPC stdio loop to consume LSP messages
// (Content-Length: N\r\n\r\n<N bytes of JSON>).
const char* avra_stdin_read_bytes(int64_t n) {
    if (n <= 0) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return empty;
    }
    char* buf = (char*)malloc(n + 1);
    int64_t got = 0;
    while (got < n) {
        ssize_t r = read(STDIN_FILENO, buf + got, n - got);
        if (r <= 0) break;
        got += r;
    }
    buf[got] = '\0';
    return buf;
}

// Read one line from stdin (terminator stripped). Returns "" on EOF.
// Used to parse LSP message headers ("Content-Length: 47\r\n").
const char* avra_stdin_read_line(void) {
    static char line_buf[8192];
    size_t n = 0;
    while (n + 1 < sizeof(line_buf)) {
        char c;
        ssize_t r = read(STDIN_FILENO, &c, 1);
        if (r <= 0) break;
        if (c == '\n') break;
        if (c == '\r') continue;
        line_buf[n++] = c;
    }
    line_buf[n] = '\0';
    char* out = (char*)malloc(n + 1);
    memcpy(out, line_buf, n + 1);
    return out;
}

// File modification time as nanoseconds since unix epoch. Returns 0
// if the path doesn't exist (caller treats 0 as "stale, re-extract").
// Used by std-lsp's incremental cache to detect changed source files
// without reading file contents.
int64_t avra_file_mtime(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
#if defined(__APPLE__)
    return (int64_t)st.st_mtimespec.tv_sec * 1000000000LL
         + (int64_t)st.st_mtimespec.tv_nsec;
#else
    return (int64_t)st.st_mtim.tv_sec * 1000000000LL
         + (int64_t)st.st_mtim.tv_nsec;
#endif
}

// Create a directory and every missing parent (mkdir -p semantics).
// Returns 1 on success or when the directory already exists, 0 on
// failure. The build system uses this to lay out the cache directory
// tree without having to shell out to mkdir.
int64_t avra_mkdir_p(const char* path) {
    if (!path || !*path) return 0;
    size_t len = strlen(path);
    if (len >= 4096) return 0;
    char buf[4096];
    memcpy(buf, path, len + 1);
    // Walk forward, replacing each '/' with '\0' to mkdir progressive
    // prefixes. Skip the leading '/' on absolute paths.
    size_t start = (buf[0] == '/') ? 1 : 0;
    for (size_t i = start; i < len; i++) {
        if (buf[i] == '/') {
            buf[i] = '\0';
            if (mkdir(buf, 0755) != 0) {
                struct stat st;
                if (stat(buf, &st) != 0 || !S_ISDIR(st.st_mode)) return 0;
            }
            buf[i] = '/';
        }
    }
    if (mkdir(buf, 0755) != 0) {
        struct stat st;
        if (stat(buf, &st) != 0 || !S_ISDIR(st.st_mode)) return 0;
    }
    return 1;
}

// Atomic rename (POSIX rename). Used to publish a cache entry: write
// to a tmp path under the cache dir, then rename into place so any
// concurrent reader sees either the old or the new entry, never a
// half-written one. Returns 1 on success, 0 on failure.
int64_t avra_rename(const char* src, const char* dst) {
    if (!src || !dst) return 0;
    return rename(src, dst) == 0 ? 1 : 0;
}

// Remove a file. Returns 1 on success or when the file is already
// absent, 0 on failure for any other reason. The cache GC needs
// this to evict stale entries.
int64_t avra_remove_file(const char* path) {
    if (!path) return 0;
    if (unlink(path) == 0) return 1;
    struct stat st;
    if (stat(path, &st) != 0) return 1;
    return 0;
}


// ─── Hash Map ─────────────────────────────────────────────────────
// String-keyed, i64-valued hash map. Linear probing for simplicity.
// Used by Map<string, T> in Avra source and internally by the
// compiler for fast symbol lookup.

#define AVRA_MAP_INIT_CAP 32
#define AVRA_MAP_LOAD_FACTOR 0.75

typedef struct {
    char**   keys;     // NULL = empty slot
    int64_t* values;
    int64_t  count;
    int64_t  cap;
} AvraHashMap;

static uint64_t avra_hash_str(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    while (*s) {
        h ^= (uint8_t)*s++;
        h *= 1099511628211ULL;
    }
    return h;
}

static void avra_map_grow(AvraHashMap* m);

void* avra_map_new_cstr(void) {
    AvraHashMap* m = (AvraHashMap*)malloc(sizeof(AvraHashMap));
    m->cap = AVRA_MAP_INIT_CAP;
    m->count = 0;
    m->keys = (char**)calloc(m->cap, sizeof(char*));
    m->values = (int64_t*)calloc(m->cap, sizeof(int64_t));
    return m;
}

void avra_map_set_cstr(void* map, const char* key, int64_t value) {
    AvraHashMap* m = (AvraHashMap*)map;
    if ((double)m->count / m->cap >= AVRA_MAP_LOAD_FACTOR) {
        avra_map_grow(m);
    }
    uint64_t idx = avra_hash_str(key) % m->cap;
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

int64_t avra_map_get_cstr(void* map, const char* key) {
    AvraHashMap* m = (AvraHashMap*)map;
    uint64_t idx = avra_hash_str(key) % m->cap;
    while (m->keys[idx]) {
        if (strcmp(m->keys[idx], key) == 0) {
            return m->values[idx];
        }
        idx = (idx + 1) % m->cap;
    }
    return 0;
}

int64_t avra_map_has_cstr(void* map, const char* key) {
    AvraHashMap* m = (AvraHashMap*)map;
    uint64_t idx = avra_hash_str(key) % m->cap;
    while (m->keys[idx]) {
        if (strcmp(m->keys[idx], key) == 0) return 1;
        idx = (idx + 1) % m->cap;
    }
    return 0;
}

int64_t avra_map_len_cstr(void* map) {
    if (!map) return 0;
    return ((AvraHashMap*)map)->count;
}

// Return an array of all keys.
void* avra_map_keys_cstr(void* map) {
    AvraHashMap* m = (AvraHashMap*)map;
    void* arr = avra_array_new();
    for (int64_t i = 0; i < m->cap; i++) {
        if (m->keys[i]) {
            avra_array_push(arr, (int64_t)m->keys[i]);
        }
    }
    return arr;
}

// Return an array of all values.
void* avra_map_values_cstr(void* map) {
    AvraHashMap* m = (AvraHashMap*)map;
    void* arr = avra_array_new();
    for (int64_t i = 0; i < m->cap; i++) {
        if (m->keys[i]) {
            avra_array_push(arr, m->values[i]);
        }
    }
    return arr;
}

// Remove a key from the map. Returns 1 if found, 0 if not.
int64_t avra_map_remove_cstr(void* map, const char* key) {
    if (!map || !key) return 0;
    AvraHashMap* m = (AvraHashMap*)map;
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

static void avra_map_grow(AvraHashMap* m) {
    int64_t old_cap = m->cap;
    char** old_keys = m->keys;
    int64_t* old_values = m->values;

    m->cap *= 2;
    m->keys = (char**)calloc(m->cap, sizeof(char*));
    m->values = (int64_t*)calloc(m->cap, sizeof(int64_t));
    m->count = 0;

    for (int64_t i = 0; i < old_cap; i++) {
        if (old_keys[i]) {
            avra_map_set_cstr(m, old_keys[i], old_values[i]);
            free(old_keys[i]);
        }
    }
    free(old_keys);
    free(old_values);
}

// ─── Lazy @comptime body registry (9p1d) ──────────────────────────
// Maps fully-qualified `@comptime fn` names to their body source. The
// metadata synthesiser stashes the body source here when a consumer
// loads std-avrac (or any package shipping @comptime fns) from
// .meta.bin, avoiding the eager parse_body_source over every
// @comptime fn declaration. The @expand pipeline's invoke_macro
// drains the entry on first lookup — parse the source, register with
// the consumer's CompTimeRegistry, then evaluate.
//
// Values are strdup'd source strings stored as pointer-cast int64_t
// inside the underlying AvraHashMap (the map's value column is i64;
// the cast is safe on every platform the bootstrap targets). The
// process-global is fine here per CLAUDE.md rule 17 (runtime.c
// statics are the explicit carve-out for process-wide state).
static AvraHashMap* g_lazy_comptime = NULL;

void avra_lazy_comptime_set(const char* qn, const char* source) {
    if (!g_lazy_comptime) {
        g_lazy_comptime = (AvraHashMap*)avra_map_new_cstr();
    }
    if ((double)g_lazy_comptime->count / g_lazy_comptime->cap >= AVRA_MAP_LOAD_FACTOR) {
        avra_map_grow(g_lazy_comptime);
    }
    uint64_t idx = avra_hash_str(qn) % g_lazy_comptime->cap;
    while (g_lazy_comptime->keys[idx]) {
        if (strcmp(g_lazy_comptime->keys[idx], qn) == 0) {
            // Overwrite: free the previous source dup, replace.
            free((char*)g_lazy_comptime->values[idx]);
            g_lazy_comptime->values[idx] = (int64_t)strdup(source);
            return;
        }
        idx = (idx + 1) % g_lazy_comptime->cap;
    }
    g_lazy_comptime->keys[idx] = strdup(qn);
    g_lazy_comptime->values[idx] = (int64_t)strdup(source);
    g_lazy_comptime->count++;
}

const char* avra_lazy_comptime_get(const char* qn) {
    if (!g_lazy_comptime) return "";
    uint64_t idx = avra_hash_str(qn) % g_lazy_comptime->cap;
    while (g_lazy_comptime->keys[idx]) {
        if (strcmp(g_lazy_comptime->keys[idx], qn) == 0) {
            return (const char*)g_lazy_comptime->values[idx];
        }
        idx = (idx + 1) % g_lazy_comptime->cap;
    }
    return "";
}

int64_t avra_lazy_comptime_has(const char* qn) {
    if (!g_lazy_comptime) return 0;
    uint64_t idx = avra_hash_str(qn) % g_lazy_comptime->cap;
    while (g_lazy_comptime->keys[idx]) {
        if (strcmp(g_lazy_comptime->keys[idx], qn) == 0) return 1;
        idx = (idx + 1) % g_lazy_comptime->cap;
    }
    return 0;
}

// ─── Int-keyed Map ────────────────────────────────────────────────
// Flat array indexed by int key. Perfect for enum tag → handler
// dispatch where keys are small sequential integers (0-63).
// Values are i64 (function pointers, struct pointers, etc.).

#define AVRA_INTMAP_CAP 256

typedef struct {
    int64_t keys[AVRA_INTMAP_CAP];
    int64_t values[AVRA_INTMAP_CAP];
    int8_t  occupied[AVRA_INTMAP_CAP];
} AvraIntMap;

void* avra_intmap_new(void) {
    AvraIntMap* m = (AvraIntMap*)calloc(1, sizeof(AvraIntMap));
    return m;
}

void avra_intmap_set(void* map, int64_t key, int64_t value) {
    AvraIntMap* m = (AvraIntMap*)map;
    uint64_t idx = (uint64_t)key % AVRA_INTMAP_CAP;
    for (int i = 0; i < AVRA_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % AVRA_INTMAP_CAP;
        if (!m->occupied[slot] || m->keys[slot] == key) {
            m->keys[slot] = key;
            m->values[slot] = value;
            m->occupied[slot] = 1;
            return;
        }
    }
}

int64_t avra_intmap_get(void* map, int64_t key) {
    AvraIntMap* m = (AvraIntMap*)map;
    uint64_t idx = (uint64_t)key % AVRA_INTMAP_CAP;
    for (int i = 0; i < AVRA_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % AVRA_INTMAP_CAP;
        if (!m->occupied[slot]) return 0;
        if (m->keys[slot] == key) return m->values[slot];
    }
    return 0;
}

// Get value as a string pointer (for storing strings in intmap).
const char* avra_intmap_get_as_string(void* map, int64_t key) {
    return (const char*)(uintptr_t)avra_intmap_get(map, key);
}

// Read current value at key and increment it. Returns the OLD value.
int64_t avra_intmap_inc(void* map, int64_t key) {
    int64_t old = avra_intmap_get(map, key);
    avra_intmap_set(map, key, old + 1);
    return old;
}

int64_t avra_intmap_has(void* map, int64_t key) {
    AvraIntMap* m = (AvraIntMap*)map;
    uint64_t idx = (uint64_t)key % AVRA_INTMAP_CAP;
    for (int i = 0; i < AVRA_INTMAP_CAP; i++) {
        uint64_t slot = (idx + i) % AVRA_INTMAP_CAP;
        if (!m->occupied[slot]) return 0;
        if (m->keys[slot] == key) return 1;
    }
    return 0;
}

// ─── String Methods ───────────────────────────────────────────────
// All take const char* and return const char* or int64_t.
// Returned strings are heap-allocated (caller doesn't free in
// the bootstrap's GC-free model — acceptable for a compiler).

int64_t avra_str_contains(const char* haystack, const char* needle) {
    return strstr(haystack, needle) != NULL;
}

int64_t avra_str_starts_with(const char* s, const char* prefix) {
    size_t plen = strlen(prefix);
    return strncmp(s, prefix, plen) == 0;
}

int64_t avra_str_ends_with(const char* s, const char* suffix) {
    size_t slen = strlen(s);
    size_t xlen = strlen(suffix);
    if (xlen > slen) return 0;
    return strcmp(s + slen - xlen, suffix) == 0;
}

int64_t avra_str_index_of(const char* s, const char* needle) {
    const char* p = strstr(s, needle);
    if (!p) return -1;
    return (int64_t)(p - s);
}

const char* avra_str_replace(const char* s, const char* from, const char* to) {
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

const char* avra_str_trim(const char* s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t len = strlen(s);
    while (len > 0 && (s[len-1] == ' ' || s[len-1] == '\t' || s[len-1] == '\n' || s[len-1] == '\r')) len--;
    char* r = (char*)malloc(len + 1);
    memcpy(r, s, len);
    r[len] = '\0';
    return r;
}

const char* avra_str_to_upper(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)malloc(len + 1);
    for (size_t i = 0; i <= len; i++) {
        r[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
    }
    return r;
}

const char* avra_str_to_lower(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)malloc(len + 1);
    for (size_t i = 0; i <= len; i++) {
        r[i] = (s[i] >= 'A' && s[i] <= 'Z') ? s[i] + 32 : s[i];
    }
    return r;
}

int64_t avra_str_char_code(const char* s, int64_t idx) {
    size_t len = strlen(s);
    if (idx < 0 || (size_t)idx >= len) return 0;
    return (int64_t)(unsigned char)s[idx];
}

const char* avra_str_from_char_code(int64_t code) {
    char* r = (char*)malloc(2);
    r[0] = (char)code;
    r[1] = '\0';
    return r;
}

// Reverse a string.
const char* avra_str_reverse(const char* s) {
    size_t len = strlen(s);
    char* r = (char*)avra_rc_alloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        r[i] = s[len - 1 - i];
    }
    r[len] = '\0';
    return r;
}

// Repeat a string n times.
const char* avra_str_repeat(const char* s, int64_t n) {
    if (n <= 0) return "";
    size_t len = strlen(s);
    size_t total = len * (size_t)n;
    char* r = (char*)avra_rc_alloc(total + 1);
    for (int64_t i = 0; i < n; i++) {
        memcpy(r + i * len, s, len);
    }
    r[total] = '\0';
    return r;
}

// Return a single-character string at index idx. Panics (via
// avra_runtime_errorf) on out-of-bounds. Returning the empty string
// silently was the historical behavior — but it masked bugs, and the
// inline-load codegen path (since fixed) read past the NUL terminator
// returning heap garbage.
const char* avra_str_char_at(const char* s, int64_t idx) {
    size_t len = s ? strlen(s) : 0;
    if (idx < 0 || (size_t)idx >= len) {
        avra_runtime_errorf("string index %lld out of bounds (length %zu)",
                            (long long)idx, len);
        exit(1);
    }
    char* r = (char*)avra_rc_alloc(2);
    r[0] = s[idx];
    r[1] = '\0';
    return r;
}

// Return a substring from index start (inclusive) to end (exclusive).
const char* avra_str_substring(const char* s, int64_t start, int64_t end) {
    size_t len = strlen(s);
    if (start < 0) start = 0;
    if (end < start) end = start;
    if ((size_t)end > len) end = (int64_t)len;
    int64_t sub_len = end - start;
    char* r = (char*)avra_rc_alloc(sub_len + 1);
    memcpy(r, s + start, sub_len);
    r[sub_len] = '\0';
    return r;
}

// Split string by separator, returns a AvraArray of string pointers.
void* avra_str_split(const char* s, const char* sep) {
    void* arr = avra_array_new();
    size_t seplen = strlen(sep);
    if (seplen == 0) {
        // Split into characters
        size_t len = strlen(s);
        for (size_t i = 0; i < len; i++) {
            char* ch = (char*)malloc(2);
            ch[0] = s[i];
            ch[1] = '\0';
            avra_array_push(arr, (int64_t)ch);
        }
        return arr;
    }
    const char* p = s;
    while (*p) {
        const char* found = strstr(p, sep);
        if (!found) {
            char* chunk = strdup(p);
            avra_array_push(arr, (int64_t)chunk);
            break;
        }
        size_t chunk_len = found - p;
        char* chunk = (char*)malloc(chunk_len + 1);
        memcpy(chunk, p, chunk_len);
        chunk[chunk_len] = '\0';
        avra_array_push(arr, (int64_t)chunk);
        p = found + seplen;
    }
    return arr;
}

// ─── Higher-order list operations ─────────────────────────────────

typedef int64_t (*AvraFn1)(int64_t);
typedef int64_t (*AvraFn2)(int64_t, int64_t);

// Forward declarations for closure trampolines
int64_t avra_closure_call_1(int64_t closure, int64_t a0);
int64_t avra_closure_call_2(int64_t closure, int64_t a0, int64_t a1);

void* avra_array_map(void* arr, int64_t fn_ptr) {
    AvraArray* src = (AvraArray*)arr;
    void* dst = avra_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        avra_array_push(dst, avra_closure_call_1(fn_ptr, src->data[i]));
    }
    return dst;
}

void* avra_array_filter(void* arr, int64_t fn_ptr) {
    AvraArray* src = (AvraArray*)arr;
    void* dst = avra_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        if (avra_closure_call_1(fn_ptr, src->data[i])) {
            avra_array_push(dst, src->data[i]);
        }
    }
    return dst;
}

int64_t avra_array_reduce(void* arr, int64_t initial, int64_t fn_ptr) {
    AvraArray* src = (AvraArray*)arr;
    int64_t acc = initial;
    for (int64_t i = 0; i < src->len; i++) {
        acc = avra_closure_call_2(fn_ptr, acc, src->data[i]);
    }
    return acc;
}

void avra_array_foreach(void* arr, int64_t fn_ptr) {
    AvraArray* src = (AvraArray*)arr;
    for (int64_t i = 0; i < src->len; i++) {
        avra_closure_call_1(fn_ptr, src->data[i]);
    }
}

// Check if array contains a value. For strings, does pointer/strcmp comparison.
int64_t avra_array_contains(void* arr, int64_t value) {
    AvraArray* a = (AvraArray*)arr;
    for (int64_t i = 0; i < a->len; i++) {
        if (a->data[i] == value) return 1;
    }
    return 0;
}

// Find index of value in array. Returns -1 if not found.
int64_t avra_array_index_of(void* arr, int64_t value) {
    AvraArray* a = (AvraArray*)arr;
    for (int64_t i = 0; i < a->len; i++) {
        if (a->data[i] == value) return i;
    }
    return -1;
}

// Reverse an array in-place. Returns the same array.
void* avra_array_reverse(void* arr) {
    AvraArray* a = (AvraArray*)arr;
    for (int64_t i = 0, j = a->len - 1; i < j; i++, j--) {
        int64_t tmp = a->data[i];
        a->data[i] = a->data[j];
        a->data[j] = tmp;
    }
    return arr;
}

// Insert `value` at index `idx`, shifting later elements right by one.
// `idx == len` appends (matches Python's list.insert / Rust's Vec::insert).
// Returns the same array so the call chains.
void* avra_array_insert(void* arr, int64_t idx, int64_t value) {
    AvraArray* a = (AvraArray*)arr;
    if (idx < 0) idx = 0;
    if (idx > a->len) idx = a->len;
    if (a->len >= a->cap) {
        a->cap *= 2;
        if (a->cap == 0) a->cap = 8;
        a->data = (int64_t*)realloc(a->data, a->cap * sizeof(int64_t));
    }
    memmove(a->data + idx + 1, a->data + idx, (size_t)(a->len - idx) * sizeof(int64_t));
    a->data[idx] = value;
    a->len += 1;
    return arr;
}

// Sort context for qsort_r — packs the closure-based comparator's
// fn_ptr into the comparator's user-data slot. qsort_r is the
// portable way to thread state through a C qsort callback.
typedef struct AvraSortCtx { int64_t fn_ptr; } AvraSortCtx;

// rlb4: comparator wrapper around the user's closure. Returns the
// closure's int directly so a user-supplied `(a, b) -> a - b` works
// without normalisation. Crashes inside the closure propagate via the
// usual signal-handler path; sort is single-threaded so partial results
// are discarded by the runtime panic anyway.
#if defined(__APPLE__) || defined(__FreeBSD__)
// macOS / BSD qsort_r: comparator is (ctx, a, b) — context first.
static int avra_array_sort_cmp(void* ctx, const void* a, const void* b) {
    AvraSortCtx* sc = (AvraSortCtx*)ctx;
    int64_t r = avra_closure_call_2(sc->fn_ptr,
        *(const int64_t*)a, *(const int64_t*)b);
    return r < 0 ? -1 : (r > 0 ? 1 : 0);
}
#else
// glibc qsort_r: comparator is (a, b, ctx) — context last.
static int avra_array_sort_cmp(const void* a, const void* b, void* ctx) {
    AvraSortCtx* sc = (AvraSortCtx*)ctx;
    int64_t r = avra_closure_call_2(sc->fn_ptr,
        *(const int64_t*)a, *(const int64_t*)b);
    return r < 0 ? -1 : (r > 0 ? 1 : 0);
}
#endif

// In-place sort by a user comparator `(a, b) -> int` (negative ⇒
// a before b). Returns the same array so the call chains.
// O(N log N) via qsort_r.
void* avra_array_sort(void* arr, int64_t cmp_fn) {
    AvraArray* a = (AvraArray*)arr;
    AvraSortCtx ctx = { .fn_ptr = cmp_fn };
#if defined(__APPLE__) || defined(__FreeBSD__)
    qsort_r(a->data, (size_t)a->len, sizeof(int64_t), &ctx, avra_array_sort_cmp);
#else
    qsort_r(a->data, (size_t)a->len, sizeof(int64_t), avra_array_sort_cmp, &ctx);
#endif
    return arr;
}

// Join a list of strings with a separator.
const char* avra_str_join(void* arr, const char* sep) {
    AvraArray* a = (AvraArray*)arr;
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
const char* avra_file_read(const char* path) {
    return avra_selfhost_read_file(path);
}

int64_t avra_file_write(const char* path, const char* content) {
    return avra_selfhost_write_file(path, content);
}

int64_t avra_file_exists(const char* path) {
    return avra_selfhost_file_exists(path);
}

// ─── Closure support ──────────────────────────────────────────────
// A closure with captures is stored as a AvraArray:
//   [0] = fn_ptr (intptr_t)
//   [1..N] = captured values
// A non-capturing closure is a bare function pointer (int64_t).
//
// avra_closure_call dispatches: if the value looks like a AvraArray
// (has a valid length field), unpack fn_ptr + captures and call with
// both user args and captures. Otherwise call directly.

// ── Closure representation ────────────────────────────────────────
// ALL callable values are AvraArrays: [TAG, fn_ptr, cap1, cap2, ...]
//   data[0] = FORGE_CLOSURE_TAG (sentinel for safety checks)
//   data[1] = fn_ptr (intptr_t of the function)
//   data[2..] = captured values (0 or more)
//
// Named function references, non-capturing lambdas, and capturing
// closures all use the same layout. The codegen wraps every callable
// in this format. No bare function pointers exist at runtime.
#define FORGE_CLOSURE_TAG ((int64_t)-559038737)

// Extract the function pointer from a closure array.
int64_t avra_closure_get_fn(int64_t closure_val) {
    AvraArray* arr = (AvraArray*)(uintptr_t)closure_val;
    if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[1];
    }
    // Should never happen — all callables are arrays. Log and return
    // the value itself as a last resort (better than silent crash).
    avra_runtime_errorf("closure call on non-closure value 0x%llx",
            (unsigned long long)closure_val);
    return closure_val;
}

// Get a captured value by index (0-based, captures start at data[2]).
int64_t avra_closure_get_capture(int64_t closure_val, int64_t idx) {
    AvraArray* arr = (AvraArray*)(uintptr_t)closure_val;
    if (arr && arr->len > idx + 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->data[idx + 2];
    }
    return 0;
}

// Get the number of captured values.
int64_t avra_closure_num_captures(int64_t closure_val) {
    AvraArray* arr = (AvraArray*)(uintptr_t)closure_val;
    if (arr && arr->len >= 2 && arr->data && arr->data[0] == FORGE_CLOSURE_TAG) {
        return arr->len - 2;
    }
    return 0;
}

// ── Generic closure calls ─────────────────────────────────────────
// Used by C-side higher-order list operations (avra_array_map, etc.)
// that receive closures as i64 values. These extract fn_ptr + captures
// and call with the combined argument list.
//
// The codegen's direct LLVM calls handle the common case. These
// trampolines only exist for the C-side list operations.

// Helper: unpack closure and call with user_args + captures.
// Supports up to 8 total args (user + captures).
static int64_t avra_closure_dispatch(int64_t closure, int64_t* user_args, int64_t user_argc) {
    int64_t fn = avra_closure_get_fn(closure);
    int64_t n_caps = avra_closure_num_captures(closure);
    int64_t total = user_argc + n_caps;

    // Build combined arg array: [user_args..., captures...]
    int64_t args[8];
    for (int64_t i = 0; i < user_argc && i < 8; i++) args[i] = user_args[i];
    for (int64_t i = 0; i < n_caps && user_argc + i < 8; i++) args[user_argc + i] = avra_closure_get_capture(closure, i);

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
            avra_runtime_errorf("closure call with %lld args exceeds limit of 8", (long long)total);
            return 0;
    }
}

int64_t avra_closure_call_0(int64_t closure) {
    return avra_closure_dispatch(closure, NULL, 0);
}

int64_t avra_closure_call_1(int64_t closure, int64_t a0) {
    int64_t args[] = { a0 };
    return avra_closure_dispatch(closure, args, 1);
}

int64_t avra_closure_call_2(int64_t closure, int64_t a0, int64_t a1) {
    int64_t args[] = { a0, a1 };
    return avra_closure_dispatch(closure, args, 2);
}

int64_t avra_closure_call_3(int64_t closure, int64_t a0, int64_t a1, int64_t a2) {
    int64_t args[] = { a0, a1, a2 };
    return avra_closure_dispatch(closure, args, 3);
}
int64_t avra_closure_call_4(int64_t closure, int64_t a0, int64_t a1, int64_t a2, int64_t a3) {
    int64_t args[] = { a0, a1, a2, a3 };
    return avra_closure_dispatch(closure, args, 4);
}
int64_t avra_closure_call_5(int64_t closure, int64_t a0, int64_t a1, int64_t a2, int64_t a3, int64_t a4) {
    int64_t args[] = { a0, a1, a2, a3, a4 };
    return avra_closure_dispatch(closure, args, 5);
}

// ── Levenshtein distance ──
// Used by "did you mean?" suggestions in the compiler.
int64_t avra_selfhost_levenshtein(const char *a, const char *b, int64_t len_a, int64_t len_b) {
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
const char* avra_char_from_hex(const char* hi, const char* lo) {
    char* buf = (char*)malloc(2);
    buf[0] = (char)((hex_val(hi[0]) << 4) | hex_val(lo[0]));
    buf[1] = 0;
    return buf;
}

// ═══════════════════════════════════════════════════════════════════
// Developer tooling — debugging, crash guards, tracing
// ═══════════════════════════════════════════════════════════════════

// ── 1. Crash guard ──────────────────────────────────────────────
// Wraps a function call in setjmp/longjmp so a segfault inside
// becomes a return value instead of a process-killing signal.
// Usage: if (avra_try_call(fn, arg1, arg2)) { /* crashed */ }

static jmp_buf avra_crash_jmp;
static volatile sig_atomic_t avra_crash_guard_active = 0;

static void avra_crash_guard_handler(int sig) {
    if (avra_crash_guard_active) {
        avra_crash_guard_active = 0;
        longjmp(avra_crash_jmp, sig);
    }
    // Not guarded — fall through to normal handler
    avra_signal_handler(sig, NULL, NULL);
}

// Returns 0 on success, signal number on crash.
int64_t avra_try_call_1(int64_t (*fn)(int64_t), int64_t a) {
    struct sigaction old_segv, old_bus;
    struct sigaction sa = { .sa_handler = avra_crash_guard_handler };
    sigaction(SIGSEGV, &sa, &old_segv);
    sigaction(SIGBUS, &sa, &old_bus);

    avra_crash_guard_active = 1;
    int sig = setjmp(avra_crash_jmp);
    if (sig == 0) {
        fn(a);
        avra_crash_guard_active = 0;
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

void avra_trace_ptr(const char* label, int64_t val) {
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
// available for debugging via extern fn in Avra source.

// ── 4. AST dumper ───────────────────────────────────────────────
// Prints Stmt/Expr enum tag + pointer for debugging AST traversal.

void avra_dump_stmt(const char* label, int64_t stmt_ptr) {
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

void avra_dump_stmt_list(const char* label, int64_t list_ptr) {
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
    avra_dump_stmt("  stmt", fields[0]);
}

// ── eprintln: write string + newline to stderr ──
void avra_eprintln(const char* s) {
    fputs(s, stderr);
    fputc('\n', stderr);
}

// ── Float support ──
int64_t avra_float_parse(const char* s) {
    double d = strtod(s, NULL);
    int64_t result;
    memcpy(&result, &d, sizeof(result));
    return result;
}

// `string(bool)` and `${bool}` interpolation. Returns static
// strings — no allocation, safe to use without an arena.
const char* avra_bool_to_string(int64_t b) {
    return b != 0 ? "true" : "false";
}

const char* avra_float_to_string(int64_t bits) {
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
// Takes float bits as int64 (same convention as avra_float_to_string).
const char* avra_format_float(int64_t bits, const char* spec) {
    double d;
    memcpy(&d, &bits, sizeof(d));
    char fmt[32];
    snprintf(fmt, sizeof(fmt), "%%%s", spec);
    char* buf = (char*)malloc(128);
    snprintf(buf, 128, fmt, d);
    return buf;
}

// Format an int with a printf-style format spec (e.g. "d", "x", "08x").
const char* avra_format_int(int64_t n, const char* spec) {
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
int64_t avra_expr_tag(int64_t expr_val) {
    int64_t* p = (int64_t*)(uintptr_t)expr_val;
    return p[0];
}

int64_t avra_stmt_tag(int64_t stmt_val) {
    int64_t* p = (int64_t*)(uintptr_t)stmt_val;
    return p[0];
}

// ── Ptr byte write ──
void avra_ptr_store_byte(int64_t ptr_val, int64_t offset, int64_t byte_val) {
    uint8_t* p = (uint8_t*)(uintptr_t)ptr_val;
    p[offset] = (uint8_t)byte_val;
}

// ── Ptr ↔ String ──
const char* avra_string_from_ptr(int64_t ptr_val, int64_t len) {
    char* buf = (char*)malloc(len + 1);
    memcpy(buf, (void*)(uintptr_t)ptr_val, len);
    buf[len] = '\0';
    return buf;
}

// ── Process timing ──
#include <time.h>
#include <pthread.h>

static struct timespec avra_start_time;

__attribute__((constructor))
static void avra_init_timer(void) {
    clock_gettime(CLOCK_MONOTONIC, &avra_start_time);
}

int64_t avra_uptime_ms(void) {
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    int64_t secs = now.tv_sec - avra_start_time.tv_sec;
    int64_t nsecs = now.tv_nsec - avra_start_time.tv_nsec;
    return secs * 1000 + nsecs / 1000000;
}

// ── DateTime ──
int64_t avra_datetime_now(void) {
    return (int64_t)time(NULL);
}

const char* avra_datetime_format(int64_t epoch, const char* fmt) {
    time_t t = (time_t)epoch;
    struct tm* tm = localtime(&t);
    char* buf = (char*)malloc(256);
    strftime(buf, 256, fmt, tm);
    return buf;
}

int64_t avra_datetime_year(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_year + 1900;
}
int64_t avra_datetime_month(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_mon + 1;
}
int64_t avra_datetime_day(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_mday;
}
int64_t avra_datetime_hour(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_hour;
}
int64_t avra_datetime_minute(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_min;
}
int64_t avra_datetime_second(int64_t epoch) {
    time_t t = (time_t)epoch; struct tm* tm = localtime(&t); return tm->tm_sec;
}

// ── JSON ──
// Minimal JSON: stringify maps/lists/primitives, parse field extraction.

// Stringify an integer to JSON.
const char* avra_json_stringify_int(int64_t value) {
    char* buf = (char*)malloc(32);
    snprintf(buf, 32, "%lld", (long long)value);
    return buf;
}

// Stringify a string to JSON (with escaping).
const char* avra_json_stringify_string(const char* s) {
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
const char* avra_json_stringify_bool(int64_t value) {
    return value ? "true" : "false";
}

// Parse a JSON string and extract an integer field by key.
int64_t avra_json_get_int(const char* json, const char* key) {
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
const char* avra_json_get_string(const char* json, const char* key) {
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
int64_t avra_json_get_bool(const char* json, const char* key) {
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
int64_t avra_semver_major(const char* version) {
    if (!version) return 0;
    return atoi(version);
}
int64_t avra_semver_minor(const char* version) {
    if (!version) return 0;
    const char* dot = strchr(version, '.');
    return dot ? atoi(dot + 1) : 0;
}
int64_t avra_semver_patch(const char* version) {
    if (!version) return 0;
    const char* dot1 = strchr(version, '.');
    if (!dot1) return 0;
    const char* dot2 = strchr(dot1 + 1, '.');
    return dot2 ? atoi(dot2 + 1) : 0;
}
// Returns -1, 0, or 1 for version comparison.
int64_t avra_semver_compare(const char* a, const char* b) {
    int64_t am = avra_semver_major(a), bm = avra_semver_major(b);
    if (am != bm) return am < bm ? -1 : 1;
    int64_t ai = avra_semver_minor(a), bi = avra_semver_minor(b);
    if (ai != bi) return ai < bi ? -1 : 1;
    int64_t ap = avra_semver_patch(a), bp = avra_semver_patch(b);
    if (ap != bp) return ap < bp ? -1 : 1;
    return 0;
}

// ── TOML (minimal) ──
// Extracts string values from simple key = "value" TOML.
const char* avra_toml_get_string(const char* toml, const char* key) {
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

int64_t avra_toml_get_int(const char* toml, const char* key) {
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

int64_t avra_toml_get_bool(const char* toml, const char* key) {
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
const char* avra_toml_get_section_string(const char* toml, const char* section, const char* key) {
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
int64_t avra_toml_has_section(const char* toml, const char* section) {
    if (!toml || !section) return 0;
    char header[256];
    snprintf(header, sizeof(header), "[%s]", section);
    return strstr(toml, header) != NULL ? 1 : 0;
}

// Locate the bounds of a [section] in `toml`. Sets *out_start to the
// first byte after the header line and *out_end to the byte before the
// next [section] header (or end of string). Returns 1 on success, 0 if
// the section is absent. Used by the section-aware getters below to
// avoid duplicating the boundary search across types.
static int avra_toml_section_bounds(const char* toml, const char* section,
                                    const char** out_start, const char** out_end) {
    if (!toml || !section) return 0;
    char header[256];
    snprintf(header, sizeof(header), "[%s]", section);
    const char* sec_start = strstr(toml, header);
    if (!sec_start) return 0;
    sec_start = strchr(sec_start, '\n');
    if (!sec_start) return 0;
    sec_start++;
    const char* sec_end = sec_start;
    while (*sec_end) {
        if (*sec_end == '[' && (sec_end == sec_start || sec_end[-1] == '\n')) break;
        sec_end++;
    }
    *out_start = sec_start;
    *out_end = sec_end;
    return 1;
}

// Section-aware int read: returns the int value of `key` inside
// [section], or `default_value` if missing. Recognizes plain decimal
// integers; rejects floats and booleans.
int64_t avra_toml_get_section_int(const char* toml, const char* section,
                                  const char* key, int64_t default_value) {
    const char* sec_start;
    const char* sec_end;
    if (!avra_toml_section_bounds(toml, section, &sec_start, &sec_end)) {
        return default_value;
    }
    if (!key) return default_value;
    size_t klen = strlen(key);
    const char* pos = sec_start;
    while (pos < sec_end && (pos = strstr(pos, key)) != NULL && pos < sec_end) {
        if (pos != sec_start && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        if (after >= sec_end) return default_value;
        // Reject if the value looks like a string or bool — caller asked for int.
        if (*after == '"' || *after == 't' || *after == 'f') return default_value;
        return (int64_t)strtoll(after, NULL, 10);
    }
    return default_value;
}

// Section-aware bool read: returns 1 for `true`, 0 for `false`, and
// `default_value` when the key is missing or the value is unrecognized.
int64_t avra_toml_get_section_bool(const char* toml, const char* section,
                                   const char* key, int64_t default_value) {
    const char* sec_start;
    const char* sec_end;
    if (!avra_toml_section_bounds(toml, section, &sec_start, &sec_end)) {
        return default_value;
    }
    if (!key) return default_value;
    size_t klen = strlen(key);
    const char* pos = sec_start;
    while (pos < sec_end && (pos = strstr(pos, key)) != NULL && pos < sec_end) {
        if (pos != sec_start && pos[-1] != '\n' && pos[-1] != ' ') { pos++; continue; }
        const char* after = pos + klen;
        while (*after == ' ' || *after == '\t') after++;
        if (*after != '=') { pos++; continue; }
        after++;
        while (*after == ' ' || *after == '\t') after++;
        if (after + 4 <= sec_end && strncmp(after, "true", 4) == 0) return 1;
        if (after + 5 <= sec_end && strncmp(after, "false", 5) == 0) return 0;
        return default_value;
    }
    return default_value;
}

// ── Bytes ──
// Raw octet sequences distinct from strings. Phase B v1 uses
// NUL-terminated heap buffers under the hood — same lowering as
// string — so length comes from strlen and existing rc machinery
// applies. The TYPE distinction is enforced by typeck (bytes !=
// string), not by the runtime layout. A future v2 swap to
// length-prefixed storage is non-breaking at the surface.
//
// Tracked under forge-crafting-intepreters-73wa (in the
// in-language-crypto epic ayq3).

// `bytes` is a length-prefixed buffer: `[u64 length][data...]`. The
// pointer returned to Avra-land points at the length header so
// b.byte(i) reads `data[i]` at offset 8+i. This lets bytes hold raw
// octets including embedded NUL — the previous layout used strlen(),
// which truncated at the first 0x00 and silently corrupted any binary
// payload (metadata.bin, image data, hash output, …).
//
// Tracked under forge-crafting-intepreters-73wa (sub-ticket of ayq3).

static inline char* avra_bytes_alloc(int64_t len) {
    char* r = (char*)avra_rc_alloc(8 + (size_t)len);
    *(int64_t*)r = len;
    return r;
}

static inline char* avra_bytes_data(const char* b) {
    return (char*)b + 8;
}

const char* avra_bytes_from_string(const char* s) {
    if (!s) {
        char* r = avra_bytes_alloc(0);
        return r;
    }
    size_t len = strlen(s);
    char* r = avra_bytes_alloc((int64_t)len);
    memcpy(avra_bytes_data(r), s, len);
    return r;
}

const char* avra_string_from_bytes(const char* b) {
    if (!b) return "";
    int64_t len = *(int64_t*)b;
    if (len < 0) len = 0;
    char* r = (char*)avra_rc_alloc((size_t)len + 1);
    memcpy(r, avra_bytes_data(b), (size_t)len);
    r[len] = '\0';
    return r;
}

int64_t avra_bytes_length(const char* b) {
    if (!b) return 0;
    return *(int64_t*)b;
}

int64_t avra_bytes_byte(const char* b, int64_t idx) {
    if (!b) return 0;
    int64_t len = *(int64_t*)b;
    if (idx < 0 || idx >= len) return 0;
    return (int64_t)(unsigned char)avra_bytes_data(b)[idx];
}

const char* avra_bytes_concat(const char* a, const char* b) {
    int64_t la = a ? *(int64_t*)a : 0;
    int64_t lb = b ? *(int64_t*)b : 0;
    char* r = avra_bytes_alloc(la + lb);
    if (la > 0) memcpy(avra_bytes_data(r), avra_bytes_data(a), (size_t)la);
    if (lb > 0) memcpy(avra_bytes_data(r) + la, avra_bytes_data(b), (size_t)lb);
    return r;
}

const char* avra_bytes_slice(const char* b, int64_t start, int64_t end) {
    if (!b) {
        char* r = avra_bytes_alloc(0);
        return r;
    }
    int64_t len = *(int64_t*)b;
    if (start < 0) start = 0;
    if (end < 0) end = 0;
    if (start > len) start = len;
    if (end > len) end = len;
    if (end < start) end = start;
    int64_t out = end - start;
    char* r = avra_bytes_alloc(out);
    if (out > 0) memcpy(avra_bytes_data(r), avra_bytes_data(b) + start, (size_t)out);
    return r;
}

const char* avra_bytes_empty(void) {
    return avra_bytes_alloc(0);
}

// ── Bytes builder primitives ──
//
// Writers for in-language binary serialization. `avra_bytes_make`
// allocates a fresh (uniquely-owned) buffer of the requested size,
// zero-initialized; `avra_bytes_set` mutates one octet of that
// buffer. The combination is the building block for length-prefixed
// records, fixed-size headers, and any little-endian / big-endian
// scalar encoding written in pure Avra. These are the minimum
// primitives that close the gap left by 73wa.

const char* avra_bytes_make(int64_t len) {
    if (len < 0) len = 0;
    char* r = avra_bytes_alloc(len);
    if (len > 0) memset(avra_bytes_data(r), 0, (size_t)len);
    return r;
}

void avra_bytes_set(const char* b, int64_t idx, int64_t val) {
    if (!b) return;
    int64_t len = *(int64_t*)b;
    if (idx < 0 || idx >= len) return;
    avra_bytes_data((char*)b)[idx] = (char)(unsigned char)(val & 0xFF);
}

const char* avra_bytes_to_hex(const char* b) {
    if (!b) return "";
    int64_t len = *(int64_t*)b;
    if (len < 0) len = 0;
    char* r = (char*)avra_rc_alloc((size_t)(len * 2) + 1);
    static const char hex[] = "0123456789abcdef";
    const unsigned char* data = (const unsigned char*)avra_bytes_data(b);
    for (int64_t i = 0; i < len; i++) {
        r[i * 2]     = hex[(data[i] >> 4) & 0xF];
        r[i * 2 + 1] = hex[data[i] & 0xF];
    }
    r[len * 2] = '\0';
    return r;
}

// ── SHA-256 ──
// Public-domain reference implementation. Used by the build system for
// fingerprint cache keys (see docs/spec_build_manifest.md and the
// build-system epic).
//
// PORT TO AVRA: this whole section should eventually live in
// @std/crypto written in pure Avra. Doing it here today because the
// language is missing sized unsigned ints (u32), wrapping arithmetic,
// and direct byte access on strings. See the language tickets filed
// under the in-language-crypto tracking issue.

static const uint32_t SHA256_K[64] = {
    0x428a2f98u, 0x71374491u, 0xb5c0fbcfu, 0xe9b5dba5u, 0x3956c25bu,
    0x59f111f1u, 0x923f82a4u, 0xab1c5ed5u, 0xd807aa98u, 0x12835b01u,
    0x243185beu, 0x550c7dc3u, 0x72be5d74u, 0x80deb1feu, 0x9bdc06a7u,
    0xc19bf174u, 0xe49b69c1u, 0xefbe4786u, 0x0fc19dc6u, 0x240ca1ccu,
    0x2de92c6fu, 0x4a7484aau, 0x5cb0a9dcu, 0x76f988dau, 0x983e5152u,
    0xa831c66du, 0xb00327c8u, 0xbf597fc7u, 0xc6e00bf3u, 0xd5a79147u,
    0x06ca6351u, 0x14292967u, 0x27b70a85u, 0x2e1b2138u, 0x4d2c6dfcu,
    0x53380d13u, 0x650a7354u, 0x766a0abbu, 0x81c2c92eu, 0x92722c85u,
    0xa2bfe8a1u, 0xa81a664bu, 0xc24b8b70u, 0xc76c51a3u, 0xd192e819u,
    0xd6990624u, 0xf40e3585u, 0x106aa070u, 0x19a4c116u, 0x1e376c08u,
    0x2748774cu, 0x34b0bcb5u, 0x391c0cb3u, 0x4ed8aa4au, 0x5b9cca4fu,
    0x682e6ff3u, 0x748f82eeu, 0x78a5636fu, 0x84c87814u, 0x8cc70208u,
    0x90befffau, 0xa4506cebu, 0xbef9a3f7u, 0xc67178f2u
};

static inline uint32_t sha256_rotr(uint32_t x, int n) {
    return (x >> n) | (x << (32 - n));
}

static void sha256_compress(uint32_t state[8], const uint8_t block[64]) {
    uint32_t w[64];
    for (int i = 0; i < 16; i++) {
        w[i] = ((uint32_t)block[i * 4] << 24)
             | ((uint32_t)block[i * 4 + 1] << 16)
             | ((uint32_t)block[i * 4 + 2] << 8)
             | (uint32_t)block[i * 4 + 3];
    }
    for (int i = 16; i < 64; i++) {
        uint32_t s0 = sha256_rotr(w[i - 15], 7) ^ sha256_rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
        uint32_t s1 = sha256_rotr(w[i - 2], 17) ^ sha256_rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
        w[i] = w[i - 16] + s0 + w[i - 7] + s1;
    }
    uint32_t a = state[0], b = state[1], c = state[2], d = state[3];
    uint32_t e = state[4], f = state[5], g = state[6], h = state[7];
    for (int i = 0; i < 64; i++) {
        uint32_t S1 = sha256_rotr(e, 6) ^ sha256_rotr(e, 11) ^ sha256_rotr(e, 25);
        uint32_t ch = (e & f) ^ (~e & g);
        uint32_t t1 = h + S1 + ch + SHA256_K[i] + w[i];
        uint32_t S0 = sha256_rotr(a, 2) ^ sha256_rotr(a, 13) ^ sha256_rotr(a, 22);
        uint32_t mj = (a & b) ^ (a & c) ^ (b & c);
        uint32_t t2 = S0 + mj;
        h = g; g = f; f = e; e = d + t1;
        d = c; c = b; b = a; a = t1 + t2;
    }
    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
}

// Hash `len` bytes at `data` and write 32 raw digest bytes into `out`.
static void sha256_raw(const uint8_t* data, size_t len, uint8_t out[32]) {
    uint32_t state[8] = {
        0x6a09e667u, 0xbb67ae85u, 0x3c6ef372u, 0xa54ff53au,
        0x510e527fu, 0x9b05688cu, 0x1f83d9abu, 0x5be0cd19u
    };
    uint64_t bitlen = (uint64_t)len * 8u;
    uint8_t block[64];
    size_t i = 0;
    while (len - i >= 64) {
        sha256_compress(state, data + i);
        i += 64;
    }
    size_t rem = len - i;
    memcpy(block, data + i, rem);
    block[rem] = 0x80;
    if (rem + 1 > 56) {
        memset(block + rem + 1, 0, 64 - rem - 1);
        sha256_compress(state, block);
        memset(block, 0, 56);
    } else {
        memset(block + rem + 1, 0, 56 - rem - 1);
    }
    for (int b8 = 0; b8 < 8; b8++) {
        block[56 + b8] = (uint8_t)(bitlen >> (56 - b8 * 8));
    }
    sha256_compress(state, block);
    for (int s = 0; s < 8; s++) {
        out[s * 4]     = (uint8_t)(state[s] >> 24);
        out[s * 4 + 1] = (uint8_t)(state[s] >> 16);
        out[s * 4 + 2] = (uint8_t)(state[s] >> 8);
        out[s * 4 + 3] = (uint8_t)state[s];
    }
}

// Avra-facing: SHA-256 a string (interpreted as raw bytes), return the
// lowercase 64-character hex digest. Caller owns the returned heap
// buffer.
const char* avra_sha256_hex(const char* s) {
    if (!s) s = "";
    uint8_t digest[32];
    sha256_raw((const uint8_t*)s, strlen(s), digest);
    char* out = (char*)malloc(65);
    static const char HEX[] = "0123456789abcdef";
    for (int i = 0; i < 32; i++) {
        out[i * 2]     = HEX[(digest[i] >> 4) & 0xf];
        out[i * 2 + 1] = HEX[digest[i] & 0xf];
    }
    out[64] = '\0';
    return out;
}

// Read mtime + size for a file. Returns 1 on success, 0 on miss.
// Used by the sha256_file sidecar memo below.
static int avra_stat_mtime_size(const char* path, long* mtime_out, long* size_out) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
    *mtime_out = (long)st.st_mtime;
    *size_out = (long)st.st_size;
    return 1;
}

// Sidecar path for `<path>` → `<path>.avra-sha256`. Same-dir colocation
// keeps invalidation trivial (delete the sidecar to force a recompute)
// and matches how rqwh's link-cache stamps siblings.
static int avra_sha256_sidecar_path(const char* path, char* out, size_t cap) {
    int n = snprintf(out, cap, "%s.avra-sha256", path);
    return (n > 0 && (size_t)n < cap);
}

// SHA-256 a file's contents. Returns the same 64-char lowercase hex
// digest as avra_sha256_hex, or the digest of empty input when the
// file is missing/unreadable. Streams the file in 64KB chunks so
// large inputs do not blow the heap.
//
// Sidecar memoization: when `<path>.avra-sha256` exists, contains a
// fresh "<mtime> <size>\n<hex>" envelope, and the recorded mtime+size
// match the current file, return the cached hex directly. Cuts the
// per-shard fingerprint cost from ~10-30ms (full sha256 of bs2 binary)
// to ~50µs (one stat() + one fread()). Wire-format is deliberately
// boring text so a human can `cat` it for debugging.
const char* avra_sha256_file_uncached(const char* path);

const char* avra_sha256_file(const char* path) {
    if (!path) path = "";
    long mtime = 0, size = 0;
    if (!avra_stat_mtime_size(path, &mtime, &size)) {
        return avra_sha256_file_uncached(path);
    }
    char sidecar[4096];
    if (!avra_sha256_sidecar_path(path, sidecar, sizeof(sidecar))) {
        return avra_sha256_file_uncached(path);
    }
    FILE* sf = fopen(sidecar, "r");
    if (sf) {
        long sm = 0, ss = 0;
        char hex[80] = {0};
        // "mtime size\nhex\n"
        if (fscanf(sf, "%ld %ld\n%64s", &sm, &ss, hex) == 3 && sm == mtime && ss == size && strlen(hex) == 64) {
            fclose(sf);
            char* out = (char*)malloc(65);
            memcpy(out, hex, 65);
            return out;
        }
        fclose(sf);
    }
    const char* hex = avra_sha256_file_uncached(path);
    FILE* wf = fopen(sidecar, "w");
    if (wf) {
        fprintf(wf, "%ld %ld\n%s\n", mtime, size, hex);
        fclose(wf);
    }
    return hex;
}

// 73r2: per-process in-memory memoization for package_source_fingerprint.
//
// The DISK sidecar (`.pkg-fp` in build/cache/) is unreliable: `find -newer`
// misses mtime ties (APFS second granularity), and the writer can record
// fp=X while the reader independently computes fp=Y because the source
// drifted between them. Meta files keyed on the OLD fp are then orphaned.
//
// This in-process cache stores (pkg_root → fp) for the lifetime of one
// bs2 invocation. Source files don't change mid-invocation, so the cache
// is automatically consistent. Cross-process callers each compute fresh
// — cheaper than the disk sidecar's correctness debt.
typedef struct PkgFpEntry {
    char* path;
    char* fp;
    struct PkgFpEntry* next;
} PkgFpEntry;
static PkgFpEntry* pkg_fp_cache_head = NULL;

const char* avra_pkg_fp_cache_get(const char* path) {
    if (!path) return "";
    for (PkgFpEntry* e = pkg_fp_cache_head; e; e = e->next) {
        if (strcmp(e->path, path) == 0) return e->fp;
    }
    return "";
}

void avra_pkg_fp_cache_set(const char* path, const char* fp) {
    if (!path || !fp) return;
    // Overwrite if already present.
    for (PkgFpEntry* e = pkg_fp_cache_head; e; e = e->next) {
        if (strcmp(e->path, path) == 0) {
            free(e->fp);
            e->fp = strdup(fp);
            return;
        }
    }
    PkgFpEntry* e = (PkgFpEntry*)malloc(sizeof(PkgFpEntry));
    e->path = strdup(path);
    e->fp = strdup(fp);
    e->next = pkg_fp_cache_head;
    pkg_fp_cache_head = e;
}

const char* avra_sha256_file_uncached(const char* path) {
    if (!path) path = "";
    FILE* f = fopen(path, "rb");
    if (!f) return avra_sha256_hex("");
    uint32_t state[8] = {
        0x6a09e667u, 0xbb67ae85u, 0x3c6ef372u, 0xa54ff53au,
        0x510e527fu, 0x9b05688cu, 0x1f83d9abu, 0x5be0cd19u
    };
    uint8_t buf[65536];
    uint8_t carry[64];
    size_t carry_len = 0;
    uint64_t total = 0;
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        total += n;
        size_t off = 0;
        if (carry_len > 0) {
            size_t need = 64 - carry_len;
            if (n >= need) {
                memcpy(carry + carry_len, buf, need);
                sha256_compress(state, carry);
                off = need;
                carry_len = 0;
            } else {
                memcpy(carry + carry_len, buf, n);
                carry_len += n;
                continue;
            }
        }
        while (n - off >= 64) {
            sha256_compress(state, buf + off);
            off += 64;
        }
        size_t rem = n - off;
        if (rem > 0) {
            memcpy(carry, buf + off, rem);
            carry_len = rem;
        }
    }
    fclose(f);
    uint64_t bitlen = total * 8u;
    uint8_t block[64];
    memcpy(block, carry, carry_len);
    block[carry_len] = 0x80;
    if (carry_len + 1 > 56) {
        memset(block + carry_len + 1, 0, 64 - carry_len - 1);
        sha256_compress(state, block);
        memset(block, 0, 56);
    } else {
        memset(block + carry_len + 1, 0, 56 - carry_len - 1);
    }
    for (int b8 = 0; b8 < 8; b8++) {
        block[56 + b8] = (uint8_t)(bitlen >> (56 - b8 * 8));
    }
    sha256_compress(state, block);
    char* out = (char*)malloc(65);
    static const char HEX[] = "0123456789abcdef";
    for (int s = 0; s < 8; s++) {
        uint32_t v = state[s];
        out[s * 8]     = HEX[(v >> 28) & 0xf];
        out[s * 8 + 1] = HEX[(v >> 24) & 0xf];
        out[s * 8 + 2] = HEX[(v >> 20) & 0xf];
        out[s * 8 + 3] = HEX[(v >> 16) & 0xf];
        out[s * 8 + 4] = HEX[(v >> 12) & 0xf];
        out[s * 8 + 5] = HEX[(v >> 8) & 0xf];
        out[s * 8 + 6] = HEX[(v >> 4) & 0xf];
        out[s * 8 + 7] = HEX[v & 0xf];
    }
    out[64] = '\0';
    return out;
}

// ── Validation ──
// Basic runtime validation: assert conditions, check non-null.
int64_t avra_validate_not_null(int64_t value, const char* name) {
    if (value == 0) {
        avra_runtime_errorf("%s must not be null", name);
        exit(1);
    }
    return value;
}

int64_t avra_validate_positive(int64_t value, const char* name) {
    if (value <= 0) {
        avra_runtime_errorf("%s must be positive, got %lld", name, (long long)value);
        exit(1);
    }
    return value;
}

int64_t avra_validate_range(int64_t value, int64_t min, int64_t max, const char* name) {
    if (value < min || value > max) {
        avra_runtime_errorf("%s must be between %lld and %lld, got %lld",
                name, (long long)min, (long long)max, (long long)value);
        exit(1);
    }
    return value;
}

int64_t avra_validate_not_empty(const char* s, const char* name) {
    if (!s || strlen(s) == 0) {
        avra_runtime_errorf("%s must not be empty", name);
        exit(1);
    }
    return (int64_t)(uintptr_t)s;
}

int64_t avra_parse_int(const char* s) {
    return (int64_t)atoll(s);
}

// ── Shell execution ──
const char* avra_shell_exec(const char* cmd) {
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

int64_t avra_shell_exec_status(const char* cmd) {
    int status = system(cmd);
    return (int64_t)((status >> 8) & 0xff);
}

// Forward declared so avra_capture_stdout (above) and the test
// capture API (below) share the same recursive mutex. Body lives in
// the spec-test section below.
extern pthread_mutex_t _capture_mutex;

// vez6.4szi: in-process stdout capture. Replaces fixture tests that
// fork bs2 to grep stdout. Redirects stdout to a tmpfile across the
// closure invocation, then reads the file back as a string. tmpfile
// chosen over pipe to avoid the 64KB buffer-fill deadlock when the
// closure produces more output than a pipe can hold without a reader.
//
// Thread safety: serialized via the recursive _capture_mutex so two
// spawned threads can't race on dup2(STDOUT_FILENO). Nested same-
// thread captures still work (recursive). Closure panics leak the
// redirect AND the mutex; production code shouldn't capture stdout
// this way.
const char* avra_capture_stdout(int64_t closure) {
    pthread_mutex_lock(&_capture_mutex);
    fflush(stdout);
    int saved = dup(STDOUT_FILENO);
    if (saved < 0) { pthread_mutex_unlock(&_capture_mutex); return ""; }
    FILE* tmp = tmpfile();
    if (!tmp) {
        close(saved);
        pthread_mutex_unlock(&_capture_mutex);
        return "";
    }
    if (dup2(fileno(tmp), STDOUT_FILENO) < 0) {
        fclose(tmp);
        close(saved);
        pthread_mutex_unlock(&_capture_mutex);
        return "";
    }

    avra_closure_call_0(closure);

    fflush(stdout);
    dup2(saved, STDOUT_FILENO);
    close(saved);

    if (fseek(tmp, 0, SEEK_END) != 0) { fclose(tmp); pthread_mutex_unlock(&_capture_mutex); return ""; }
    long len = ftell(tmp);
    if (len < 0) { fclose(tmp); pthread_mutex_unlock(&_capture_mutex); return ""; }
    if (fseek(tmp, 0, SEEK_SET) != 0) { fclose(tmp); pthread_mutex_unlock(&_capture_mutex); return ""; }

    char* buf = (char*)malloc((size_t)len + 1);
    if (!buf) { fclose(tmp); pthread_mutex_unlock(&_capture_mutex); return ""; }
    size_t n = fread(buf, 1, (size_t)len, tmp);
    buf[n] = '\0';
    fclose(tmp);
    pthread_mutex_unlock(&_capture_mutex);
    return buf;
}

// Stdout TTY check — gates the build progress bar so CI logs (which
// pipe stdout) don't get polluted with \r-rewriting escape codes.
// 1 if interactive, 0 if pipe/file. Mirrors POSIX isatty(STDOUT_FILENO).
int64_t avra_isatty_stdout(void) {
    return isatty(STDOUT_FILENO) ? 1 : 0;
}

// Coarse-grained sleep, used by the progress-bar poll loop to render
// at ~10Hz without busy-waiting. Negative or zero is a no-op.
void avra_sleep_ms(int64_t ms) {
    if (ms <= 0) return;
    struct timespec ts;
    ts.tv_sec = ms / 1000;
    ts.tv_nsec = (ms % 1000) * 1000000;
    nanosleep(&ts, NULL);
}

// ── Process management (@std/process port) ──
// Full port of the Rust std-process package. Provides:
// - avra_process_run: synchronous exec with stdout/stderr capture + timeout
// - avra_process_spawn/wait/kill: async process management
// - avra_process_read_line: line-by-line stdout streaming
// - avra_process_forward: passthrough (inherited stdio)
// - avra_process_pipe: stdin piping
// - avra_process_env_get/args/self_dir: environment utilities

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
    // Cached exit code so a wait() following an is_alive() that
    // already reaped the child via WNOHANG can still return the
    // real status. Without this, wait()'s second waitpid() finds
    // no zombie and returns -1, silently losing the exit code
    // (e20h: pool_extract_rc was always seeing -1 on workers
    // that completed between is_alive polls). Initialised to
    // INT_MIN as a sentinel for "not yet reaped".
    int cached_exit_code;
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
    process_registry[slot].cached_exit_code = INT_MIN;
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
const char* avra_process_run(const char* cmd, const char* args_json, const char* opts_json) {
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
int64_t avra_process_spawn_bg(const char* cmd, const char* args_json, const char* opts_json) {
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
int64_t avra_process_kill(int64_t handle) {
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
/// When avra_process_is_alive already reaped the child, prefer the
/// cached exit code (the second waitpid would otherwise return -1
/// because the zombie has been collected and we'd lose the real
/// status). cached_exit_code is INT_MIN until is_alive's WNOHANG
/// reap fires; if still INT_MIN here, do the canonical blocking
/// waitpid as before.
const char* avra_process_wait(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e) return make_result_json("", "process not found", -1);
    char* out_str = read_fd_all(e->stdout_fd);
    char* err_str = read_fd_all(e->stderr_fd);
    close(e->stdout_fd);
    close(e->stderr_fd);
    int code;
    if (e->cached_exit_code != INT_MIN) {
        code = e->cached_exit_code;
    } else {
        int status;
        waitpid(e->pid, &status, 0);
        code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    }
    registry_remove(handle);
    const char* result = make_result_json(out_str, err_str, code);
    free(out_str); free(err_str);
    return result;
}

/// Read a line from a spawned process's stdout. Returns "\0EOF" at end.
const char* avra_process_read_line(int64_t handle) {
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
int64_t avra_process_wait_for_output(int64_t handle, const char* pattern, int64_t timeout_ms) {
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
/// When the child is reaped here, cache its exit code so a follow-up
/// avra_process_wait() can still return the real status (otherwise
/// the second waitpid would find no zombie and the code would
/// silently come back as -1 — broke pool_extract_rc on completed
/// workers in e20h's worker pool).
int64_t avra_process_is_alive(int64_t handle) {
    ProcessEntry* e = registry_get(handle);
    if (!e || !e->alive) return 0;
    int status;
    pid_t result = waitpid(e->pid, &status, WNOHANG);
    if (result == 0) return 1; // still running
    e->alive = 0;
    e->cached_exit_code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    return 0;
}

/// Execute with inherited stdio (passthrough). Returns exit code.
int64_t avra_process_forward(const char* cmd, const char* args_json, const char* opts_json) {
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
const char* avra_process_pipe(const char* input, const char* cmd, const char* args_json) {
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
const char* avra_process_env_get(const char* key) {
    const char* val = getenv(key);
    if (!val) return "\0NULL";
    // Return a copy
    size_t len = strlen(val);
    char* copy = (char*)malloc(len + 1);
    memcpy(copy, val, len + 1);
    return copy;
}

// Unset an environment variable for THIS process. Used by the test
// runner before forking the test binary so its shell-outs to bs2
// don't inherit AVRA_USE_METADATA / AVRA_LIB_OBJS / AVRA_LIB_PKG_ROOT
// — those are scoped to the shard's compile, not to any subsequent
// runtime sub-invocations the test makes.
void avra_process_env_unset(const char* key) {
    unsetenv(key);
}

/// Get the directory containing the current executable.
const char* avra_process_self_dir(void) {
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
// The vtable is a AvraArray of function pointers (closure arrays).
// vtable[i] = closure array for the i-th trait method.
// Method dispatch: load vtable[method_index], call with concrete_value as self.

void* avra_trait_object_new(int64_t value, void* vtable) {
    int64_t* obj = (int64_t*)avra_rc_alloc(16);
    obj[0] = value;
    obj[1] = (int64_t)(uintptr_t)vtable;
    return obj;
}

int64_t avra_trait_object_value(void* obj) {
    return ((int64_t*)obj)[0];
}

void* avra_trait_object_vtable(void* obj) {
    return (void*)(uintptr_t)((int64_t*)obj)[1];
}

// ── Codegen counters ──
// Monotonic counters for unique name generation during codegen.
// Kept in C to avoid mutable globals in Avra source.
static int64_t g_lambda_counter = 0;
int64_t avra_next_lambda_id(void) { return g_lambda_counter++; }

// ── Error trace support ──
// Format a source location as "file:line" string for error traces.
const char* avra_format_location(const char* file, int64_t line) {
    char buf[512];
    snprintf(buf, sizeof(buf), "%s:%lld", file ? file : "<unknown>", (long long)line);
    size_t len = strlen(buf);
    char* result = (char*)avra_rc_alloc(len + 1);
    memcpy(result, buf, len + 1);
    return result;
}

// Forward declare capture state (used by test flush + capture).
// Recursive so a thread can do nested avra_capture_stdout(closure)
// calls (the spec/given/then capture_stdout_test exercises this).
// Across threads it serializes — only one capture window at a time;
// other threads block at the lock boundary rather than leaking their
// stdout into the capturing thread's tmpfile.
// Defined non-static so avra_capture_stdout (forward-declared above)
// shares the same mutex.
pthread_mutex_t _capture_mutex;
static int _capture_fd_backup = -1;

__attribute__((constructor))
static void _capture_mutex_init(void) {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&_capture_mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

// ── Spec test runtime: state primitives ──
// Rendering moved to Avra (features/spec_test/reporter.av) — this
// file only owns thread-safe counters + a failure-record linked list
// + capture machinery. Everything user-visible (PASS/FAIL lines, the
// failures summary, exit code) is rendered Avra-side via the
// diagnostics framework.
//
// TODO(forge-crafting-intepreters-3uy9): once Avra has a typed
// `Mutex<T>` / `OnceCell<T>` singleton primitive, move the failure
// list and counters into an Avra `Mutex<TestReporter>` and delete
// every `avra_test_*` symbol below except the capture machinery.
// The current C primitives exist only because Avra forbids mut
// globals (rule 17) and singletons need somewhere to live — same
// pragmatic split Rust uses for the panic hook / global allocator.

#include <stdatomic.h>

static _Atomic int64_t avra_test_pass_count = 0;
static _Atomic int64_t avra_test_fail_count = 0;

// ── Append-only record store ──────────────────────────────────────
// The test reporter holds two heterogeneous record streams: failed
// assertions and crashed specs. Both follow the SAME shape — a
// linked list with O(1) append + O(idx) random access via getters,
// guarded by a mutex against concurrent test execution, with an
// atomic count so the reporter's reader-side reads don't need to
// take the lock. The only thing that differs is the payload struct.
//
// `AvraRecordList` factors the head/tail/count/mutex bookkeeping
// out of every per-record store; each payload type then declares a
// `static AvraRecordList _foo = AVRA_RECORD_LIST_INIT;` and uses
// `record_list_append` + `record_list_at`. Failures and crashes both
// use this — see below.

typedef struct AvraRecordNode {
    void* payload;
    struct AvraRecordNode* next;
} AvraRecordNode;

typedef struct AvraRecordList {
    AvraRecordNode* head;
    AvraRecordNode* tail;
    _Atomic int64_t count;
    pthread_mutex_t mutex;
    // jbkk: amortised-O(1) random access. The reporter walks each
    // record N times (one per field getter) at summary time; a naive
    // linked-list walk per call is O(N²). We cache the (idx, node)
    // pair of the last read — sequential walks (`for i in 0..count`)
    // hit the cache every iteration and degrade to O(N) total.
    // Append-only data, so the cache only ever needs to advance
    // forward; resets when an entry is overwritten (never today).
    AvraRecordNode* cache_node;
    int64_t         cache_idx;
} AvraRecordList;

#define AVRA_RECORD_LIST_INIT { NULL, NULL, 0, PTHREAD_MUTEX_INITIALIZER, NULL, -1 }

static void record_list_append(AvraRecordList* list, void* payload) {
    AvraRecordNode* node = (AvraRecordNode*)malloc(sizeof(AvraRecordNode));
    node->payload = payload;
    node->next = NULL;
    pthread_mutex_lock(&list->mutex);
    if (list->tail) list->tail->next = node;
    else list->head = node;
    list->tail = node;
    atomic_fetch_add(&list->count, 1);
    pthread_mutex_unlock(&list->mutex);
}

// Index into the linked list with a one-slot positional cache.
// Sequential access (idx N+1 after idx N) is O(1). Random access
// stays O(idx) — same as the naive walk — but only pays the full
// walk once per index, not once per field-getter call.
//
// The cache is updated unconditionally on lookup; concurrent
// readers tolerate the race (worst case: a stale cache forces an
// extra walk on one call, then the cache is refreshed). The
// reporter is single-threaded at summary time anyway.
static void* record_list_at(AvraRecordList* list, int64_t idx) {
    AvraRecordNode* node;
    int64_t start;
    if (list->cache_node != NULL && idx >= list->cache_idx) {
        node = list->cache_node;
        start = list->cache_idx;
    } else {
        node = list->head;
        start = 0;
    }
    while (node && start < idx) { node = node->next; start++; }
    if (node) {
        list->cache_node = node;
        list->cache_idx = idx;
        return node->payload;
    }
    return NULL;
}

// One failed assertion's metadata. Strings are rc-allocated copies
// so they survive past the call site (the Avra reporter reads them
// at summary time).
typedef struct AvraTestFailure {
    const char* spec;
    const char* given;
    const char* then_name;
    const char* file;
    int64_t line;
} AvraTestFailure;

static AvraRecordList _failures = AVRA_RECORD_LIST_INIT;

// Simple rc-allocated string copy — outlives the C call so the Avra
// reporter can read it later. Re-uses avra_rc_alloc so refcount works.
static const char* test_str_dup(const char* s) {
    if (!s) return "";
    size_t len = strlen(s);
    char* out = (char*)avra_rc_alloc(len + 1);
    memcpy(out, s, len + 1);
    return out;
}

void avra_test_pass_inc(void) {
    atomic_fetch_add(&avra_test_pass_count, 1);
}

void avra_test_fail_inc(void) {
    atomic_fetch_add(&avra_test_fail_count, 1);
}

int64_t avra_test_get_pass(void) {
    return atomic_load(&avra_test_pass_count);
}

int64_t avra_test_get_fail(void) {
    return atomic_load(&avra_test_fail_count);
}

void avra_test_record_failure(const char* spec, const char* given,
                              const char* then_name, const char* file,
                              int64_t line) {
    AvraTestFailure* f = (AvraTestFailure*)malloc(sizeof(AvraTestFailure));
    f->spec = test_str_dup(spec);
    f->given = test_str_dup(given);
    f->then_name = test_str_dup(then_name);
    f->file = test_str_dup(file);
    f->line = line;
    record_list_append(&_failures, f);
}

int64_t avra_test_failure_count(void) {
    return atomic_load(&_failures.count);
}

// Per-field getter macro — every Avra-side getter follows the
// `lookup → null guard → return field-or-default` pattern. Parametric
// over the record struct type AND the list global so failures, crashes,
// and any future record stream share one boilerplate-collapser.
#define AVRA_RECORD_FIELD(StructT, list, field, default_) do { \
        StructT* r = (StructT*)record_list_at(&(list), idx); \
        return r ? r->field : (default_); \
    } while (0)

const char* avra_test_failure_spec (int64_t idx) { AVRA_RECORD_FIELD(AvraTestFailure, _failures, spec,      ""); }
const char* avra_test_failure_given(int64_t idx) { AVRA_RECORD_FIELD(AvraTestFailure, _failures, given,     ""); }
const char* avra_test_failure_then (int64_t idx) { AVRA_RECORD_FIELD(AvraTestFailure, _failures, then_name, ""); }
const char* avra_test_failure_file (int64_t idx) { AVRA_RECORD_FIELD(AvraTestFailure, _failures, file,      ""); }
int64_t     avra_test_failure_line (int64_t idx) { AVRA_RECORD_FIELD(AvraTestFailure, _failures, line,       0); }

// Current spec/given "context" — set by the codegen-emitted
// `test_render_spec_start` / `test_render_given_start` calls so
// the next `test_render_then` knows which spec/given it belongs
// to without threading state through every assertion. Single-
// threaded test execution today; if parallel test runners land
// these become per-thread or per-context refs.
static const char* _current_spec = "";
static const char* _current_given = "";

void avra_test_set_current_spec(const char* name) {
    _current_spec = test_str_dup(name);
}

void avra_test_set_current_given(const char* name) {
    _current_given = test_str_dup(name);
}

const char* avra_test_get_current_spec(void) { return _current_spec; }
const char* avra_test_get_current_given(void) { return _current_given; }

int64_t avra_test_roughly(double actual, double expected, double tolerance) {
    double diff = actual - expected;
    if (diff < 0) diff = -diff;
    return diff <= tolerance ? 1 : 0;
}

// ── Per-spec crash isolation (hkms.3) ──
// Each top-level spec block in a test bundle is wrapped by the test
// runner's AST transform as `avra_test_run_spec_guarded(name, file,
// line, () -> { ...body... })`. We sigsetjmp around the closure
// invocation; the modified signal handler siglongjmps back here on
// fatal crashes. The runner records the crash with full attribution
// and returns so the next spec block runs.

typedef struct AvraTestCrash {
    const char* spec;
    const char* file;
    int64_t line;
    int64_t signal;
} AvraTestCrash;

static AvraRecordList _crashes = AVRA_RECORD_LIST_INIT;

// Per-signal label buffer pool — one slot per supported signal so the
// "SIGNAME (description)" string returned by `avra_signal_label` has
// a stable storage location. The reporter holds the pointer past the
// call (via `record_list_at(&_crashes, ...)`) so a thread-local stack
// buffer would dangle.
static char _signal_label_buf[NSIG][48] = {{0}};

// Render "SIGNAME (description)" for the spec-guard crash record.
// Composes the parts from the same source-of-truth `avra_signal_*`
// helpers the unguarded signal handler uses. Idempotent — first call
// per signal populates the buffer, subsequent calls re-use it.
static const char* avra_signal_label(int sig) {
    if (sig < 0 || sig >= NSIG) return "unknown signal";
    if (_signal_label_buf[sig][0] == '\0') {
        snprintf(_signal_label_buf[sig], sizeof(_signal_label_buf[sig]),
                 "%s (%s)", avra_signal_short_name(sig), avra_signal_description(sig));
    }
    return _signal_label_buf[sig];
}

void avra_test_record_crash(const char* spec, const char* file,
                            int64_t line, int64_t signal) {
    AvraTestCrash* c = (AvraTestCrash*)malloc(sizeof(AvraTestCrash));
    c->spec = test_str_dup(spec);
    c->file = test_str_dup(file);
    c->line = line;
    c->signal = signal;
    record_list_append(&_crashes, c);
}

int64_t avra_test_crash_count(void) {
    return atomic_load(&_crashes.count);
}

// Hook for tests that DELIBERATELY crash a spec to exercise the
// guard (e.g. spec_test/tests/crash_isolation_test.av). Decrements
// the live count so the reporter's exit code stays green AND the
// "Crashed specs:" section stops walking — the linked list entry
// is left in place so prior introspection (avra_test_crash_spec etc.)
// can still see what was recorded before the ack.
void avra_test_ack_expected_crash(void) {
    atomic_fetch_sub(&_crashes.count, 1);
}

const char* avra_test_crash_spec  (int64_t idx) { AVRA_RECORD_FIELD(AvraTestCrash, _crashes, spec,   ""); }
const char* avra_test_crash_file  (int64_t idx) { AVRA_RECORD_FIELD(AvraTestCrash, _crashes, file,   ""); }
int64_t     avra_test_crash_line  (int64_t idx) { AVRA_RECORD_FIELD(AvraTestCrash, _crashes, line,    0); }
int64_t     avra_test_crash_signal(int64_t idx) { AVRA_RECORD_FIELD(AvraTestCrash, _crashes, signal,  0); }

const char* avra_test_crash_signal_name(int64_t idx) {
    AvraTestCrash* c = (AvraTestCrash*)record_list_at(&_crashes, idx);
    return c ? avra_signal_label((int)c->signal) : "";
}

#undef AVRA_RECORD_FIELD

// Testing helper for the spec-guard mechanism itself: raise a
// process-wide signal that the guard is supposed to catch. Avra has
// no built-in "force a crash" primitive (raw memory ops are gated by
// the language), so we expose `raise(signal)` under a name that
// makes its intent obvious. Only used inside `*_test.av` files —
// production code has no reason to call it.
int64_t avra_test_raise_signal(int64_t sig) {
    raise((int)sig);
    return 0;
}

// Single-call bytes serializer for the @marshal-compatible
// TestResults wire format. Replaces a 4-deep nested
// `avra_bytes_concat(...)` chain in reporter.av — one alloc + one
// pass of memcpy here vs five small allocs through the per-int
// concat path. Wire layout must stay in sync with
// `cli/main.av :: TestResults` (5 × i64 little-endian).
const char* avra_test_summary_to_bytes(int64_t pass, int64_t fail,
                                       int64_t total, int64_t elapsed_ms,
                                       int64_t crashes) {
    char* r = avra_bytes_alloc(40);
    int64_t* d = (int64_t*)avra_bytes_data(r);
    d[0] = pass;
    d[1] = fail;
    d[2] = total;
    d[3] = elapsed_ms;
    d[4] = crashes;
    return r;
}

// Invoke a no-arg Avra closure under a sigsetjmp guard. Returns 0 on
// success, the signal number on crash (in which case the crash is
// already recorded via `avra_test_record_crash` and a one-liner has
// been printed to stdout). The closure pointer is the standard Avra
// callable layout — `avra_closure_call_0` handles fn-ptr extraction
// and the captures convention.
//
// Output channel note: stdout (same stream as `test_render_*` /
// `println`) so the per-spec header / given / crash lines land in
// source order. Stderr would interleave randomly when the shard's
// combined stdio is captured by the orchestrator.
int64_t avra_test_run_spec_guarded(const char* name, const char* file,
                                   int64_t line, int64_t closure) {
    int sig = sigsetjmp(_spec_guard_jmp, 1);
    if (sig == 0) {
        _spec_guard_active = 1;
        avra_closure_call_0(closure);
        _spec_guard_active = 0;
        return 0;
    }
    _spec_guard_active = 0;
    avra_test_record_crash(name, file, line, sig);
    printf("    \x1b[31m✗ SPEC CRASHED\x1b[0m %s \x1b[2m(at %s:%lld — %s)\x1b[0m\n",
           name ? name : "<unknown>",
           file ? file : "<unknown>",
           (long long)line,
           avra_signal_label(sig));
    fflush(stdout);
    return sig;
}

// ── Backward-compat shims ──
// Older test binaries (and the seed) call these — keep them as
// thin wrappers around the new primitives so the seed continues
// to compile until it cycles forward. Once the seed is updated,
// these can be deleted.

void avra_test_flush(void) { /* no-op: rendering moved to Avra */ }
void avra_test_start_spec(const char* name) { (void)name; }
void avra_test_end_spec(void) { }
void avra_test_start_given(const char* name) { (void)name; }
void avra_test_end_given(void) { }

void avra_test_run_then(const char* name, int64_t result) {
    (void)name;
    if (result) avra_test_pass_inc();
    else avra_test_fail_inc();
}

void avra_test_skip(const char* name) { (void)name; }
void avra_test_todo(const char* name) { (void)name; }

// Legacy entry — main() in old test bundles calls this. New bundles
// route through the Avra reporter's `test_render_summary`. Kept here
// so seed cycle stays buildable.
int64_t avra_test_summary(void) {
    int64_t pass = atomic_load(&avra_test_pass_count);
    int64_t fail = atomic_load(&avra_test_fail_count);
    int64_t total = pass + fail;
    if (total == 0) return 0;
    printf("\n%lld/%lld tests passed", pass, total);
    if (fail > 0) printf(" (%lld failed)", fail);
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

void avra_test_capture_start(void) {
    // Flush our own output buffer before capturing
    avra_test_flush();
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

const char* avra_test_capture_stop(void) {
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
// Thread spawning via pthreads. spawn takes a closure (AvraArray)
// and runs it in a new thread. Returns a task handle for .await.

typedef struct {
    pthread_t thread;
    int64_t closure;
    int64_t result;     // captured return value from closure
    int joined;         // set to 1 after pthread_join (prevents double-join)
} AvraTask;

static void* avra_thread_entry(void* arg) {
    AvraTask* task = (AvraTask*)arg;
    task->result = avra_closure_call_0(task->closure);
    return NULL;
}

// Spawn a closure in a new thread. Returns a task handle (ptr to AvraTask).
int64_t avra_spawn(int64_t closure) {
    AvraTask* task = (AvraTask*)malloc(sizeof(AvraTask));
    task->closure = closure;
    task->result = 0;
    task->joined = 0;
    pthread_create(&task->thread, NULL, avra_thread_entry, task);
    return (int64_t)(uintptr_t)task;
}

// Wait for a spawned task to finish and return its result value.
// Does NOT free the task — the task group frees all tasks at scope exit.
// When no task group is active (legacy usage), caller is responsible.
int64_t avra_task_await(int64_t handle) {
    AvraTask* task = (AvraTask*)(uintptr_t)handle;
    if (!task->joined) {
        pthread_join(task->thread, NULL);
        task->joined = 1;
    }
    return task->result;
}

// Cancel a spawned task. Sends SIGCANCEL (pthread_cancel) then joins.
// Returns 0 on success, -1 if already joined.
int64_t avra_task_cancel(int64_t handle) {
    AvraTask* task = (AvraTask*)(uintptr_t)handle;
    if (task->joined) return -1;
    pthread_cancel(task->thread);
    pthread_join(task->thread, NULL);
    task->joined = 1;
    return 0;
}

// ── Process isolation ──
// `isolated_run(body)`: run a zero-arg closure that produces bytes
// in a forked subprocess; return a status-framed bytes payload so
// the parent can distinguish "ok with empty data" from "child
// crashed". The child inherits parent memory via copy-on-write, so
// closure captures travel for free — only the return value crosses
// the IPC boundary.
//
// Wire format the parent hands back to Avra-land:
//
//     [i64 status][i64 payload_len][payload_len bytes of data]
//
// status:
//   0 = OK            (payload follows)
//   1 = CRASH         (signal / non-zero exit; no payload)
//   2 = FORK_FAILED   (fork(2) returned -1)
//   3 = PIPE_FAILED   (pipe / short read; no payload)
//
// The stdlib wraps this into `Result<T, IsolatedError>` so callers
// never see the framing or have to reason about sentinel values.

#define AVRA_ISOLATED_STATUS_OK           0
#define AVRA_ISOLATED_STATUS_CRASH        1
#define AVRA_ISOLATED_STATUS_FORK_FAILED  2
#define AVRA_ISOLATED_STATUS_PIPE_FAILED  3

// Sanity cap on the child's declared payload length. Larger than
// any realistic stdout/result blob; smaller than what would let a
// corrupted header trigger gigabyte allocations.
#define AVRA_ISOLATED_PAYLOAD_CAP ((int64_t)1 << 30)

// Build a [status][len=0][] frame for an early failure path.
static const char* avra_isolated_frame_err(int64_t status) {
    char* r = avra_bytes_alloc(16);
    char* d = avra_bytes_data(r);
    int64_t s = status;
    int64_t z = 0;
    memcpy(d, &s, 8);
    memcpy(d + 8, &z, 8);
    return r;
}

// ── Bytes ↔ int marshaling primitives ──
//
// Pure-i64 little-endian encode/decode used by the stdlib's
// `isolated_int` and `isolated_string` wrappers (and any caller
// hand-rolling a marshaler until `@marshal` lands). The runtime
// owns this because Avra has no bit-shift over the bytes layer
// today — a pure-Avra impl would burn 8 byte() reads + shifts per
// int. Native is one memcpy.

const char* avra_int_to_bytes_le(int64_t n) {
    char* r = avra_bytes_alloc(8);
    memcpy(avra_bytes_data(r), &n, 8);
    return r;
}

int64_t avra_bytes_to_int_le(const char* b, int64_t offset) {
    if (!b) return 0;
    int64_t len = *(int64_t*)b;
    if (offset < 0 || offset + 8 > len) return 0;
    int64_t v = 0;
    memcpy(&v, avra_bytes_data((char*)b) + offset, 8);
    return v;
}

// Float (IEEE-754 double) encode/decode. Avra's `float` is f64 so
// the wire format is 8 raw bytes — same shape as the int variant.
// Endianness matches the host; we don't bswap because subprocess
// and parent are the same arch (fork() can't cross machines).

const char* avra_float_to_bytes_le(double f) {
    char* r = avra_bytes_alloc(8);
    memcpy(avra_bytes_data(r), &f, 8);
    return r;
}

double avra_bytes_to_float_le(const char* b, int64_t offset) {
    if (!b) return 0.0;
    int64_t len = *(int64_t*)b;
    if (offset < 0 || offset + 8 > len) return 0.0;
    double v = 0.0;
    memcpy(&v, avra_bytes_data((char*)b) + offset, 8);
    return v;
}

const char* avra_isolated_run(int64_t closure) {
    int pipefd[2];
    if (pipe(pipefd) != 0) return avra_isolated_frame_err(AVRA_ISOLATED_STATUS_PIPE_FAILED);

    pid_t pid = fork();
    if (pid < 0) {
        close(pipefd[0]);
        close(pipefd[1]);
        return avra_isolated_frame_err(AVRA_ISOLATED_STATUS_FORK_FAILED);
    }

    if (pid == 0) {
        // Child: closure returns a bytes header ptr. Pipe out the
        // length then the payload, exit cleanly. Any crash here is
        // caught by the parent's waitpid status check.
        close(pipefd[0]);
        int64_t result = avra_closure_call_0(closure);
        const char* b = (const char*)(uintptr_t)result;
        int64_t len = b ? *(int64_t*)b : 0;
        ssize_t hn = write(pipefd[1], &len, sizeof(len));
        ssize_t dn = 0;
        if (hn == sizeof(len) && len > 0) {
            dn = write(pipefd[1], avra_bytes_data((char*)b), (size_t)len);
        }
        close(pipefd[1]);
        _exit((hn == sizeof(len) && dn == len) ? 0 : 1);
    }

    // Parent: read length header, allocate the receiving bytes,
    // drain the data. waitpid LAST so a child writing more than
    // PIPE_BUF can't deadlock on a full pipe.
    close(pipefd[1]);
    int64_t len = 0;
    ssize_t hn = read(pipefd[0], &len, sizeof(len));
    int header_ok = (hn == (ssize_t)sizeof(len) && len >= 0 && len <= AVRA_ISOLATED_PAYLOAD_CAP);

    // Drain payload into a scratch buffer (when the header was
    // valid) so we can surface the right status after seeing the
    // child's exit code: a short read on a crashed child is a
    // crash, not a pipe failure.
    char* scratch = (header_ok && len > 0) ? (char*)malloc((size_t)len) : NULL;
    int short_read = 0;
    if (header_ok && len > 0) {
        int64_t got = 0;
        while (got < len) {
            ssize_t m = read(pipefd[0], scratch + got, (size_t)(len - got));
            if (m <= 0) { short_read = 1; break; }
            got += m;
        }
    }
    close(pipefd[0]);

    int status = 0;
    int64_t wstat = (waitpid(pid, &status, 0) < 0) ? -1 : 0;
    int crashed = (wstat < 0) || !WIFEXITED(status) || WEXITSTATUS(status) != 0;

    // Order matters: a crashed child often produces a missing
    // header or short read, but the *cause* is the crash. Report
    // that first so callers don't see `PipeFailed` when the truth
    // is `Crashed`.
    if (crashed) {
        if (scratch) free(scratch);
        return avra_isolated_frame_err(AVRA_ISOLATED_STATUS_CRASH);
    }
    if (!header_ok || short_read) {
        if (scratch) free(scratch);
        return avra_isolated_frame_err(AVRA_ISOLATED_STATUS_PIPE_FAILED);
    }

    // Success: emit [status=OK][len][payload].
    char* framed = avra_bytes_alloc(16 + len);
    char* d = avra_bytes_data(framed);
    int64_t s = AVRA_ISOLATED_STATUS_OK;
    memcpy(d, &s, 8);
    memcpy(d + 8, &len, 8);
    if (len > 0) memcpy(d + 16, scratch, (size_t)len);
    if (scratch) free(scratch);
    return framed;
}

// Legacy join — kept for backward compat with existing tests.
// Does NOT free the task — the task group handles cleanup.
void avra_thread_join(int64_t handle) {
    AvraTask* task = (AvraTask*)(uintptr_t)handle;
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
} AvraTaskGroup;

void* avra_task_group_new(void) {
    AvraTaskGroup* g = (AvraTaskGroup*)malloc(sizeof(AvraTaskGroup));
    g->capacity = 8;
    g->count = 0;
    g->handles = (int64_t*)malloc(g->capacity * sizeof(int64_t));
    return g;
}

void avra_task_group_add(void* group, int64_t handle) {
    AvraTaskGroup* g = (AvraTaskGroup*)group;
    if (g->count >= g->capacity) {
        g->capacity *= 2;
        g->handles = (int64_t*)realloc(g->handles, g->capacity * sizeof(int64_t));
    }
    g->handles[g->count++] = handle;
}

void avra_task_group_await_all(void* group) {
    AvraTaskGroup* g = (AvraTaskGroup*)group;
    for (int i = 0; i < g->count; i++) {
        AvraTask* task = (AvraTask*)(uintptr_t)g->handles[i];
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
void avra_yield(void) {
    // v1.0: no-op — real cooperative scheduling comes later
}

// Run the scheduler until all tasks complete. No-op in v1.0
// because tasks are OS threads that run to completion.
void avra_scheduler_run(void) {
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
} AvraChannel;

void* avra_channel_new(void) {
    AvraChannel* ch = (AvraChannel*)calloc(1, sizeof(AvraChannel));
    pthread_mutex_init(&ch->mutex, NULL);
    pthread_cond_init(&ch->send_cond, NULL);
    pthread_cond_init(&ch->recv_cond, NULL);
    return ch;
}

void avra_channel_send(void* channel, int64_t value) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_lock(&ch->mutex);
    while (ch->has_value) {
        pthread_cond_wait(&ch->send_cond, &ch->mutex);
    }
    ch->value = value;
    ch->has_value = 1;
    pthread_cond_signal(&ch->recv_cond);
    pthread_mutex_unlock(&ch->mutex);
}

int64_t avra_channel_recv(void* channel) {
    AvraChannel* ch = (AvraChannel*)channel;
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
// channels is a AvraArray of channel pointers.
// Returns: (index << 32) | (value & 0xFFFFFFFF) packed into i64.
// Better approach: write index + value to out params.
typedef struct {
    int64_t index;  // which channel fired
    int64_t value;  // the received value
} AvraSelectResult;

// Polls channels in round-robin until one has data.
// Returns pointer to heap-allocated AvraSelectResult.
void* avra_select(void* channel_array, int64_t count) {
    AvraSelectResult* result = (AvraSelectResult*)malloc(sizeof(AvraSelectResult));
    AvraArray* arr = (AvraArray*)(uintptr_t)channel_array;
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
            AvraChannel* ch = (AvraChannel*)(uintptr_t)arr->data[i];
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

int64_t avra_select_index(void* result) {
    AvraSelectResult* r = (AvraSelectResult*)result;
    return r->index;
}

int64_t avra_select_value(void* result) {
    AvraSelectResult* r = (AvraSelectResult*)result;
    return r->value;
}

// Run an array of closures in parallel threads, join all before returning.
void avra_parallel_run(void* closure_array) {
    AvraArray* arr = (AvraArray*)(uintptr_t)closure_array;
    if (!arr || arr->len == 0) return;
    int64_t n = arr->len;
    pthread_t* threads = (pthread_t*)malloc(n * sizeof(pthread_t));
    AvraTask** args = (AvraTask**)malloc(n * sizeof(AvraTask*));
    for (int64_t i = 0; i < n; i++) {
        args[i] = (AvraTask*)malloc(sizeof(AvraTask));
        args[i]->closure = arr->data[i];
        args[i]->result = 0;
        pthread_create(&threads[i], NULL, avra_thread_entry, args[i]);
    }
    for (int64_t i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }
    free(threads);
    free(args);
}

void avra_channel_close(void* channel) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_destroy(&ch->mutex);
    pthread_cond_destroy(&ch->send_cond);
    pthread_cond_destroy(&ch->recv_cond);
    free(ch);
}

// ── Debug: enum tag validation ──
//
// Call before matching on an enum to catch corrupt tags early with a
// clear error instead of segfaulting in the generated switch dispatch.
// Usage from Forge: avra_validate_tag(expr, 35, "Expr")
//   - ptr: pointer to the enum value
//   - max_tag: highest valid tag number for this enum type
//   - type_name: name for the error message
void avra_validate_tag(void *ptr, int64_t max_tag, const char *type_name) {
    if (!ptr) {
        avra_runtime_errorf("null %s pointer passed to match", type_name);
        exit(99);
    }
    uint8_t tag = *(uint8_t *)ptr;
    if (tag > max_tag) {
        avra_runtime_errorf("%s tag %d exceeds max %lld (ptr=%p)",
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
void avra_null_arg_trap(const char *fn_name, int64_t fn_len,
                         const char *param_name, int64_t param_len) {
    fprintf(stderr, "\nerror: null argument `");
    fwrite(param_name, 1, (size_t)param_len, stderr);
    fprintf(stderr, "` in function `");
    fwrite(fn_name, 1, (size_t)fn_len, stderr);
    fprintf(stderr, "`\n");
    abort();
}

// Conditional version: only traps if is_null != 0.
void avra_null_arg_check(const char *fn_name, int64_t fn_len,
                          const char *param_name, int64_t param_len,
                          int64_t is_null) {
    if (!is_null) return;
    avra_null_arg_trap(fn_name, fn_len, param_name, param_len);
}

// ── Match fallthrough trap ──
//
// Called when a match expression falls through all arms without finding
// a match. This should never happen with correct enum tags. If it does,
// the data is corrupt. Prints the function name and tag value so the
// developer knows exactly where and why.
void avra_match_unreachable(const char *fn_name, int64_t tag, const char *file, int64_t line) {
    avra_runtime_errorf("non-exhaustive match in function `%s` — unmatched tag %lld (0x%llx)", fn_name, (long long)tag, (unsigned long long)tag);
    if (file && file[0]) {
        fprintf(stderr, "  --> %s:%lld\n", file, (long long)line);
    }

    // Heuristic-rich tag analysis. The historical message just said "tag looks
    // like ptr"; the seed-cycle debug sessions (lkze.9) showed that's nearly
    // useless. The new bias: dump every plausible interpretation and let the
    // reader pick the right one.
    int looks_like_ptr = (tag > 0x100000000LL && tag < 0x800000000000LL);
    if (looks_like_ptr) {
        int64_t w0 = ((int64_t*)tag)[0];
        int64_t w1 = ((int64_t*)tag)[1];
        fprintf(stderr, "\n  value at 0x%llx looks like a heap ptr; first 16 bytes:\n",
            (unsigned long long)tag);
        fprintf(stderr, "    word[0] = 0x%llx  (%lld)\n", (unsigned long long)w0, (long long)w0);
        fprintf(stderr, "    word[1] = 0x%llx  (%lld)\n", (unsigned long long)w1, (long long)w1);

        // Shape heuristics — covers the silent-mismatch case (lkze.9 #18)
        // where the seed's baked codegen matches a value as a cons-cell
        // enum but the value is actually a `List<T>` or some other ptr-
        // shaped carrier.
        int w0_small = (w0 >= 0 && w0 < 0x1000000);
        int w1_is_ptr = (w1 > 0x100000000LL && w1 < 0x800000000000LL);
        if (w0_small && w1_is_ptr) {
            fprintf(stderr, "    shape hint: looks like `List<T> { length=%lld, data=0x%llx }`\n",
                (long long)w0, (unsigned long long)w1);
            fprintf(stderr, "                or a struct whose first two fields are (int, ptr)\n");
        } else if (w0 < 0x100 && w1_is_ptr) {
            fprintf(stderr, "    shape hint: looks like `{ tag=%lld, payload=0x%llx }` (cons-cell enum)\n",
                (long long)w0, (unsigned long long)w1);
        } else {
            fprintf(stderr, "    shape hint: bytes don't match List<T> or cons-cell layouts;\n");
            fprintf(stderr, "                this may be a use-after-free or a wholly different type\n");
        }
    } else if (tag >= 0 && tag < 0x100) {
        fprintf(stderr, "\n  small int — likely a real enum tag the match didn't cover\n");
        fprintf(stderr, "  (function `%s`'s source-level `match` is missing a variant arm)\n", fn_name);
    } else {
        fprintf(stderr, "\n  tag value out of expected ranges — probable use-after-free\n");
    }

    fprintf(stderr, "\nCommon causes:\n");
    fprintf(stderr, "  - SEED MISMATCH: the seed's baked codegen for `%s` destructures a\n", fn_name);
    fprintf(stderr, "    different runtime shape than the source declares (lkze.9 class).\n");
    fprintf(stderr, "    Diagnose: bash scripts/diagnose.sh --seed-diff %s\n", fn_name);
    fprintf(stderr, "  - Enum variant added but match arms not updated\n");
    fprintf(stderr, "  - Struct field read at wrong offset (enum layout mismatch)\n");
    fprintf(stderr, "  - Use-after-free or memory corruption\n");
    exit(99);
}

// ── Null pointer dereference trap ──
//
// Called when a field access or method call is attempted on a null pointer.
// Uses the branchless pattern: codegen passes is_null (0 or 1) and the
// C function checks internally, avoiding basic block creation in the IR.
void avra_null_deref_trap(const char *field, int64_t field_len,
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
void avra_div_by_zero_trap(int64_t is_zero, const char *file, int64_t file_len, int64_t line) {
    if (!is_zero) return;
    avra_runtime_error("division by zero");
    if (file_len > 0) {
        fprintf(stderr, "  --> ");
        fwrite(file, 1, (size_t)file_len, stderr);
        fprintf(stderr, ":%lld\n", (long long)line);
    }
    abort();
}

// djb2 hash of a string → i64. Used for stable enum variant tags.
int64_t avra_variant_hash(const char* name) {
    uint64_t hash = 5381;
    while (*name) {
        hash = hash * 33 + (unsigned char)*name;
        name++;

    }
    return (int64_t)hash;
}

// ────────────────────────────────────────────────────────────────────
// ResolverCtx state stack — step 5 of EXPAND_PIPELINE_HANDOFF.md.
//
// The 2-arg @expand macro receives a ResolverCtx { id: int } handle.
// Each ctx_* extern fn (ctx_lookup_type / ctx_qualify_ident / etc) is
// special-cased in the comptime eval and routed here: the handler
// reads the active ResolverState pointer from this stack and runs the
// query.
//
// Stack (not a single global) so nested @expand invocations can each
// have their own active state. Handles are 1-indexed so 0 stays the
// "no active resolver" sentinel.
// ────────────────────────────────────────────────────────────────────

#define AVRA_RESOLVER_STACK_CAP 16

static void*   avra_resolver_stack[AVRA_RESOLVER_STACK_CAP];
static int64_t avra_resolver_top = 0;

int64_t avra_resolver_ctx_push(void* state) {
    if (avra_resolver_top >= AVRA_RESOLVER_STACK_CAP) {
        fprintf(stderr, "avra_resolver_ctx_push: stack overflow (cap=%d)\n", AVRA_RESOLVER_STACK_CAP);
        abort();
    }
    avra_resolver_stack[avra_resolver_top] = state;
    avra_resolver_top++;
    return avra_resolver_top;
}

void avra_resolver_ctx_pop(void) {
    if (avra_resolver_top > 0) {
        avra_resolver_top--;
        avra_resolver_stack[avra_resolver_top] = NULL;
    }
}

// Return the handle for the most recently pushed state, or 0 if
// the stack is empty. Used by `invoke_macro` to set ResolverCtx.id
// when invoking a 2-arg macro.
int64_t avra_resolver_ctx_top(void) {
    return avra_resolver_top;
}

// Fresh-ident counter — per-process monotonic. Each call returns
// a new int the macro can format into a unique identifier. Reset
// is intentionally not provided; uniqueness scope is the whole
// compile.
static int64_t avra_resolver_fresh_counter = 0;

int64_t avra_resolver_fresh_id(void) {
    avra_resolver_fresh_counter++;
    return avra_resolver_fresh_counter;
}

// ────────────────────────────────────────────────────────────────────
// Resolver-data layer (Step 5 of expand-pipeline doc)
// ────────────────────────────────────────────────────────────────────
//
// Per-macro-invocation scratch space populated by expand_macro.av
// before invoking each macro. Macros call ctx_* fns which dispatch
// through eval_resolver_ctx_call → these getters instead of
// introspecting an opaque ResolverState ptr from Avra (no general
// unsafe-cast facility exists).
//
// Lifecycle (per @expand site):
//   1. expand_macro.av computes the current_module, aliases, globals,
//      and type field info for this site.
//   2. avra_rd_clear() resets all storage.
//   3. avra_rd_set_*() / avra_rd_add_*() fills it.
//   4. The macro runs; ctx_* read via avra_rd_lookup_*() / etc.
//   5. Next site loops back to step 1.
//
// String storage: we hold references rather than copies. The AST
// strings stay alive for the whole compile, so this is safe.
//
// Growable storage: per-bucket (aliases, globals, types, fields) we
// keep a (keys/vals, n, cap) tuple. avra_rd_grow_strs / _grow_ints
// double cap on push when n == cap. Starts small (256/256/128/512)
// and grows by 2x; programs with bounded ResolverState pay almost
// no overhead, but the prior fixed 16K/16K/2K/16K caps no longer
// silently drop entries on overflow.

static const char* avra_rd_current_module_v = "";

// Initial cap for the type bucket — referenced by avra_rd_grow_types.
// The other buckets (aliases / globals / fields) flow through
// avra_rd_grow_strs2 which uses a uniform 256 starting cap (cheap;
// doubles to fit any real program).
#define AVRA_RD_INIT_TYPES    128

static const char** avra_rd_alias_keys = NULL;
static const char** avra_rd_alias_vals = NULL;
static int64_t avra_rd_alias_n = 0;
static int64_t avra_rd_alias_cap = 0;

static const char** avra_rd_global_keys = NULL;
static const char** avra_rd_global_vals = NULL;
static int64_t avra_rd_global_n = 0;
static int64_t avra_rd_global_cap = 0;

static const char** avra_rd_type_canonicals = NULL;
static const char** avra_rd_type_kinds = NULL;
static int64_t* avra_rd_type_field_starts = NULL;
static int64_t* avra_rd_type_field_counts = NULL;
static int64_t avra_rd_type_n = 0;
static int64_t avra_rd_type_cap = 0;

static const char** avra_rd_field_names = NULL;
static const char** avra_rd_field_type_canonicals = NULL;
static int64_t avra_rd_field_n = 0;
static int64_t avra_rd_field_cap = 0;

// Grow a pair of const char* buckets (keys + vals) to at least
// `needed` capacity. Doubles cap until it's enough. Aborts on alloc
// failure (rare; production process would just be killed by OOM).
static void avra_rd_grow_strs2(const char*** a, const char*** b, int64_t* cap, int64_t needed) {
    int64_t new_cap = (*cap == 0) ? 256 : *cap;
    while (new_cap < needed) new_cap *= 2;
    if (new_cap == *cap) return;
    *a = (const char**)realloc(*a, new_cap * sizeof(const char*));
    *b = (const char**)realloc(*b, new_cap * sizeof(const char*));
    if (!*a || !*b) {
        fprintf(stderr, "avra_rd: out of memory growing string bucket to %lld entries\n", (long long)new_cap);
        abort();
    }
    *cap = new_cap;
}

// Grow the type bucket — needs four parallel arrays (canonicals,
// kinds, field_starts, field_counts).
static void avra_rd_grow_types(int64_t needed) {
    int64_t new_cap = (avra_rd_type_cap == 0) ? AVRA_RD_INIT_TYPES : avra_rd_type_cap;
    while (new_cap < needed) new_cap *= 2;
    if (new_cap == avra_rd_type_cap) return;
    avra_rd_type_canonicals = (const char**)realloc(avra_rd_type_canonicals, new_cap * sizeof(const char*));
    avra_rd_type_kinds = (const char**)realloc(avra_rd_type_kinds, new_cap * sizeof(const char*));
    avra_rd_type_field_starts = (int64_t*)realloc(avra_rd_type_field_starts, new_cap * sizeof(int64_t));
    avra_rd_type_field_counts = (int64_t*)realloc(avra_rd_type_field_counts, new_cap * sizeof(int64_t));
    if (!avra_rd_type_canonicals || !avra_rd_type_kinds ||
        !avra_rd_type_field_starts || !avra_rd_type_field_counts) {
        fprintf(stderr, "avra_rd: out of memory growing type bucket to %lld entries\n", (long long)new_cap);
        abort();
    }
    avra_rd_type_cap = new_cap;
}

void avra_rd_clear(void) {
    avra_rd_current_module_v = "";
    avra_rd_alias_n = 0;
    avra_rd_global_n = 0;
    avra_rd_type_n = 0;
    avra_rd_field_n = 0;
    // Keep capacity; future fill of similar size will reuse without
    // realloc. Caller decides via process exit when to truly free.
}

void avra_rd_set_current_module(const char* s) {
    avra_rd_current_module_v = s ? s : "";
}

const char* avra_rd_get_current_module(void) {
    return avra_rd_current_module_v;
}

// Shared key/value-array append used by both alias + global buckets.
// Grows the parallel string buckets if necessary, then writes the
// (key,val) pair at the end. Keeping this single helper means a future
// change to growth policy (e.g. interning, free-on-clear) touches one
// place instead of two near-identical add_*-shaped fns.
static void rd_strmap_add(const char*** keys, const char*** vals,
                          int64_t* n, int64_t* cap,
                          const char* key, const char* val) {
    if (*n >= *cap) {
        avra_rd_grow_strs2(keys, vals, cap, *n + 1);
    }
    (*keys)[*n] = key;
    (*vals)[*n] = val;
    (*n)++;
}

// Linear lookup over a parallel keys/vals bucket. Returns the matched
// value or "" — same null-equivalent the Avra side expects from
// `avra_rd_lookup_*` extern fns.
static const char* rd_strmap_lookup(const char** keys, const char** vals,
                                    int64_t n, const char* key) {
    for (int64_t i = 0; i < n; i++) {
        if (strcmp(keys[i], key) == 0) return vals[i];
    }
    return "";
}

void avra_rd_add_alias(const char* short_name, const char* canonical) {
    rd_strmap_add(&avra_rd_alias_keys, &avra_rd_alias_vals,
                  &avra_rd_alias_n, &avra_rd_alias_cap,
                  short_name, canonical);
}

const char* avra_rd_lookup_alias(const char* name) {
    return rd_strmap_lookup(avra_rd_alias_keys, avra_rd_alias_vals,
                            avra_rd_alias_n, name);
}

void avra_rd_add_global(const char* short_name, const char* canonical) {
    rd_strmap_add(&avra_rd_global_keys, &avra_rd_global_vals,
                  &avra_rd_global_n, &avra_rd_global_cap,
                  short_name, canonical);
}

const char* avra_rd_lookup_global(const char* name) {
    return rd_strmap_lookup(avra_rd_global_keys, avra_rd_global_vals,
                            avra_rd_global_n, name);
}

// Returns the type id (index into avra_rd_type_*) for the new type.
// Macros append fields via `avra_rd_add_type_field(type_id, ...)` until
// they move on to the next type.
int64_t avra_rd_begin_type(const char* canonical, const char* kind) {
    if (avra_rd_type_n >= avra_rd_type_cap) {
        avra_rd_grow_types(avra_rd_type_n + 1);
    }
    int64_t id = avra_rd_type_n;
    avra_rd_type_canonicals[id] = canonical;
    avra_rd_type_kinds[id] = kind ? kind : "";
    avra_rd_type_field_starts[id] = avra_rd_field_n;
    avra_rd_type_field_counts[id] = 0;
    avra_rd_type_n++;
    return id;
}

void avra_rd_add_type_field(int64_t type_id, const char* field_name, const char* field_type_canonical) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return;
    if (avra_rd_field_n >= avra_rd_field_cap) {
        avra_rd_grow_strs2(&avra_rd_field_names, &avra_rd_field_type_canonicals, &avra_rd_field_cap, avra_rd_field_n + 1);
    }
    avra_rd_field_names[avra_rd_field_n] = field_name;
    avra_rd_field_type_canonicals[avra_rd_field_n] = field_type_canonical ? field_type_canonical : "";
    avra_rd_field_n++;
    avra_rd_type_field_counts[type_id]++;
}

// Look up a type by short_name OR canonical. Returns id or -1.
int64_t avra_rd_find_type(const char* name) {
    for (int64_t i = 0; i < avra_rd_type_n; i++) {
        if (strcmp(avra_rd_type_canonicals[i], name) == 0) return i;
        // also accept short-name suffix match (e.g. "Foo" matches "@user::ast::Foo")
        const char* canonical = avra_rd_type_canonicals[i];
        size_t cl = strlen(canonical);
        size_t nl = strlen(name);
        if (nl < cl) {
            const char* tail = canonical + (cl - nl);
            if (strcmp(tail, name) == 0) {
                // make sure preceding char is ':' or start
                if (tail == canonical || (tail >= canonical + 2 && *(tail-1) == ':' && *(tail-2) == ':')) {
                    return i;
                }
            }
        }
    }
    return -1;
}

const char* avra_rd_type_canonical(int64_t type_id) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return "";
    return avra_rd_type_canonicals[type_id];
}

const char* avra_rd_type_kind(int64_t type_id) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return "";
    return avra_rd_type_kinds[type_id];
}

int64_t avra_rd_type_field_count(int64_t type_id) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return 0;
    return avra_rd_type_field_counts[type_id];
}

const char* avra_rd_type_field_name(int64_t type_id, int64_t idx) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return "";
    if (idx < 0 || idx >= avra_rd_type_field_counts[type_id]) return "";
    return avra_rd_field_names[avra_rd_type_field_starts[type_id] + idx];
}

const char* avra_rd_type_field_type(int64_t type_id, int64_t idx) {
    if (type_id < 0 || type_id >= avra_rd_type_n) return "";
    if (idx < 0 || idx >= avra_rd_type_field_counts[type_id]) return "";
    return avra_rd_field_type_canonicals[avra_rd_type_field_starts[type_id] + idx];
}

