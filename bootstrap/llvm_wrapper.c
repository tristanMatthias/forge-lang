// Pure C wrapper around LLVM's C API.
// Replaces libforge_llvm.a (Rust) — no Rust toolchain needed.
// Targets LLVM 21 C API.

#include <llvm-c/Core.h>
#include <llvm-c/Analysis.h>
#include <llvm-c/ExecutionEngine.h>
#include <llvm-c/Target.h>
#include <llvm-c/TargetMachine.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// All functions use the forge_llvm_* naming convention matching
// the extern fn declarations in src/core/llvm.fg.

// ── Context / Module / Builder ──

LLVMContextRef forge_llvm_context_create(void) {
    return LLVMContextCreate();
}

void forge_llvm_context_dispose(LLVMContextRef ctx) {
    LLVMContextDispose(ctx);
}

LLVMModuleRef forge_llvm_module_create(const char* name, LLVMContextRef ctx) {
    return LLVMModuleCreateWithNameInContext(name, ctx);
}

void forge_llvm_module_dispose(LLVMModuleRef m) {
    LLVMDisposeModule(m);
}

LLVMBuilderRef forge_llvm_create_builder(LLVMContextRef ctx) {
    return LLVMCreateBuilderInContext(ctx);
}

void forge_llvm_dispose_builder(LLVMBuilderRef b) {
    LLVMDisposeBuilder(b);
}

// ── Types ──

LLVMTypeRef forge_llvm_int1_type(LLVMContextRef ctx) {
    return LLVMInt1TypeInContext(ctx);
}

LLVMTypeRef forge_llvm_int8_type(LLVMContextRef ctx) {
    return LLVMInt8TypeInContext(ctx);
}

LLVMTypeRef forge_llvm_int32_type(LLVMContextRef ctx) {
    return LLVMInt32TypeInContext(ctx);
}

LLVMTypeRef forge_llvm_int64_type(LLVMContextRef ctx) {
    return LLVMInt64TypeInContext(ctx);
}

LLVMTypeRef forge_llvm_double_type(LLVMContextRef ctx) {
    return LLVMDoubleTypeInContext(ctx);
}

LLVMTypeRef forge_llvm_void_type(LLVMContextRef ctx) {
    return LLVMVoidTypeInContext(ctx);
}

LLVMTypeRef forge_llvm_pointer_type(LLVMContextRef ctx) {
    return LLVMPointerTypeInContext(ctx, 0);
}

LLVMValueRef forge_llvm_const_null(LLVMTypeRef ty) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_const_null: ty is NULL\n");
        abort();
    }
    return LLVMConstNull(ty);
}

LLVMTypeRef forge_llvm_function_type(LLVMTypeRef ret, LLVMTypeRef* params, int param_count, int is_vararg) {
    return LLVMFunctionType(ret, params, (unsigned)param_count, is_vararg);
}

LLVMTypeRef forge_llvm_struct_create_named(LLVMContextRef ctx, const char* name) {
    return LLVMStructCreateNamed(ctx, name);
}

LLVMTypeRef forge_llvm_struct_set_body(LLVMTypeRef st, LLVMTypeRef* elems, int count, int packed) {
    if (!st) {
        fprintf(stderr, "[CRASH] forge_llvm_struct_set_body: st is NULL\n");
        abort();
    }
    for (int i = 0; i < count; i++) {
        if (!elems[i]) {
            fprintf(stderr, "[CRASH] forge_llvm_struct_set_body: elems[%d] is NULL (struct=%s)\n",
                    i, LLVMGetStructName(st));
            abort();
        }
    }
    LLVMStructSetBody(st, elems, (unsigned)count, packed);
    return st;
}

LLVMTypeRef forge_llvm_get_type_by_name(LLVMContextRef ctx, const char* name) {
    return LLVMGetTypeByName2(ctx, name);
}

// ── Type/Value arrays (heap-allocated) ──

LLVMTypeRef* forge_llvm_type_array_new(int count) {
    if (count <= 0) return (LLVMTypeRef*)calloc(1, sizeof(LLVMTypeRef));
    return (LLVMTypeRef*)calloc(count, sizeof(LLVMTypeRef));
}

void forge_llvm_type_array_set(LLVMTypeRef* arr, int idx, LLVMTypeRef ty) {
    arr[idx] = ty;
}

void forge_llvm_type_array_free(LLVMTypeRef* arr) {
    free(arr);
}

LLVMValueRef* forge_llvm_value_array_new(int count) {
    if (count <= 0) return (LLVMValueRef*)calloc(1, sizeof(LLVMValueRef));
    return (LLVMValueRef*)calloc(count, sizeof(LLVMValueRef));
}

void forge_llvm_value_array_set(LLVMValueRef* arr, int idx, LLVMValueRef val) {
    arr[idx] = val;
}

