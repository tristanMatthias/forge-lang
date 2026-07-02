// ═══════════════════════════════════════════════════════════════════
// Forge Debug Utilities
// ═══════════════════════════════════════════════════════════════════
// Included by runtime.c — do NOT compile separately.
// All types (ForgeString, etc.) are already defined by runtime.c.
// ═══════════════════════════════════════════════════════════════════

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

// ─── Token ABI diagnostic ───────────────────────────────────────
// Token = {i64 kind, Span{4xi64}, ForgeString{ptr,i64}, i64 kind_id} = 64 bytes
typedef struct {
    int64_t kind;
    int64_t span[4];
    ForgeString text;
    int64_t kind_id;
} DebugToken;

// Dump a Token struct (passed by pointer to 64-byte memory)
void forge_debug_dump_token(DebugToken* tok) {
    if (!tok) return;
    static int _ddt = 0;
    if (_ddt < 20) {
        fprintf(stderr, "[DBG_TOKEN] kind=%lld kid=%lld text='%.*s' span.start=%lld\n",
                (long long)tok->kind, (long long)tok->kind_id,
                tok->text.ptr && tok->text.len > 0 ? (int)(tok->text.len < 20 ? tok->text.len : 20) : 0,
                tok->text.ptr ? tok->text.ptr : "",
                (long long)tok->span[0]);
        _ddt++;
    }
}

// ─── Token raw dump ─────────────────────────────────────────────
// Dump raw bytes of a Token value by pointer.
// Use to diagnose field ordering / ABI issues at runtime.
// Call: forge_dump_token_raw(&token) from C, or pass alloca ptr from Forge.
void forge_dump_token_raw(void* ptr) {
    if (!ptr) { fprintf(stderr, "[TOKEN_RAW] null\n"); return; }
    uint8_t* p = (uint8_t*)ptr;
    // Dump first 64 bytes as i64 values (8 i64s)
    int64_t* vals = (int64_t*)ptr;
    fprintf(stderr, "[TOKEN_RAW] i64s:");
    for (int i = 0; i < 8; i++) fprintf(stderr, " [%d]=%lld", i, (long long)vals[i]);
    fprintf(stderr, "\n");
}

// Validate Token struct: checks that kind_id (last i64 field) is non-zero.
// Token = {i64 kind, Span{4×i64}, ForgeString{ptr,i64}, i64 kind_id}
// kind_id should be at offset 56 (byte offset) = i64 index 7.
// Returns 1 if valid, 0 if kind_id is 0 (likely field order bug).
int64_t forge_validate_token(void* ptr) {
    if (!ptr) return 0;
    int64_t* vals = (int64_t*)ptr;
    int64_t kind_id = vals[7]; // i64 at byte offset 56
    if (kind_id == 0) {
        static int _vt_trace = 0;
        if (_vt_trace < 10) {
            fprintf(stderr, "[VALIDATE_TOKEN] kind_id=0 at offset 7! Full dump:");
            for (int i = 0; i < 8; i++) fprintf(stderr, " [%d]=%lld", i, (long long)vals[i]);
            fprintf(stderr, "\n");
            _vt_trace++;
        }
        return 0;
    }
    return 1;
}
