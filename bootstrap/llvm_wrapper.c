// Pure C wrapper around LLVM's C API.
// Replaces libforge_llvm.a (Rust) — no Rust toolchain needed.
// Targets LLVM 21 C API.

#include <llvm-c/Core.h>
#include <llvm-c/Analysis.h>
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
    return LLVMConstNull(ty);
}

LLVMTypeRef forge_llvm_function_type(LLVMTypeRef ret, LLVMTypeRef* params, int param_count, int is_vararg) {
    return LLVMFunctionType(ret, params, (unsigned)param_count, is_vararg);
}

LLVMTypeRef forge_llvm_struct_create_named(LLVMContextRef ctx, const char* name) {
    return LLVMStructCreateNamed(ctx, name);
}

LLVMTypeRef forge_llvm_struct_set_body(LLVMTypeRef st, LLVMTypeRef* elems, int count, int packed) {
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

LLVMValueRef forge_llvm_const_real(LLVMTypeRef ty, double value) {
    return LLVMConstReal(ty, value);
}

// ── Functions ──

LLVMValueRef forge_llvm_add_function(LLVMModuleRef m, const char* name, LLVMTypeRef fn_type) {
    return LLVMAddFunction(m, name, fn_type);
}

LLVMValueRef forge_llvm_get_named_function(LLVMModuleRef m, const char* name) {
    return LLVMGetNamedFunction(m, name);
}

LLVMValueRef forge_llvm_get_param(LLVMValueRef f, int index) {
    return LLVMGetParam(f, (unsigned)index);
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

void forge_llvm_set_global_constant(LLVMValueRef g, int is_constant) {
    LLVMSetGlobalConstant(g, is_constant);
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
    return LLVMBuildStructGEP2(b, ty, ptr_val, (unsigned)idx, name);
}

LLVMValueRef forge_llvm_build_global_string_ptr(LLVMBuilderRef b, const char* s, const char* name) {
    return LLVMBuildGlobalStringPtr(b, s, name);
}

// ── Calls ──

LLVMValueRef forge_llvm_build_call(LLVMBuilderRef b, LLVMTypeRef fn_type, LLVMValueRef fn_val, LLVMValueRef* args, int count, const char* name) {
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