void forge_llvm_value_array_free(LLVMValueRef* arr) {
    free(arr);
}

// ── Constants ──

LLVMValueRef forge_llvm_const_int(LLVMTypeRef ty, int64_t value, int sign_extend) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_const_int: ty is NULL (value=%lld)\n", value);
        abort();
    }
    // Safety: the bootstrap sometimes passes null or non-integer types.
    // Default to i64 (matching the everything-is-i64 model).
    if (!ty || LLVMGetTypeKind(ty) != LLVMIntegerTypeKind) {
        // Can't get context from a null type; use a global fallback.
        // This only happens in edge cases where the bootstrap's type
        // tracking loses the correct LLVM type.
        ty = LLVMInt64Type();
    }
    return LLVMConstInt(ty, (unsigned long long)value, sign_extend);
}

// ── Functions ──

LLVMValueRef forge_llvm_add_function(LLVMModuleRef m, const char* name, LLVMTypeRef fn_type) {
    if (!fn_type) {
        fprintf(stderr, "[CRASH] forge_llvm_add_function: fn_type is NULL (name=%s)\n", name);
        abort();
    }
    return LLVMAddFunction(m, name, fn_type);
}

LLVMValueRef forge_llvm_get_named_function(LLVMModuleRef m, const char* name) {
    return LLVMGetNamedFunction(m, name);
}

LLVMValueRef forge_llvm_get_param(LLVMValueRef f, int index) {
    return LLVMGetParam(f, (unsigned)index);
}

int64_t forge_llvm_count_params(LLVMValueRef f) {
    return (int64_t)LLVMCountParams(f);
}

LLVMTypeRef forge_llvm_fn_type_of(LLVMValueRef fn_val) {
    return LLVMGlobalGetValueType(fn_val);
}

// ── Globals ──

LLVMValueRef forge_llvm_add_global(LLVMModuleRef m, LLVMTypeRef ty, const char* name) {
    return LLVMAddGlobal(m, ty, name);
}

void forge_llvm_set_initializer(LLVMValueRef g, LLVMValueRef val) {
    LLVMSetInitializer(g, val);
}

// ── Basic blocks ──

LLVMBasicBlockRef forge_llvm_append_basic_block(LLVMContextRef ctx, LLVMValueRef fn_val, const char* name) {
    return LLVMAppendBasicBlockInContext(ctx, fn_val, name);
}

void forge_llvm_position_at_end(LLVMBuilderRef b, LLVMBasicBlockRef bb) {
    LLVMPositionBuilderAtEnd(b, bb);
}

int forge_llvm_block_has_terminator(LLVMBuilderRef b) {
    LLVMBasicBlockRef bb = LLVMGetInsertBlock(b);
    if (!bb) return 0;
    return LLVMGetBasicBlockTerminator(bb) != NULL ? 1 : 0;
}

LLVMBasicBlockRef forge_llvm_get_insert_block(LLVMBuilderRef b) {
    return LLVMGetInsertBlock(b);
}

// ── Integer arithmetic ──

