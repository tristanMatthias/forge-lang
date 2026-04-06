// ═══════════════════════════════════════════════════════════════════
// Forge Debug Utilities
// ═══════════════════════════════════════════════════════════════════
// Diagnostic functions for debugging the self-hosting compiler.
// These are compiled into the runtime and callable from Forge source.
// They have no effect on correctness — only produce stderr traces.
//
// To use: call from Forge source (e.g., forge_dump_stmt_list(stmts))
// To disable all output: set FORGE_DEBUG=0 env var (TODO)
// ═══════════════════════════════════════════════════════════════════

#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef struct { char* ptr; int64_t len; } ForgeString;

// Forward declarations for token access (defined in runtime.c)
extern int64_t forge_token_kind_id(ForgeString token_list, int64_t index);
extern ForgeString forge_token_text(ForgeString token_list, int64_t index);

// ─── Body parsing trace ─────────────────────────────────────────
// Tracks when emit_fn_body_from_source is active, so other traces
// can filter to only fire during body parsing.
static int _emit_fn_body_active = 0;
static int _emit_fn_body_count = 0;
void forge_emit_fn_body_start(void) { _emit_fn_body_active = 1; _emit_fn_body_count++; }
void forge_emit_fn_body_end(void)   { _emit_fn_body_active = 0; }
int  forge_emit_fn_body_is_active(void) { return _emit_fn_body_active; }

// ─── Parse return path tracing ──────────────────────────────────
// Call with path_id at each return point in parse_var_binding (or similar)
// to identify which early return is taken.
// path_id convention: 0=success, 1+=error paths
void forge_parse_return_path(int64_t path_id) {
    if (_emit_fn_body_active) {
        fprintf(stderr, "  [PARSE_PATH] fn_body#%d path=%lld\n",
                _emit_fn_body_count, (long long)path_id);
    }
}

// ─── Token list dump ────────────────────────────────────────────
// Dumps the first N tokens from a token list (ForgeString = {ptr, len}).
// Useful for verifying body tokenization before parsing.
void forge_dump_token_kids(ForgeString list, int64_t count) {
    fprintf(stderr, "[TOKEN_KIDS] ptr=%p len=%lld count=%lld\n",
            list.ptr, (long long)list.len, (long long)count);
    for (int i = 0; i < count && i < list.len && i < 50; i++) {
        int64_t kid = forge_token_kind_id(list, i);
        ForgeString text = forge_token_text(list, i);
        fprintf(stderr, "  tok[%d] kid=%lld text='%.*s'\n", i, (long long)kid,
                text.ptr && text.len > 0 ? (int)(text.len < 30 ? text.len : 30) : 0,
                text.ptr ? text.ptr : "");
    }
}

// ─── Statement list dump ────────────────────────────────────────
// Dumps raw bytes of a Statement list.
// Statement = {i8 tag, i64 × 13} = 112 bytes (Rust compiler representation).
// Pass the list as ForgeString (same layout as List<Statement>).
void forge_dump_stmt_list(ForgeString list) {
    void* ptr = list.ptr;
    int64_t len = list.len;
    if (!ptr || len <= 0) {
        fprintf(stderr, "[DUMP_STMTS] ptr=%p len=%lld\n", ptr, (long long)len);
        return;
    }
    int elem_size = 112;
    fprintf(stderr, "[DUMP_STMTS] ptr=%p len=%lld elem_size=%d\n", ptr, (long long)len, elem_size);
    for (int i = 0; i < len && i < 10; i++) {
        uint8_t* p = (uint8_t*)ptr + i * elem_size;
        fprintf(stderr, "  stmt[%d] tag=%d i64[0]=0x%llx raw: %02x %02x %02x %02x %02x %02x %02x %02x | %02x %02x %02x %02x %02x %02x %02x %02x\n",
                i, p[0],
                *(unsigned long long*)(p + 8),
                p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
                p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
    }
}

// ─── Peek trace ─────────────────────────────────────────────────
// Enable to trace all forge_peek_kind_id calls (very verbose).
static int _peek_trace = 0;
void forge_enable_peek_trace(void) { _peek_trace = 1; }
void forge_disable_peek_trace(void) { _peek_trace = 0; }
int  forge_peek_trace_enabled(void) { return _peek_trace; }
