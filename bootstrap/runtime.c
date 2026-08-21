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

// glibc gates several extensions used below behind _GNU_SOURCE:
// `Dl_info`/`dladdr` (<dlfcn.h>) and the `qsort_r` prototype. Must be
// defined before any system header is pulled in. No-op on macOS/BSD,
// which expose these unconditionally.
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

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
#include <sys/file.h>
#include <fcntl.h>
#include <errno.h>
#if defined(__APPLE__)
// Needed on EVERY Apple arch for avra_mem_rss_kb's task_info() RSS poll,
// not just arm64 — so keep it outside the arm64-only ucontext block.
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <dispatch/dispatch.h>
#endif
#if defined(__APPLE__) && (defined(__aarch64__) || defined(__arm64__))
#define _XOPEN_SOURCE
#include <ucontext.h>
#undef _XOPEN_SOURCE
#include <mach-o/dyld.h>
#endif

// ─── Forward declarations for error reporting ────────────────────
static void avra_runtime_error(const char* msg);
static void avra_runtime_errorf(const char* fmt, ...);
// AVRA_RC_STRICT foreign-release detector (defined after the crash-report
// helpers it uses; called from the RC retain/release no-op paths below).
static void avra_rc_strict_check(const char* op, void* ptr);

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

// Single-threaded fast path: the rc_set mutex is only needed once a SECOND
// thread exists. The compiler process and the vast majority of Avra programs
// never spawn a thread, yet every alloc / retain / release paid an
// unconditional lock+unlock (~6% of compiler instructions, measured). Gate the
// lock on this flag — set to 1 exactly once, on the main thread, immediately
// BEFORE the first pthread_create (a full memory barrier, so the new thread and
// all later rc_set ops observe it as 1). It never resets: once multithreaded,
// always locked. The only lock-free window is strictly before any thread
// exists, i.e. genuinely single-threaded, so it is race-free by construction.
static int g_rc_multithreaded = 0;
void avra_rc_go_multithreaded(void) { g_rc_multithreaded = 1; }
static inline void rc_lock(void)   { if (g_rc_multithreaded) pthread_mutex_lock(&rc_set_mutex); }
static inline void rc_unlock(void) { if (g_rc_multithreaded) pthread_mutex_unlock(&rc_set_mutex); }

// Single-threaded refcount fast path — same rationale as rc_lock above, applied
// to the refcount RMW itself. A retain/release increment must be ATOMIC only
// when a second thread can observe the object concurrently. Before
// g_rc_multithreaded arms (immediately before the first pthread_create), the
// process is genuinely single-threaded, so a plain load+add+store — no `lock`
// prefix, ~20+ cycles cheaper per op on x86 — is race-free by construction.
// Once multithreaded, fall back to the seq_cst atomic RMW (unchanged semantics
// for the threaded case: channels hand objects across fibers). This is a
// runtime-only change; the IR bs2 emits is byte-identical (it still calls
// avra_rc_retain/release by name).
static inline int32_t rc_refcount_incr(_Atomic int32_t* rc) {
    if (!g_rc_multithreaded) {
        int32_t v = atomic_load_explicit(rc, memory_order_relaxed) + 1;
        atomic_store_explicit(rc, v, memory_order_relaxed);
        return v;
    }
    return atomic_fetch_add(rc, 1) + 1;
}
static inline int32_t rc_refcount_decr(_Atomic int32_t* rc) {
    if (!g_rc_multithreaded) {
        int32_t v = atomic_load_explicit(rc, memory_order_relaxed) - 1;
        atomic_store_explicit(rc, v, memory_order_relaxed);
        return v;
    }
    return atomic_fetch_sub(rc, 1) - 1;
}

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
    rc_lock();
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
    rc_unlock();
}

static int rc_set_contains(void* ptr) {
    rc_lock();
    if (!rc_set_buckets || rc_set_count == 0) {
        rc_unlock();
        return 0;
    }
    size_t idx = rc_set_hash(ptr) & (rc_set_cap - 1);
    int found = 0;
    while (rc_set_buckets[idx] != NULL) {
        if (rc_set_buckets[idx] == ptr) { found = 1; break; }
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    rc_unlock();
    return found;
}

static int avra_rc_strict;   // fwd decl (tentative); real definition + default below
// ─── Fast RC region allocator (default path) ───────────────────────────
// avra_rc_alloc's per-object malloc (glibc arena lock + _int_malloc) plus the
// rc_set membership hash (insert on every alloc, probe on every retain/release,
// periodic full-table rehash) were ~40% of a compile's instructions (measured,
// callgrind). Replace both for the common case: small RC objects come from ONE
// reserved virtual region — allocation is a pointer bump or a size-class
// free-list pop, and "is this pointer RC-managed?" is a range check against the
// region, so there is NO malloc lock, NO hash insert, NO table resize on the hot
// path. Large/rare blocks (> RC_REGION_MAXBLK) still use malloc + the rc_set,
// which therefore stays tiny. Strict mode (AVRA_RC_STRICT) runs its detectors
// ON TOP of the region (see rc_reclaim); AVRA_RC_NO_REGION restores the
// original malloc+set path (debugging / A-B verification, composes with strict).
//
// Block layout in the region: [ total_size(8) | RcHeader(8) | payload ]. The
// 8-byte total lets free() bucket the block by size class; the user pointer is
// base+16 (16-byte aligned, ≥ the 8-byte alignment codegen needs). All region
// state is guarded by the SAME gated rc_lock, so a single-threaded process
// (the compiler, most programs) bump-allocates lock-free.
#define RC_REGION_BYTES  (48ULL << 30)                        // 48 GiB virtual (MAP_NORESERVE: RAM committed on touch)
#define RC_REGION_HDR    16                                   // 8 total-size + 8 RcHeader, before the payload
#define RC_REGION_GRAIN  16                                   // block size granularity == alignment
#define RC_REGION_MAXBLK 4096                                 // blocks up to this (incl. header) use the region
#define RC_REGION_NLIST  (RC_REGION_MAXBLK / RC_REGION_GRAIN + 1)
static char*  rc_region_base = NULL;
static char*  rc_region_frontier = NULL;
static char*  rc_region_end = NULL;
static void*  rc_region_free[RC_REGION_NLIST];               // free-list heads, indexed by total/GRAIN
static int    rc_region_enabled = 0;

__attribute__((constructor(102)))                             // after auto_enable_rc_strict (101)
static void rc_region_init(void) {
    if (rc_region_base) return;
    // Strict mode keeps the region: its detectors (poison-on-free, reuse
    // quarantine, foreign-release abort) run at the region layer — see
    // rc_reclaim. Disabling the region under strict made every small object
    // an individual malloc + hash insert, a measured 3.6x wall / +18% RSS on
    // a package compile, which is what held the rc-strict CI suite to shard
    // width 1. AVRA_RC_NO_REGION remains the explicit A/B escape hatch and
    // composes with strict (= the historical all-malloc strict behaviour).
    if (getenv("AVRA_RC_NO_REGION")) { rc_region_enabled = 0; return; }
    void* p = mmap(NULL, RC_REGION_BYTES, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (p == MAP_FAILED) { rc_region_enabled = 0; return; }   // graceful fallback to malloc+set
    rc_region_base = (char*)p;
    rc_region_frontier = (char*)p;
    rc_region_end = (char*)p + RC_REGION_BYTES;
    rc_region_enabled = 1;
}

static inline int rc_region_contains(void* ptr) {
    // Bound by rc_region_end, NOT the live rc_region_frontier. Membership is
    // read on every retain/release (is_rc_managed) with no lock — the whole
    // point of the region is a lock-free hot path — but rc_region_frontier is
    // mutated under rc_lock by the allocator, so reading it here would be a data
    // race (and a stale frontier could misjudge a freshly-allocated region
    // object as non-RC → a leak or premature free). base/end/enabled are set
    // once in the constructor and never mutated, so this read is race-free.
    // Safe by construction: a real region object is always < frontier ≤ end;
    // the only pointers in [frontier, end) are reserved-but-untouched region
    // space (never handed to retain/release), and were a stray pointer to land
    // there its zero header (type_tag != RC_MAGIC) makes retain/release a no-op.
    return rc_region_enabled && (char*)ptr >= rc_region_base && (char*)ptr < rc_region_end;
}

// Allocate `payload` bytes from the region; returns the user pointer (past the
// 16-byte header) or NULL when the region is off / the block is too big / the
// region is exhausted — in which case the caller falls back to malloc + rc_set.
static void* rc_region_try_alloc(size_t payload) {
    if (!rc_region_enabled) return NULL;
    size_t total = (RC_REGION_HDR + payload + (RC_REGION_GRAIN - 1)) & ~(size_t)(RC_REGION_GRAIN - 1);
    if (total > RC_REGION_MAXBLK) return NULL;
    size_t li = total / RC_REGION_GRAIN;
    rc_lock();
    char* base;
    if (rc_region_free[li]) {
        base = (char*)rc_region_free[li];
        rc_region_free[li] = *(void**)base;                   // pop the free list
    } else if (rc_region_frontier + total <= rc_region_end) {
        base = rc_region_frontier;                            // bump the frontier
        rc_region_frontier += total;
    } else {
        rc_unlock();
        return NULL;                                          // exhausted → malloc fallback
    }
    rc_unlock();
    *(size_t*)base = total;                                   // remember the size class for free()
    return base + RC_REGION_HDR;
}

// Return a region block to its size-class free list (LIFO, link stored in the
// block's own memory). The size was recorded at the base by rc_region_try_alloc
// and is still intact here: the strict quarantine stores block addresses in its
// own ring and never writes into a held block, so a base arriving via eviction
// reads the same size a direct free would.
static void rc_region_free_base(void* base) {
    size_t li = (*(size_t*)base) / RC_REGION_GRAIN;
    rc_lock();
    *(void**)base = rc_region_free[li];
    rc_region_free[li] = base;
    rc_unlock();
}
static void rc_region_free_block(void* user_ptr) {
    rc_region_free_base((char*)user_ptr - RC_REGION_HDR);
}

// Thread-local net-allocation accounting for single-threaded leak
// probes. The global live count is process-wide, so under the
// parallel test runner a sibling unit's allocations between a
// spec's before/after reads produce spurious deltas. A spec whose
// body allocates and drops on ONE thread gets an exact, isolation-
// proof reading from the local delta instead. Frees are counted on
// the thread that performs them — cross-thread hand-offs (channel
// sends) intentionally skew the local view, which is why tests
// asserting transfer semantics keep using the global count.
static _Thread_local int64_t t_rc_allocs = 0;
static _Thread_local int64_t t_rc_frees = 0;

int64_t avra_rc_live_delta_local(void) {
    return t_rc_allocs - t_rc_frees;
}

static void rc_set_remove(void* ptr) {
    t_rc_frees++;
    if (rc_region_contains(ptr)) return;     // region blocks were never added to the set
    rc_lock();
    if (!rc_set_buckets) {
        rc_unlock();
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
            rc_unlock();
            return;
        }
        idx = (idx + 1) & (rc_set_cap - 1);
    }
    rc_unlock();
}

// ─── Strict allocator mode (AVRA_RC_STRICT) ─────────────────────
// Debug mode that makes RC misuse LOUD instead of silently absorbable.
// zm77 — a phantom-release of uninitialised stack garbage at every zero-arg
// call site — stayed silent for a whole session because the release/free
// paths no-op on any pointer that isn't a live RC allocation. Under
// AVRA_RC_STRICT the runtime turns three screws:
//   (a) poison-on-free   — freed payloads are memset to 0xDD, so a
//       use-after-free READ hits an obviously-garbage value (0xDDDD…)
//       instead of stale-but-plausible data.
//   (b) reuse quarantine — freed blocks are held back from the allocator
//       (deferred free), so a stale pointer keeps pointing at DEAD memory
//       rather than a recycled live object (defeats ABA reuse).
//   (c) foreign-release abort — a release/retain path that receives a
//       pointer into a freed-and-quarantined block aborts with a backtrace
//       naming the releasing context. That freed set is exactly the zm77
//       signature (releasing a stale pointer to memory we already
//       reclaimed); because membership is tested against blocks WE froze —
//       never an address-range guess — it never fires on the legitimate
//       non-RC no-ops these paths also see (NULL, stack, text, LLVM
//       ValueRefs, bump-arena interiors), so a clean suite stays green.
// Every branch here is gated on avra_rc_strict; with the env var unset the
// allocation layout and free path are byte-for-byte the historical ones.

#define RC_POISON_BYTE 0xDD
// A strict allocation stores its payload size in an 8-byte prefix placed
// BEFORE the RC header, so the free path can poison exactly the payload.
// The header still sits at user_ptr-8 in BOTH modes, so codegen (which
// reads the header at ptr-8) is unaffected:
//   normal:  [ RcHeader:8 ][ payload… ]                 base = ptr-8
//   strict:  [ size:8 ][ RcHeader:8 ][ payload… ]       base = ptr-16
#define RC_STRICT_PREFIX 8

static int avra_rc_strict = 0;

// Strict-mode live-allocation accounting. With the region serving strict
// allocations, rc_set no longer sees every object (region blocks bypass it by
// design), so avra_rc_live_count's strict contract — the count moves by N for
// N stranded objects, whichever path allocated them — is carried by this pair
// instead: every successful avra_rc_alloc increments, every rc_reclaim
// decrements. Gated on avra_rc_strict at both sites, so the non-strict hot
// path pays nothing.
static _Atomic int64_t rc_strict_allocs = 0;
static _Atomic int64_t rc_strict_frees = 0;

// High-priority constructor (101 = earliest user priority): the alloc/free
// layout is flag-dependent (rc_malloc_base), so the flag MUST be settled
// before the FIRST avra_rc_alloc. All C constructors already finish before
// main() (where compiled Avra — the only caller of avra_rc_alloc — begins),
// so this is belt-and-suspenders against any RC-allocating initializer that
// might otherwise sneak in ahead of a default-priority constructor.
//
// SILENT by design: no startup banner. This mode is meant to run across the
// whole CI suite, where every compiled binary is a subprocess whose output
// some test captures + exact-matches; a chatty stderr line would pollute
// those captures. Strict mode announces itself only when it ACTUALLY catches
// misuse (avra_rc_strict_check aborts). Query the flag via
// avra_rc_strict_enabled() when a test needs to confirm it is active.
__attribute__((constructor(101)))
static void auto_enable_rc_strict(void) {
    if (getenv("AVRA_RC_STRICT")) avra_rc_strict = 1;
}

// The malloc base for a user pointer, layout-aware. avra_rc_strict is set
// once in a constructor and constant thereafter, so every alloc/free in a
// process agrees on the offset.
static inline void* rc_malloc_base(void* user_ptr) {
    size_t back = RC_HEADER_SIZE + (avra_rc_strict ? RC_STRICT_PREFIX : 0);
    return (char*)user_ptr - back;
}

// Quarantine: an open-addressing hash set (O(1) membership) paired with a
// FIFO ring (eviction order + deferred-free storage). Holds the malloc/region
// bases of freed-but-not-yet-reclaimed strict allocations.
//
// The ring is capped by COUNT and by BYTES. The byte cap matters precisely
// because the region serves small strict allocations now: only >RC_REGION_MAXBLK
// blocks reach this ring, so the small-block churn that used to cycle big
// blocks out of the 16384-slot window is gone — without a byte cap, 16384
// deferred multi-KB..MB blocks pinned gigabytes (observed: an 8.2GB shard on
// the error-recovery differential batch, F4014 under the pool's soft grant).
// Evicting by bytes restores the effective deferred-free window big blocks had
// when everything shared the ring.
#define RC_QUARANTINE_CAP       16384                 // freed blocks held back
#define RC_QUARANTINE_MAX_BYTES (256ULL << 20)        // and at most 256MB of them
#define RC_QUARANTINE_SLOTS (RC_QUARANTINE_CAP * 2)   // hash load ≤ 50%
static void*  rc_quar_ring[RC_QUARANTINE_CAP];        // zero-init (FIFO order)
static size_t rc_quar_sizes[RC_QUARANTINE_CAP];       // block bytes, ring-parallel
static size_t rc_quar_head = 0;                       // next ring slot to write
static size_t rc_quar_fill = 0;
static size_t rc_quar_bytes = 0;                      // sum of held block bytes
static void*  rc_quar_slots[RC_QUARANTINE_SLOTS];     // hash set, NULL = empty
static pthread_mutex_t rc_quar_mutex = PTHREAD_MUTEX_INITIALIZER;

static size_t rc_quar_hash(void* p) {
    uintptr_t x = (uintptr_t)p >> 4;   // bases are ≥16-byte spaced
    x *= 0x9E3779B97F4A7C15ULL;         // fibonacci hashing
    return (size_t)(x & (RC_QUARANTINE_SLOTS - 1));
}
static void rc_quar_slot_insert(void* base) {
    size_t i = rc_quar_hash(base);
    while (rc_quar_slots[i] != NULL) i = (i + 1) & (RC_QUARANTINE_SLOTS - 1);
    rc_quar_slots[i] = base;
}
static void rc_quar_slot_remove(void* base) {
    size_t i = rc_quar_hash(base);
    while (rc_quar_slots[i] != NULL) {
        if (rc_quar_slots[i] == base) {
            rc_quar_slots[i] = NULL;
            // Backward-shift deletion: reinsert the following cluster so
            // probe chains stay intact (no tombstones).
            size_t j = (i + 1) & (RC_QUARANTINE_SLOTS - 1);
            while (rc_quar_slots[j] != NULL) {
                void* moved = rc_quar_slots[j];
                rc_quar_slots[j] = NULL;
                rc_quar_slot_insert(moved);
                j = (j + 1) & (RC_QUARANTINE_SLOTS - 1);
            }
            return;
        }
        i = (i + 1) & (RC_QUARANTINE_SLOTS - 1);
    }
}
static int rc_quar_slot_contains(void* base) {
    size_t i = rc_quar_hash(base);
    while (rc_quar_slots[i] != NULL) {
        if (rc_quar_slots[i] == base) return 1;
        i = (i + 1) & (RC_QUARANTINE_SLOTS - 1);
    }
    return 0;
}

// Really reclaim an evicted base. Route by block kind: region blocks rejoin
// their size-class free list (lock order is rc_quar_mutex → rc_lock, never
// the reverse — no caller takes the quarantine mutex under rc_lock), malloc
// blocks free().
static void rc_quar_reclaim_base(void* base) {
    if (rc_region_contains(base)) rc_region_free_base(base);
    else free(base);
}

// Defer-free a strict allocation's base; evict + really free oldest blocks
// while either cap (count or bytes) is exceeded. A single oversized push can
// evict many blocks — eviction happens inline under the mutex.
static void rc_quarantine_push(void* base, size_t bytes) {
    // A block larger than the whole byte cap can never legally sit in the
    // ring — with an empty ring the eviction loop below is a no-op and the
    // block would park unbounded until the next push. Reclaim it
    // immediately instead (the ASan rule for over-quarantine chunks). The
    // deferred-reuse window is knowingly zero for such blocks: they are
    // >256MB one-offs, and holding even one defeats the bound the cap
    // exists to enforce.
    if (bytes > RC_QUARANTINE_MAX_BYTES) {
        rc_quar_reclaim_base(base);
        return;
    }
    pthread_mutex_lock(&rc_quar_mutex);
    while (rc_quar_fill > 0 &&
           (rc_quar_fill == RC_QUARANTINE_CAP ||
            rc_quar_bytes + bytes > RC_QUARANTINE_MAX_BYTES)) {
        size_t oldest = (rc_quar_head + RC_QUARANTINE_CAP - rc_quar_fill) % RC_QUARANTINE_CAP;
        void* evict = rc_quar_ring[oldest];
        rc_quar_slot_remove(evict);
        rc_quar_bytes -= rc_quar_sizes[oldest];
        rc_quar_fill--;
        rc_quar_reclaim_base(evict);
    }
    rc_quar_ring[rc_quar_head] = base;
    rc_quar_sizes[rc_quar_head] = bytes;
    rc_quar_slot_insert(base);
    rc_quar_bytes += bytes;
    rc_quar_fill++;
    rc_quar_head = (rc_quar_head + 1) % RC_QUARANTINE_CAP;
    pthread_mutex_unlock(&rc_quar_mutex);
}

// Is user_ptr a pointer into a freed-and-quarantined strict allocation?
static int rc_quarantine_contains_user(void* user_ptr) {
    void* base = rc_malloc_base(user_ptr);
    pthread_mutex_lock(&rc_quar_mutex);
    int found = rc_quar_slot_contains(base);
    pthread_mutex_unlock(&rc_quar_mutex);
    return found;
}

// Reclaim an RC object. Under strict mode: poison the payload then hand the
// base to the quarantine (deferred free) — region and malloc blocks alike;
// both layouts put the base at user_ptr-16 with a size field at base+0, so
// the quarantine treats them uniformly and only eviction routes by kind.
// Otherwise: immediate reuse/free, the historical paths. Caller has already
// cleared type_tag + removed from rc_set.
static void rc_reclaim(void* user_ptr) {
    if (avra_rc_strict) {
        atomic_fetch_add_explicit(&rc_strict_frees, 1, memory_order_relaxed);
        int in_region = rc_region_contains(user_ptr);
        void* base = in_region ? (char*)user_ptr - RC_REGION_HDR
                               : rc_malloc_base(user_ptr);
        // Region blocks store the TOTAL (header included) at base; strict
        // malloc blocks store the payload itself (the RC_STRICT_PREFIX).
        size_t stored = *(size_t*)base;
        size_t payload = in_region ? stored - RC_REGION_HDR : stored;
        if (payload) memset(user_ptr, RC_POISON_BYTE, payload);
        size_t held = in_region ? stored
                                : payload + RC_HEADER_SIZE + RC_STRICT_PREFIX;
        rc_quarantine_push(base, held);
        return;
    }
    if (rc_region_contains(user_ptr)) {          // region block → size-class free list
        rc_region_free_block(user_ptr);
        return;
    }
    free((char*)user_ptr - RC_HEADER_SIZE);
}

// Allocate an RC-managed object via system malloc.
// Returns pointer to payload (past header).
// Forward declarations for the comptime memory bound (ps3t.5.4), defined far
// below next to the comptime depth counter — avra_rc_alloc charges against the
// per-fold budget when a comptime fold is on the stack.
int64_t avra_comptime_active(void);
static void avra_comptime_charge(int64_t bytes);
// t-drl0: process-wide RSS ceiling (defined next to the comptime budget it
// mirrors). Amortised — a relaxed increment on all but every 65536th call.
static void avra_mem_poll(void);

void* avra_rc_alloc(int64_t payload_size) {
    size_t payload = (size_t)payload_size;
    // ps3t.5.4: charge comptime-active allocations against the per-fold ceiling
    // so a runaway fold trips a diagnostic before it can OOM the compiler.
    if (avra_comptime_active()) avra_comptime_charge((int64_t)payload_size);
    // t-drl0: and against the process-wide ceiling, so a runaway ANYWHERE (this
    // is the compiler's single hottest allocation path) reports instead of
    // getting the whole container SIGKILLed.
    avra_mem_poll();
    // Fast path: a small object straight from the region (no malloc, no rc_set).
    void* ruser = rc_region_try_alloc(payload);
    if (ruser) {
        RcHeader* rhdr = (RcHeader*)((char*)ruser - RC_HEADER_SIZE);
        atomic_store_explicit(&rhdr->refcount, 1, memory_order_relaxed);
        rhdr->type_tag = RC_MAGIC;
        t_rc_allocs++;
        if (avra_rc_strict) atomic_fetch_add_explicit(&rc_strict_allocs, 1, memory_order_relaxed);
        if (rc_trace) {
            fprintf(stderr, "[RC] alloc %p (payload=%lld, rc=1, region)\n", ruser, (long long)payload_size);
        }
        return ruser;
    }
    // Fallback: strict mode, oversized block, or region exhausted → malloc + rc_set.
    size_t prefix = avra_rc_strict ? RC_STRICT_PREFIX : 0;
    size_t total = prefix + RC_HEADER_SIZE + payload;
    total = (total + 7) & ~7;  // align to 8
    void* raw = malloc(total);
    if (!raw) {
        avra_runtime_errorf("out of memory (rc_alloc %lld bytes)", (long long)payload_size);
        exit(1);
    }
    if (avra_rc_strict) *(size_t*)raw = payload;   // size prefix for poison-on-free
    void* user_ptr = (char*)raw + prefix + RC_HEADER_SIZE;
    RcHeader* hdr = (RcHeader*)((char*)user_ptr - RC_HEADER_SIZE);
    atomic_store_explicit(&hdr->refcount, 1, memory_order_relaxed);
    hdr->type_tag = RC_MAGIC;
    t_rc_allocs++;
    if (avra_rc_strict) atomic_fetch_add_explicit(&rc_strict_allocs, 1, memory_order_relaxed);
    rc_set_add(user_ptr);
    if (rc_trace) {
        fprintf(stderr, "[RC] alloc %p (payload=%lld, rc=1)\n", user_ptr, (long long)payload_size);
    }
    return user_ptr;
}

// Check if a pointer is an RC-managed object using the pointer set.
static inline int is_rc_managed(void* ptr) {
    if (rc_region_contains(ptr)) return 1;   // region block — RC by construction, no set lookup
    return rc_set_contains(ptr);             // large / strict block — the residual set
}

// Increment reference count.
void avra_rc_retain(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) {
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_retain", ptr);
        return;
    }
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) {
        // A freed REGION block still passes the is_rc_managed range check, so
        // a stale pointer to one lands here (cleared tag), not on the
        // !is_rc_managed branch above — without this check strict mode would
        // silently no-op on exactly the zm77 class it exists to catch.
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_retain", ptr);
        return;
    }
    int32_t new_rc = rc_refcount_incr(&hdr->refcount);
    if (rc_trace) {
        fprintf(stderr, "[RC] retain %p (rc=%d)\n", ptr, new_rc);
    }
}