LLVMValueRef forge_llvm_build_add(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildAdd(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_sub(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildSub(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_mul(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildMul(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_sdiv(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildSDiv(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_srem(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildSRem(b, lhs, rhs, name);
}

// ── Bitwise ──

LLVMValueRef forge_llvm_build_and(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildAnd(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_or(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildOr(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_xor(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildXor(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_shl(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildShl(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_ashr(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildAShr(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_not(LLVMBuilderRef b, LLVMValueRef val, const char* name) {
    return LLVMBuildNot(b, val, name);
}

// ── Comparison ──

LLVMValueRef forge_llvm_build_icmp(LLVMBuilderRef b, int pred, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildICmp(b, (LLVMIntPredicate)pred, lhs, rhs, name);
}

// ── Float arithmetic ──

LLVMValueRef forge_llvm_build_fadd(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFAdd(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_fsub(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFSub(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_fmul(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFMul(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_fdiv(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFDiv(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_frem(LLVMBuilderRef b, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFRem(b, lhs, rhs, name);
}

LLVMValueRef forge_llvm_build_fneg(LLVMBuilderRef b, LLVMValueRef val, const char* name) {
    return LLVMBuildFNeg(b, val, name);
}

LLVMValueRef forge_llvm_build_fcmp(LLVMBuilderRef b, int pred, LLVMValueRef lhs, LLVMValueRef rhs, const char* name) {
    return LLVMBuildFCmp(b, (LLVMRealPredicate)pred, lhs, rhs, name);
}

// ── Casts ──

LLVMValueRef forge_llvm_build_zext(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildZExt(b, val, dest_ty, name);
}

LLVMValueRef forge_llvm_build_sext(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildSExt(b, val, dest_ty, name);
}

// Validate name: if it doesn't start with a letter or underscore, it's a
// corrupted pointer value being used as a name. Use a deterministic fallback.
static const char* safe_name(const char* name, const char* fallback) {
    if (!name) return fallback;
    char c = name[0];
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '.') return name;
    return fallback;
}

LLVMValueRef forge_llvm_build_ptr_to_int(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildPtrToInt(b, val, dest_ty, safe_name(name, "p2i"));
}

LLVMValueRef forge_llvm_build_int_to_ptr(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildIntToPtr(b, val, dest_ty, safe_name(name, "i2p"));
}

LLVMValueRef forge_llvm_build_si_to_fp(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildSIToFP(b, val, dest_ty, name);
}

LLVMValueRef forge_llvm_build_fp_to_si(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildFPToSI(b, val, dest_ty, name);
}

LLVMValueRef forge_llvm_build_bitcast(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef dest_ty, const char* name) {
    return LLVMBuildBitCast(b, val, dest_ty, name);
}

// ── Memory ──

LLVMValueRef forge_llvm_build_alloca(LLVMBuilderRef b, LLVMTypeRef ty, const char* name) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_build_alloca: ty is NULL (name=%s)\n", name);
        abort();
    }
    // Always place allocas in the entry block for correctness.
    LLVMBasicBlockRef current_bb = LLVMGetInsertBlock(b);
    LLVMValueRef fn = LLVMGetBasicBlockParent(current_bb);
    LLVMBasicBlockRef entry = LLVMGetEntryBasicBlock(fn);
    LLVMValueRef first_inst = LLVMGetFirstInstruction(entry);

    LLVMBuilderRef entry_builder = LLVMCreateBuilder();
    if (first_inst) {
        LLVMPositionBuilderBefore(entry_builder, first_inst);
    } else {
        LLVMPositionBuilderAtEnd(entry_builder, entry);
    }
    LLVMValueRef alloca = LLVMBuildAlloca(entry_builder, ty, name);
    LLVMDisposeBuilder(entry_builder);
    return alloca;
}

LLVMValueRef forge_llvm_build_load(LLVMBuilderRef b, LLVMTypeRef ty, LLVMValueRef ptr_val, const char* name) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_build_load: ty is NULL (name=%s)\n", name);
        abort();
    }
    LLVMValueRef load = LLVMBuildLoad2(b, ty, ptr_val, name);
    // Force align 8 for i64 loads to avoid optimizer miscompiles.
    LLVMSetAlignment(load, 8);
    return load;
}

// Emit a CALL to forge_track_store_i64/ptr that logs and performs the store.
// Falls back to raw store if the tracking function isn't available.
static LLVMValueRef tracked_store_or_raw(LLVMBuilderRef b, LLVMValueRef val, LLVMValueRef ptr_val) {
    if (!getenv("FORGE_TRACK_STORES")) {
        LLVMValueRef store = LLVMBuildStore(b, val, ptr_val);
        LLVMSetAlignment(store, 8);
        return store;
    }
    LLVMBasicBlockRef bb = LLVMGetInsertBlock(b);
    LLVMValueRef fn = LLVMGetBasicBlockParent(bb);
    LLVMModuleRef mod = LLVMGetGlobalParent(fn);
    LLVMContextRef lc = LLVMGetModuleContext(mod);
    LLVMTypeRef i64t = LLVMInt64TypeInContext(lc);
    LLVMTypeRef pt = LLVMPointerTypeInContext(lc, 0);
    LLVMTypeRef val_ty = LLVMTypeOf(val);
    LLVMTypeKind kind = LLVMGetTypeKind(val_ty);
    const char* fn_name;
    LLVMTypeRef arg1_ty;
    if (kind == LLVMPointerTypeKind) {
        fn_name = "forge_track_store_ptr";
        arg1_ty = pt;
    } else if (kind == LLVMIntegerTypeKind && LLVMGetIntTypeWidth(val_ty) == 64) {
        fn_name = "forge_track_store_i64";
        arg1_ty = i64t;
    } else {
        // Types we don't track (i1, f64, etc.) — raw store
        LLVMValueRef store = LLVMBuildStore(b, val, ptr_val);
        LLVMSetAlignment(store, 8);
        return store;
    }
    LLVMValueRef tracker = LLVMGetNamedFunction(mod, fn_name);
    if (!tracker) {
        LLVMTypeRef params[] = { pt, arg1_ty };
        LLVMTypeRef ft = LLVMFunctionType(LLVMVoidTypeInContext(lc), params, 2, 0);
        tracker = LLVMAddFunction(mod, fn_name, ft);
    }
    LLVMTypeRef params[] = { pt, arg1_ty };
    LLVMTypeRef ft = LLVMFunctionType(LLVMVoidTypeInContext(lc), params, 2, 0);
    LLVMValueRef args[] = { ptr_val, val };
    LLVMBuildCall2(b, ft, tracker, args, 2, "");
    return NULL;
}

LLVMValueRef forge_llvm_build_store(LLVMBuilderRef b, LLVMValueRef val, LLVMValueRef ptr_val) {
    LLVMValueRef r = tracked_store_or_raw(b, val, ptr_val);
    return r;
}

LLVMValueRef forge_llvm_build_struct_gep2(LLVMBuilderRef b, LLVMTypeRef ty, LLVMValueRef ptr_val, int idx, const char* name) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_build_struct_gep2: ty is NULL (idx=%d, name=%s)\n", idx, name);
        abort();
    }
    return LLVMBuildStructGEP2(b, ty, ptr_val, (unsigned)idx, name);
}

LLVMValueRef forge_llvm_build_global_string_ptr(LLVMBuilderRef b, const char* s, const char* name) {
    return LLVMBuildGlobalStringPtr(b, s, name);
}

// ── Calls ──

LLVMValueRef forge_llvm_build_call(LLVMBuilderRef b, LLVMTypeRef fn_type, LLVMValueRef fn_val, LLVMValueRef* args, int count, const char* name) {
    if (!fn_type) {
        fprintf(stderr, "[CRASH] forge_llvm_build_call: fn_type is NULL (name=%s)\n", name ? name : "(null)");
        abort();
    }
    LLVMTypeRef ret_type = LLVMGetReturnType(fn_type);
    int is_void = (LLVMGetTypeKind(ret_type) == LLVMVoidTypeKind);
    const char* call_name = is_void ? "" : (name ? name : "");
    LLVMValueRef result = LLVMBuildCall2(b, fn_type, fn_val, args, (unsigned)count, call_name);
    if (is_void) {
        LLVMContextRef ctx = LLVMGetModuleContext(LLVMGetGlobalParent(fn_val));
        return LLVMConstInt(LLVMInt64TypeInContext(ctx), 0, 0);
    }
    return result;
}

// ── Control flow ──

LLVMValueRef forge_llvm_build_br(LLVMBuilderRef b, LLVMBasicBlockRef bb) {
    return LLVMBuildBr(b, bb);
}

LLVMValueRef forge_llvm_build_cond_br(LLVMBuilderRef b, LLVMValueRef cond, LLVMBasicBlockRef then_bb, LLVMBasicBlockRef else_bb) {
    return LLVMBuildCondBr(b, cond, then_bb, else_bb);
}

LLVMValueRef forge_llvm_build_ret(LLVMBuilderRef b, LLVMValueRef val) {
    return LLVMBuildRet(b, val);
}

LLVMValueRef forge_llvm_build_unreachable(LLVMBuilderRef b) {
    return LLVMBuildUnreachable(b);
}

// ── PHI nodes ──

LLVMValueRef forge_llvm_build_phi(LLVMBuilderRef b, LLVMTypeRef ty, const char* name) {
    if (!ty) {
        fprintf(stderr, "[CRASH] forge_llvm_build_phi: ty is NULL (name=%s)\n", name);
        abort();
    }
    return LLVMBuildPhi(b, ty, name);
}

void forge_llvm_add_incoming(LLVMValueRef phi, LLVMValueRef value, LLVMBasicBlockRef block) {
    LLVMValueRef vals[1] = { value };
    LLVMBasicBlockRef blocks[1] = { block };
    LLVMAddIncoming(phi, vals, blocks, 1);
}

// ── Module output ──

int forge_llvm_print_module_to_file(LLVMModuleRef m, const char* path) {
    char* error = NULL;
    int result = LLVMPrintModuleToFile(m, path, &error);
    if (error) {
        fprintf(stderr, "LLVM error: %s\n", error);
        LLVMDisposeMessage(error);
    }
    return result;
}

int forge_llvm_verify_module_print(LLVMModuleRef m) {
    char* error = NULL;
    int result = LLVMVerifyModule(m, LLVMPrintMessageAction, &error);
    if (error) LLVMDisposeMessage(error);
    return result;
}

// Verify a single function. Returns 0 if valid, 1 if invalid.
// Prints the error to stderr with the function name for easy debugging.
int forge_llvm_verify_function(LLVMValueRef fn_val) {
    int result = LLVMVerifyFunction(fn_val, LLVMPrintMessageAction);
    if (result) {
        const char* name = LLVMGetValueName(fn_val);
        fprintf(stderr, "FATAL: LLVM verification failed for function `%s`\n", name ? name : "<unknown>");
    }
    return result;
}

// ── Type introspection ──

// Returns 1 if the LLVM value's type is a pointer type, 0 otherwise.
// Used by the codegen to avoid redundant ptrtoint/inttoptr casts.
int forge_llvm_is_ptr_value(LLVMValueRef val) {
    return LLVMGetTypeKind(LLVMTypeOf(val)) == LLVMPointerTypeKind ? 1 : 0;
}

// Returns the LLVM type of a value (LLVMTypeOf wrapper).
LLVMTypeRef forge_llvm_typeof(LLVMValueRef val) {
    return LLVMTypeOf(val);
}

// Returns 1 if the LLVM value has void type, 0 otherwise.
int forge_llvm_is_void_value(LLVMValueRef val) {
    if (!val) return 1;
    return LLVMGetTypeKind(LLVMTypeOf(val)) == LLVMVoidTypeKind ? 1 : 0;
}

// Cast a value to match an expected type. Handles all combinations:
//   ptr ↔ integer: ptrtoint / inttoptr
//   integer ↔ integer (different widths): zext / trunc
//   double ↔ i64: bitcast (bit reinterpretation)
//   smaller int → double: sitofp
//   double → smaller int: fptosi
// Returns val unchanged if types already match.
LLVMValueRef forge_llvm_cast_to_type(LLVMBuilderRef b, LLVMValueRef val, LLVMTypeRef expected) {
    LLVMTypeRef actual = LLVMTypeOf(val);
    if (actual == expected) return val;
    LLVMTypeKind ak = LLVMGetTypeKind(actual);
    LLVMTypeKind ek = LLVMGetTypeKind(expected);

    // ptr → integer
    if (ak == LLVMPointerTypeKind && ek == LLVMIntegerTypeKind)
        return LLVMBuildPtrToInt(b, val, expected, "cast");
    // integer → ptr
    if (ak == LLVMIntegerTypeKind && ek == LLVMPointerTypeKind)
        return LLVMBuildIntToPtr(b, val, expected, "cast");
    // integer → integer (i1↔i64, i32↔i64, etc.)
    if (ak == LLVMIntegerTypeKind && ek == LLVMIntegerTypeKind) {
        unsigned aw = LLVMGetIntTypeWidth(actual);
        unsigned ew = LLVMGetIntTypeWidth(expected);
        if (aw < ew) return LLVMBuildZExt(b, val, expected, "cast");
        if (aw > ew) return LLVMBuildTrunc(b, val, expected, "cast");
        return val;
    }
    // double ↔ i64: bitcast (preserves bits)
    if (ak == LLVMDoubleTypeKind && ek == LLVMIntegerTypeKind) {
        unsigned ew = LLVMGetIntTypeWidth(expected);
        if (ew == 64) return LLVMBuildBitCast(b, val, expected, "cast");
        return LLVMBuildFPToSI(b, val, expected, "cast");
    }
    if (ak == LLVMIntegerTypeKind && ek == LLVMDoubleTypeKind) {
        unsigned aw = LLVMGetIntTypeWidth(actual);
        if (aw == 64) return LLVMBuildBitCast(b, val, expected, "cast");
        return LLVMBuildSIToFP(b, val, expected, "cast");
    }
    // ptr ↔ double: chain through i64
    if (ak == LLVMPointerTypeKind && ek == LLVMDoubleTypeKind) {
        LLVMContextRef ctx = LLVMGetTypeContext(expected);
        LLVMValueRef i = LLVMBuildPtrToInt(b, val, LLVMInt64TypeInContext(ctx), "cast");
        return LLVMBuildBitCast(b, i, expected, "cast");
    }
    if (ak == LLVMDoubleTypeKind && ek == LLVMPointerTypeKind) {
        LLVMContextRef ctx = LLVMGetTypeContext(actual);
        LLVMValueRef i = LLVMBuildBitCast(b, val, LLVMInt64TypeInContext(ctx), "cast");
        return LLVMBuildIntToPtr(b, i, expected, "cast");
    }
    return val;
}

// Type-safe store for alloca destinations: casts the value to match
// the alloca's allocated type. For non-alloca destinations (GEPs),
// performs a raw store — the caller MUST use store_field with an
// explicit type for struct field stores.
void forge_llvm_build_store_cast(LLVMBuilderRef b, LLVMValueRef val, LLVMValueRef dest) {
    LLVMTypeRef dest_ty = LLVMGetAllocatedType(dest);
    if (dest_ty) {
        val = forge_llvm_cast_to_type(b, val, dest_ty);
    }
    tracked_store_or_raw(b, val, dest);
}

// Type introspection helpers for the Forge codegen.
int64_t forge_llvm_type_kind(LLVMTypeRef ty) {
    return (int64_t)LLVMGetTypeKind(ty);
}
int64_t forge_llvm_int_type_width(LLVMTypeRef ty) {
    return (int64_t)LLVMGetIntTypeWidth(ty);
}

// Build a call with automatic argument type coercion.
// For each argument, if the value type doesn't match the function's
// expected parameter type, insert a cast (ptr↔i64).
LLVMValueRef forge_llvm_build_call_coerce(LLVMBuilderRef b,
    LLVMTypeRef fn_type, LLVMValueRef fn_val,
    LLVMValueRef* args, int64_t count, const char* name) {
    if (!fn_type) {
        fprintf(stderr, "[CRASH] forge_llvm_build_call_coerce: fn_type is NULL (name=%s)\n", name ? name : "(null)");
        abort();
    }
    unsigned param_count = LLVMCountParamTypes(fn_type);
    LLVMTypeRef* param_types = NULL;
    if (param_count > 0) {
        param_types = (LLVMTypeRef*)malloc(param_count * sizeof(LLVMTypeRef));
        LLVMGetParamTypes(fn_type, param_types);
    }
    for (int i = 0; i < count && i < (int)param_count; i++) {
        args[i] = forge_llvm_cast_to_type(b, args[i], param_types[i]);
    }
    if (param_types) free(param_types);
    // Void-returning calls must not have a name (LLVM requirement).
    LLVMTypeRef ret_type = LLVMGetReturnType(fn_type);
    int is_void = (LLVMGetTypeKind(ret_type) == LLVMVoidTypeKind);
    const char* call_name = is_void ? "" : (name ? name : "");
    LLVMValueRef result = LLVMBuildCall2(b, fn_type, fn_val, args, (unsigned)count, call_name);
    // Void values cannot be stored, returned, or used in the value pipeline.
    // Replace with i64 0 so callers don't need to handle void specially.
    if (is_void) {
        LLVMContextRef ctx = LLVMGetModuleContext(LLVMGetGlobalParent(fn_val));
        return LLVMConstInt(LLVMInt64TypeInContext(ctx), 0, 0);
    }
    // If the return type is a smaller integer (i32, i8, i1), widen to i64.
    // i1 uses zext (bool is unsigned), others use sext (C int is signed).
    if (LLVMGetTypeKind(ret_type) == LLVMIntegerTypeKind) {
        unsigned width = LLVMGetIntTypeWidth(ret_type);
        if (width < 64) {
            LLVMContextRef ctx = LLVMGetModuleContext(LLVMGetGlobalParent(fn_val));
            LLVMTypeRef i64_type = LLVMInt64TypeInContext(ctx);
            if (width == 1) return LLVMBuildZExt(b, result, i64_type, "widen");
            return LLVMBuildSExt(b, result, i64_type, "widen");
        }
    }
    return result;
}

// ── Coverage instrumentation ──
// Declares @llvm.instrprof.increment and provides helpers for emitting
// coverage region counters. The LLVM InstrProfiling pass lowers these
// intrinsic calls into __profc_* counter arrays and __profd_* data records.

static LLVMValueRef coverage_intrinsic = NULL;
static int32_t coverage_region_counter = 0;
static int32_t coverage_fn_region_count = 0;

// Declare @llvm.instrprof.increment(ptr, i64, i32, i32) in the module.
// Idempotent — safe to call multiple times.
void forge_coverage_declare(LLVMModuleRef m) {
    if (coverage_intrinsic) return;
    LLVMContextRef ctx = LLVMGetModuleContext(m);
    LLVMTypeRef param_types[] = {
        LLVMPointerType(LLVMInt8TypeInContext(ctx), 0),
        LLVMInt64TypeInContext(ctx),
        LLVMInt32TypeInContext(ctx),
        LLVMInt32TypeInContext(ctx)
    };
    LLVMTypeRef fn_type = LLVMFunctionType(LLVMVoidTypeInContext(ctx), param_types, 4, 0);
    coverage_intrinsic = LLVMAddFunction(m, "llvm.instrprof.increment", fn_type);
}

// Create @__profn_<name> = private constant [N x i8] c"<name>"
// Returns the global value for use in instrprof.increment calls.
LLVMValueRef forge_coverage_name_global(LLVMModuleRef m, const char* fn_name) {
    // Check if already created
    char buf[512];
    snprintf(buf, sizeof(buf), "__profn_%s", fn_name);
    LLVMValueRef existing = LLVMGetNamedGlobal(m, buf);
    if (existing) return existing;

    LLVMContextRef ctx = LLVMGetModuleContext(m);
    size_t len = strlen(fn_name);
    LLVMValueRef str = LLVMConstStringInContext(ctx, fn_name, (unsigned)len, 1);
    LLVMValueRef global = LLVMAddGlobal(m, LLVMTypeOf(str), buf);
    LLVMSetInitializer(global, str);
    LLVMSetLinkage(global, LLVMPrivateLinkage);
    LLVMSetGlobalConstant(global, 1);
    return global;
}

// Emit: call void @llvm.instrprof.increment(ptr @__profn_<name>, i64 <hash>, i32 <num_counters>, i32 <idx>)
// num_counters is set to a placeholder (0) during codegen, then patched to
// the actual count by forge_coverage_finalize_fn at function end.
void forge_coverage_emit_hit(LLVMBuilderRef builder, LLVMModuleRef m,
                              const char* fn_name, int64_t fn_hash_unused,
                              int32_t num_counters_unused, int32_t counter_idx) {
    if (!coverage_intrinsic) return;
    // Compute unique hash from function name (djb2)
    uint64_t hash = 5381;
    for (const char* p = fn_name; *p; p++)
        hash = ((hash << 5) + hash) + (uint64_t)*p;
    LLVMContextRef ctx = LLVMGetModuleContext(m);
    LLVMValueRef name_global = forge_coverage_name_global(m, fn_name);
    // Use 0 as placeholder for num_counters — patched by finalize_fn
    LLVMValueRef args[] = {
        name_global,
        LLVMConstInt(LLVMInt64TypeInContext(ctx), hash, 0),
        LLVMConstInt(LLVMInt32TypeInContext(ctx), 0, 0),
        LLVMConstInt(LLVMInt32TypeInContext(ctx), (uint32_t)counter_idx, 0)
    };
    LLVMTypeRef param_types[] = {
        LLVMPointerType(LLVMInt8TypeInContext(ctx), 0),
        LLVMInt64TypeInContext(ctx),
        LLVMInt32TypeInContext(ctx),
        LLVMInt32TypeInContext(ctx)
    };
    LLVMTypeRef fn_type = LLVMFunctionType(LLVMVoidTypeInContext(ctx), param_types, 4, 0);
    LLVMBuildCall2(builder, fn_type, coverage_intrinsic, args, 4, "");
}

// Patch all llvm.instrprof.increment calls in fn_val to use actual_count
// as the num_counters argument (arg index 2).
void forge_coverage_finalize_fn(LLVMValueRef fn_val, int32_t actual_count) {
    if (!coverage_intrinsic || actual_count <= 0) return;
    LLVMContextRef ctx = LLVMGetGlobalParent(fn_val) ?
        LLVMGetModuleContext(LLVMGetGlobalParent(fn_val)) : NULL;
    if (!ctx) return;
    LLVMValueRef count_val = LLVMConstInt(LLVMInt32TypeInContext(ctx),
                                           (uint32_t)actual_count, 0);
    LLVMBasicBlockRef bb = LLVMGetFirstBasicBlock(fn_val);
    while (bb) {
        LLVMValueRef inst = LLVMGetFirstInstruction(bb);
        while (inst) {
            if (LLVMIsACallInst(inst)) {
                LLVMValueRef callee = LLVMGetCalledValue(inst);
                if (callee == coverage_intrinsic) {
                    // Replace arg 2 (num_counters) with actual count
                    LLVMSetOperand(inst, 2, count_val);
                }
            }
            inst = LLVMGetNextInstruction(inst);
        }
        bb = LLVMGetNextBasicBlock(bb);
    }
}

// ── Coverage mapping (counter allocation + JSON covmap) ──

#include <stdio.h>

#define COV_MAX_COUNTERS 65536

typedef struct {
    const char* type;       // "line", "branch_then", "branch_else", "fn_entry", "match_arm"
    const char* fn_name;
    int32_t line;
    int32_t col;
    int32_t branch_id;      // for grouping then/else pairs
} CovCounterInfo;

static CovCounterInfo cov_counters[COV_MAX_COUNTERS];
static int32_t cov_next_id = 0;
static int32_t cov_branch_id = 0;
static int32_t cov_decision_id = 0;
static int32_t cov_total_entries = 0;
static const char* cov_source_file = NULL;
static FILE* cov_map_file = NULL;

void forge_covmap_begin(const char* source_file, const char* covmap_path) {
    cov_next_id = 0;
    cov_branch_id = 0;
    cov_decision_id = 0;
    cov_total_entries = 0;
    cov_source_file = source_file;
    cov_map_file = fopen(covmap_path, "w");
    if (cov_map_file) {
        fprintf(cov_map_file, "{\"file\":\"%s\",\"counters\":[\n", source_file);
    }
}

int32_t forge_covmap_alloc(const char* type, const char* fn_name, int32_t line, int32_t col, int32_t branch_id) {
    if (cov_next_id >= COV_MAX_COUNTERS) return -1;
    int32_t id = cov_next_id++;
    cov_counters[id].type = type;
    cov_counters[id].fn_name = fn_name;
    cov_counters[id].line = line;
    cov_counters[id].col = col;
    cov_counters[id].branch_id = branch_id;
    
    if (cov_map_file) {
        if (cov_total_entries > 0) fprintf(cov_map_file, ",\n");
        cov_total_entries++;
        fprintf(cov_map_file, "  {\"id\":%d,\"type\":\"%s\",\"fn\":\"%s\",\"line\":%d,\"col\":%d,\"branch\":%d}",
                id, type, fn_name, line, col, branch_id);
    }
    return id;
}

void forge_covmap_reset_fn(void) {
    cov_next_id = 0;
}

// Returns the number of counters allocated for the current function.
int32_t forge_covmap_counter_count(void) {
    return cov_next_id;
}

int32_t forge_covmap_next_branch_id(void) {
    return cov_branch_id++;
}

int32_t forge_covmap_next_decision_id(void) {
    return cov_decision_id++;
}

void forge_covmap_end(void) {
    if (cov_map_file) {
        fprintf(cov_map_file, "\n]}\n");
        fclose(cov_map_file);
        cov_map_file = NULL;
    }
}

// ── Basic block / instruction helpers ──

LLVMBasicBlockRef forge_llvm_get_entry_basic_block(LLVMValueRef fn) {
    return LLVMGetEntryBasicBlock(fn);
}

LLVMValueRef forge_llvm_get_first_instruction(LLVMBasicBlockRef bb) {
    return LLVMGetFirstInstruction(bb);
}

void forge_llvm_position_before(LLVMBuilderRef builder, LLVMValueRef instr) {
    LLVMPositionBuilderBefore(builder, instr);
}

void forge_llvm_build_call_void(LLVMBuilderRef builder, LLVMModuleRef mod, const char* fn_name, LLVMValueRef* args, int arg_count) {
    LLVMValueRef fn = LLVMGetNamedFunction(mod, fn_name);
    if (!fn) return;
    LLVMTypeRef fn_ty = LLVMGlobalGetValueType(fn);
    LLVMBuildCall2(builder, fn_ty, fn, args, arg_count, "");
}

// ── JIT Execution ──
// Execute an LLVM module's main() function in-process via MCJIT.
// Returns the exit code from main(), or -1 on error.

int64_t forge_llvm_jit_run(LLVMModuleRef module) {
    // Initialize native target for JIT
    LLVMLinkInMCJIT();
    LLVMInitializeNativeTarget();
    LLVMInitializeNativeAsmPrinter();
    LLVMInitializeNativeAsmParser();

    char* error = NULL;
    LLVMExecutionEngineRef engine;
    struct LLVMMCJITCompilerOptions options;
    LLVMInitializeMCJITCompilerOptions(&options, sizeof(options));
    options.OptLevel = 2;

    if (LLVMCreateMCJITCompilerForModule(&engine, module, &options, sizeof(options), &error)) {
        fprintf(stderr, "JIT error: %s\n", error);
        LLVMDisposeMessage(error);
        return -1;
    }

    // Look up main
    uint64_t main_addr = LLVMGetFunctionAddress(engine, "main");
    if (!main_addr) {
        fprintf(stderr, "JIT error: main() not found\n");
        LLVMDisposeExecutionEngine(engine);
        return -1;
    }

    // Call main() — it takes no args and returns void in our convention
    typedef void (*MainFn)(void);
    MainFn main_fn = (MainFn)main_addr;
    main_fn();

    LLVMDisposeExecutionEngine(engine);
    return 0;
}

// ── Object File Emission ──
// Emit an LLVM module as an object file. Returns 0 on success, -1 on error.

int64_t forge_llvm_emit_object(LLVMModuleRef module, const char* output_path) {
    LLVMInitializeNativeTarget();
    LLVMInitializeNativeAsmPrinter();

    char* triple = LLVMGetDefaultTargetTriple();
    LLVMTargetRef target;
    char* error = NULL;

    if (LLVMGetTargetFromTriple(triple, &target, &error)) {
        fprintf(stderr, "target error: %s\n", error);
        LLVMDisposeMessage(error);
        LLVMDisposeMessage(triple);
        return -1;
    }

    LLVMTargetMachineRef tm = LLVMCreateTargetMachine(
        target, triple, "generic", "",
        LLVMCodeGenLevelDefault, LLVMRelocDefault, LLVMCodeModelDefault);
    LLVMDisposeMessage(triple);

    if (LLVMTargetMachineEmitToFile(tm, module, (char*)output_path, LLVMObjectFile, &error)) {
        fprintf(stderr, "emit error: %s\n", error);
        LLVMDisposeMessage(error);
        LLVMDisposeTargetMachine(tm);
        return -1;
    }

    LLVMDisposeTargetMachine(tm);
    return 0;
}