// Decrement reference count. Frees the object when refcount reaches 0.
void avra_rc_release(void* ptr) {
    if (!ptr) return;
    if (!is_rc_managed(ptr)) {
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_release", ptr);
        return;
    }
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) {
        // Same region-range subtlety as avra_rc_retain: a stale release of a
        // freed region block must reach the strict check, not no-op.
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_release", ptr);
        return;
    }
    int32_t new_rc = rc_refcount_decr(&hdr->refcount);
    if (rc_trace) {
        fprintf(stderr, "[RC] release %p (rc=%d)\n", ptr, new_rc);
    }
    if (new_rc == 0) {
        if (rc_trace) {
            fprintf(stderr, "[RC] free %p\n", ptr);
        }
        hdr->type_tag = 0;  // Clear magic to prevent double-free
        rc_set_remove(ptr);
        rc_reclaim(ptr);
    }
}

// Decrement refcount and return 1 if the object should be freed (refcount hit 0).
// Does NOT free the memory — the caller is responsible for releasing fields
// first, then calling avra_rc_free. Used by generated __release_TypeName
// functions for recursive field release.
int64_t avra_rc_should_free(void* ptr) {
    if (!ptr) return 0;
    if (!is_rc_managed(ptr)) {
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_should_free", ptr);
        return 0;
    }
    RcHeader* hdr = rc_header(ptr);
    if (hdr->type_tag != RC_MAGIC) {
        // Same region-range subtlety as avra_rc_retain/release above.
        if (avra_rc_strict) avra_rc_strict_check("avra_rc_should_free", ptr);
        return 0;
    }
    int32_t new_rc = rc_refcount_decr(&hdr->refcount);
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
    rc_reclaim(ptr);
}

// Introspection for spec tests / leak checks. Returns the number of currently
// live RC-managed allocations across the whole heap. NOT for production code
// paths.
//
// HARD-GATED ON AVRA_RC_STRICT (t-0ks0). Under strict this reads the dedicated
// rc_strict_allocs/rc_strict_frees pair, bumped on EVERY successful alloc and
// every reclaim — region and malloc paths alike — so the count sees all
// objects. Outside strict those counters never move (their increments are
// strict-gated), so a delta assertion would pass whether or not the code under
// test leaks — vacuously.
//
// That is not hypothetical: t-c6y7 closed three sub-cases as leak-free on
// "delta == 0 over 200 builds" for four different emitters. Positive control —
// 150 deliberately stranded objects held alive across the read — reads delta=0
// by default and delta=150 under AVRA_RC_STRICT=1. Four uniform zeros was a
// blind instrument, not four confirmations.
//
// Returning a sentinel would NOT fix this: any constant still yields a delta of
// zero between two reads, i.e. the same vacuous pass. The only safe failure
// mode is refusing to answer, so misuse surfaces as a loud error naming the fix
// instead of a green test. There are no non-strict callers to break.
int64_t avra_rc_live_count(void) {
    if (!avra_rc_strict) {
        avra_runtime_errorf(
            "avra_rc_live_count() requires AVRA_RC_STRICT=1 — outside strict mode it only "
            "counts malloc-fallback allocations, so bump-region objects are invisible and a "
            "leak assertion would pass vacuously. Re-run with AVRA_RC_STRICT=1, and pair the "
            "measurement with a positive control (strand N objects, assert the count moves by N).");
        exit(1);
    }
    // Region-backed strict allocations never enter rc_set, so the strict
    // count reads the dedicated alloc/free pair (bumped on BOTH paths) — the
    // positive-control contract (count moves by N for N stranded objects)
    // holds regardless of which path served an allocation.
    return atomic_load_explicit(&rc_strict_allocs, memory_order_relaxed)
         - atomic_load_explicit(&rc_strict_frees, memory_order_relaxed);
}
// (`avra_rc_strict_enabled()` already exists below, next to the strict
// self-test — a spec that needs a working counter gates on that and skips its
// measurement where the instrument has no signal, rather than tripping the
// error above.)

// Deterministic self-test for AVRA_RC_STRICT (spec: tests/rc_strict_test.av).
// Allocates an RC block, releases it to zero (reclaimed), then feeds the now
// STALE pointer back to a release path — the exact zm77 signature. Under
// AVRA_RC_STRICT this aborts with the foreign-release diagnostic; with the
// env var unset it is the historical silent no-op (the double-free guard), so
// the normal suite stays green. Returns 0 on the no-op path (strict mode
// aborts before returning). A test hook, like avra_rc_live_count above — not
// a codegen workaround.
int64_t avra_rc_strict_selftest_stale_release(void) {
    void* p = avra_rc_alloc(64);
    avra_rc_release(p);   // rc 1 → 0: reclaimed (strict: poisoned + quarantined)
    avra_rc_release(p);   // p is stale now: strict mode must catch this release
    return 0;
}

// Query whether AVRA_RC_STRICT is active (1) or not (0). Lets a test confirm
// strict mode is really on without a stderr banner (which would pollute
// output-capturing tests when the whole suite runs under strict).
int64_t avra_rc_strict_enabled(void) {
    return (int64_t)avra_rc_strict;
}

// Introspection sibling of avra_rc_strict_enabled, for the spec that pins the
// strict-over-region composition: strict mode must NOT disable the region
// (the historical all-malloc strict allocator was a measured 3.6x wall / 2x
// admission seed, and a silent regression to it would pass every behavioural
// test — just slowly). AVRA_RC_NO_REGION remains the deliberate opt-out.
int64_t avra_rc_region_active(void) {
    return (int64_t)rc_region_enabled;
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
            rc_reclaim(ptr);
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

// ── ICE localization (compile cursor) ──
// The self-hosted compiler maintains a "where am I" cursor as it walks the
// program, so an *internal* crash — a segfault or null-deref while bs2 is
// compiling source — reports the exact construct instead of an
// un-symbolizable self-host backtrace. Three layers, each self-installing
// at a central chokepoint so no feature can forget it:
//
//   phase    — resolve / typeck / codegen (one SET per pass)
//   fn stack — nested function/closure/impl-method trail (push/pop)
//   at       — current statement's file:line:col (one SET per statement)
//
// Everything is copied into fixed buffers (no dangling pointers into the
// arena), so the async-signal-safe crash handler can read it even after
// the heap is corrupt. Process-wide statics, written only from non-signal
// context — same carve-out as the rc/arena bookkeeping (one bs2 process;
// not threaded state). The fn-stack push/pop only needs to balance on the
// *non-crash* path; an in-flight crash leaves the frame on the stack,
// which is exactly what we want to print.
#define ICE_FN_STACK_MAX 512
#define ICE_NAME_MAX     128
#define ICE_FILE_MAX     256
static char    g_ice_phase[32]                         = "";
static char    g_ice_fn_stack[ICE_FN_STACK_MAX][ICE_NAME_MAX];
static int     g_ice_fn_depth                          = 0;
static char    g_ice_at_file[ICE_FILE_MAX]             = "";
static int64_t g_ice_at_line                           = 0;
static int64_t g_ice_at_col                            = 0;

static void ice_copy(char *dst, size_t cap, const char *src) {
    if (cap == 0) return;
    if (!src) { dst[0] = 0; return; }
    size_t i = 0;
    for (; src[i] && i < cap - 1; i++) dst[i] = src[i];
    dst[i] = 0;
}

// Set the current pass. Resets the fn stack + position — each pass
// starts fresh so the trail reflects only the active phase.
void avra_ice_phase(const char *phase) {
    ice_copy(g_ice_phase, sizeof g_ice_phase, phase);
    g_ice_fn_depth = 0;
    g_ice_at_file[0] = 0;
    g_ice_at_line = 0;
    g_ice_at_col = 0;
}

// Enter a function / closure / impl-method body.
void avra_ice_push_fn(const char *name) {
    if (g_ice_fn_depth >= 0 && g_ice_fn_depth < ICE_FN_STACK_MAX)
        ice_copy(g_ice_fn_stack[g_ice_fn_depth], ICE_NAME_MAX, name);
    g_ice_fn_depth++;  // count past the cap so deep nesting still balances
}

void avra_ice_pop_fn(void) {
    if (g_ice_fn_depth > 0) g_ice_fn_depth--;
}

// Deliberate F9999 ICE (ps3t.4.5(d), spec §6): an under-determined type
// (`ValueType.Unknown`) reached the LLVM layout boundary OUTSIDE an erased
// generic template. The compiler must resolve or hard-error — never guess a
// layout. Historically this silently returned i64, so a ptr-carrying value
// laid out as an int and corrupted memory at runtime. Now it is a first-class
// internal-compiler-error naming the offending function (from the ICE
// fn-stack) so the real bug surfaces at compile time instead of at runtime.
// Never returns (exits 99); typed `void*` only to satisfy the Avra call site.
void *avra_layout_unknown_ice(void) {
    const char *fn = "?";
    if (g_ice_fn_depth > 0) {
        int top = g_ice_fn_depth - 1;
        if (top >= ICE_FN_STACK_MAX) top = ICE_FN_STACK_MAX - 1;
        if (g_ice_fn_stack[top][0]) fn = g_ice_fn_stack[top];
    }
    safe_write("\n  error[F9999]: internal compiler error — under-determined type at the layout boundary\n");
    safe_write("    the compiler tried to choose an LLVM representation for an unresolved (`Unknown`) type,\n");
    safe_write("    but nothing bound it. Per spec §6 a layout is never guessed from an under-determined type.\n");
    if (g_ice_phase[0]) { safe_write("    phase: "); safe_write(g_ice_phase); safe_write("\n"); }
    safe_write("    in:    "); safe_write(fn); safe_write("\n");
    safe_write("    please report (include these lines): https://github.com/tristanMatthias/forge-lang/issues\n");
    exit(99);
    return NULL;  // unreachable
}

// Mark the statement currently being processed (file:line:col).
void avra_ice_at(const char *file, int64_t line, int64_t col) {
    ice_copy(g_ice_at_file, sizeof g_ice_at_file, file);
    g_ice_at_line = line;
    g_ice_at_col = col;
}

// Async-signal-safe: emit the cursor on a crash, formatted like a
// first-class diagnostic (F9999) so an internal crash reads like every
// other error — phase, the nested-function trail, and the precise span.
static void avra_print_ice_breadcrumb(void) {
    if (!g_ice_phase[0] && g_ice_fn_depth == 0 && !g_ice_at_file[0] && g_ice_at_line == 0)
        return;
    safe_write("\n  error[F9999]: internal compiler error — the compiler crashed, not your program\n");
    if (g_ice_phase[0]) {
        safe_write("    phase: ");
        safe_write(g_ice_phase);
        safe_write("\n");
    }
    if (g_ice_fn_depth > 0) {
        safe_write("    in:    ");
        int n = g_ice_fn_depth < ICE_FN_STACK_MAX ? g_ice_fn_depth : ICE_FN_STACK_MAX;
        for (int i = 0; i < n; i++) {
            if (i) safe_write(" \xE2\x96\xB8 ");  // ▸
            safe_write(g_ice_fn_stack[i][0] ? g_ice_fn_stack[i] : "?");
        }
        if (g_ice_fn_depth > ICE_FN_STACK_MAX) safe_write(" \xE2\x96\xB8 \xE2\x80\xA6");  // ▸ …
        safe_write("\n");
    }
    if (g_ice_at_file[0] || g_ice_at_line > 0) {
        safe_write("    at:    ");
        if (g_ice_at_file[0]) safe_write(g_ice_at_file);
        if (g_ice_at_line > 0) {
            char buf[48];
            int len = snprintf(buf, sizeof(buf), ":%lld:%lld", (long long)g_ice_at_line, (long long)g_ice_at_col);
            write(STDERR_FILENO, buf, len);
        }
        safe_write("\n");
    }
    safe_write("    please report (include these lines): https://github.com/tristanMatthias/forge-lang/issues\n");
}

// ─── AVRA_RC_STRICT foreign-release detector ────────────────────
// Reached from the RC retain/release/should_free no-op paths when `ptr` is
// NOT a live RC allocation. If it points into a freed-and-quarantined block
// this is a use-after-free / double-free / stale-pointer release — the zm77
// signature — so we abort, naming the offending context. Every other
// non-live pointer these paths legitimately see (NULL is pre-filtered by the
// callers; stack, text, foreign heap such as LLVM ValueRefs, bump-arena
// interiors) is not in the quarantine set, so this returns quietly and the
// historical no-op behaviour is preserved. Testing membership against blocks
// we actually froze — rather than guessing from an address range — is what
// makes strict mode false-positive-free on a clean suite.
static void avra_rc_strict_check(const char* op, void* ptr) {
    if (!ptr) return;
    if (!rc_quarantine_contains_user(ptr)) return;   // not one of our freed blocks
    safe_write("\nerror: AVRA_RC_STRICT: ");
    safe_write(op);
    safe_write(" received a pointer to freed RC memory\n  ptr = ");
    safe_write_ptr(ptr);
    safe_write("\n"
        "  A stale/garbage pointer to an object the runtime already reclaimed\n"
        "  reached a release path. This is the zm77 phantom-release class: in\n"
        "  production it silently corrupts memory (a later alias frees a live\n"
        "  object mid-use); strict mode makes it fatal HERE, at the first\n"
        "  offending release, instead of a multi-session watchpoint hunt.\n");
    avra_print_ice_breadcrumb();   // names the Avra phase / fn-trail / statement
    // C-level backtrace: names the releasing runtime + generated frames.
    void* frames[64];
    int n = backtrace(frames, 64);
    backtrace_symbols_fd(frames, n, STDERR_FILENO);
    abort();
}

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
            avra_print_ice_breadcrumb();
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

    avra_print_ice_breadcrumb();

    safe_write("\n");
    safe_write("  Suggestions:\n");
    safe_write("    - Check for null values passed to functions\n");
    safe_write("    - Rebuild with `make build-debug` (enables --debug-null) to name the exact null argument + function\n");
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
    // Alternate signal stack so the handler runs during stack overflow.
    // SIGSTKSZ is a runtime value on modern glibc (>= 2.34) so it can't
    // size a static array; allocate at install time from the runtime
    // SIGSTKSZ with a 256 KiB floor (the handler's crash-report path is
    // not trivial). The buffer lives for the process lifetime — never
    // freed, by design.
    size_t alt_stack_size = (size_t)SIGSTKSZ;
    if (alt_stack_size < 256 * 1024) alt_stack_size = 256 * 1024;
    static char* alt_stack = NULL;
    if (!alt_stack) alt_stack = (char*)malloc(alt_stack_size);
    stack_t ss = { .ss_sp = alt_stack, .ss_size = alt_stack_size, .ss_flags = 0 };
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

// Tail read: return only the bytes at or after `offset`, so a poller can
// read the new suffix of a growing file instead of re-reading from byte 0
// every tick (the O(N^2)-over-a-build re-read the spinner's progress
// drain hit). Returns "" for a missing/unreadable file, or when `offset`
// is at/past EOF (nothing new yet) — same empty-string contract as
// avra_selfhost_read_file's failure case, so callers branch on length.
// A negative offset is clamped to 0 (read the whole file).
const char* avra_selfhost_read_file_from(const char* path, int64_t offset) {
    FILE* f = fopen(path, "rb");
    if (!f) return "";
    if (offset < 0) offset = 0;
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    if (offset >= size) { fclose(f); return ""; }
    long tail = size - (long)offset;
    if (fseek(f, (long)offset, SEEK_SET) != 0) { fclose(f); return ""; }
    char* buf = (char*)malloc(tail + 1);
    size_t got = fread(buf, 1, tail, f);
    buf[got] = '\0';
    fclose(f);
    return buf;
}

// Whole-file writes land via a same-directory temp file + rename(2),
// so concurrent readers see the complete old content or the complete
// new content — never a truncated/interleaved hybrid. The test
// runner's parallel units share content-keyed cache files (fixture
// stdout, fp sidecars, results sidecars); before this, a reader
// overlapping a writer's fopen("wb") truncation window got a short
// read and failed flakily. rename within one directory is atomic on
// every platform we target.
static int avra_write_file_atomic(const char* path, const char* data, size_t len) {
    static _Atomic int64_t seq = 0;
    char tmp[4096];
    int64_t n = atomic_fetch_add(&seq, 1);
    if (snprintf(tmp, sizeof(tmp), "%s.tmp.%d.%lld", path, (int)getpid(), (long long)n)
            >= (int)sizeof(tmp)) {
        return 0;
    }
    FILE* f = fopen(tmp, "wb");
    if (!f) return 0;
    size_t wrote = fwrite(data, 1, len, f);
    if (fclose(f) != 0 || wrote != len) {
        remove(tmp);
        return 0;
    }
    if (rename(tmp, path) != 0) {
        remove(tmp);
        return 0;
    }
    return 1;
}

int64_t avra_selfhost_write_file(const char* path, const char* content) {
    return avra_write_file_atomic(path, content, strlen(content));
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
    int64_t len = *(int64_t*)b;
    if (len < 0) len = 0;
    return avra_write_file_atomic(path, b + 8, (size_t)len);
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

// Small-buffer optimization (SBO): the first AVRA_ARRAY_SBO slots live INLINE
// in the header, so a small array (the pervasive case — an AST node's few
// children, a call's args) is ONE malloc instead of two (header + data buffer)
// and never touches malloc for its backing at all. Only when it grows past the
// inline capacity does it heap-allocate a separate buffer. `data` points at
// `inline_buf` until then; the struct is never realloc'd (only `data` grows),
// so `inline_buf` is stable for the array's lifetime. AvraArray's layout is
// private to runtime.c — codegen treats a list as an opaque ptr and only calls
// avra_array_* — so widening the struct is transparent.
#define AVRA_ARRAY_SBO 8
typedef struct {
    int64_t* data;
    int64_t  len;
    int64_t  cap;
    int64_t  inline_buf[AVRA_ARRAY_SBO];
} AvraArray;

// Arrays service arbitrary user (Avra) programs, so an allocation failure gets a
// graceful diagnostic + exit (matching avra_rc_alloc) rather than an unguarded
// null-deref. Centralised so every array alloc/grow site is covered uniformly.
static void* avra_arr_xmalloc(size_t bytes) {
    avra_mem_poll();   // t-drl0: the other bulk allocator — list growth
    void* p = malloc(bytes);
    if (!p) { avra_runtime_errorf("out of memory (array alloc %zu bytes)", bytes); exit(1); }
    return p;
}
static void* avra_arr_xrealloc(void* old, size_t bytes) {
    avra_mem_poll();   // t-drl0: geometric growth is how a runaway list gets big
    void* p = realloc(old, bytes);
    if (!p) { avra_runtime_errorf("out of memory (array grow %zu bytes)", bytes); exit(1); }
    return p;
}

void* avra_array_new(void) {
    AvraArray* a = (AvraArray*)avra_arr_xmalloc(sizeof(AvraArray));   // single allocation
    a->cap = AVRA_ARRAY_SBO;
    a->len = 0;
    a->data = a->inline_buf;                                // backing lives inline
    return a;
}

void avra_array_push(void* arr, int64_t value) {
    AvraArray* a = (AvraArray*)arr;
    if (a->len >= a->cap) {
        int64_t newcap = a->cap * 2;
        if (a->data == a->inline_buf) {
            // First growth out of inline storage: malloc a real buffer + copy.
            int64_t* nd = (int64_t*)avra_arr_xmalloc((size_t)newcap * sizeof(int64_t));
            memcpy(nd, a->data, (size_t)a->len * sizeof(int64_t));
            a->data = nd;
        } else {
            a->data = (int64_t*)avra_arr_xrealloc(a->data, (size_t)newcap * sizeof(int64_t));
        }
        a->cap = newcap;
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

// Drop every element, keeping the allocation. `clear` has always been in the list
// method vocabulary (resolve/mod.av) but had no codegen, so reaching it was an ICE
// rather than a diagnostic; this is the missing primitive.
void avra_array_clear(void* arr) {
    if (!arr) return;
    ((AvraArray*)arr)->len = 0;
}

// Create a new array from a slice of an existing one.
void* avra_array_slice(void* arr, int64_t start, int64_t end) {
    AvraArray* src = (AvraArray*)arr;
    if (start < 0) start = 0;
    if (end > src->len) end = src->len;
    if (start >= end) return avra_array_new();

    int64_t count = end - start;
    AvraArray* dst = (AvraArray*)avra_arr_xmalloc(sizeof(AvraArray));
    dst->len = count;
    if (count <= AVRA_ARRAY_SBO) {
        dst->cap = AVRA_ARRAY_SBO;
        dst->data = dst->inline_buf;                        // small slice: no second malloc
    } else {
        dst->cap = count;
        dst->data = (int64_t*)avra_arr_xmalloc((size_t)dst->cap * sizeof(int64_t));
    }
    memcpy(dst->data, src->data + start, (size_t)count * sizeof(int64_t));
    return dst;
}

// Allocate a 2-slot i64 tuple buffer {a, b} matching the tuple memory
// model (a tuple `(a, b)` is a heap buffer of i64 slots; slot 0 = a,
// 1 = b), returned as an i64 handle. Shared by enumerate/zip.
static int64_t avra_make_pair(int64_t a, int64_t b) {
    int64_t* pair = (int64_t*)malloc(2 * sizeof(int64_t));
    pair[0] = a;
    pair[1] = b;
    return (int64_t)(uintptr_t)pair;
}

// Pair the index with each element: List<T> -> List<(int, T)>.
// Backs `xs.enumerate()` — the idiomatic replacement for the manual
// `mut i = 0; while i < xs.length { let x = xs[i]; …; i += 1 }` loop.
void* avra_array_enumerate(void* arr) {
    void* dst = avra_array_new();
    if (!arr) return dst;
    AvraArray* src = (AvraArray*)arr;
    for (int64_t i = 0; i < src->len; i++) {
        avra_array_push(dst, avra_make_pair(i, src->data[i]));
    }
    return dst;
}

// Parallel iteration: List<A>, List<B> -> List<(A, B)>, truncated to
// the shorter input (like Python's zip / Rust's Iterator::zip).
// Backs `a.zip(b)` — the idiomatic replacement for the manual
// `while i < min(a.length, b.length) { … a[i] … b[i] … }` loop.
void* avra_array_zip(void* a_, void* b_) {
    void* dst = avra_array_new();
    if (!a_ || !b_) return dst;
    AvraArray* a = (AvraArray*)a_;
    AvraArray* b = (AvraArray*)b_;
    int64_t n = a->len < b->len ? a->len : b->len;
    for (int64_t i = 0; i < n; i++) {
        avra_array_push(dst, avra_make_pair(a->data[i], b->data[i]));
    }
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

// ── Per-thread output sinks ─────────────────────────────────────
// Every byte of program stdout flows through avra_puts (codegen
// lowers `println` here) or avra_stdout_write. A thread with no
// sink installed writes straight to stdout — the only added cost
// is one thread-local load.
//
// Sinks form a per-thread STACK so output-capture windows nest:
// the spec runner pushes a frame around each test unit (grouping
// that unit's output for atomic printing), and the test capture
// API pushes a nested frame inside a spec. Capture isolation is
// per-thread by construction — no dup2, no process-wide fd swaps,
// no serializing mutex. The dup2-based predecessor redirected the
// process-wide STDOUT_FILENO, so any concurrently-running thread's
// output landed inside whichever capture window happened to be
// open. Per-thread sinks make that impossible by construction.
//
// Deliberate semantics, pinned by spec tests:
//   - Only the CURRENT thread's writes enter its sink. A thread
//     spawned inside a capture window writes to the real stdout
//     (fresh threads start sink-less), mirroring how subprocesses
//     behave under popen-based avra_shell_exec.
//   - stderr (avra_eprintln) is never sunk — diagnostics stay live.

typedef struct AvraSinkFrame {
    char* buf;
    size_t len;
    size_t cap;
    struct AvraSinkFrame* prev;
} AvraSinkFrame;

static _Thread_local AvraSinkFrame* t_sink = NULL;

static void sink_write(const char* s, size_t n) {
    AvraSinkFrame* f = t_sink;
    if (n == 0) return;
    if (f->len + n + 1 > f->cap) {
        size_t want = f->cap * 2;
        while (want < f->len + n + 1) want *= 2;
        f->buf = (char*)realloc(f->buf, want);
        f->cap = want;
    }
    memcpy(f->buf + f->len, s, n);
    f->len += n;
    f->buf[f->len] = '\0';
}

// Install a fresh capture frame on the current thread.
void avra_sink_push(void) {
    AvraSinkFrame* f = (AvraSinkFrame*)malloc(sizeof(AvraSinkFrame));
    f->cap = 4096;
    f->len = 0;
    f->buf = (char*)malloc(f->cap);
    f->buf[0] = '\0';
    f->prev = t_sink;
    t_sink = f;
}

// Pop the current thread's top frame, returning everything written
// while it was installed. Returns an rc string (same allocation
// discipline as every other runtime-produced Avra string).
const char* avra_sink_pop(void) {
    AvraSinkFrame* f = t_sink;
    if (!f) return "";
    t_sink = f->prev;
    char* out = (char*)avra_rc_alloc((int64_t)f->len + 1);
    memcpy(out, f->buf, f->len + 1);
    free(f->buf);
    free(f);
    return out;
}

// Discard frames until the stack matches `snapshot`. The crash
// guard uses this so a spec that dies inside a capture window
// doesn't leave orphan frames silently swallowing the next spec's
// output (the longjmp skips the balancing pop).
static void sink_unwind_to(AvraSinkFrame* snapshot) {
    while (t_sink && t_sink != snapshot) {
        AvraSinkFrame* f = t_sink;
        t_sink = f->prev;
        free(f->buf);
        free(f);
    }
}

// Shared writer: top sink frame when installed, else real stdout.
// The unsinked path flushes so out-of-band writers (crash lines,
// LSP framing) are never reordered behind stdio buffering.
static void avra_output_write(const char* s) {
    if (!s) return;
    if (t_sink) { sink_write(s, strlen(s)); return; }
    fputs(s, stdout);
    fflush(stdout);
}

// `println` lowering target. Historically println compiled to libc
// puts directly, which left the runtime no chokepoint over program
// output — the reason stdout capture had to resort to fd games.
// Same observable behavior as puts on the unsinked path.
void avra_puts(const char* s) {
    if (t_sink) {
        if (s) sink_write(s, strlen(s));
        sink_write("\n", 1);
        return;
    }
    puts(s ? s : "");
}

// Write a string to stdout exactly as-is — no trailing newline,
// no buffering tricks. Used by @std/lsp's JSON-RPC writer where the
// framing protocol requires precise byte counts.
void avra_stdout_write(const char* s) {
    avra_output_write(s);
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

// pdme.6: refresh a path's mtime to now (works on files and dirs).
// The cache layer calls this on HIT so mtime approximates last-USE,
// turning the age-based `cache prune` into an LRU: hot entries stay
// fresh however old their content is. Native (no `touch` fork, and no
// $PWD-derived path ever reaches a shell — the ohyd injection class).
// Returns 1 on success, 0 on failure (missing path, permissions).
int64_t avra_touch(const char* path) {
    if (!path) return 0;
    return utimensat(AT_FDCWD, path, NULL, 0) == 0 ? 1 : 0;
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
// Advisory file lock for cross-thread AND cross-process critical
// sections (flock is shared by both: threads contend via separate
// fds, processes via the file). The fixture-stdout cache uses this
// to serialize concurrent cold-misses on one fixture: bs2 emits the
// fixture's .ll/.o at FIXED sibling paths, so two simultaneous
// runs of the same fixture would race on those artifacts. Returns
// the lock fd (>= 0) or -1 on failure; pass the fd to
// avra_file_unlock to release. Locks are per-open-fd, so callers
// must thread the handle rather than re-opening the path.
// Held-lock bookkeeping mirrors the output-sink stack: a spec that
// crashes between lock and unlock longjmps past the balancing
// release, and a leaked flock would block every other unit touching
// that fixture for the life of the process (the stall detector would
// NAME the victims, but the suite still wedges). The crash guard
// releases everything acquired inside the crashed spec via
// avra_locks_unwind_to.
#define AVRA_HELD_LOCKS_MAX 16
static _Thread_local int64_t t_held_locks[AVRA_HELD_LOCKS_MAX];
static _Thread_local int t_held_locks_n = 0;

int64_t avra_file_lock_exclusive(const char* path) {
    int fd = open(path, O_CREAT | O_RDWR, 0644);
    if (fd < 0) return -1;
    if (flock(fd, LOCK_EX) != 0) {
        close(fd);
        return -1;
    }
    if (t_held_locks_n < AVRA_HELD_LOCKS_MAX) {
        t_held_locks[t_held_locks_n++] = fd;
    }
    return fd;
}

void avra_file_unlock(int64_t fd) {
    if (fd < 0) return;
    for (int i = t_held_locks_n - 1; i >= 0; i--) {
        if (t_held_locks[i] == fd) {
            for (int j = i; j < t_held_locks_n - 1; j++) {
                t_held_locks[j] = t_held_locks[j + 1];
            }
            t_held_locks_n--;
            break;
        }
    }
    flock((int)fd, LOCK_UN);
    close((int)fd);
}

// Release every lock acquired above `depth` — the crash guard's
// cleanup for specs that died inside a lock window.
static void avra_locks_unwind_to(int depth) {
    while (t_held_locks_n > depth) {
        int64_t fd = t_held_locks[--t_held_locks_n];
        flock((int)fd, LOCK_UN);
        close((int)fd);
    }
}

int64_t avra_rename(const char* src, const char* dst) {
    if (!src || !dst) return 0;
    return rename(src, dst) == 0 ? 1 : 0;
}

// This process's PID. Callers build a process-unique temp path
// (`<final>.tmp.<pid>`) to materialise an artifact then avra_rename it
// onto the final path — so a killed/OOM'd writer leaves only the temp,
// never a truncated final that a later cache HIT would serve (kaux).
// The test runner parallelises at the PROCESS level, so PID alone makes
// concurrent producers of the same slot land on distinct temps.
int64_t avra_getpid(void) {
    return (int64_t)getpid();
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

// Depth cap shared by the recursive cache walkers. A build cache is a handful
// of levels deep (build/cache/<hash>/...); 256 is far beyond any real tree and
// bounds both the C stack and the open-fd count (one DIR* is held per level
// while recursing). lstat (below) already prevents symlink loops, so the cap
// only ever fires on a pathological tree — where refusing is the safe answer.
#define AVRA_CACHE_WALK_MAX_DEPTH 256

static int64_t avra_remove_tree_rec(const char* path, int depth) {
    if (depth > AVRA_CACHE_WALK_MAX_DEPTH) return 0;  // too deep — refuse
    struct stat st;
    if (lstat(path, &st) != 0) return errno == ENOENT ? 1 : 0;  // ENOENT = already gone (ok); any other errno (EACCES/EIO/ELOOP/…) = it's still there, so fail
    if (!S_ISDIR(st.st_mode)) return unlink(path) == 0 ? 1 : 0;
    DIR* d = opendir(path);
    if (!d) return 0;  // can't enumerate → can't empty → report failure
    int ok = 1;
    struct dirent* e;
    while ((e = readdir(d)) != NULL) {
        if (e->d_name[0] == '.' && (e->d_name[1] == '\0' ||
            (e->d_name[1] == '.' && e->d_name[2] == '\0'))) continue;
        size_t len = strlen(path) + 1 + strlen(e->d_name) + 1;
        char* child = (char*)malloc(len);
        if (!child) { ok = 0; continue; }
        snprintf(child, len, "%s/%s", path, e->d_name);
        if (avra_remove_tree_rec(child, depth + 1) != 1) ok = 0;
        free(child);
    }
    closedir(d);
    if (!ok) return 0;  // a child survived — don't claim success
    return rmdir(path) == 0 ? 1 : 0;
}

// Recursively delete a directory tree (`rm -rf <path>` semantics). Used by
// `bs2 cache prune` to evict a stale cache entry without shelling out (a
// $PWD-derived path interpolated into a shell command is injectable). Uses
// lstat so a symlink is unlinked itself and never followed into its target.
// Refuses NULL/empty, `.`, `..`, and any path that collapses to the filesystem
// root, so a buggy caller can never recursively wipe the cwd or `/`. Returns 1
// on success (or when the path was already gone), 0 if ANY entry could not be
// removed (opendir/unlink/rmdir failure, OOM, or the depth cap) — so the caller
// can report a partial prune instead of silently claiming success.
int64_t avra_remove_tree(const char* path) {
    if (!path || !path[0]) return 0;
    if (strcmp(path, ".") == 0 || strcmp(path, "..") == 0) return 0;
    size_t n = strlen(path);
    while (n > 1 && path[n - 1] == '/') n--;       // collapse trailing slashes
    if (n == 1 && path[0] == '/') return 0;        // "/", "//", "///", …
    return avra_remove_tree_rec(path, 0);
}

static int64_t avra_dir_size_rec(const char* path, int depth) {
    if (depth > AVRA_CACHE_WALK_MAX_DEPTH) return 0;
    struct stat st;
    if (lstat(path, &st) != 0) return 0;
    if (!S_ISDIR(st.st_mode)) return S_ISREG(st.st_mode) ? (int64_t)st.st_size : 0;
    int64_t total = 0;
    DIR* d = opendir(path);
    if (!d) return 0;
    struct dirent* e;
    while ((e = readdir(d)) != NULL) {
        if (e->d_name[0] == '.' && (e->d_name[1] == '\0' ||
            (e->d_name[1] == '.' && e->d_name[2] == '\0'))) continue;
        size_t len = strlen(path) + 1 + strlen(e->d_name) + 1;
        char* child = (char*)malloc(len);
        if (!child) continue;
        snprintf(child, len, "%s/%s", path, e->d_name);
        total += avra_dir_size_rec(child, depth + 1);
        free(child);
    }
    closedir(d);
    return total;
}

// Recursive apparent-byte total for a directory tree, for `bs2 cache info`.
// lstat-based (a symlink contributes nothing, never its target's tree) and
// sums only REGULAR files — symlinks/FIFOs/devices/sockets contribute 0, so a
// device node's bogus st_size can't inflate the total. Returns total bytes, or
// 0 when the path is missing. (Apparent size — sum of st_size — not allocated
// blocks; close enough for a cache-size readout.)
int64_t avra_dir_size(const char* path) {
    if (!path) return 0;
    return avra_dir_size_rec(path, 0);
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
    if (!map) return 0;  // a null map reads as EMPTY, never a fault
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
    if (!map) return 0;  // a null map reads as EMPTY, never a fault
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
    if (!map) return avra_array_new();
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
// Remove a key. Two bugs lived here, both silent:
//
// 1. It hashed with djb2 while set/get/has hash with avra_hash_str
//    (FNV-1a). Remove therefore probed a different chain from the one
//    the key was stored on, hit an empty slot, and returned 0 having
//    deleted NOTHING. `map.remove(k)` (features/map_lit) was a no-op
//    for every Avra program, and internally it turned a shrink-to-
//    fixpoint loop into an infinite one.
// 2. Clearing the slot to NULL breaks LINEAR PROBING: any key that
//    collided and landed further along the chain becomes unreachable,
//    because the lookup stops at the hole. Deleting one key silently
//    deleted others, whenever the table had a collision.
//
// Fixed by hashing the same way as every other operation, and by
// backward-shift deletion — after clearing a slot, pull forward any
// following entry whose home position is at or before the hole, so
// no chain is ever left with a gap in the middle. That keeps the
// invariant avra_map_grow relies on (it re-inserts by walking slots).
int64_t avra_map_remove_cstr(void* map, const char* key) {
    if (!map || !key) return 0;
    AvraHashMap* m = (AvraHashMap*)map;
    int64_t idx = (int64_t)(avra_hash_str(key) % (uint64_t)m->cap);
    for (int64_t i = 0; i < m->cap; i++) {
        int64_t hole = (idx + i) % m->cap;
        if (!m->keys[hole]) return 0;
        if (strcmp(m->keys[hole], key) != 0) continue;

        free(m->keys[hole]);
        m->keys[hole] = NULL;
        m->values[hole] = 0;
        m->count--;

        // Backward-shift: walk forward, relocating any entry that would
        // otherwise be cut off from its home slot by the hole.
        int64_t j = hole;
        while (1) {
            j = (j + 1) % m->cap;
            if (!m->keys[j]) break;
            int64_t home = (int64_t)(avra_hash_str(m->keys[j]) % (uint64_t)m->cap);
            // Does `home` lie cyclically within (hole, j]? If so this entry
            // is already reachable past the hole and must stay put.
            int stays = (hole <= j) ? (home > hole && home <= j)
                                    : (home > hole || home <= j);
            if (stays) continue;
            m->keys[hole] = m->keys[j];
            m->values[hole] = m->values[j];
            m->keys[j] = NULL;
            m->values[j] = 0;
            hole = j;
        }
        return 1;
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

// Linear-probe lookup over the global lazy-comptime map. Returns the
// slot index where `qn` lives, or -1 when the map is uninitialised or
// the key isn't present. Used by get/has; set re-probes after its
// init+grow gate so it can insert into the post-grow capacity.
static int64_t lazy_comptime_probe(const char* qn) {
    if (!g_lazy_comptime) return -1;
    uint64_t idx = avra_hash_str(qn) % g_lazy_comptime->cap;
    while (g_lazy_comptime->keys[idx]) {
        if (strcmp(g_lazy_comptime->keys[idx], qn) == 0) return (int64_t)idx;
        idx = (idx + 1) % g_lazy_comptime->cap;
    }
    return -1;
}

void avra_lazy_comptime_set(const char* qn, const char* source) {
    if (!g_lazy_comptime) {
        g_lazy_comptime = (AvraHashMap*)avra_map_new_cstr();
    }
    if ((double)g_lazy_comptime->count / g_lazy_comptime->cap >= AVRA_MAP_LOAD_FACTOR) {
        avra_map_grow(g_lazy_comptime);
    }
    int64_t existing = lazy_comptime_probe(qn);
    if (existing >= 0) {
        // Overwrite: free the previous source dup, replace.
        free((char*)g_lazy_comptime->values[existing]);
        g_lazy_comptime->values[existing] = (int64_t)strdup(source);
        return;
    }
    uint64_t idx = avra_hash_str(qn) % g_lazy_comptime->cap;
    while (g_lazy_comptime->keys[idx]) idx = (idx + 1) % g_lazy_comptime->cap;
    g_lazy_comptime->keys[idx] = strdup(qn);
    g_lazy_comptime->values[idx] = (int64_t)strdup(source);
    g_lazy_comptime->count++;
}

const char* avra_lazy_comptime_get(const char* qn) {
    int64_t i = lazy_comptime_probe(qn);
    return i < 0 ? "" : (const char*)g_lazy_comptime->values[i];
}

int64_t avra_lazy_comptime_has(const char* qn) {
    return lazy_comptime_probe(qn) >= 0 ? 1 : 0;
}

// ─── 4szi.1 perf: in-process memo for the test_runner toolchain fp ──
// The toolchain fp is invariant for the entire bs2-test-runner process
// lifetime (the binary, its runtime, llvm_wrapper, AND std-avrac src
// can't change while we're running). Before this memo, every
// `cached_fixture_capture` call fed `read_or_compute_toolchain_fp`,
// which always shell-exec'd `find packages -newer sidecar -print -quit`
// to verify the sidecar — ~3-10ms of fork+exec per cache check, paid
// 100s of times per shard. With the memo, the first call computes,
// every later call returns the cached string in nanoseconds.
//
// Single-key memo (the fp is global to the process) — no hashmap
// needed. Write-once under a mutex: the fp is a pure function of
// process-stable inputs, so the first writer wins and the pointer
// is never freed after publish — concurrent getters (parallel test
// units warming the fixture cache simultaneously) can safely hold
// the returned pointer without copy or lock-on-read hazards.
static char* g_test_toolchain_fp_memo = NULL;
static pthread_mutex_t g_test_toolchain_fp_mutex = PTHREAD_MUTEX_INITIALIZER;

void avra_test_toolchain_fp_set(const char* fp) {
    pthread_mutex_lock(&g_test_toolchain_fp_mutex);
    if (!g_test_toolchain_fp_memo) g_test_toolchain_fp_memo = strdup(fp);
    pthread_mutex_unlock(&g_test_toolchain_fp_mutex);
}

const char* avra_test_toolchain_fp_get(void) {
    pthread_mutex_lock(&g_test_toolchain_fp_mutex);
    const char* v = g_test_toolchain_fp_memo;
    pthread_mutex_unlock(&g_test_toolchain_fp_mutex);
    return v ? v : "";
}

// ─── Int-keyed Map ────────────────────────────────────────────────
// Flat array indexed by int key. Perfect for enum tag → handler
// dispatch where keys are small sequential integers (0-63).
// Values are i64 (function pointers, struct pointers, etc.).

// Growable open-addressing int→int map. The historic fixed 256-slot
// table SILENTLY DROPPED the 257th insert (the probe loop exhausted
// every slot and returned without storing) — the type registry's
// id→name reverse map lost entries the moment a program registered
// more than 256 types, surfacing as "unknown struct" codegen errors
// for perfectly-registered types. Grows at 75% load; lookups stay
// O(1) expected.

#define AVRA_INTMAP_INITIAL_CAP 256

typedef struct {
    int64_t* keys;
    int64_t* values;
    int8_t*  occupied;
    size_t   cap;
    size_t   count;
} AvraIntMap;

static void intmap_alloc_slots(AvraIntMap* m, size_t cap) {
    m->keys = (int64_t*)calloc(cap, sizeof(int64_t));
    m->values = (int64_t*)calloc(cap, sizeof(int64_t));
    m->occupied = (int8_t*)calloc(cap, sizeof(int8_t));
    m->cap = cap;
    m->count = 0;
}

void* avra_intmap_new(void) {
    AvraIntMap* m = (AvraIntMap*)calloc(1, sizeof(AvraIntMap));
    intmap_alloc_slots(m, AVRA_INTMAP_INITIAL_CAP);
    return m;
}

static void intmap_insert_into(int64_t* keys, int64_t* values, int8_t* occupied,
                               size_t cap, int64_t key, int64_t value) {
    uint64_t slot = (uint64_t)key % cap;
    while (occupied[slot] && keys[slot] != key) {
        slot = (slot + 1) % cap;
    }
    if (!occupied[slot]) {
        keys[slot] = key;
        occupied[slot] = 1;
    }
    values[slot] = value;
}

static void intmap_grow(AvraIntMap* m) {
    size_t new_cap = m->cap * 2;
    int64_t* nk = (int64_t*)calloc(new_cap, sizeof(int64_t));
    int64_t* nv = (int64_t*)calloc(new_cap, sizeof(int64_t));
    int8_t* no = (int8_t*)calloc(new_cap, sizeof(int8_t));
    for (size_t i = 0; i < m->cap; i++) {
        if (m->occupied[i]) {
            intmap_insert_into(nk, nv, no, new_cap, m->keys[i], m->values[i]);
        }
    }
    free(m->keys);
    free(m->values);
    free(m->occupied);
    m->keys = nk;
    m->values = nv;
    m->occupied = no;
    m->cap = new_cap;
}

void avra_intmap_set(void* map, int64_t key, int64_t value) {
    AvraIntMap* m = (AvraIntMap*)map;
    if ((m->count + 1) * 4 >= m->cap * 3) intmap_grow(m);
    uint64_t slot = (uint64_t)key % m->cap;
    while (m->occupied[slot] && m->keys[slot] != key) {
        slot = (slot + 1) % m->cap;
    }
    if (!m->occupied[slot]) {
        m->keys[slot] = key;
        m->occupied[slot] = 1;
        m->count++;
    }
    m->values[slot] = value;
}

int64_t avra_intmap_get(void* map, int64_t key) {
    AvraIntMap* m = (AvraIntMap*)map;
    uint64_t slot = (uint64_t)key % m->cap;
    while (m->occupied[slot]) {
        if (m->keys[slot] == key) return m->values[slot];
        slot = (slot + 1) % m->cap;
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
    uint64_t slot = (uint64_t)key % m->cap;
    while (m->occupied[slot]) {
        if (m->keys[slot] == key) return 1;
        slot = (slot + 1) % m->cap;
    }
    return 0;
}

// ─── String Methods ───────────────────────────────────────────────
// All take const char* and return const char* or int64_t.
// Returned strings are heap-allocated (caller doesn't free in
// the bootstrap's GC-free model — acceptable for a compiler).

// String equality with a first-byte fast-reject. Codegen lowers a
// `match s { "a" -> …, "b" -> … }` to a SEQUENCE of these — one per arm —
// so a non-matching subject (the common case: an identifier that is not a
// keyword walks all ~60 keyword arms) pays a full strcmp per arm. The vast
// majority of those arms differ from the subject in byte 0, so a single
// char compare rejects them before the (AVX2-setup-heavy) strcmp call.
// Semantically identical to `strcmp(a,b)==0`: byte 0 equal is necessary for
// equality, and reading a[0]/b[0] is always valid on NUL-terminated strings
// (empty string ⇒ a[0]=='\0', handled by the strcmp fall-through). Returns
// 1 when equal, 0 otherwise.
int64_t avra_streq(const char* a, const char* b) {
    if (a == b) return 1;
    if ((unsigned char)a[0] != (unsigned char)b[0]) return 0;
    return strcmp(a, b) == 0 ? 1 : 0;
}

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

// One-pass line-start index for LineIndex construction: byte offsets where
// each line begins ([0, nl0+1, nl1+1, ...]). Replaces per-char `source[i]`
// scanning in Avra, whose bounds check re-derives strlen(source) on every
// access — quadratic in file size.
void* avra_str_line_starts(const char* s) {
    AvraArray* arr = avra_array_new();
    avra_array_push(arr, 0);
    const char* p = s;
    while ((p = strchr(p, '\n')) != NULL) {
        p++;
        avra_array_push(arr, (int64_t)(p - s));
    }
    return arr;
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

// Length-aware char_at: identical to avra_str_char_at, but the caller
// supplies the string's known length so the bounds check needs no strlen.
// Per-char scanners (the lexer) hold a fixed source and its length across
// an entire file, so threading `len` turns a per-character strlen — the
// dominant cost of every compile (measured at ~63% of instructions —
// __strlen_avx2, half of that from this very call) — into an O(1) index.
// The stored length is trusted; s is NOT re-measured.
const char* avra_str_char_at_len(const char* s, int64_t idx, int64_t len) {
    if (idx < 0 || idx >= len) {
        avra_runtime_errorf("string index %lld out of bounds (length %lld)",
                            (long long)idx, (long long)len);
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

// Length-aware substring: like avra_str_substring, but the caller supplies
// the source's known length so the end-clamp needs no strlen. The lexer
// slices each token out of a fixed source it already measured; without the
// threaded length every token extraction re-strlens the WHOLE file (the
// secondary half of the lexer's quadratic, after per-char access). `len` is
// trusted as an upper bound on valid indices; s is NOT re-measured.
const char* avra_str_substring_len(const char* s, int64_t start, int64_t end,
                                   int64_t len) {
    if (start < 0) start = 0;
    if (end < start) end = start;
    if (end > len) end = len;
    int64_t sub_len = end - start;
    char* r = (char*)avra_rc_alloc(sub_len + 1);
    memcpy(r, s + start, sub_len);
    r[sub_len] = '\0';
    return r;
}

// ── Codepoint-aware string ops ──
// The byte-indexed substring/length ops above split multibyte UTF-8
// sequences and miscount width for non-ASCII text. These two count and
// slice by Unicode CODEPOINT instead, so CLI truncation/padding never
// emits a torn codepoint and column math is right for narrow non-ASCII.
// (Display WIDTH — CJK/emoji occupying two columns — is a further step
// left to a wcwidth surface; codepoint count is the documented minimum.)
// A continuation byte is 10xxxxxx (0x80..0xBF); every other byte starts
// a codepoint. Malformed UTF-8 degrades gracefully — stray continuation
// bytes just aren't counted as starts, so the result never exceeds the
// byte length.

// Number of UTF-8 codepoints in `s` (not bytes).
int64_t avra_str_codepoint_count(const char* s) {
    int64_t n = 0;
    for (const unsigned char* p = (const unsigned char*)s; *p; p++) {
        if ((*p & 0xC0) != 0x80) n++;
    }
    return n;
}

// Substring by CODEPOINT index: codepoints [start, end). Clamps like the
// byte substring (start>=0, end>=start, indices past the end clamp to the
// string end). Returns a fresh null-terminated copy of the byte span those
// codepoints occupy. A codepoint's byte offset is recorded only at a
// BOUNDARY (a start byte or the terminator), so a multibyte sequence is
// never sliced through the middle.
const char* avra_str_substring_codepoints(const char* s, int64_t start, int64_t end) {
    if (start < 0) start = 0;
    if (end < start) end = start;
    int64_t cp = 0;
    size_t byte_start = SIZE_MAX, byte_end = SIZE_MAX;
    const unsigned char* base = (const unsigned char*)s;
    const unsigned char* p = base;
    for (;;) {
        int at_boundary = (*p == '\0') || ((*p & 0xC0) != 0x80);
        if (at_boundary) {
            // cp is the index of the codepoint that begins here.
            if (byte_start == SIZE_MAX && cp == start) byte_start = (size_t)(p - base);
            if (byte_end == SIZE_MAX && cp == end) byte_end = (size_t)(p - base);
            if (*p == '\0') break;
            cp++;
        }
        p++;
    }
    size_t str_end = (size_t)(p - base);  // byte length (p sits on the NUL)
    if (byte_start == SIZE_MAX) byte_start = str_end;   // start past the end
    if (byte_end == SIZE_MAX) byte_end = str_end;       // end past the end
    if (byte_end < byte_start) byte_end = byte_start;
    size_t sub_len = byte_end - byte_start;
    char* r = (char*)avra_rc_alloc(sub_len + 1);
    memcpy(r, s + byte_start, sub_len);
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
        int64_t newcap = a->cap * 2;
        if (newcap == 0) newcap = AVRA_ARRAY_SBO;
        if (a->data == a->inline_buf) {
            // Growing out of inline storage — realloc on inline_buf is UB.
            int64_t* nd = (int64_t*)avra_arr_xmalloc((size_t)newcap * sizeof(int64_t));
            memcpy(nd, a->data, (size_t)a->len * sizeof(int64_t));
            a->data = nd;
        } else {
            a->data = (int64_t*)avra_arr_xrealloc(a->data, (size_t)newcap * sizeof(int64_t));
        }
        a->cap = newcap;
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
    // Check stack (rough heuristic — stack is near sp). The address of a
    // local is a portable approximation of the current stack pointer, so
    // no arch-specific inline asm is needed (ARM64 `sp` isn't a valid
    // x86-64 register name).
    {
        uintptr_t sp_anchor;
        uintptr_t sp = (uintptr_t)&sp_anchor;
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


// ── stderr tee (j568) ─────────────────────────────────────────────
// The compile-cache must preserve a compile's DIAGNOSTICS, not just its
// .ll: fixture tests shell out to `bs2 compile` and assert specific
// diagnostic text (`no @comptime fn named …`, `is not a valid child of
// …`). A cache HIT that returned the .ll silently dropped those, so
// /tmp fixtures were excluded from caching entirely. The tee captures a
// compile's stderr into a buffer the cache stores, then replays it on a
// hit — diagnostics are observable output, so the cache preserves them.
//
// Distinct from the sink (avra_sink_*) BY DESIGN: the sink DIVERTS
// stdout and deliberately never touches stderr ("diagnostics stay
// live"). The tee does NOT divert — every teed line still prints live
// to stderr exactly as before; the tee only ADDITIONALLY accumulates a
// copy. So a first (miss) compile shows its diagnostics live AND stores
// them; a later (hit) compile replays the stored copy. Every Avra
// `eprintln` lowers to avra_eprintln (the sole stderr chokepoint), so
// teeing here captures DiagnosticBag renders and raw eprintlns alike.
typedef struct AvraStderrTee {
    char* buf;
    size_t len;
    size_t cap;
} AvraStderrTee;

static _Thread_local AvraStderrTee* t_etee = NULL;

// Begin capturing stderr on the current thread. A compile is single-
// shot and non-nested, so a stray begin without a matching end just
// replaces the frame rather than stacking (no leak, no orphan).
void avra_stderr_tee_begin(void) {
    if (t_etee) { free(t_etee->buf); free(t_etee); }
    AvraStderrTee* t = (AvraStderrTee*)malloc(sizeof(AvraStderrTee));
    t->cap = 4096;
    t->len = 0;
    t->buf = (char*)malloc(t->cap);
    t->buf[0] = '\0';
    t_etee = t;
}

static void etee_append(const char* s, size_t n) {
    AvraStderrTee* t = t_etee;
    if (!t || n == 0) return;
    if (t->len + n + 1 > t->cap) {
        size_t want = t->cap * 2;
        while (want < t->len + n + 1) want *= 2;
        t->buf = (char*)realloc(t->buf, want);
        t->cap = want;
    }
    memcpy(t->buf + t->len, s, n);
    t->len += n;
    t->buf[t->len] = '\0';
}

// Stop capturing; return everything teed while it was active (rc
// string, same allocation discipline as avra_sink_pop). "" when no
// tee was active or nothing was written.
const char* avra_stderr_tee_end(void) {
    AvraStderrTee* t = t_etee;
    if (!t) return "";
    t_etee = NULL;
    char* out = (char*)avra_rc_alloc((int64_t)t->len + 1);
    memcpy(out, t->buf, t->len + 1);
    free(t->buf);
    free(t);
    return out;
}

// Write a string to stderr VERBATIM — no trailing newline, no tee.
// j568 uses this to replay a cached compile's captured diagnostics on
// a cache hit: the captured text already carries each line's newline,
// so replaying it raw reproduces the original stderr byte-for-byte.
// Deliberately does NOT tee — a replay is not a fresh diagnostic.
void avra_stderr_write_raw(const char* s) {
    if (!s) return;
    fputs(s, stderr);
    fflush(stderr);
}

// ── eprintln: write string + newline to stderr ──
void avra_eprintln(const char* s) {
    fputs(s, stderr);
    fputc('\n', stderr);
    // Tee a copy (with the same trailing newline) when a capture window
    // is open. Live output above is untouched — the tee never diverts.
    if (t_etee) {
        etee_append(s, strlen(s));
        etee_append("\n", 1);
    }
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
// pdme.1: the mtime is reported at NANOSECOND granularity. Whole-second
// mtimes made the sha sidecar trust a stale hash whenever a file was
// rewritten with the same size within the same second — the exact
// mtime-tie disease 41ul documented for `find -newer`, resurfacing here
// as "revert an edit, fingerprints keep the edited value". Sub-second
// edit→compile cycles are the norm for tooling-driven loops, so ties
// were common, not exotic. Existing whole-second sidecar envelopes
// simply mismatch once and re-hash — self-healing.
static int avra_stat_mtime_size(const char* path, long* mtime_out, long* size_out) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
#ifdef __APPLE__
    *mtime_out = (long)st.st_mtimespec.tv_sec * 1000000000L + (long)st.st_mtimespec.tv_nsec;
#else
    *mtime_out = (long)st.st_mtim.tv_sec * 1000000000L + (long)st.st_mtim.tv_nsec;
#endif
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
    char rec[128];
    int rl = snprintf(rec, sizeof(rec), "%ld %ld\n%s\n", mtime, size, hex);
    if (rl > 0 && rl < (int)sizeof(rec)) {
        // Atomic publish: a reader racing this write must validate
        // against either the old record or the new one, never a torn
        // hybrid that happens to scan as plausible.
        avra_write_file_atomic(sidecar, rec, (size_t)rl);
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

const char* avra_validate_not_empty(const char* s, const char* name) {
    if (!s || strlen(s) == 0) {
        avra_runtime_errorf("%s must not be empty", name);
        exit(1);
    }
    return s;
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

// vez6.4szi: in-process stdout capture. Replaces fixture tests that
// fork bs2 to grep stdout. Built on the per-thread sink stack: the
// closure's println traffic lands in a fresh frame, popped verbatim.
// Nesting works because frames stack; concurrent captures on other
// threads are isolated by construction (each thread has its own
// stack). If the closure crashes under a spec guard, the guard's
// sink_unwind_to reclaims the unbalanced frame.
const char* avra_capture_stdout(int64_t closure) {
    avra_sink_push();
    avra_closure_call_0(closure);
    return avra_sink_pop();
}

// Stdout TTY check — gates the build progress bar so CI logs (which
// pipe stdout) don't get polluted with \r-rewriting escape codes.
// 1 if interactive, 0 if pipe/file. Mirrors POSIX isatty(STDOUT_FILENO).
int64_t avra_isatty_stdout(void) {
    return isatty(STDOUT_FILENO) ? 1 : 0;
}

// Online core count — sizes the in-process test runner's default
// worker pool. 0 on failure (callers fall back to a fixed default).
int64_t avra_cpu_count(void) {
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return (n > 0) ? (int64_t)n : 0;
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

// Drain BOTH of a child's pipes CONCURRENTLY into malloc'd strings.
//
// WHY this is not two sequential `read_fd_all` calls (t-flai): a pipe holds
// 64KB. Read stdout to EOF first and a child that fills stderr BLOCKS in
// write() — so it never exits, never closes stdout, and the first read waits
// for an EOF that can only arrive after the second read that it precedes.
// A guaranteed deadlock, gated purely on output volume. Observed live: a
// `bs2 test` @std prebuild hung 2h+ at static RSS with the child parked in
// `anon_pipe_write` after emitting 2.19MB of warnings to stderr, while the
// parent sat in read() on stdout.
//
// poll() both, drain whichever is ready, retire each on EOF. Neither stream
// can starve the other, so the ordering dependency is gone rather than
// merely made less likely. (`avra_process_run`'s timeout path already had
// this shape — the bug was only ever in the paths that skipped it.)
static void drain_two_fds(int out_fd, int err_fd, char** out_str, char** err_str) {
    struct pollfd fds[2] = {{out_fd, POLLIN, 0}, {err_fd, POLLIN, 0}};
    char* bufs[2] = {(char*)malloc(8192), (char*)malloc(8192)};
    size_t caps[2] = {8192, 8192};
    size_t lens[2] = {0, 0};
    int open_fds = 2;
    while (open_fds > 0) {
        int ret = poll(fds, 2, -1);
        if (ret < 0) {
            if (errno == EINTR) continue;
            break;  // unrecoverable — hand back what was captured
        }
        for (int i = 0; i < 2; i++) {
            if (fds[i].fd < 0 || fds[i].revents == 0) continue;
            // Keep a full pipe-buffer of headroom so MB-scale streams are
            // read in big chunks, not in the shrinking tail of a full buffer.
            if (caps[i] - lens[i] < 4096) {
                caps[i] *= 2;
                bufs[i] = (char*)realloc(bufs[i], caps[i]);
            }
            ssize_t n = read(fds[i].fd, bufs[i] + lens[i], caps[i] - lens[i] - 1);
            if (n < 0 && (errno == EINTR || errno == EAGAIN)) continue;
            if (n <= 0) { fds[i].fd = -1; open_fds--; continue; }
            lens[i] += (size_t)n;
        }
    }
    bufs[0][lens[0]] = '\0';
    bufs[1][lens[1]] = '\0';
    *out_str = bufs[0];
    *err_str = bufs[1];
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
// The async Process API (avra_process_spawn_bg/wait/kill) is reachable from the
// parallel test runner's WORKER THREADS (a test file that spawns a background
// process runs as a @deferred_init unit on a worker thread, d4jv). Without this
// lock, two concurrent spawns raced on the non-atomic `next_process_id++` and
// could get the SAME id → the SAME slot → one silently overwrote the other's
// entry, so a later wait/kill read the wrong pid/fds (wrong exit code). The
// entry writes/reads are guarded too so a lookup can't observe a half-written
// slot. Uncontended cost is ~20ns against a fork+exec (~ms), so no g_rc_-style
// gating is needed. NOTE: the id%MAX_PROCESSES slot mapping still collides once
// >256 processes are concurrently live — a separate pre-existing bound, not this
// race; real suites stay well under it.
static pthread_mutex_t process_registry_mutex = PTHREAD_MUTEX_INITIALIZER;

static int64_t registry_add(pid_t pid, int stdout_fd, int stderr_fd) {
    pthread_mutex_lock(&process_registry_mutex);
    int64_t id = next_process_id++;
    int slot = (int)(id % MAX_PROCESSES);
    process_registry[slot].pid = pid;
    process_registry[slot].stdout_fd = stdout_fd;
    process_registry[slot].stderr_fd = stderr_fd;
    process_registry[slot].alive = 1;
    process_registry[slot].cached_exit_code = INT_MIN;
    pthread_mutex_unlock(&process_registry_mutex);
    return id;
}

// Snapshot the entry for `id` under the lock — callers use the COPY, never a
// raw pointer into the shared registry, so a concurrent add/remove on the slot
// can't race their (possibly blocking) use of it. Returns 1 and fills *out when
// the slot is live, 0 otherwise. The fields callers then read — pid, stdout_fd,
// stderr_fd — are set once at registry_add and never mutated in place; alive /
// cached_exit_code are the only mutable fields, and the one in-place update
// goes through registry_set_reaped below.
static int registry_snapshot(int64_t id, ProcessEntry* out) {
    pthread_mutex_lock(&process_registry_mutex);
    int slot = (int)(id % MAX_PROCESSES);
    int found = process_registry[slot].pid != 0;
    if (found) *out = process_registry[slot];
    pthread_mutex_unlock(&process_registry_mutex);
    return found;
}

// Record a WNOHANG-reaped child's exit code (avra_process_is_alive) so a later
// avra_process_wait returns the real status instead of -1. Locked in-place.
static void registry_set_reaped(int64_t id, int exit_code) {
    pthread_mutex_lock(&process_registry_mutex);
    int slot = (int)(id % MAX_PROCESSES);
    if (process_registry[slot].pid != 0) {
        process_registry[slot].alive = 0;
        process_registry[slot].cached_exit_code = exit_code;
    }
    pthread_mutex_unlock(&process_registry_mutex);
}

static void registry_remove(int64_t id) {
    pthread_mutex_lock(&process_registry_mutex);
    int slot = (int)(id % MAX_PROCESSES);
    process_registry[slot].pid = 0;
    process_registry[slot].alive = 0;
    pthread_mutex_unlock(&process_registry_mutex);
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

    // No timeout: drain both concurrently, then wait
    char *out_str, *err_str;
    drain_two_fds(stdout_fd, stderr_fd, &out_str, &err_str);
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
    ProcessEntry e;
    if (!registry_snapshot(handle, &e) || !e.alive) return 0;
    kill(e.pid, SIGKILL);
    waitpid(e.pid, NULL, 0);
    close(e.stdout_fd);
    close(e.stderr_fd);
    registry_remove(handle);   // clears alive + pid (the old in-place e->alive=0 was redundant)
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
    ProcessEntry e;
    if (!registry_snapshot(handle, &e)) return make_result_json("", "process not found", -1);
    char *out_str, *err_str;
    drain_two_fds(e.stdout_fd, e.stderr_fd, &out_str, &err_str);
    close(e.stdout_fd);
    close(e.stderr_fd);
    int code;
    if (e.cached_exit_code != INT_MIN) {
        code = e.cached_exit_code;
    } else {
        int status;
        waitpid(e.pid, &status, 0);
        code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    }
    registry_remove(handle);
    const char* result = make_result_json(out_str, err_str, code);
    free(out_str); free(err_str);
    return result;
}

/// Read a line from a spawned process's stdout. Returns "\0EOF" at end.
const char* avra_process_read_line(int64_t handle) {
    ProcessEntry e;
    if (!registry_snapshot(handle, &e)) return "\0EOF";
    char buf[4096];
    size_t pos = 0;
    while (pos < sizeof(buf) - 1) {
        ssize_t n = read(e.stdout_fd, &buf[pos], 1);
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
    ProcessEntry e;
    if (!registry_snapshot(handle, &e)) return 0;
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

        struct pollfd pfd = {e.stdout_fd, POLLIN, 0};
        int64_t remaining = (deadline.tv_sec - now.tv_sec) * 1000 + (deadline.tv_nsec - now.tv_nsec) / 1000000;
        if (remaining <= 0) return 0;
        int ret = poll(&pfd, 1, (int)(remaining > 1000 ? 1000 : remaining));
        if (ret <= 0) continue;

        ssize_t n = read(e.stdout_fd, &line[pos], 1);
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
    ProcessEntry e;
    if (!registry_snapshot(handle, &e) || !e.alive) return 0;
    int status;
    pid_t result = waitpid(e.pid, &status, WNOHANG);
    if (result == 0) return 1; // still running
    registry_set_reaped(handle, WIFEXITED(status) ? WEXITSTATUS(status) : -1);
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

    char *out_str, *err_str;
    drain_two_fds(stdout_fd, stderr_fd, &out_str, &err_str);
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

// ── Comptime execution budget (ps3t.5.4) ──
// The tree-walk interpreter is shared between compile-time folding/expansion
// and runtime program execution (bs2 run / spec tests). A @comptime fn MUST
// terminate, but a runtime program's loops are unbounded — so the comptime
// loop ceiling is enforced ONLY while a comptime fold/macro is on the stack.
// The fold + macro entry points bracket their eval with enter/leave; the
// interpreter's `while` executor checks `active` and, when set, caps iterations.
// THREAD-LOCAL (o092): a comptime fold/macro is on the stack of exactly ONE
// thread, and the in-process parallel test runner (d4jv) runs test files on
// worker THREADS that each do their own in-process folds. A process-global
// counter let one worker's in-flight fold (depth>0) make ANOTHER worker's
// `avra_comptime_active()` check see "comptime active" — so a plain runtime loop
// on the second worker was wrongly capped by the comptime ceiling. Per-thread
// state isolates the workers (and is race-free within a thread, so no atomics).
// Single-threaded bs2 is unaffected (thread-local ≡ global for one thread).
static _Thread_local int64_t avra_comptime_depth_v = 0;
// ps3t.5.4 memory bound: cumulative bytes allocated (via avra_rc_alloc) while a
// comptime fold/macro is on the stack, and a sticky "exceeded" flag the
// interpreter polls. Reset when the OUTERMOST fold begins (depth 0→1), so each
// top-level comptime evaluation gets a fresh budget; nested (transitive) enters
// don't reset it. Bounds a runaway comptime that builds unbounded collections/
// strings — traps with a diagnostic instead of OOM-ing the compiler. Thread-local
// alongside the depth: the budget is per-fold, and folds are per-thread.
static _Thread_local int64_t avra_comptime_bytes_v = 0;
static _Thread_local int64_t avra_comptime_mem_exceeded_v = 0;
void avra_comptime_enter(void) {
    if (avra_comptime_depth_v++ == 0) {
        avra_comptime_bytes_v = 0;
        avra_comptime_mem_exceeded_v = 0;
    }
}
void avra_comptime_leave(void) { avra_comptime_depth_v--; }
int64_t avra_comptime_active(void) { return avra_comptime_depth_v > 0 ? 1 : 0; }
// o092: snapshot/restore the per-thread comptime depth around the per-spec crash
// guard — a caught crash (siglongjmp) unwinds past a pending avra_comptime_leave,
// so restore the pre-spec depth on the crash path (mirrors the guard's existing
// sink/lock unwinds). Same translation unit, but exposed so the guard reads it
// through a stable name.
int64_t avra_comptime_depth_snapshot(void) { return avra_comptime_depth_v; }
void avra_comptime_depth_restore(int64_t v) { avra_comptime_depth_v = v; }

// Per-fold comptime allocation ceiling (bytes). A runaway comptime that builds
// an unbounded collection/string trips this before it can OOM the compiler.
// Overridable via AVRA_COMPTIME_MEM_LIMIT (mainly for tests, which set it low to
// trip fast); read once, cached. Default 256 MiB — generous enough that no real
// fold trips it.
int64_t avra_comptime_mem_limit(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    const char* e = getenv("AVRA_COMPTIME_MEM_LIMIT");
    int64_t v = (e && *e) ? strtoll(e, NULL, 10) : (256LL * 1024 * 1024);
    if (v <= 0) v = 256LL * 1024 * 1024;
    atomic_store(&cached, v);
    return v;
}

// Charge `bytes` against the comptime allocation budget and latch the exceeded
// flag once the running total passes the ceiling. Called from avra_rc_alloc when
// a fold is active. Cheap (two atomics) and only on the comptime path.
static void avra_comptime_charge(int64_t bytes) {
    avra_comptime_bytes_v += bytes;
    if (avra_comptime_bytes_v > avra_comptime_mem_limit()) {
        avra_comptime_mem_exceeded_v = 1;
    }
}

// True once the active fold has allocated past the ceiling. The interpreter
// polls this per statement and traps (→ F4007) instead of continuing to OOM.
int64_t avra_comptime_mem_exceeded(void) { return avra_comptime_mem_exceeded_v; }

// ─── Process memory ceiling (t-drl0) ─────────────────────────────
//
// The comptime budget above bounds ONE fold. This is its process-wide sibling:
// it bounds the whole compiler, so a runaway anywhere — a quadratic re-lex, a
// pathological monomorphization, an unbounded collection — reports a diagnostic
// and exits, instead of being SIGKILLed by the kernel's OOM killer.
//
// WHY THIS LIVES IN THE COMPILER AND NOT IN A WRAPPER SCRIPT: an external
// watchdog can only observe the process from outside, so it kills a black box.
// It cannot name the phase, cannot be tested, cannot ship to users, and on a
// small box it races the kernel — which frequently wins and takes the whole
// container down with it. A ceiling the compiler enforces itself turns "the
// machine died" into a normal, reproducible compiler error with an F-code.
//
// MEASURED, NOT ACCOUNTED: we poll real RSS from /proc/self/statm rather than
// instrumenting every allocation. Two reasons. (1) Accuracy: the compiler links
// LLVM, which allocates through C++ `new` and never touches avra_rc_alloc — an
// allocation-accounting scheme would miss the single largest consumer. RSS sees
// every byte, whoever allocated it. (2) Cost: charging every alloc pays on the
// hottest path in the compiler; polling once every 1<<16 allocations makes the
// check a single relaxed increment plus a rare ~2µs file read.
//
// Default ceiling: 75% of MemAvailable sampled at first use — i.e. "most of
// what this box can actually give us", so a legitimately heavy build still
// completes while a runaway trips before the kernel notices. AVRA_MEM_LIMIT_MB
// overrides it; 0 disables the ceiling entirely.
#define AVRA_MEM_POLL_MASK ((int64_t)0xFFFF)   // poll every 65536 allocations

static _Atomic int64_t avra_mem_poll_ctr = 0;
static _Atomic int64_t avra_mem_tripped = 0;
static _Atomic int64_t avra_mem_peak_kb = 0;
// Phase label for the report — set by the compiler as it moves through its
// passes, so the diagnostic can say WHERE the memory went. Plain pointer to a
// string literal / leaked copy; read-mostly, single writer.
//
// Seeded with a real label rather than NULL: a ceiling low enough to trip during
// process start-up (registry construction, before any pass stamps itself) would
// otherwise report with no phase at all, which reads like the phase machinery is
// broken. "startup" is the honest answer for that window.
static _Atomic(const char*) avra_mem_phase = "startup (before parse)";

// Resident set size in KiB, or -1 where /proc is unavailable (non-Linux).
//
// RAW SYSCALLS, NOT stdio. This runs from inside avra_rc_alloc — the allocator's
// hot path — so `fopen` is doubly wrong there: it MALLOCS (the stream buffer),
// which re-enters the allocator we were called from, and it takes stdio locks. In
// the in-process parallel test runner that is a lock held across threads on the
// hottest path in the compiler; and the spec crash guard `siglongjmp`s out of
// deliberate SIGABRT/SIGFPE, which can unwind straight past an `fclose` and strand
// both the lock and the fd. open/read/close allocate nothing, lock nothing, and are
// safe to abandon mid-flight. (The first version of this used fopen/fscanf and the
// crash-isolation specs went red in the parallel suite while passing in isolation —
// the signature of exactly this.)
static int64_t avra_mem_rss_kb(void) {
#ifdef __linux__
    int fd = open("/proc/self/statm", O_RDONLY | O_CLOEXEC);
    if (fd < 0) return -1;
    char buf[128];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return -1;
    buf[n] = '\0';
    // "<size> <resident> …" — skip the first field, parse the second.
    const char* p = buf;
    while (*p == ' ') p++;
    while (*p >= '0' && *p <= '9') p++;
    while (*p == ' ') p++;
    int64_t resident_pages = 0;
    if (!(*p >= '0' && *p <= '9')) return -1;
    while (*p >= '0' && *p <= '9') { resident_pages = resident_pages * 10 + (*p - '0'); p++; }
    return resident_pages * (int64_t)(sysconf(_SC_PAGESIZE) / 1024);
#elif defined(__APPLE__)
    // macOS has no /proc: resident size comes from the Mach task info port.
    // Without this the whole F4014 ceiling was dead here (avra_mem_rss_kb
    // returned -1, which reads as "unknown" and disables the check), so a
    // runaway had no backstop AND memory_ceiling_test could never trip —
    // its deliberately-runaway compile ran to completion instead of being
    // stopped, taking 778s of a 814s suite. Same allocation-free, lock-free
    // discipline as the Linux path: one syscall, no malloc, safe to abandon.
    mach_task_basic_info_data_t info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO,
                  (task_info_t)&info, &count) != KERN_SUCCESS) return -1;
    return (int64_t)(info.resident_size / 1024);
#else
    return -1;
#endif
}

// One /proc/meminfo field in KiB; 0 when unknown.
// Raw syscalls for the same reason as avra_mem_rss_kb: this is reached from the
// allocator's hot path (via the ceiling's lazy init) and must not re-enter malloc.
static int64_t avra_meminfo_kb(const char* key) {
#ifdef __linux__
    int fd = open("/proc/meminfo", O_RDONLY | O_CLOEXEC);
    if (fd < 0) return 0;
    char buf[4096];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return 0;
    buf[n] = '\0';
    const char* p = strstr(buf, key);
    if (!p) return 0;
    p += strlen(key);                          // past the key
    while (*p == ' ' || *p == '\t') p++;
    int64_t out = 0;
    if (!(*p >= '0' && *p <= '9')) return 0;
    while (*p >= '0' && *p <= '9') { out = out * 10 + (*p - '0'); p++; }
    return out;                                // /proc/meminfo reports kB
#else
    (void)key;
    return 0;
#endif
}

// What the kernel thinks we can still get without swapping. 0 when unknown.
static int64_t avra_mem_available_kb(void) { return avra_meminfo_kb("MemAvailable:"); }

// The box's total RAM. 0 when unknown. Unlike MemAvailable this does not move
// under load, which is exactly why the ceiling floors itself against it.
static int64_t avra_mem_total_kb(void) { return avra_meminfo_kb("MemTotal:"); }

// MemAvailable in MB for Avra-side schedulers (t-kdyj.1): the shard pool
// samples this at every admission decision, so it must stay a couple of raw
// syscalls — never a shell fork. -1 when unknown (non-Linux, or the read
// failed) so callers fall back to their static behaviour.
int64_t avra_mem_available_mb(void) {
    int64_t kb = avra_mem_available_kb();
    return (kb > 0) ? kb / 1024 : -1;
}

// ── Portable resource snapshot (uzs9.10) ─────────────────────────────
//
// Build and test schedulers need one semantic answer — usable memory, CPU
// capacity, pressure, and scope — rather than platform conditionals. Linux
// prefers the current cgroup's finite limit and PSI. macOS exposes host VM
// availability plus the supported libdispatch memory-pressure source. Every
// function returns -1/0 when a capability is genuinely unavailable; callers
// must be conservative instead of pretending unlike kernel counters match.

#ifdef __linux__
static pthread_once_t avra_cgroup_v2_once = PTHREAD_ONCE_INIT;
static char avra_cgroup_v2_dir[PATH_MAX];
// The controller mount point — the STOP boundary for the ancestor walk
// (t-kdyj.11). Without it a walk up from the leaf would climb out of the
// cgroup filesystem entirely.
static char avra_cgroup_v2_mount_dir[PATH_MAX];

// Find the v2 hierarchy's root and mountpoint from mountinfo. `/sys/fs/cgroup`
// is common but not guaranteed in containers, so treating it as an API would
// make the controller silently use host values in exactly the environments
// where cgroup limits matter most. mountinfo paths are kernel-produced and
// normally have no escaped whitespace; unsupported escaped paths safely fall
// back to the usual mountpoint below.
static int avra_cgroup_v2_mount(char* root, size_t root_cap, char* mount, size_t mount_cap) {
    int fd = open("/proc/self/mountinfo", O_RDONLY | O_CLOEXEC);
    if (fd < 0) return 0;
    char buf[65536];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return 0;
    buf[n] = '\0';
    char* line = buf;
    while (line && *line) {
        char* eol = strchr(line, '\n');
        if (eol) *eol = '\0';
        if (strstr(line, " - cgroup2 ") != NULL) {
            char found_root[PATH_MAX];
            char found_mount[PATH_MAX];
            // Fields 4 and 5 in mountinfo are the hierarchy root and mount
            // point. The preceding three fields never contain whitespace.
            if (sscanf(line, "%*s %*s %*s %1023s %1023s", found_root, found_mount) == 2) {
                snprintf(root, root_cap, "%s", found_root);
                snprintf(mount, mount_cap, "%s", found_mount);
                return 1;
            }
        }
        line = eol ? eol + 1 : NULL;
    }
    return 0;
}

// Locate this process's unified cgroup. Failure simply leaves the resource
// backend at host scope. This is deliberately a one-time read because
// admission samples run frequently while dispatching a pool.
static void avra_cgroup_v2_init(void) {
    int fd = open("/proc/self/cgroup", O_RDONLY | O_CLOEXEC);
    if (fd < 0) return;
    char buf[4096];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return;
    buf[n] = '\0';
    const char* p = buf;
    while (p && *p) {
        const char* eol = strchr(p, '\n');
        size_t len = eol ? (size_t)(eol - p) : strlen(p);
        // Unified hierarchy lines have the exact "0::/path" shape.
        if (len >= 4 && p[0] == '0' && p[1] == ':' && p[2] == ':') {
            const char* rel = p + 3;
            size_t rel_len = len - 3;
            if (rel_len >= PATH_MAX) return;
            char rel_path[PATH_MAX];
            memcpy(rel_path, rel, rel_len);
            rel_path[rel_len] = '\0';
            char mount_root[PATH_MAX];
            char mount_point[PATH_MAX];
            if (!avra_cgroup_v2_mount(mount_root, sizeof(mount_root), mount_point, sizeof(mount_point))) {
                snprintf(mount_root, sizeof(mount_root), "/");
                snprintf(mount_point, sizeof(mount_point), "/sys/fs/cgroup");
            }
            const char* suffix = rel_path;
            size_t root_len = strlen(mount_root);
            if (root_len > 1) {
                if (strncmp(rel_path, mount_root, root_len) != 0
                    || (rel_path[root_len] != '\0' && rel_path[root_len] != '/')) return;
                suffix = rel_path + root_len;
            }
            if (rel_len == 0 || (rel_len == 1 && rel_path[0] == '/')) suffix = "";
            snprintf(avra_cgroup_v2_dir, sizeof(avra_cgroup_v2_dir), "%s%s", mount_point, suffix);
            snprintf(avra_cgroup_v2_mount_dir, sizeof(avra_cgroup_v2_mount_dir), "%s", mount_point);
            return;
        }
        p = eol ? eol + 1 : NULL;
    }
}

static ssize_t avra_cgroup_v2_read(const char* name, char* out, size_t cap) {
    pthread_once(&avra_cgroup_v2_once, avra_cgroup_v2_init);
    if (avra_cgroup_v2_dir[0] == '\0' || cap < 2) return -1;
    char path[PATH_MAX];
    int written = snprintf(path, sizeof(path), "%s/%s", avra_cgroup_v2_dir, name);
    if (written <= 0 || (size_t)written >= sizeof(path)) return -1;
    int fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return -1;
    ssize_t n;
    do { n = read(fd, out, cap - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return -1;
    out[n] = '\0';
    return n;
}

// ── shared cgroup hierarchy walk (t-kdyj.11) ─────────────────────────
//
// Both hierarchies used to read the process's OWN leaf group and nothing else.
// When the constraint sits on an ANCESTOR — the leaf's own file reads unlimited
// — the lookup returned "no limit" and the sampler fell back to the box's
// memory. That is the same silent overestimate t-kdyj.9 removed for the v1/v2
// axis, arriving by a different route, and it is the ordinary layout for nested
// runtimes: a Kubernetes pod under a limited parent, a systemd slice, a
// container inside a container.
//
// ONE walk, used by BOTH hierarchies. Two implementations of the same question
// drifting apart is precisely how v1 and v2 came to disagree in the first
// place, which is the defect this family of changes exists to remove.

// A cgroup byte value read from an explicit directory. Guards the ADD as well
// as the multiply: at out == INT64_MAX/10 the multiply is still safe but the
// final digit can carry past the max, and signed overflow is UB rather than a
// wrapped value we could detect after the fact.
static int64_t avra_cgroup_bytes_at(const char* dir, const char* name) {
    char path[PATH_MAX];
    int written = snprintf(path, sizeof(path), "%s/%s", dir, name);
    if (written <= 0 || (size_t)written >= sizeof(path)) return 0;
    int fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return 0;
    char buf[128];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return 0;
    buf[n] = '\0';
    const char* q = buf;
    if (!(*q >= '0' && *q <= '9')) return 0;
    int64_t out = 0;
    while (*q >= '0' && *q <= '9') {
        int digit = *q - '0';
        if (out > (INT64_MAX - digit) / 10) return 0;
        out = out * 10 + digit;
        q++;
    }
    return out;
}

// "Unlimited" is spelled differently per hierarchy — v2 writes the literal
// `max` (non-numeric, so the parse above yields 0) and v1 writes
// PAGE_COUNTER_MAX (numeric but absurd). Both land here as "no finite limit at
// this level", so the walk skips the level rather than treating it as binding.
static int avra_cgroup_limit_is_finite(int64_t bytes) {
    return bytes > 0 && bytes <= INT64_MAX / 2;
}

// Walk from `leaf` up to `mount` inclusive.
//
// `want_headroom` picks the SELECTION RULE, because capacity and availability
// are different questions:
//
//   0 — the CEILING: the smallest finite limit anywhere on the path. "How much
//       can this process ever use" is a property of the limits alone, so no
//       usage file is opened and the limit-only callers stay cheap.
//   1 — the BINDING HEADROOM: the level with the smallest (limit - usage).
//       "How much more can I allocate" is not answered by the smallest limit —
//       a level with a larger limit but higher usage can be the one that
//       actually stops the next allocation.
//
// Reporting both figures from the SAME level keeps them in one accounting
// domain, the invariant t-kdyj.9 pinned for the v1-vs-v2 choice.
static void avra_cgroup_walk(const char* leaf, const char* mount,
                             const char* limit_file, const char* usage_file,
                             int want_headroom,
                             int64_t* limit_kb, int64_t* current_kb) {
    *limit_kb = 0;
    *current_kb = 0;
    if (leaf == NULL || leaf[0] == '\0' || mount == NULL || mount[0] == '\0') return;
    size_t mount_len = strlen(mount);
    char cur[PATH_MAX];
    if (snprintf(cur, sizeof(cur), "%s", leaf) < 0) return;
    if (strlen(cur) < mount_len) return;   // leaf outside the mount: not walkable
    // Length alone does not prove CONTAINMENT: an unrelated path that happens
    // to be at least as long would otherwise be walked as though it were in the
    // hierarchy, reading files outside it and climbing into unrelated
    // directories. Both callers build the leaf as mount + suffix so the
    // invariant holds today; this makes the boundary explicit rather than
    // inherited from the callers.
    if (strncmp(cur, mount, mount_len) != 0) return;
    if (cur[mount_len] != '\0' && cur[mount_len] != '/') return;

    int64_t best_limit = 0, best_usage = 0, best_key = 0;
    int have = 0;
    for (;;) {
        int64_t lim = avra_cgroup_bytes_at(cur, limit_file);
        if (avra_cgroup_limit_is_finite(lim)) {
            int64_t use = 0;
            int64_t key = lim;
            if (want_headroom && usage_file != NULL) {
                use = avra_cgroup_bytes_at(cur, usage_file);
                if (use < 0) use = 0;
                key = lim - use;
                if (key < 0) key = 0;
            }
            if (!have || key < best_key) {
                have = 1;
                best_key = key;
                best_limit = lim;
                best_usage = use;
            }
        }
        if (strlen(cur) <= mount_len) break;          // reached the mount point
        char* slash = strrchr(cur, '/');
        if (slash == NULL || slash == cur) break;
        *slash = '\0';
        if (strlen(cur) < mount_len) break;
    }
    if (!have) return;
    *limit_kb = best_limit / 1024;
    *current_kb = best_usage / 1024;
}

static int64_t avra_cgroup_v2_memory_limit_kb(void) {
    pthread_once(&avra_cgroup_v2_once, avra_cgroup_v2_init);
    int64_t limit, current;
    avra_cgroup_walk(avra_cgroup_v2_dir, avra_cgroup_v2_mount_dir,
                     "memory.max", NULL, 0, &limit, &current);
    return limit;
}

// The binding (limit, usage) pair for v2 — the level with the least headroom.
static void avra_cgroup_v2_memory_pair_kb(int64_t* limit_kb, int64_t* current_kb) {
    pthread_once(&avra_cgroup_v2_once, avra_cgroup_v2_init);
    avra_cgroup_walk(avra_cgroup_v2_dir, avra_cgroup_v2_mount_dir,
                     "memory.max", "memory.current", 1, limit_kb, current_kb);
}

// ── cgroup v1 (legacy) memory controller (t-kdyj.9) ──────────────────
//
// v2 is not the only layout still in the field. Plenty of container hosts run
// the legacy hierarchies, where each controller is mounted separately and the
// memory files are named differently (`memory.limit_in_bytes` /
// `memory.usage_in_bytes` instead of `memory.max` / `memory.current`). On such
// a host every v2 probe above returns "no limit", so the scheduler budgets
// against the BOX while the kernel enforces the cgroup — the governor's own
// `[admission]` lines report healthy headroom right up to the moment the OOM
// killer reaps a shard. That is the same lying-input defect as t-6flr, one
// level down.
//
// Only the memory controller is mirrored. `memory.pressure` and `cpu.max` are
// unified-hierarchy concepts with no v1 equivalent worth emulating, so those
// probes stay v2-only and degrade to their existing fallbacks.

// Exact token match inside a comma-separated list. Substring matching would
// accept `memory` inside `name=memory` or a future `memory_foo`, and both the
// controller list and the mount's super options are attacker-free but
// genuinely do carry neighbouring tokens (`cpu,cpuacct`, `rw,memory`).
static int avra_csv_has_token(const char* list, size_t len, const char* tok) {
    size_t tok_len = strlen(tok);
    size_t i = 0;
    while (i < len) {
        size_t start = i;
        while (i < len && list[i] != ',') i++;
        if (i - start == tok_len && strncmp(list + start, tok, tok_len) == 0) return 1;
        if (i < len) i++;
    }
    return 0;
}

static pthread_once_t avra_cgroup_v1_mem_once = PTHREAD_ONCE_INIT;
static char avra_cgroup_v1_mem_dir[PATH_MAX];
static char avra_cgroup_v1_mount_dir[PATH_MAX];

// Find the legacy memory controller's hierarchy root and mount point. Unlike
// v2 there is one mount per controller, so the fstype alone is not enough —
// the `memory` controller must appear in the mount's super options.
// mountinfo escapes space, tab, newline and backslash in the root and
// mount-point fields as three-digit octal (`\040` for a space). Decoding is
// not cosmetic: an undecoded `\040` makes the assembled path fail to open, so
// the controller would read as absent — the same silent "no limit" answer this
// whole path exists to eliminate.
static void avra_mountinfo_unescape(const char* src, size_t len, char* out, size_t cap) {
    size_t o = 0;
    for (size_t i = 0; i < len && o + 1 < cap; i++) {
        if (src[i] == '\\' && i + 3 < len
            && src[i + 1] >= '0' && src[i + 1] <= '3'
            && src[i + 2] >= '0' && src[i + 2] <= '7'
            && src[i + 3] >= '0' && src[i + 3] <= '7') {
            out[o++] = (char)(((src[i + 1] - '0') << 6)
                            | ((src[i + 2] - '0') << 3)
                            |  (src[i + 3] - '0'));
            i += 3;
        } else {
            out[o++] = src[i];
        }
    }
    out[o] = '\0';
}

// Copy the nth (1-based) space-delimited mountinfo field, unescaped, bounded
// by the caller's capacity. Replaces an `sscanf("%1023s")` whose width was a
// hardcoded literal that no longer matched its PATH_MAX buffer — a width
// cannot be derived from PATH_MAX by macro (a stringified `(PATH_MAX-1)` is
// not a valid conversion width), so the field is walked explicitly instead.
static int avra_mountinfo_field(const char* line, int n, char* out, size_t cap) {
    const char* p = line;
    for (int i = 1; i < n; i++) {
        while (*p != '\0' && *p != ' ') p++;
        while (*p == ' ') p++;
        if (*p == '\0') return 0;
    }
    size_t len = 0;
    while (p[len] != '\0' && p[len] != ' ') len++;
    if (len == 0 || cap == 0) return 0;
    avra_mountinfo_unescape(p, len, out, cap);
    return 1;
}

// Read a whole /proc file into a heap buffer. mountinfo is a seq_file: a
// single read() returns only what fits, so on a host with many mounts the
// `memory` line can sit past the first bufferful or be split across two. The
// old single-read version answered "no v1 memory controller" in that case and
// fell back to a default mount path — restoring the exact silent-host-memory
// defect this change removes, but only on busy hosts.
static char* avra_read_proc_file(const char* path) {
    int fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return NULL;
    size_t cap = 65536, len = 0;
    char* buf = (char*)malloc(cap);
    if (buf == NULL) { close(fd); return NULL; }
    for (;;) {
        if (len + 1 >= cap) {
            size_t next = cap * 2;
            char* grown = (char*)realloc(buf, next);
            if (grown == NULL) { free(buf); close(fd); return NULL; }
            buf = grown;
            cap = next;
        }
        ssize_t n = read(fd, buf + len, cap - len - 1);
        if (n < 0) {
            if (errno == EINTR) continue;
            free(buf);
            close(fd);
            return NULL;
        }
        if (n == 0) break;
        len += (size_t)n;
    }
    close(fd);
    buf[len] = '\0';
    return buf;
}

static int avra_cgroup_v1_mem_mount(char* root, size_t root_cap, char* mount, size_t mount_cap) {
    char* buf = avra_read_proc_file("/proc/self/mountinfo");
    if (buf == NULL) return 0;
    int found = 0;
    char* line = buf;
    while (line && *line) {
        char* eol = strchr(line, '\n');
        if (eol) *eol = '\0';
        // " - cgroup " is the v1 fstype; the trailing space keeps it from
        // matching "cgroup2".
        char* sep = strstr(line, " - cgroup ");
        if (sep != NULL) {
            // After the separator: "cgroup <source> <superopts>".
            const char* p = sep + strlen(" - cgroup ");
            while (*p == ' ') p++;
            while (*p != '\0' && *p != ' ') p++;   // skip source
            while (*p == ' ') p++;
            size_t opts_len = 0;
            while (p[opts_len] != '\0' && p[opts_len] != ' ') opts_len++;
            if (avra_csv_has_token(p, opts_len, "memory")) {
                // Fields 4 and 5 are the hierarchy root and the mount point.
                if (avra_mountinfo_field(line, 4, root, root_cap)
                    && avra_mountinfo_field(line, 5, mount, mount_cap)) {
                    found = 1;
                    break;
                }
            }
        }
        line = eol ? eol + 1 : NULL;
    }
    free(buf);
    return found;
}

// Locate this process's v1 memory cgroup from the "N:memory:/path" line.
// Resolved once, like the v2 path, because admission samples run frequently.
static void avra_cgroup_v1_mem_init(void) {
    int fd = open("/proc/self/cgroup", O_RDONLY | O_CLOEXEC);
    if (fd < 0) return;
    char buf[4096];
    ssize_t n;
    do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
    close(fd);
    if (n <= 0) return;
    buf[n] = '\0';
    const char* p = buf;
    while (p && *p) {
        const char* eol = strchr(p, '\n');
        size_t len = eol ? (size_t)(eol - p) : strlen(p);
        // "hierarchy-ID:controller-list:cgroup-path". A v2 line ("0::/path")
        // has an empty controller list and is skipped by the token test.
        const char* c1 = memchr(p, ':', len);
        if (c1 != NULL) {
            size_t rest = len - (size_t)(c1 + 1 - p);
            const char* c2 = memchr(c1 + 1, ':', rest);
            if (c2 != NULL && avra_csv_has_token(c1 + 1, (size_t)(c2 - (c1 + 1)), "memory")) {
                const char* rel = c2 + 1;
                size_t rel_len = len - (size_t)(rel - p);
                if (rel_len >= PATH_MAX) return;
                char rel_path[PATH_MAX];
                memcpy(rel_path, rel, rel_len);
                rel_path[rel_len] = '\0';
                char mount_root[PATH_MAX];
                char mount_point[PATH_MAX];
                if (!avra_cgroup_v1_mem_mount(mount_root, sizeof(mount_root), mount_point, sizeof(mount_point))) {
                    snprintf(mount_root, sizeof(mount_root), "/");
                    snprintf(mount_point, sizeof(mount_point), "/sys/fs/cgroup/memory");
                }
                const char* suffix = rel_path;
                size_t root_len = strlen(mount_root);
                if (root_len > 1) {
                    // The mount exposes a SUBTREE, so the process's path is
                    // relative to it; a path outside that subtree is not
                    // reachable through this mount and must not be guessed.
                    if (strncmp(rel_path, mount_root, root_len) != 0
                        || (rel_path[root_len] != '\0' && rel_path[root_len] != '/')) return;
                    suffix = rel_path + root_len;
                }
                if (rel_len == 0 || (rel_len == 1 && rel_path[0] == '/')) suffix = "";
                snprintf(avra_cgroup_v1_mem_dir, sizeof(avra_cgroup_v1_mem_dir), "%s%s", mount_point, suffix);
                snprintf(avra_cgroup_v1_mount_dir, sizeof(avra_cgroup_v1_mount_dir), "%s", mount_point);
                return;
            }
        }
        p = eol ? eol + 1 : NULL;
    }
}

static int64_t avra_cgroup_v1_memory_limit_kb(void) {
    pthread_once(&avra_cgroup_v1_mem_once, avra_cgroup_v1_mem_init);
    int64_t limit, current;
    avra_cgroup_walk(avra_cgroup_v1_mem_dir, avra_cgroup_v1_mount_dir,
                     "memory.limit_in_bytes", NULL, 0, &limit, &current);
    return limit;
}

// The binding (limit, usage) pair for v1 — the level with the least headroom.
static void avra_cgroup_v1_memory_pair_kb(int64_t* limit_kb, int64_t* current_kb) {
    pthread_once(&avra_cgroup_v1_mem_once, avra_cgroup_v1_mem_init);
    avra_cgroup_walk(avra_cgroup_v1_mem_dir, avra_cgroup_v1_mount_dir,
                     "memory.limit_in_bytes", "memory.usage_in_bytes", 1,
                     limit_kb, current_kb);
}

// The effective memory cgroup limit and current usage, preferring v2 and
// falling back to v1. Both figures come from the SAME hierarchy by
// construction: pairing a v2 limit with a v1 usage would compute headroom
// across two different accounting domains. 0/0 means no finite limit.
// Limit-only sibling: which hierarchy answers is decided the same way, so the
// two cannot disagree about WHICH limit is in force. Callers that need only
// the ceiling (capacity, scope kind) use this and skip a usage-file read they
// would discard — resource_snapshot() calls capacity, available and scope in
// sequence on every sample.
static int64_t avra_cgroup_memory_limit_kb(void) {
    int64_t limit = avra_cgroup_v2_memory_limit_kb();
    if (limit > 0) return limit;
    return avra_cgroup_v1_memory_limit_kb();
}

static void avra_cgroup_memory_kb(int64_t* limit_kb, int64_t* current_kb) {
    avra_cgroup_v2_memory_pair_kb(limit_kb, current_kb);
    if (*limit_kb > 0) return;
    avra_cgroup_v1_memory_pair_kb(limit_kb, current_kb);
    if (*limit_kb > 0) return;
    *limit_kb = 0;
    *current_kb = 0;
}

// Parse an avg10 PSI percentage into hundredths of a percent. The caller names
// either "some avg10=" or "full avg10="; -1 means absent/malformed.
static int avra_psi_avg10_bps(const char* body, const char* key) {
    const char* p = strstr(body, key);
    if (!p) return -1;
    p += strlen(key);
    if (!(*p >= '0' && *p <= '9')) return -1;
    int whole = 0;
    while (*p >= '0' && *p <= '9') { whole = whole * 10 + (*p - '0'); p++; }
    int fraction = 0;
    if (*p == '.') {
        p++;
        if (*p >= '0' && *p <= '9') { fraction = (*p - '0') * 10; p++; }
        if (*p >= '0' && *p <= '9') { fraction += *p - '0'; }
    }
    return whole * 100 + fraction;
}

static int avra_linux_pressure_level(void) {
    char buf[512];
    // Per-cgroup PSI is the right signal in CI. Host PSI remains a useful
    // fallback on older/non-delegated cgroup installations.
    ssize_t n = avra_cgroup_v2_read("memory.pressure", buf, sizeof(buf));
    if (n < 0) {
        int fd = open("/proc/pressure/memory", O_RDONLY | O_CLOEXEC);
        if (fd < 0) return 0;
        do { n = read(fd, buf, sizeof(buf) - 1); } while (n < 0 && errno == EINTR);
        close(fd);
        if (n <= 0) return 0;
        buf[n] = '\0';
    }
    int full = avra_psi_avg10_bps(buf, "full avg10=");
    int some = avra_psi_avg10_bps(buf, "some avg10=");
    if (full < 0 && some < 0) return 0;
    // Full stalls mean every runnable task is blocked; even 0.25% sustained
    // over ten seconds is a real thrash signal. Partial stalls are earlier
    // feedback, so 1% asks the controller to stop ramping up.
    if (full >= 25) return 3;      // critical
    if (some >= 100) return 2;     // elevated
    return 1;                      // normal
}

static int avra_linux_cpu_capacity(void) {
    long host = sysconf(_SC_NPROCESSORS_ONLN);
    int cap = host > 0 ? (int)host : 1;
    char buf[128];
    if (avra_cgroup_v2_read("cpu.max", buf, sizeof(buf)) < 0) return cap;
    const char* p = buf;
    if (strncmp(p, "max", 3) == 0) return cap;
    char* end = NULL;
    long long quota = strtoll(p, &end, 10);
    if (end == p || quota <= 0) return cap;
    while (*end == ' ' || *end == '\t') end++;
    char* period_end = NULL;
    long long period = strtoll(end, &period_end, 10);
    if (period_end == end || period <= 0) return cap;
    long long by_quota = (quota + period - 1) / period;
    if (by_quota < 1) by_quota = 1;
    return by_quota < cap ? (int)by_quota : cap;
}
#endif

#if defined(__APPLE__)
static dispatch_once_t avra_macos_pressure_once;
static dispatch_source_t avra_macos_pressure_source;
static _Atomic int avra_macos_pressure = 0;

static void avra_macos_pressure_handler(void* context) {
    dispatch_source_t source = (dispatch_source_t)context;
    unsigned long flags = dispatch_source_get_data(source);
    if (flags & DISPATCH_MEMORYPRESSURE_CRITICAL) {
        atomic_store_explicit(&avra_macos_pressure, 3, memory_order_relaxed);
    } else if (flags & DISPATCH_MEMORYPRESSURE_WARN) {
        atomic_store_explicit(&avra_macos_pressure, 2, memory_order_relaxed);
    } else if (flags & DISPATCH_MEMORYPRESSURE_NORMAL) {
        atomic_store_explicit(&avra_macos_pressure, 1, memory_order_relaxed);
    }
}

static void avra_macos_pressure_init(void* unused) {
    (void)unused;
    avra_macos_pressure_source = dispatch_source_create(
        DISPATCH_SOURCE_TYPE_MEMORYPRESSURE,
        0,
        DISPATCH_MEMORYPRESSURE_NORMAL | DISPATCH_MEMORYPRESSURE_WARN | DISPATCH_MEMORYPRESSURE_CRITICAL,
        dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
    if (!avra_macos_pressure_source) return;
    dispatch_set_context(avra_macos_pressure_source, avra_macos_pressure_source);
    dispatch_source_set_event_handler_f(avra_macos_pressure_source, avra_macos_pressure_handler);
    atomic_store_explicit(&avra_macos_pressure, 1, memory_order_relaxed);
    dispatch_resume(avra_macos_pressure_source);
}

static int64_t avra_macos_memory_capacity_kb(void) {
    uint64_t bytes = 0;
    size_t size = sizeof(bytes);
    if (sysctlbyname("hw.memsize", &bytes, &size, NULL, 0) != 0 || bytes == 0) return 0;
    return (int64_t)(bytes / 1024);
}

static int64_t avra_macos_memory_available_kb(void) {
    vm_statistics64_data_t vm;
    mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
    if (host_statistics64(mach_host_self(), HOST_VM_INFO64,
                          (host_info64_t)&vm, &count) != KERN_SUCCESS) return 0;
    vm_size_t page_size = 0;
    if (host_page_size(mach_host_self(), &page_size) != KERN_SUCCESS || page_size == 0) return 0;
    // Free, inactive, and speculative pages are reclaimable without treating
    // compressed/active application memory as ours to spend.
    uint64_t pages = (uint64_t)vm.free_count + (uint64_t)vm.inactive_count + (uint64_t)vm.speculative_count;
    return (int64_t)((pages * (uint64_t)page_size) / 1024);
}
#endif

// Effective capacity of the current resource scope, in MiB. A finite cgroup
// cap wins over host RAM; otherwise the host capacity is the honest scope.
int64_t avra_resource_memory_capacity_mb(void) {
#ifdef __linux__
    int64_t cgroup = avra_cgroup_memory_limit_kb();
    if (cgroup > 0) return cgroup / 1024;
    int64_t host = avra_mem_total_kb();
    return host > 0 ? host / 1024 : -1;
#elif defined(__APPLE__)
    int64_t host = avra_macos_memory_capacity_kb();
    return host > 0 ? host / 1024 : -1;
#else
    return -1;
#endif
}

// Memory the current scope can still spend, in MiB. Under a finite cgroup we
// take the smaller of cgroup headroom and host reclaimable memory: neither may
// be exceeded safely. Unknown inputs are ignored rather than treated as zero.
int64_t avra_resource_memory_available_mb(void) {
#ifdef __linux__
    int64_t best = avra_mem_available_kb();
    int64_t limit, current;
    avra_cgroup_memory_kb(&limit, &current);
    if (limit > 0 && current >= 0) {
        int64_t cgroup_free = limit - current;
        if (cgroup_free < 0) cgroup_free = 0;
        if (best <= 0 || cgroup_free < best) best = cgroup_free;
    }
    return best > 0 ? best / 1024 : -1;
#elif defined(__APPLE__)
    int64_t host = avra_macos_memory_available_kb();
    return host > 0 ? host / 1024 : -1;
#else
    return -1;
#endif
}

int64_t avra_resource_cpu_capacity(void) {
#ifdef __linux__
    return avra_linux_cpu_capacity();
#else
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return n > 0 ? n : 1;
#endif
}

// 0 unknown, 1 normal, 2 elevated, 3 critical. This is feedback for the
// controller, never a replacement for its reservation accounting.
int64_t avra_resource_pressure_level(void) {
#ifdef __linux__
    return avra_linux_pressure_level();
#elif defined(__APPLE__)
    dispatch_once_f(&avra_macos_pressure_once, NULL, avra_macos_pressure_init);
    return atomic_load_explicit(&avra_macos_pressure, memory_order_relaxed);
#else
    return 0;
#endif
}

// 0 unknown, 1 host, 2 finite cgroup.
int64_t avra_resource_scope_kind(void) {
#ifdef __linux__
    int64_t limit = avra_cgroup_memory_limit_kb();
    if (limit > 0) return 2;
    return avra_mem_total_kb() > 0 ? 1 : 0;
#elif defined(__APPLE__)
    return avra_macos_memory_capacity_kb() > 0 ? 1 : 0;
#else
    return 0;
#endif
}

// Derive the ceiling (KiB, 0 = none) from a MemAvailable / MemTotal pair.
//
// PURE and separately callable so the policy can be tested at the numbers that
// actually broke, instead of only at whatever the test box happens to report —
// on a quiet machine every plausible policy agrees, so an end-to-end assertion
// there proves nothing.
//
// Two rules:
//
// (1) 90% of what's available at startup. Below ~1GiB available we'd only produce
//     false trips on an already-doomed box, so stay out of the way. 90, not 75:
//     this ceiling exists to beat the OOM killer to a RUNAWAY, and a runaway grows
//     without bound — it trips any ceiling. Setting the bar low buys nothing
//     against that and costs real builds. The first 75% default false-tripped a
//     legitimate whole-program test shard on a 16 GiB box, which peaks around
//     11.4 GiB of ~15.1 GiB available (75.5%) — a known-heavy path (snw0), not a
//     bug. Killing it turned a working suite into 5 failed shards.
//
// (2) …but FLOOR that against half of MemTotal, because MemAvailable is sampled
//     ONCE, at startup, and under a parallel build it measures the NEIGHBOURS
//     rather than anything about this process. A child that starts while sibling
//     shards hold memory bakes a low ceiling for its whole life — even as they
//     finish and the memory comes back.
//
//     Not hypothetical: this is what made `bs2 build --lib` on @std/avrac fail
//     intermittently in CI, and it took several runs to see, because the build's
//     ARTIFACTS were all fine (cache hits) and only its exit code was wrong:
//
//         error[F4014]: compiler memory ceiling exceeded
//                       — 3443 MiB resident (ceiling 3441 MiB)
//           phase: parse src/typeck/typeenv_cache.av
//
//     3441 MiB is 90% of a transiently-low ~3.8 GiB reading; compiling the whole
//     compiler legitimately peaks around 3.4 GiB, so the ceiling landed UNDER a
//     known-good build. Raising the percentage would not have fixed it — the same
//     dip at 95% still lands under a heavy build. The derivation was the defect,
//     which is the 75%→90% lesson above repeating one scale down.
//
//     MemTotal does not move under load. Half of it sits well above any legitimate
//     build here and still far below a runaway, which by definition grows past any
//     bound. So: track availability when the box is genuinely quiet, but never
//     conclude from a neighbour's spike that this process may use less than the box
//     could always have given it.
// The floor is THREE QUARTERS of MemTotal, not half.
//
// It was half, chosen to clear a whole-compiler peak believed to be ~3.4 GiB. That
// figure was wrong, and wrong in the direction that matters: it was read off the
// F4014 diagnostic's "3443 MiB resident" — the size the process had reached when the
// ceiling KILLED it, not the size it would have reached had it finished. Measured
// properly (poll RSS with the ceiling disabled, `bs2 compile --emit_metadata` on
// @std/avrac), that build peaks at ~7.0 GiB locally and reached 7997 MiB on a CI
// runner. Against a 16 GiB box the half-of-total floor is 7994 MiB, so the headroom
// that looked like 2.3x was in fact NEGATIVE, and rc-strict failed with
//
//     error[F4014]: compiler memory ceiling exceeded
//                   — 7997 MiB resident (ceiling 7994 MiB)
//       phase: parse src/typeck/typeenv_cache.av
//
// which is the same shape as the failure the floor was added to fix, one octave up.
//
// Three quarters clears the measured peak with ~4.5 GiB of margin on a 16 GiB runner
// while still stopping a genuine runaway well before the OS OOM-killer — which is the
// ceiling's entire purpose. It also restores coherence with the documented default:
// 75% of the box, or 90% of what is actually free, whichever is HIGHER.
//
// Divide-then-multiply, matching the availability rule's idiom, so a large MemTotal
// cannot overflow the intermediate.
int64_t avra_mem_ceiling_for(int64_t avail_kb, int64_t total_kb) {
    int64_t from_avail = (avail_kb > 1024 * 1024) ? (avail_kb / 10) * 9 : 0;
    int64_t floor_kb = (total_kb > 0) ? (total_kb / 4) * 3 : 0;
    return (from_avail > floor_kb) ? from_avail : floor_kb;
}

// The ceiling in KiB; 0 means "no ceiling". Read once, cached.
//
// Precedence (t-kdyj.1 slice 3): an explicit AVRA_MEM_LIMIT_MB is the user's
// HARD override and always wins. Otherwise a pool-exported AVRA_MEM_BUDGET_MB
// (the admission governor's allocation for this process TREE) is a SOFT
// grant: the poll below lets the process exceed it while the box has slack
// and trips only over-budget under pressure — see avra_mem_should_trip.
// Otherwise the box-wide 75%/90% derivation (hard, as ever). A malformed
// budget (non-numeric → 0) falls back to the box-wide derivation rather
// than disabling the ceiling.
static _Atomic int avra_mem_limit_soft = 0;

// An UNSATISFIABLE soft grant — at or below the RSS the process already has
// when the grant is first read — is lifted to baseline + one working quantum
// (64 MiB). The trip precondition is rss >= limit; with a grant under
// baseline that holds the moment the process EXISTS, so under box pressure
// the whole back-off machinery degenerates into "kill a process that has
// allocated nothing and has nothing to yield" — the t-u602 shape: a test
// unit inheriting a small pool grant died as `MEMORY CEILING … during
// startup (before parse)` on three consecutive CI runs while every spec in
// the suite passed (7073/7073), because the deterministic shard packing put
// its start inside the ~7 GiB @std prebuild's climb (avail under the slack
// floor, still falling, so the release valve yielded a baseline-sized
// process that could give nothing back). A grant below what an empty
// process costs is a modeling error upstream, never evidence of a runaway;
// the smallest satisfiable grant keeps the ceiling's entire purpose —
// growth PAST baseline still trips under pressure exactly as designed, and
// a satisfiable grant passes through untouched. PURE and separately
// callable (the avra_mem_ceiling_for pattern) so the policy is pinned at
// the numbers that broke, not whatever a quiet test box reports; a failed
// baseline read (negative) changes nothing.
int64_t avra_mem_soft_grant_floor(int64_t grant_kb, int64_t baseline_kb) {
    if (baseline_kb < 0) return grant_kb;
    int64_t min_kb = baseline_kb + 64 * 1024;
    return (grant_kb < min_kb) ? min_kb : grant_kb;
}

int64_t avra_mem_limit_kb(void) {
    static _Atomic int64_t cached = -1;
    // Release/acquire pairing with the store below: the soft flag is
    // written BEFORE the release-store of `cached`, so any thread that
    // acquire-loads a non-negative `cached` also sees the flag. With
    // relaxed ordering a racing poll could observe the budget-derived
    // limit while still reading soft==0 and hard-trip a soft grant.
    int64_t c = atomic_load_explicit(&cached, memory_order_acquire);
    if (c >= 0) return c;
    int64_t v;
    const char* e = getenv("AVRA_MEM_LIMIT_MB");
    const char* b = getenv("AVRA_MEM_BUDGET_MB");
    if (e && *e) {
        v = strtoll(e, NULL, 10) * 1024;
        if (v < 0) v = 0;
    } else if (b && *b && strtoll(b, NULL, 10) > 0) {
        v = avra_mem_soft_grant_floor(strtoll(b, NULL, 10) * 1024,
                                      avra_mem_rss_kb());
        atomic_store_explicit(&avra_mem_limit_soft, 1, memory_order_relaxed);
    } else {
        v = avra_mem_ceiling_for(avra_mem_available_kb(), avra_mem_total_kb());
    }
    atomic_store_explicit(&cached, v, memory_order_release);
    return v;
}

// The pressure floor for a SOFT grant, in KiB: below this much MemAvailable
// the box is genuinely NEAR THE CLIFF and an over-budget tree must stop
// itself. This is a property of the box, not of any run's schedule, and it
// SCALES with the box: MemTotal/16, clamped to [512 MiB, 2 GiB]. Two
// falsified constants bracket the derivation:
//   - the admission reserve (6144MB) as the floor: a loaded 16GB runner
//     legitimately sits below the reserve for most of a suite, so "normal
//     load" read as "pressure" and every over-grant fixture probe tripped
//     — the hard cap re-created through the pressure branch;
//   - an absolute 2048MB: CI then tripped the ~7GB @std/avrac lib-build
//     probe at "2047 MiB available < 2048 MiB floor" — a fixture the
//     pre-budget world completed routinely at LOWER avail (the kernel
//     reclaims page cache well below 2GB). On a 16GB box, ~2GB avail
//     under the known-heaviest fixture is NORMAL, not near-cliff.
// Kernel low-memory watermarks scale with box size; so must this line.
// AVRA_MEM_SLACK_FLOOR_MB remains an override for tests and unusual
// boxes; the pool never sets it.
int64_t avra_mem_slack_floor_for(int64_t total_kb) {
    int64_t v = total_kb / 16;
    int64_t lo = 512 * 1024;
    int64_t hi = 2048 * 1024;
    if (v < lo) v = lo;
    if (v > hi) v = hi;
    return v;
}

int64_t avra_mem_slack_floor_kb(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    int64_t v;
    const char* e = getenv("AVRA_MEM_SLACK_FLOOR_MB");
    if (e && *e && strtoll(e, NULL, 10) > 0) {
        v = strtoll(e, NULL, 10) * 1024;
    } else {
        v = avra_mem_slack_floor_for(avra_mem_total_kb());
    }
    atomic_store(&cached, v);
    return v;
}

// ── The compile slot gate (t-kdyj.1 slice 4) ─────────────────────────────
//
// The acceptance-proof falsification of slice 3: the budget grant is computed
// per admitted TREE but enforced per PROCESS, so a shard binary whose W test
// workers each shell a `bs2 compile` fixture probe is W concurrent processes
// EACH entitled to the full grant — the tree's effective bound is W x grant,
// no member ever crosses its own budget, and the soft trip's floor condition
// is unreachable no matter how bad the box gets. Three cold trees of
// under-their-own-budget probes took the container down in five minutes with
// zero diagnostics (2026-08-01, logged on t-kdyj.1).
//
// Dividing the grant per member is the wrong repair: under pressure every
// legitimately-heavy probe would F4014 at once — mass spec failure instead of
// slows-and-completes. The repair that matches the epic's back-pressure rule
// is a BOX-WIDE concurrency bound on heavy compiler processes, enforced where
// the process starts (so it covers pool children, spec-shelled probes and
// ad-hoc runs alike, regardless of who spawned them) and engaged ONLY under
// pressure: while MemAvailable is above a box-scaled threshold the gate is a
// single meminfo read; below it, a compile must hold one of a small fixed set
// of flock slots before doing heavy work. Waiting is the enforcement — no
// process is ever killed, and a crash releases its slot by construction
// (flock dies with the fd). The wait loop RE-SAMPLES pressure, so a box that
// recovers releases its waiters without any slot changing hands.
//
// Deliberately NOT inherited: each bs2 process gates itself. An inherited
// "slot held" mark would survive the shard binary's exec and wave its whole
// probe storm through — the exact per-tree/per-process mismatch this exists
// to fix. No gated process waits on another gated process while holding a
// slot (compile/check are leaves; _test_shard's slot dies at exec via
// O_CLOEXEC), so the gate cannot deadlock.

// The pressure threshold policy, pure for spec-pinning: gating engages below
// 3/8 of MemTotal, clamped to [2 GiB, 8 GiB]. On the 16 GiB box that killed
// the container this is ~6 GiB — the same territory as the pool's reserve,
// i.e. "the zone where the un-modelled tree growth must stop stacking".
// Unknown MemTotal (non-Linux) returns 0 = the gate never engages; the box
// has no pressure signal to act on, and failing open matches the ceiling's
// availability-fallback precedent.
int64_t avra_slot_gate_threshold_for(int64_t total_kb) {
    if (total_kb <= 0) return 0;
    int64_t v = (total_kb / 8) * 3;
    int64_t lo = (int64_t)2048 * 1024;
    int64_t hi = (int64_t)8192 * 1024;
    if (v < lo) v = lo;
    if (v > hi) v = hi;
    return v;
}

int64_t avra_slot_gate_threshold_kb(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    int64_t v;
    const char* e = getenv("AVRA_SLOT_GATE_MB");
    if (e && *e) {
        v = strtoll(e, NULL, 10) * 1024;   // 0 disables the gate explicitly
        if (v < 0) v = 0;
    } else {
        v = avra_slot_gate_threshold_for(avra_mem_total_kb());
    }
    atomic_store(&cached, v);
    return v;
}

// Pure: does this availability reading demand a slot before heavy work?
// Usable memory in KB for the slot gate, via the PORTABLE resource layer.
//
// The gate used avra_mem_available_kb() directly, which is Linux-only
// (avra_meminfo_kb reads /proc/meminfo and returns 0 elsewhere). Combined with
// the `avail_kb > 0` guard in avra_slot_gate_should_wait, that made the gate
// return 0 unconditionally on macOS — i.e. the compile slot gate, one of the
// three mechanisms CLAUDE.md credits for "bs2 test is memory-safe by
// construction on any box", did not exist there.
//
// avra_resource_memory_available_mb() is the same source the admission
// governor already uses (host_statistics64 on Apple, meminfo + cgroup on
// Linux) and returns -1 when genuinely unknown, which the caller's guard
// treats as "do not gate" exactly as before.
static int64_t avra_slot_gate_avail_kb(void) {
    int64_t mb = avra_resource_memory_available_mb();
    return mb > 0 ? mb * 1024 : 0;
}

int64_t avra_slot_gate_should_wait(int64_t avail_kb, int64_t threshold_kb) {
    return (threshold_kb > 0 && avail_kb > 0 && avail_kb < threshold_kb) ? 1 : 0;
}

// How many heavy compiles the box runs concurrently UNDER PRESSURE. Two keeps
// a little overlap (one draining, one starting) while bounding the stacked
// peak to ~2 whole-program compiles + the already-running trees — measured
// survivable where width 3-4 died. Roomy boxes never see this number.
int64_t avra_slot_gate_width(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    const char* e = getenv("AVRA_COMPILE_SLOT_WIDTH");
    int64_t v = (e && *e) ? strtoll(e, NULL, 10) : 2;
    if (v < 1) v = 1;
    if (v > 64) v = 64;
    atomic_store(&cached, v);
    return v;
}

// Try to take one slot non-blockingly; returns the held fd or -1. The fd is
// O_CLOEXEC on purpose: _test_shard execs the shard binary after its compile,
// and the slot must die at that boundary — the test RUN is not a compile.
static int avra_slot_gate_try(const char* dir, int64_t width) {
    for (int64_t i = 0; i < width; i++) {
        char path[512];
        snprintf(path, sizeof(path), "%s/slot%lld", dir, (long long)i);
        // O_NOFOLLOW: a slot name that is a symlink is an attack on the
        // shared default dir, never a legitimate slot — refuse to chase it.
        int fd = open(path, O_CREAT | O_RDWR | O_CLOEXEC | O_NOFOLLOW, 0666);
        if (fd < 0) continue;
        if (flock(fd, LOCK_EX | LOCK_NB) == 0) return fd;
        close(fd);
    }
    return -1;
}

// The default slot dir lives in world-writable /tmp, so it must be treated
// as hostile until proven ours: /tmp-style sticky mode on creation, and on
// every entry reject a path that is a symlink, a non-directory, or owned by
// a different effective uid. Validation failure FAILS OPEN (no gating, no
// wait): a foreign or tampered dir must never be able to park every compile
// on this box behind locks an attacker controls.
static int avra_slot_gate_dir_ok(const char* dir) {
    if (mkdir(dir, 01777) == 0) {
        (void)chmod(dir, 01777);   // umask-proof the sticky bit we just asked for
    } else if (errno != EEXIST) {
        return 0;
    }
    struct stat st;
    if (lstat(dir, &st) != 0) return 0;
    if (!S_ISDIR(st.st_mode)) return 0;      // symlink or plain file: hostile
    if (st.st_uid != geteuid()) return 0;    // someone else's dir: not ours to trust
    return 1;
}

// The gate. Called at the top of every heavy CLI mode (compile / check / run /
// _test_shard). Holds the winning slot fd for the life of the process — the
// kernel releases it at exit, _exit, crash or exec; there is deliberately no
// release path to forget.
void avra_compile_slot_gate(void) {
    int64_t threshold_kb = avra_slot_gate_threshold_kb();
    if (threshold_kb <= 0) return;
    int64_t avail_kb = avra_slot_gate_avail_kb();
    if (!avra_slot_gate_should_wait(avail_kb, threshold_kb)) return;
    const char* dir = getenv("AVRA_COMPILE_SLOT_DIR");
    if (!dir || !*dir) dir = "/tmp/.avra-slots";   // dot-named: outside the
                                                   // /tmp/avra_* prune glob
    if (!avra_slot_gate_dir_ok(dir)) return;       // unwritable/hostile: fail open
    int64_t width = avra_slot_gate_width();
    static int avra_slot_gate_fd = -1;
    // The uncontended fast path is SILENT on purpose: mid-suite the box sits
    // under the threshold routinely, and a line here would leak into every
    // shelled probe's captured output — nondeterministic contamination of
    // output-asserting fixtures. Only genuine schedule events (waiting,
    // acquired, pressure-cleared) speak, and only on the contended path.
    avra_slot_gate_fd = avra_slot_gate_try(dir, width);
    if (avra_slot_gate_fd >= 0) return;
    fprintf(stderr,
        "[slot-gate] memory pressure (%lld MiB available < %lld MiB): waiting for one of %lld compile slots\n",
        (long long)(avail_kb / 1024), (long long)(threshold_kb / 1024), (long long)width);
    for (;;) {
        struct timespec ts = { 0, 200 * 1000 * 1000 };
        nanosleep(&ts, NULL);
        avail_kb = avra_slot_gate_avail_kb();
        if (!avra_slot_gate_should_wait(avail_kb, threshold_kb)) {
            // Pressure passed while we queued — the gate is a pressure gate,
            // not a semaphore; proceed slotless rather than serialise a box
            // that has already recovered.
            fprintf(stderr, "[slot-gate] pressure cleared (%lld MiB available): proceeding\n",
                (long long)(avail_kb / 1024));
            return;
        }
        avra_slot_gate_fd = avra_slot_gate_try(dir, width);
        if (avra_slot_gate_fd >= 0) {
            fprintf(stderr, "[slot-gate] compile slot acquired (%lld MiB available)\n",
                (long long)(avail_kb / 1024));
            return;
        }
    }
}

// Test-facing flock primitives, so specs can OCCUPY a slot deterministically
// (hold from the spec's own process; release explicitly — the shard binary
// outlives any one spec).
int64_t avra_flock_try_exclusive(const char* path) {
    int fd = open(path, O_CREAT | O_RDWR | O_CLOEXEC | O_NOFOLLOW, 0666);
    if (fd < 0) return -1;
    if (flock(fd, LOCK_EX | LOCK_NB) != 0) { close(fd); return -1; }
    return (int64_t)fd;
}

int64_t avra_flock_unlock(int64_t fd) {
    if (fd < 0) return -1;
    close((int)fd);   // closing the last fd on the description drops the lock
    return 0;
}

// The ONE trip decision, pure so spec tests pin the semantics without
// faking box pressure. A hard ceiling trips on RSS alone (the pre-slice-3
// contract, unchanged). A soft grant trips only when BOTH hold: the tree
// is over its grant AND MemAvailable has fallen under the slack floor —
// while the box has room, exceeding a modeled grant is legitimate
// borrowing (a cold whole-program fixture compile peaks ~7GB against a
// ~3GB shard grant), and capping it re-creates the exact false-F4014 the
// grant replaced the 75% guess to avoid.
int64_t avra_mem_should_trip(int64_t rss_kb, int64_t limit_kb, int64_t soft,
                             int64_t avail_kb, int64_t floor_kb) {
    if (limit_kb <= 0 || rss_kb < limit_kb) return 0;
    if (!soft) return 1;
    return avail_kb < floor_kb ? 1 : 0;
}

// COPY the label; do NOT retain the caller's pointer.
//
// Every caller passes an INTERPOLATED Avra string ("parse ${file}"), which is
// refcounted and freed as soon as the caller drops it — while the ceiling may
// report arbitrarily later, from an allocation deep inside the very parse that
// label describes. Storing the caller's pointer was a use-after-free waiting for
// the one report that matters; the label would be freed memory precisely when the
// compiler is under memory pressure and most likely to have reused it.
//
// A fixed static buffer, not strdup: this must not allocate (the report path is
// reached from the allocator) and must not grow without bound (a per-file phase
// stamp fires once per source file). A concurrent set can interleave bytes, which
// at worst garbles the label text — it stays NUL-terminated and in-bounds, so the
// failure mode is a cosmetically wrong phase, never a crash.
static char avra_mem_phase_buf[1024] = "startup (before parse)";

// Resident size sampled when the CURRENT phase was stamped, so the report can
// separate growth WITHIN this phase from what was already resident when it
// began.
//
// WHY: the phase label alone systematically mis-attributes an ACCUMULATION
// blowup. The stamp names whichever file the compiler was reading when the
// running total crossed the ceiling — so a shard that grew steadily across 200
// files blames the 201st. Measured instance (uzs9, 2026-08-01): 28 of 31 trips
// on a 16GB box named the same large generated parser, which reads exactly like
// a single-input parse blowup; bisected single-process probes then peaked in the
// same band on BOTH the base and branch compilers, i.e. the named file was never
// the cause. A reader cannot tell the two apart from a label, but can from a
// delta: a phase that grew +40 MiB of an 13 GB total plainly did not cause it.
// Sampled once per stamp (once per source file), so the extra /proc read is
// noise beside parsing the file it precedes.
static _Atomic int64_t avra_mem_phase_start_kb = 0;

void avra_mem_phase_set(const char* label) {
    if (!label) return;
    size_t n = strlen(label);
    if (n >= sizeof(avra_mem_phase_buf)) n = sizeof(avra_mem_phase_buf) - 1;
    memcpy(avra_mem_phase_buf, label, n);
    avra_mem_phase_buf[n] = '\0';
    atomic_store_explicit(&avra_mem_phase, avra_mem_phase_buf, memory_order_relaxed);
    atomic_store_explicit(&avra_mem_phase_start_kb, avra_mem_rss_kb(),
                          memory_order_relaxed);
}

int64_t avra_mem_peak_mb(void) { return atomic_load(&avra_mem_peak_kb) / 1024; }

// How long a SOFT-grant borrower may BACK OFF under the pressure floor before
// its trip fires, in ms (t-d91l). The floor is a reading of the NEIGHBOURS —
// a sibling shard peaking, page cache not yet reclaimed — and such troughs
// routinely pass within seconds; the pre-budget world completed its heaviest
// fixtures at sub-floor availability as a matter of course (see the slack-floor
// derivation above). Killing a legitimate over-grant borrower at the first
// sub-floor SAMPLE therefore turned transient co-scheduling into deterministic
// spec failure: the fold fixture's ~9.6 GiB whole-program child inherits the
// shard pool's ~2 GiB grant, crosses it by design, and died the instant the
// suite's own trough touched the floor (t-d91l, twice on CI on one head).
// Waiting is the same answer the compile slot gate already gives pressure —
// hold, re-sample, resume on recovery — applied at the trip site. The bound
// keeps the ceiling's purpose intact: a box whose pressure NEVER lifts (a
// genuine cliff — resident sets alone exceeding RAM) still trips, just late.
// 0 restores the instant trip (tests that pin the trip itself use it).
//
// The parse policy is PURE and separately callable (the avra_mem_ceiling_for
// pattern): the COMPLETE value must be a valid integer. A prefix parse
// ("300ms" → 300) or a non-numeric value ("oops" → 0) must not silently
// become some other wait — 0 in particular would disable the back-off on a
// typo, reopening the exact first-sample kill this knob exists to fix. Any
// incomplete/out-of-range value falls back to the default; a NEGATIVE value
// is a complete parse and clamps to 0 (an explicit instant-trip request).
int64_t avra_mem_soft_wait_parse(const char* e) {
    if (!e || !*e) return 60000;
    char* end = NULL;
    errno = 0;
    long long v = strtoll(e, &end, 10);
    if (errno != 0 || end == e || *end != '\0') return 60000;
    if (v < 0) return 0;
    return (int64_t)v;
}

// The back-off's RELEASE-VALVE guard, pure for spec-pinning: may a borrower
// keep holding at this fresh reading, given the highest MemAvailable seen
// since the hold began? Holding is only safe while the box is NOT
// deteriorating — under the old instant-trip code the borrowers' F4014s
// were, functionally, the box's pressure-release valve, and back-off v1
// removed it: three consecutive rc-strict runs died as runner-level OOM
// evictions at the same suite phase (the ~7 GiB @std prebuild still
// climbing while two over-grant shards HELD ~4.6 GiB under the floor —
// avail 1536 MiB and falling, dead 48 s later). A net fall of more than
// 256 MiB from the hold's high-water mark means a neighbour is still
// allocating into the hole; the borrower must yield NOW and give the
// memory back, exactly as the pre-back-off code did. The margin tolerates
// meminfo jitter and kernel reclaim churn; a genuinely climbing build
// crosses it within a few 100 ms samples. A trough that has BOTTOMED
// (siblings peaked, avail flat or recovering) never trips this — that is
// the t-d91l shape the back-off exists to ride.
int64_t avra_mem_hold_is_safe(int64_t high_water_kb, int64_t avail_kb, int64_t margin_kb) {
    return avail_kb >= high_water_kb - margin_kb;
}

// The valve margin (KiB): 256 MiB unless AVRA_MEM_HOLD_MARGIN_MB overrides
// it — same strict complete-parse policy as the wait knob (a typo must not
// silently move a safety boundary). The override exists for the spec that
// pins the BUDGET exit: on a shared box a neighbour's allocations can fall
// past any fixed margin mid-wait, so the deterministic way to test "held
// the whole configured wait" is to set the margin unreachably high; the
// valve's own decision stays pinned pure at the default margin.
static int64_t avra_mem_hold_margin_kb(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    int64_t v = 256 * 1024;
    const char* e = getenv("AVRA_MEM_HOLD_MARGIN_MB");
    if (e && *e) {
        char* end = NULL;
        errno = 0;
        long long m = strtoll(e, &end, 10);
        // The MiB→KiB conversion bounds the accepted range: past
        // INT64_MAX/1024 the multiply is signed overflow (UB) and the
        // margin it produced would be garbage — keep the default instead.
        if (errno == 0 && end != e && *end == '\0' && m > 0 && m <= INT64_MAX / 1024) {
            v = (int64_t)m * 1024;
        }
    }
    atomic_store(&cached, v);
    return v;
}

// How much soft-hold grace remains for THIS process (t-2fe6).
//
// The window is CUMULATIVE, not per call. `avra_mem_poll` runs from the
// allocation hot path, so a tree oscillating around the pressure threshold
// re-enters constantly; if each entry were granted the full window it could
// hold forever in 60s slices, never accumulating toward the trip. Returning 0
// once the window is spent is what makes sustained pressure trip and REPORT,
// instead of wedging silently until an outer timeout kills the job.
//
// Clamps at 0 and never returns negative: an over-held process gets no grace,
// not inverted grace.
int64_t avra_mem_hold_remaining_ms(int64_t budget_ms, int64_t already_ms) {
    if (budget_ms <= 0) return 0;
    if (already_ms <= 0) return budget_ms;
    int64_t remaining = budget_ms - already_ms;
    return remaining > 0 ? remaining : 0;
}

static int64_t avra_mem_soft_wait_ms(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    int64_t v = avra_mem_soft_wait_parse(getenv("AVRA_MEM_SOFT_WAIT_MS"));
    atomic_store(&cached, v);
    return v;
}

// Report and terminate. Rendered in the same shape as a CompileError header so
// it reads like every other compiler diagnostic (ZERO RAW ERRORS policy) — the
// runtime cannot construct a DiagnosticBag from an arbitrary allocation site,
// but it can and does speak the same language.
static void avra_mem_ceiling_report(int64_t rss_kb, int64_t limit_kb,
                                    int soft, int64_t avail_kb, int64_t floor_kb,
                                    int64_t waited_ms, int deepened) {
    const char* phase = atomic_load_explicit(&avra_mem_phase, memory_order_relaxed);
    fflush(stdout);
    fprintf(stderr,
        "\nerror[F4014]: compiler memory ceiling exceeded — %lld MiB resident (ceiling %lld MiB)\n",
        (long long)(rss_kb / 1024), (long long)(limit_kb / 1024));
    if (phase && *phase) fprintf(stderr, "  phase: %s\n", phase);
    // Growth within the phase vs what preceded it — see avra_mem_phase_start_kb.
    // Guarded on a sane sample: 0 means no phase was ever stamped, and a
    // baseline above the current RSS means memory was RELEASED since the stamp
    // (so "growth" is meaningless); print nothing rather than a negative.
    int64_t phase_start_kb = atomic_load_explicit(&avra_mem_phase_start_kb,
                                                  memory_order_relaxed);
    if (phase_start_kb > 0 && rss_kb >= phase_start_kb) {
        int64_t grew_kb = rss_kb - phase_start_kb;
        fprintf(stderr,
            "  in-phase growth: +%lld MiB (%lld MiB already resident when this phase began)\n",
            (long long)(grew_kb / 1024), (long long)(phase_start_kb / 1024));
        // State the reading rather than leaving it as arithmetic for someone
        // debugging under pressure. This is a comparison of two measured
        // numbers, not a heuristic guess at a cause: when the phase accounts
        // for under half the total, the label above is where the ceiling was
        // CROSSED, which is not the same claim as where the memory went.
        if (grew_kb * 2 < rss_kb) {
            fprintf(stderr,
                "  note: most of this footprint predates the phase above — memory ACCUMULATED\n"
                "        across earlier work. The phase names where the total crossed the\n"
                "        ceiling, not what consumed it; suspect the workload's total size\n"
                "        (batch/shard width, or a leak across inputs) before that one input.\n");
        }
    }
    if (soft) {
        // A soft grant only trips under real box pressure — say so, because
        // "which condition fired" is the first question a reader asks of a
        // budgeted tree (an over-grant alone never trips).
        fprintf(stderr,
            "  budget: soft grant exceeded while the box is under pressure "
            "(%lld MiB available < %lld MiB floor)\n",
            (long long)(avail_kb / 1024), (long long)(floor_kb / 1024));
        // The back-off line is the reader's tell between three shapes: a
        // transient trough (no trip at all — no report), a genuine cliff
        // (held the whole budget, pressure never lifted), and a DEEPENING
        // collapse (yielded early so a still-allocating neighbour survives —
        // the release valve, avra_mem_hold_is_safe).
        if (waited_ms > 0 && deepened) {
            fprintf(stderr,
                "  backed off: held allocation %lld ms, then yielded — pressure kept "
                "DEEPENING (a neighbour is still allocating; holding would feed the "
                "OS OOM-killer a bigger victim)\n",
                (long long)waited_ms);
        } else if (waited_ms > 0) {
            fprintf(stderr,
                "  backed off: held allocation %lld ms waiting for the box to recover "
                "(AVRA_MEM_SOFT_WAIT_MS) — pressure never lifted\n",
                (long long)waited_ms);
        }
    }
    fprintf(stderr,
        "  help: this is the compiler stopping itself before the OS OOM-killer does.\n"
        "        Raise or disable the ceiling with AVRA_MEM_LIMIT_MB=<mb> (0 = no ceiling).\n"
        "        If the input is not enormous, this is a compiler bug — start from the\n"
        "        growth line above, not the phase name; capture it with a spec test.\n");
    fflush(stderr);
    _exit(1);
}

// Poll hook, called from the allocation hot paths. Amortised: a relaxed
// increment on all but every 65536th call.
static void avra_mem_poll(void) {
    int64_t limit_kb = avra_mem_limit_kb();
    if (limit_kb <= 0) return;
    // A tree KNOWN to be borrowing (soft grant, RSS past its budget) is the
    // one that can help collapse the box: several borrowers allocating hard
    // can take MemAvailable from the slack floor to zero INSIDE one 65536-
    // allocation window, and the kernel OOM-killer wins the race (observed:
    // a cold build/tests sweep dir SIGKILLed with no watchdog trip). While
    // borrowing, poll 16x more often — the meminfo read is ~µs against
    // ~ms of allocation work per 4096-allocation window, and the tighter
    // window bounds how far past the floor a borrower can run.
    static _Atomic int avra_mem_borrowing = 0;
    // Cumulative soft-hold time for THIS process (t-2fe6). See the back-off
    // block below: the wait budget must span calls, not restart on each one.
    static _Atomic int64_t avra_mem_soft_held_ms = 0;
    int64_t mask = atomic_load_explicit(&avra_mem_borrowing, memory_order_relaxed)
                       ? (AVRA_MEM_POLL_MASK >> 4) : AVRA_MEM_POLL_MASK;
    int64_t n = atomic_fetch_add_explicit(&avra_mem_poll_ctr, 1, memory_order_relaxed);
    if ((n & mask) != 0) return;
    int64_t rss = avra_mem_rss_kb();
    if (rss < 0) return;
    int64_t prev = atomic_load_explicit(&avra_mem_peak_kb, memory_order_relaxed);
    if (rss > prev) atomic_store_explicit(&avra_mem_peak_kb, rss, memory_order_relaxed);
    int soft = atomic_load_explicit(&avra_mem_limit_soft, memory_order_relaxed);
    if (rss < limit_kb) {
        if (soft) {
            atomic_store_explicit(&avra_mem_borrowing, 0, memory_order_relaxed);
            // Back under the grant is GENUINE recovery, not the momentary
            // flicker the oscillator exploits — so the cumulative hold budget
            // resets only here, never on a mid-hold sample.
            atomic_store_explicit(&avra_mem_soft_held_ms, 0, memory_order_relaxed);
        }
        return;
    }
    // Crossing is rare (once per poll window at most), so the soft-grant
    // pressure read — a /proc/meminfo parse — happens only here, never on
    // the sub-crossing hot path.
    if (soft) atomic_store_explicit(&avra_mem_borrowing, 1, memory_order_relaxed);
    int64_t avail_kb = soft ? avra_mem_available_kb() : 0;
    int64_t floor_kb = soft ? avra_mem_slack_floor_kb() : 0;
    if (!avra_mem_should_trip(rss, limit_kb, soft, avail_kb, floor_kb)) return;
    // SOFT BACK-OFF (t-d91l): a soft trip means "over the inherited grant
    // while the box is under the pressure floor" — and the floor reading is
    // about the NEIGHBOURS, not this process. Hold allocation here (we are
    // inside the allocator poll, so sleeping IS back-pressure), re-sample,
    // and resume the moment either side of the condition clears; trip only
    // if pressure holds for the whole bounded window. Hard ceilings (an
    // explicit AVRA_MEM_LIMIT_MB, the box-wide derivation) keep the instant
    // trip: they measure THIS process, and a runaway must not get a minute
    // of grace to push the box over. avra_mem_should_trip stays the one
    // trip decision — this loop only re-asks it with fresh readings.
    int64_t waited_ms = 0;
    int deepened = 0;
    int64_t held_total_ms = 0;
    if (soft) {
        int64_t budget_ms = avra_mem_soft_wait_ms();
        // THE BUDGET IS CUMULATIVE PER PROCESS, NOT PER CALL (t-2fe6). This
        // hook runs from the allocation hot path, so `waited_ms` being a local
        // meant a tree oscillating around the pressure threshold re-entered
        // with a FRESH 60s every time: hold, clear for a single sample,
        // allocate a sliver, hold again — indefinitely, never accumulating
        // toward the trip. From outside that is a shard that never finishes,
        // with FLAT memory (it is sleeping, not allocating) and no diagnostic
        // at all. Worse, it is self-sustaining under concurrency: each
        // holder's RSS keeps MemAvailable low, which keeps its neighbours
        // holding, and the release valve cannot break the tie because flat
        // memory neither falls (no valve) nor recovers (no progress).
        // Observed as two CI suites frozen at 112/150 and 113/150 with three
        // shards in flight until the job timeout killed them.
        // Carrying the total forward means SUSTAINED pressure trips and says
        // so, while a transient trough still gets its full grace.
        int64_t already_ms = atomic_load_explicit(&avra_mem_soft_held_ms, memory_order_relaxed);
        int64_t remaining_ms = avra_mem_hold_remaining_ms(budget_ms, already_ms);
        int64_t high_water_kb = avail_kb;
        while (waited_ms < remaining_ms) {
            // Sleep the REMAINDER when under one quantum, so the total wait
            // lands exactly on the budget (never past it) and the report's
            // duration is the configured bound, not a rounded-up one.
            int64_t slice_ms = remaining_ms - waited_ms;
            if (slice_ms > 100) slice_ms = 100;
            struct timespec ts = { slice_ms / 1000, (slice_ms % 1000) * 1000000L };
            // Retry interrupted sleeps with the REMAINDER before charging the
            // slice: charging unslept time overstates the reported duration
            // and, in a signal-heavy tree, drains the budget early.
            struct timespec rem = { 0, 0 };
            while (nanosleep(&ts, &rem) == -1 && errno == EINTR) ts = rem;
            waited_ms += slice_ms;
            rss = avra_mem_rss_kb();
            avail_kb = avra_mem_available_kb();
            if (!avra_mem_should_trip(rss, limit_kb, soft, avail_kb, floor_kb)) {
                // Pressure lifted — resume, but CHARGE what we just held.
                // This charge is the whole fix: without it an oscillator
                // returns here and its next hold starts from zero again.
                atomic_fetch_add_explicit(&avra_mem_soft_held_ms, waited_ms,
                                          memory_order_relaxed);
                return;
            }
            // The release valve (avra_mem_hold_is_safe): holding is only
            // legitimate while the box holds steady or recovers. Still
            // falling past the margin = a neighbour is allocating into the
            // hole we are sitting on — yield the memory NOW, exactly as the
            // pre-back-off code did, instead of feeding the kernel
            // OOM-killer a runner-sized victim.
            if (avail_kb > high_water_kb) high_water_kb = avail_kb;
            if (!avra_mem_hold_is_safe(high_water_kb, avail_kb, avra_mem_hold_margin_kb())) {
                deepened = 1;
                break;
            }
        }
        atomic_fetch_add_explicit(&avra_mem_soft_held_ms, waited_ms, memory_order_relaxed);
        held_total_ms = already_ms + waited_ms;
    }
    // Latch: the first thread to cross reports; others fall through to _exit.
    if (atomic_exchange_explicit(&avra_mem_tripped, 1, memory_order_relaxed)) return;
    avra_mem_ceiling_report(rss, limit_kb, soft, avail_kb, floor_kb, held_total_ms, deepened);
}

// Per-`while`-loop iteration ceiling for comptime execution. A comptime loop
// that runs past this can only be non-terminating (a real one folds in far
// fewer steps). Overridable via AVRA_COMPTIME_LOOP_LIMIT — mainly for tests,
// which set it low to trip fast — and read once, cached.
int64_t avra_comptime_loop_limit(void) {
    static _Atomic int64_t cached = -1;
    int64_t c = atomic_load(&cached);
    if (c >= 0) return c;
    const char* e = getenv("AVRA_COMPTIME_LOOP_LIMIT");
    int64_t v = (e && *e) ? strtoll(e, NULL, 10) : 10000000;
    if (v <= 0) v = 10000000;
    atomic_store(&cached, v);
    return v;
}

// Unset an environment variable for THIS process. Used by the test
// runner before forking the test binary so its shell-outs to bs2
// don't inherit AVRA_USE_METADATA / AVRA_LIB_OBJS / AVRA_LIB_PKG_ROOT
// — those are scoped to the shard's compile, not to any subsequent
// runtime sub-invocations the test makes.
void avra_process_env_unset(const char* key) {
    unsetenv(key);
}

// Set an environment variable for THIS process (and everything it
// forks). The test orchestrator uses this to stamp
// AVRA_SKIP_ENSURE_BS2=1 before dispatching shards: the bs2 running
// the suite IS the compiler under test, so no child shell-out to
// scripts/diagnose.sh may ever decide bs2 is stale and rebuild it
// mid-run out from under the live shards (t-gv3n).
void avra_process_env_set(const char* key, const char* value) {
    setenv(key, value, 1);
}

/// Get the directory containing the current executable. The path to
/// the running binary is resolved per-platform: `_NSGetExecutablePath`
/// on macOS, the `/proc/self/exe` symlink on Linux.
const char* avra_process_self_dir(void) {
    char path[4096];
    int ok = 0;
#if defined(__APPLE__)
    uint32_t size = sizeof(path);
    ok = (_NSGetExecutablePath(path, &size) == 0);
#else
    ssize_t n = readlink("/proc/self/exe", path, sizeof(path) - 1);
    if (n > 0) {
        path[n] = '\0';
        ok = 1;
    }
#endif
    if (ok) {
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

/// Host OS identifier, used by the linker step to pick platform-specific
/// flags (ld64 `-stack_size` + libc++ on macOS vs LLD + libstdc++ on
/// Linux). Returns a stable string literal — callers must not free it.
const char* avra_host_os(void) {
#if defined(__APPLE__)
    return "macos";
#elif defined(__linux__)
    return "linux";
#elif defined(_WIN32)
    return "windows";
#else
    return "unknown";
#endif
}

/// Host CPU architecture identifier, used by the coverage link step to
/// name the clang_rt profile archive (libclang_rt.profile-<arch>.a on
/// Linux). Returns a stable string literal — callers must not free it.
const char* avra_host_arch(void) {
#if defined(__aarch64__) || defined(__arm64__)
    return "arm64";
#elif defined(__x86_64__)
    return "x86_64";
#else
    return "unknown";
#endif
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

// General-purpose fresh-id source for synthetic names the parser/codegen
// generate (e.g. the for-(a,b) loop temp). Process-wide and monotonic, so
// every call yields a name that can never collide with another.
static int64_t g_gensym_counter = 0;
int64_t avra_gensym(void) { return g_gensym_counter++; }

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
// Thread-local: under the in-process parallel runner each worker
// thread runs its own spec at any moment; failure records must
// attribute to the spec running on the RECORDING thread, not to
// whichever spec another worker started last.
static _Thread_local const char* _current_spec = "";
static _Thread_local const char* _current_given = "";

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

// gg-flaky-harness: per-thread "the crash I'm about to cause is EXPECTED"
// flag. A test that deliberately crashes a spec (to exercise the guard) arms
// this via `avra_test_expect_crash()` immediately before raising the signal;
// the guard's crash path (`avra_test_record_crash`) consumes it and drops the
// live crash count in the SAME breath, on the SAME thread. This replaces the
// old design where the crash was recorded in one spec and a SEPARATE later
// spec called `avra_test_ack_expected_crash()` to decrement the global count —
// a window that, under parallel CI load, let a deliberate crash's live-count
// contribution survive to summary time and redden an otherwise-green suite
// (`0 failed, 1 spec(s) crashed`). Arming closes the window: record + ack are
// now atomic and co-located, so an expected crash can never leak. Touched only
// in normal (non-async-signal) context — set in the spec body, read/cleared in
// the guard's return paths — but typed `sig_atomic_t` to match the sibling
// guard state it lives beside.
static _Thread_local volatile sig_atomic_t _expect_next_crash = 0;

// Arm the next crash on THIS thread as expected. Intended for `*_test.av`
// files that deliberately raise a fatal signal to prove the per-spec guard
// catches it — call this immediately before `avra_test_raise_signal(...)`.
void avra_test_expect_crash(void) {
    _expect_next_crash = 1;
}

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
    // The record is ALWAYS appended so per-file introspection
    // (avra_test_crash_count_for_file etc.) sees every crash. But if the
    // crashing spec ARMED an expectation (avra_test_expect_crash) right before
    // deliberately raising, acknowledge it HERE — atomically, on the same
    // thread, inside the guard's crash path — rather than trusting a separate
    // later spec to decrement the count. record_list_append bumped the live
    // count; undo it in the same breath so the expected crash nets to zero and
    // can never survive to the summary. gg-flaky-harness.
    record_list_append(&_crashes, c);
    if (_expect_next_crash) {
        _expect_next_crash = 0;
        atomic_fetch_sub(&_crashes.count, 1);
    }
}

int64_t avra_test_crash_count(void) {
    return atomic_load(&_crashes.count);
}

// LEGACY hook for tests that DELIBERATELY crash a spec to exercise the guard.
// Superseded by `avra_test_expect_crash()` (arm-before-raise), which acks at
// record time on the crashing thread and so has no lost-decrement window; the
// in-tree crash-isolation tests all use the arm form now. Kept as a functional
// blind decrement purely for backward compatibility with any external/cached
// test binary that still calls it — a bare decrement is only correct when
// paired 1:1 with a real recorded crash, which was exactly the fragile
// contract the arm form replaces. Do NOT combine it with arming in the same
// spec: that double-acks and could mask a real crash.
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

// ── Per-file crash introspection (4m1e) ──
// The process-global `_crashes` list interleaves crashes from every test
// file running concurrently across the in-process worker threads (d4jv), so
// a test asserting on its OWN deliberate crashes must filter by source file
// — a global-count (`avra_test_crash_count`) or absolute-index
// (`avra_test_crash_spec(0)`) read races the other crash-isolation file's
// entries. `frag` is a substring of the caller's own path (its basename);
// the crash-isolation files' basenames are mutually non-substring, so
// containment matching is unambiguous. The list mutex is held for the walk
// so a concurrent append can't tear a node mid-traversal. Entries survive
// `avra_test_ack_expected_crash` (it drops the global live count but leaves
// the record), so these reflect exactly what THIS file recorded — the
// global count/ack/summary path is left untouched, so real (unacked)
// crashes are still detected by the shard's exit code as before.
int64_t avra_test_crash_count_for_file(const char* frag) {
    if (!frag) return 0;
    int64_t n = 0;
    pthread_mutex_lock(&_crashes.mutex);
    for (AvraRecordNode* node = _crashes.head; node; node = node->next) {
        AvraTestCrash* c = (AvraTestCrash*)node->payload;
        if (c && c->file && strstr(c->file, frag)) n++;
    }
    pthread_mutex_unlock(&_crashes.mutex);
    return n;
}

static AvraTestCrash* crash_at_for_file(const char* frag, int64_t idx) {
    if (!frag || idx < 0) return NULL;
    AvraTestCrash* found = NULL;
    int64_t seen = 0;
    pthread_mutex_lock(&_crashes.mutex);
    for (AvraRecordNode* node = _crashes.head; node; node = node->next) {
        AvraTestCrash* c = (AvraTestCrash*)node->payload;
        if (c && c->file && strstr(c->file, frag)) {
            if (seen == idx) { found = c; break; }
            seen++;
        }
    }
    pthread_mutex_unlock(&_crashes.mutex);
    return found;
}

const char* avra_test_crash_spec_for_file(const char* frag, int64_t idx) {
    AvraTestCrash* c = crash_at_for_file(frag, idx);
    return c ? c->spec : "";
}

int64_t avra_test_crash_signal_for_file(const char* frag, int64_t idx) {
    AvraTestCrash* c = crash_at_for_file(frag, idx);
    return c ? c->signal : 0;
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
    // Nest-safe: save the enclosing guard's checkpoint. The in-process
    // test runner wraps each whole test unit in this same guard, with
    // per-spec guards nesting inside — a single TLS jmp_buf slot would
    // leave the outer guard pointing at a dead stack frame once an
    // inner spec returned.
    sigjmp_buf saved_jmp;
    memcpy(&saved_jmp, &_spec_guard_jmp, sizeof(sigjmp_buf));
    sig_atomic_t saved_active = _spec_guard_active;
    AvraSinkFrame* sink_snapshot = t_sink;

    int lock_snapshot = t_held_locks_n;
    // o092: a crash mid-comptime-fold longjmps past the pending
    // avra_comptime_leave, leaking the thread's comptime depth into the next
    // spec (whose plain runtime loop is then wrongly capped by the ceiling).
    int64_t comptime_depth_snapshot = avra_comptime_depth_snapshot();
    int sig = sigsetjmp(_spec_guard_jmp, 1);
    if (sig == 0) {
        _spec_guard_active = 1;
        avra_closure_call_0(closure);
        // gg-flaky-harness: a spec that armed an expected crash
        // (avra_test_expect_crash) but returned NORMALLY — the raise never
        // happened — must not leak the arm into the next spec, where it would
        // silently ack a genuine crash. The crash path consumes the arm; this
        // is the matching consume for the no-crash path.
        _expect_next_crash = 0;
    } else {
        // The longjmp may have skipped balancing sink pops (spec died
        // inside a capture window) — reclaim orphan frames so the next
        // spec's output isn't silently swallowed. Same for advisory
        // file locks: a leaked flock would wedge every other unit
        // waiting on that fixture.
        sink_unwind_to(sink_snapshot);
        avra_locks_unwind_to(lock_snapshot);
        avra_comptime_depth_restore(comptime_depth_snapshot);
        avra_test_record_crash(name, file, line, sig);
        char crash_line[512];
        snprintf(crash_line, sizeof(crash_line),
                 "    \x1b[31m✗ SPEC CRASHED\x1b[0m %s \x1b[2m(at %s:%lld — %s)\x1b[0m\n",
                 name ? name : "<unknown>",
                 file ? file : "<unknown>",
                 (long long)line,
                 avra_signal_label(sig));
        // Through the sink router so the line lands inside the unit's
        // buffered output (correctly attributed under concurrency)
        // instead of interleaving on the shared terminal.
        avra_output_write(crash_line);
    }
    _spec_guard_active = saved_active;
    memcpy(&_spec_guard_jmp, &saved_jmp, sizeof(sigjmp_buf));
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
    printf("\n%lld/%lld tests passed", (long long)pass, (long long)total);
    if (fail > 0) printf(" (%lld failed)", (long long)fail);
    printf("\n");
    return fail > 0 ? 1 : 0;
}

// ── Stdout capture (for testing output-producing code) ──
// Thin wrappers over the per-thread sink stack. Concurrent captures
// on different threads are independent windows; nesting on one
// thread stacks. See the sink section for the full semantics.

void avra_test_capture_start(void) {
    avra_sink_push();
}

const char* avra_test_capture_stop(void) {
    AvraSinkFrame* f = t_sink;
    if (!f) return "";
    // Historical contract: strip ONE trailing newline (println adds
    // one per line; tests assert `out == "value"` for single-line
    // captures).
    if (f->len > 0 && f->buf[f->len - 1] == '\n') {
        f->len--;
        f->buf[f->len] = '\0';
    }
    return avra_sink_pop();
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
    avra_rc_go_multithreaded();  // a second thread now exists — arm the rc_set lock
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

// Build a [status][detail][] frame for a failure path. The len slot is
// unused on a failure frame, so it doubles as a detail channel: on a CRASH
// frame `detail` carries the child's death signal (WTERMSIG) — letting a
// caller tell an OS kill (SIGKILL, e.g. the OOM killer under memory
// pressure) from a genuine in-child fault (SIGSEGV/SIGABRT). 0 when the
// child exited with a non-zero code rather than dying to a signal.
static const char* avra_isolated_frame_err_detail(int64_t status, int64_t detail) {
    char* r = avra_bytes_alloc(16);
    char* d = avra_bytes_data(r);
    memcpy(d, &status, 8);
    memcpy(d + 8, &detail, 8);
    return r;
}

// Build a [status][len=0][] frame for an early failure path.
static const char* avra_isolated_frame_err(int64_t status) {
    return avra_isolated_frame_err_detail(status, 0);
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

// EINTR-safe full-buffer pipe IO for the isolated-run frames. The
// test runner's signal traffic (stall-detector timers, SIGCHLD storms
// at high parallelism) can interrupt a blocking read/write after a
// PARTIAL transfer; a single call then reports a short count, which
// the framing logic misreads as a crash (child side) or a short read
// (parent side). Observed as a load-only flake: a 100 KB payload —
// larger than the 64 KB pipe buffer, so the transfer must block —
// round-trips fine in isolation but intermittently "crashes" under a
// full parallel suite.
static int avra_write_all(int fd, const void* buf, size_t n) {
    const char* p = (const char*)buf;
    size_t left = n;
    while (left > 0) {
        ssize_t w = write(fd, p, left);
        if (w < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        p += (size_t)w;
        left -= (size_t)w;
    }
    return 0;
}

static ssize_t avra_read_full(int fd, void* buf, size_t n) {
    char* p = (char*)buf;
    size_t got = 0;
    while (got < n) {
        ssize_t r = read(fd, p + got, n - got);
        if (r < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        if (r == 0) break;  // EOF: writer closed early
        got += (size_t)r;
    }
    return (ssize_t)got;
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
        int wrote_ok = avra_write_all(pipefd[1], &len, sizeof(len)) == 0;
        if (wrote_ok && len > 0) {
            wrote_ok = avra_write_all(pipefd[1], avra_bytes_data((char*)b), (size_t)len) == 0;
        }
        close(pipefd[1]);
        _exit(wrote_ok ? 0 : 1);
    }

    // Parent: read length header, allocate the receiving bytes,
    // drain the data. waitpid LAST so a child writing more than
    // PIPE_BUF can't deadlock on a full pipe.
    close(pipefd[1]);
    int64_t len = 0;
    ssize_t hn = avra_read_full(pipefd[0], &len, sizeof(len));
    int header_ok = (hn == (ssize_t)sizeof(len) && len >= 0 && len <= AVRA_ISOLATED_PAYLOAD_CAP);

    // Drain payload into a scratch buffer (when the header was
    // valid) so we can surface the right status after seeing the
    // child's exit code: a short read on a crashed child is a
    // crash, not a pipe failure.
    char* scratch = (header_ok && len > 0) ? (char*)malloc((size_t)len) : NULL;
    int short_read = 0;
    if (header_ok && len > 0) {
        ssize_t got = avra_read_full(pipefd[0], scratch, (size_t)len);
        if (got != (ssize_t)len) short_read = 1;
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
        // Surface the death signal so callers can distinguish an OS kill
        // (SIGKILL — the OOM killer) from an in-child fault (SIGSEGV/SIGABRT).
        int sig = (wstat == 0 && WIFSIGNALED(status)) ? WTERMSIG(status) : 0;
        return avra_isolated_frame_err_detail(AVRA_ISOLATED_STATUS_CRASH, sig);
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

// ── Typed channels (spec Axis 18) ──
// One channel implementation, three capacity semantics chosen at
// construction:
//   cap > 0   bounded — send blocks while the ring is full
//   cap = 0   rendezvous — send blocks until a receiver has TAKEN
//             the value (synchronous handoff)
//   cap < 0   unbounded — send never blocks; the ring grows
//
// close() sets a flag and wakes every waiter — it NEVER frees (the
// historic close-frees design made any post-close send/recv a
// use-after-free). The handle is rc_alloc'd; codegen routes Channel
// releases through avra_channel_release, which frees the ring when
// the last reference drops. POSIX mutex/cond on our targets hold no
// kernel resources, so skipping destroy on free is sound.
//
// Payload slots are i64 words. Element-type coercion (Bool zext,
// Float bitcast, ptr identity) and RC retain/release discipline for
// ptr-backed elements live in codegen — the runtime moves words.

typedef struct {
    int64_t* buf;
    int64_t cap;        // <0 unbounded, 0 rendezvous, >0 bounded
    int64_t alloc;      // allocated ring slots (max(cap,1) initially)
    int64_t head;       // index of oldest element
    int64_t count;      // live elements
    int closed;
    pthread_mutex_t mu;
    pthread_cond_t can_send;
    pthread_cond_t can_recv;
} AvraChannel;

// Process-wide channel-activity condvar backing `select`. A selector
// scans its channels under this mutex, then waits here; every send
// and close signals it AFTER releasing the channel's own mutex, so
// the lock order is strictly selector: activity → channel, sender:
// channel, then activity — no cycle, and a send that lands between
// a selector's scan and its wait cannot be missed (the signal needs
// the activity mutex the selector still holds).
static pthread_mutex_t g_chan_activity_mu = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t g_chan_activity_cv = PTHREAD_COND_INITIALIZER;

static void chan_activity_broadcast(void) {
    pthread_mutex_lock(&g_chan_activity_mu);
    pthread_cond_broadcast(&g_chan_activity_cv);
    pthread_mutex_unlock(&g_chan_activity_mu);
}

void* avra_channel_new_cap(int64_t cap) {
    AvraChannel* ch = (AvraChannel*)avra_rc_alloc(sizeof(AvraChannel));
    memset(ch, 0, sizeof(AvraChannel));
    ch->cap = cap;
    ch->alloc = (cap > 0) ? cap : 1;
    ch->buf = (int64_t*)malloc((size_t)ch->alloc * sizeof(int64_t));
    pthread_mutex_init(&ch->mu, NULL);
    pthread_cond_init(&ch->can_send, NULL);
    pthread_cond_init(&ch->can_recv, NULL);
    return ch;
}

// Legacy constructor — 1-slot bounded, the semantics every pre-typed
// caller (raw-extern tests) was written against.
void* avra_channel_new(void) {
    return avra_channel_new_cap(1);
}

// Free the ring when the LAST reference is being released. Safe
// without the channel lock: refcount 1 means this thread is the only
// owner left, so no concurrent send/recv can hold the mutex.
void avra_channel_release(void* channel) {
    if (!channel) return;
    AvraChannel* ch = (AvraChannel*)channel;
    RcHeader* hdr = rc_header(channel);
    if (hdr->type_tag == RC_MAGIC && atomic_load(&hdr->refcount) == 1) {
        free(ch->buf);
        ch->buf = NULL;
    }
    avra_rc_release(channel);
}

static void chan_grow_locked(AvraChannel* ch) {
    int64_t new_alloc = ch->alloc * 2;
    int64_t* nb = (int64_t*)malloc((size_t)new_alloc * sizeof(int64_t));
    for (int64_t i = 0; i < ch->count; i++) {
        nb[i] = ch->buf[(ch->head + i) % ch->alloc];
    }
    free(ch->buf);
    ch->buf = nb;
    ch->alloc = new_alloc;
    ch->head = 0;
}

void avra_channel_send(void* channel, int64_t value) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_lock(&ch->mu);
    if (ch->cap >= 0) {
        // Bounded (rendezvous holds one in-flight slot): wait for room.
        int64_t room = (ch->cap == 0) ? 1 : ch->cap;
        while (!ch->closed && ch->count >= room) {
            pthread_cond_wait(&ch->can_send, &ch->mu);
        }
    }
    if (ch->closed) {
        pthread_mutex_unlock(&ch->mu);
        avra_runtime_errorf("send on closed channel");
        exit(1);
    }
    // Only the unbounded form can be at capacity here (bounded waited
    // for room above, and its alloc == cap).
    if (ch->count >= ch->alloc) chan_grow_locked(ch);
    ch->buf[(ch->head + ch->count) % ch->alloc] = value;
    ch->count++;
    pthread_cond_signal(&ch->can_recv);
    if (ch->cap == 0) {
        // Rendezvous: the hand-off completes when a receiver TAKES the
        // value. If the channel closes while we wait, the value is
        // already queued — a post-close drain can still receive it, so
        // returning (rather than trapping) loses nothing.
        while (!ch->closed && ch->count > 0) {
            pthread_cond_wait(&ch->can_send, &ch->mu);
        }
    }
    pthread_mutex_unlock(&ch->mu);
    chan_activity_broadcast();
}

// Pop the head value. Caller holds ch->mu and has verified
// count > 0; signaling can_send here keeps every pop path waking
// blocked senders identically (recv, try_recv, and select all
// drain through this one definition).
static int64_t chan_pop_locked(AvraChannel* ch) {
    int64_t value = ch->buf[ch->head];
    ch->head = (ch->head + 1) % ch->alloc;
    ch->count--;
    pthread_cond_signal(&ch->can_send);
    return value;
}

// Pop one value. `ok_out` receives 1 on success, 0 when the channel
// is closed AND drained (the typed `recv() -> T?` null case).
int64_t avra_channel_recv_opt(void* channel, int64_t* ok_out) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_lock(&ch->mu);
    while (ch->count == 0 && !ch->closed) {
        pthread_cond_wait(&ch->can_recv, &ch->mu);
    }
    if (ch->count == 0) {
        // closed and drained
        pthread_mutex_unlock(&ch->mu);
        if (ok_out) *ok_out = 0;
        return 0;
    }
    int64_t value = chan_pop_locked(ch);
    pthread_mutex_unlock(&ch->mu);
    if (ok_out) *ok_out = 1;
    return value;
}

// Non-blocking pop. `ok_out` gets 1 with a value when one is
// available NOW; 0 otherwise — whether the channel is merely empty
// or closed (callers that need to distinguish use blocking recv,
// whose null is unambiguous). Powers polling shapes like the test
// runner's ticker shutdown check, where blocking would defeat the
// point.
int64_t avra_channel_try_recv_opt(void* channel, int64_t* ok_out) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_lock(&ch->mu);
    if (ch->count == 0) {
        pthread_mutex_unlock(&ch->mu);
        if (ok_out) *ok_out = 0;
        return 0;
    }
    int64_t value = chan_pop_locked(ch);
    pthread_mutex_unlock(&ch->mu);
    if (ok_out) *ok_out = 1;
    return value;
}

// Legacy blocking recv. Receiving from a closed-and-drained channel
// is a hard error here (the pre-close-semantics API has no way to
// express "no more values"); typed `recv()` returns null instead.
int64_t avra_channel_recv(void* channel) {
    int64_t ok = 0;
    int64_t v = avra_channel_recv_opt(channel, &ok);
    if (!ok) {
        avra_runtime_errorf("recv on closed channel (use typed recv() -> T? to observe close)");
        exit(1);
    }
    return v;
}

// Mark closed and wake everyone: blocked receivers drain then see
// null; blocked senders trap (send on closed channel). Idempotent.
void avra_channel_close(void* channel) {
    AvraChannel* ch = (AvraChannel*)channel;
    pthread_mutex_lock(&ch->mu);
    ch->closed = 1;
    pthread_cond_broadcast(&ch->can_recv);
    pthread_cond_broadcast(&ch->can_send);
    pthread_mutex_unlock(&ch->mu);
    chan_activity_broadcast();
}

// ── select ──

typedef struct {
    int64_t index;  // which channel fired
    int64_t value;  // the received value
} AvraSelectResult;

// Try to pop from one channel without blocking. Returns 1 on value,
// 0 when empty. `*closed_out` set when the channel is closed+drained.
static int chan_try_take(AvraChannel* ch, int64_t* val_out, int* closed_out) {
    pthread_mutex_lock(&ch->mu);
    if (ch->count > 0) {
        *val_out = chan_pop_locked(ch);
        pthread_mutex_unlock(&ch->mu);
        return 1;
    }
    if (ch->closed) *closed_out = 1;
    pthread_mutex_unlock(&ch->mu);
    return 0;
}

// Block until one of `count` channels has a value; pop and return
// (index, value). Wait is condvar-based (no polling): the scan runs
// under the activity mutex, so a send signaling after an empty scan
// blocks until the selector reaches cond_wait — wakeups can't be
// lost. When EVERY channel is closed and drained no value can ever
// arrive; trap rather than block forever.
void* avra_select(void* channel_array, int64_t count) {
    AvraSelectResult* result = (AvraSelectResult*)malloc(sizeof(AvraSelectResult));
    AvraArray* arr = (AvraArray*)(uintptr_t)channel_array;
    if (!arr || arr->len == 0) {
        result->index = -1;
        result->value = 0;
        return result;
    }
    pthread_mutex_lock(&g_chan_activity_mu);
    while (1) {
        int64_t n = (arr->len < count) ? arr->len : count;
        int closed_drained = 0;
        for (int64_t i = 0; i < n; i++) {
            AvraChannel* ch = (AvraChannel*)(uintptr_t)arr->data[i];
            if (!ch) continue;
            int closed = 0;
            int64_t val = 0;
            if (chan_try_take(ch, &val, &closed)) {
                pthread_mutex_unlock(&g_chan_activity_mu);
                result->index = i;
                result->value = val;
                return result;
            }
            if (closed) closed_drained++;
        }
        if (closed_drained == n) {
            pthread_mutex_unlock(&g_chan_activity_mu);
            free(result);
            avra_runtime_errorf("select: all channels closed and drained");
            exit(1);
        }
        pthread_cond_wait(&g_chan_activity_cv, &g_chan_activity_mu);
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
    avra_rc_go_multithreaded();  // threads about to exist — arm the rc_set lock
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

// t-y2i7.5: the canonical names of every module in the compilation, so a
// @comptime macro can ask WHICH MODULES EXIST (ctx_modules_under) rather than
// only "is this name a module?". A plain list, not a map: the query is a prefix
// scan, and the set is small (~120) and written once per macro invocation.
static const char** avra_rd_module_names = NULL;
static int64_t avra_rd_module_n = 0;
static int64_t avra_rd_module_cap = 0;

static const char** avra_rd_alias_keys = NULL;
static const char** avra_rd_alias_vals = NULL;
static int64_t avra_rd_alias_n = 0;
static int64_t avra_rd_alias_cap = 0;

static const char** avra_rd_global_keys = NULL;
static const char** avra_rd_global_vals = NULL;
static int64_t avra_rd_global_n = 0;
static int64_t avra_rd_global_cap = 0;

// (item canonical, annotation name) pairs. Discovery by ANNOTATION is a
// DECLARATION of membership: `@language_feature fn defer_lang()` says what the
// item IS, so nothing accidental can satisfy it. Inference from shape kept
// over-selecting by exactly one — `ctx_items_with_suffix("_lang")` also found
// `register_lang` (the registration helper), and selecting on return type also
// finds `LanguageFeature_new` (the component's synthesized constructor). Each
// name- or signature-shaped discriminator admits a different near-miss; a mark
// admits none.
static const char** avra_rd_annot_items = NULL;
static const char** avra_rd_annot_names = NULL;
static int64_t avra_rd_annot_n = 0;
static int64_t avra_rd_annot_cap = 0;

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
// One-array sibling of avra_rd_grow_strs2, same 256 start / 2x growth / abort
// contract. Split out rather than passing a NULL second array so neither call
// site has to test for it.
static void avra_rd_grow_strs1(const char*** a, int64_t* cap, int64_t needed) {
    int64_t new_cap = (*cap == 0) ? 256 : *cap;
    while (new_cap < needed) new_cap *= 2;
    if (new_cap == *cap) return;
    *a = (const char**)realloc(*a, new_cap * sizeof(const char*));
    if (!*a) {
        fprintf(stderr, "avra_rd: out of memory growing string bucket to %lld entries\n", (long long)new_cap);
        abort();
    }
    *cap = new_cap;
}

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
    avra_rd_module_n = 0;
    avra_rd_global_n = 0;
    avra_rd_annot_n = 0;
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

// Record one module's canonical name. Strings are borrowed, not copied — the
// same contract every other rd bucket uses (see the header above: they stay
// alive for the whole compile).
void avra_rd_add_module(const char* canonical) {
    if (!canonical || !*canonical) return;
    if (avra_rd_module_n >= avra_rd_module_cap) {
        avra_rd_grow_strs1(&avra_rd_module_names, &avra_rd_module_cap, avra_rd_module_n + 1);
    }
    avra_rd_module_names[avra_rd_module_n++] = canonical;
}

int64_t avra_rd_module_count(void) { return avra_rd_module_n; }

const char* avra_rd_module_at(int64_t i) {
    return (i >= 0 && i < avra_rd_module_n) ? avra_rd_module_names[i] : "";
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

void avra_rd_add_annotation(const char* item_canonical, const char* annot_name) {
    rd_strmap_add(&avra_rd_annot_items, &avra_rd_annot_names,
                  &avra_rd_annot_n, &avra_rd_annot_cap,
                  item_canonical, annot_name);
}

int64_t avra_rd_annot_count(void) { return avra_rd_annot_n; }

const char* avra_rd_annot_item_at(int64_t i) {
    return (i >= 0 && i < avra_rd_annot_n) ? avra_rd_annot_items[i] : "";
}

const char* avra_rd_annot_name_at(int64_t i) {
    return (i >= 0 && i < avra_rd_annot_n) ? avra_rd_annot_names[i] : "";
}

// Enumeration over the globals bucket. No new storage — the keys/vals arrays
// already exist for lookup; these just expose them in order, so a macro can ask
// "which items end in _lang?" instead of only "what is X?". Same reason
// avra_rd_module_at exists: a lookup-only map cannot answer a set question.
int64_t avra_rd_global_count(void) { return avra_rd_global_n; }

const char* avra_rd_global_name_at(int64_t i) {
    return (i >= 0 && i < avra_rd_global_n) ? avra_rd_global_keys[i] : "";
}

const char* avra_rd_global_canonical_at(int64_t i) {
    return (i >= 0 && i < avra_rd_global_n) ? avra_rd_global_vals[i] : "";
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


// ─── Fork quiescing (multithreaded fork safety) ─────────────────
//
// `isolated_run` forks while the parallel test runner's worker and
// ticker threads are live. A child forked from a multithreaded
// process inherits every mutex IN ITS STATE AT THE FORK INSTANT —
// one held by a sibling thread (which does not exist in the child)
// stays locked forever. The first avra_rc_alloc in the child's
// closure then deadlocks on rc_set_mutex (observed: child wedged in
// rc_set_add, parent wedged reading the result pipe — the whole
// batch hangs until the stall detector names it).
//
// The POSIX-correct pattern: prepare() locks every runtime
// singleton mutex in a fixed order — which ALSO guarantees the
// structures they guard are not mid-mutation in the fork's memory
// snapshot (an rc_set mid-grow would be torn in the child) —
// parent() unlocks them, and child() unlocks them (the forking
// thread owns them in the child) and re-arms the channel condvar
// (its waiters do not exist in the child).
//
// Boundary, stated honestly: PER-CHANNEL mutexes are dynamic and
// cannot be enumerated here. An isolated closure that touches a
// channel concurrently used by parent threads keeps the classic
// fork+threads hazard. The universal allocation path — what every
// closure hits — is what this covers. glibc quiesces malloc's own
// locks with its internal atfork handlers.

static void avra_fork_prepare(void) {
    pthread_mutex_lock(&rc_set_mutex);
    pthread_mutex_lock(&suspect_mutex);
    pthread_mutex_lock(&g_test_toolchain_fp_mutex);
    pthread_mutex_lock(&_failures.mutex);
    pthread_mutex_lock(&_crashes.mutex);
    pthread_mutex_lock(&g_chan_activity_mu);
}

static void avra_fork_parent(void) {
    pthread_mutex_unlock(&g_chan_activity_mu);
    pthread_mutex_unlock(&_crashes.mutex);
    pthread_mutex_unlock(&_failures.mutex);
    pthread_mutex_unlock(&g_test_toolchain_fp_mutex);
    pthread_mutex_unlock(&suspect_mutex);
    pthread_mutex_unlock(&rc_set_mutex);
}

static void avra_fork_child(void) {
    pthread_mutex_unlock(&g_chan_activity_mu);
    pthread_mutex_unlock(&_crashes.mutex);
    pthread_mutex_unlock(&_failures.mutex);
    pthread_mutex_unlock(&g_test_toolchain_fp_mutex);
    pthread_mutex_unlock(&suspect_mutex);
    pthread_mutex_unlock(&rc_set_mutex);
    // No waiter survives into the child; re-arm so future waits
    // start from clean futex state.
    pthread_cond_init(&g_chan_activity_cv, NULL);
}

__attribute__((constructor))
static void avra_install_fork_quiescing(void) {
    pthread_atfork(avra_fork_prepare, avra_fork_parent, avra_fork_child);
}
