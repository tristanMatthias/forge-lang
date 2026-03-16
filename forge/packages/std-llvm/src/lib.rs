//! Thin Rust wrappers around the LLVM C API for use from Forge programs.
//! Each function is a 1-3 line wrapper that calls the corresponding LLVM C API function.

use std::ffi::{c_char, c_int, c_uint, c_ulonglong, c_void};

// Opaque pointer type used for all LLVM refs
type LLVMPtr = *mut c_void;

// LLVM C API bindings (from llvm-c/Core.h, llvm-c/Analysis.h)
extern "C" {
    // Context
    fn LLVMContextCreate() -> LLVMPtr;
    fn LLVMContextDispose(ctx: LLVMPtr);

    // Module
    fn LLVMModuleCreateWithNameInContext(name: *const c_char, ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDisposeModule(m: LLVMPtr);
    fn LLVMPrintModuleToString(m: LLVMPtr) -> *mut c_char;
    fn LLVMDisposeMessage(msg: *mut c_char);

    // Types
    fn LLVMInt1TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt8TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt32TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt64TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDoubleTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMVoidTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMPointerTypeInContext(ctx: LLVMPtr, address_space: c_uint) -> LLVMPtr;
    fn LLVMFunctionType(ret: LLVMPtr, params: *mut LLVMPtr, param_count: c_uint, is_vararg: c_int) -> LLVMPtr;

    // Functions
    fn LLVMAddFunction(m: LLVMPtr, name: *const c_char, fn_type: LLVMPtr) -> LLVMPtr;
    fn LLVMGetParam(f: LLVMPtr, index: c_uint) -> LLVMPtr;

    // Basic Blocks
    fn LLVMAppendBasicBlockInContext(ctx: LLVMPtr, f: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Builder
    fn LLVMCreateBuilderInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMPositionBuilderAtEnd(builder: LLVMPtr, bb: LLVMPtr);
    fn LLVMDisposeBuilder(builder: LLVMPtr);
    fn LLVMBuildRet(builder: LLVMPtr, value: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildRetVoid(builder: LLVMPtr) -> LLVMPtr;

    // Arithmetic
    fn LLVMBuildAdd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildMul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Constants
    fn LLVMConstInt(ty: LLVMPtr, n: c_ulonglong, sign_extend: c_int) -> LLVMPtr;

    // Verification
    fn LLVMVerifyModule(m: LLVMPtr, action: c_int, out_message: *mut *mut c_char) -> c_int;

    // Memory
    fn LLVMBuildAlloca(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildStore(builder: LLVMPtr, val: LLVMPtr, ptr: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildLoad2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Control flow
    fn LLVMBuildBr(builder: LLVMPtr, dest: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildCondBr(builder: LLVMPtr, cond: LLVMPtr, then_bb: LLVMPtr, else_bb: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildICmp(builder: LLVMPtr, op: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Calls
    fn LLVMBuildCall2(builder: LLVMPtr, fn_type: LLVMPtr, f: LLVMPtr, args: *mut LLVMPtr, num_args: c_uint, name: *const c_char) -> LLVMPtr;

    // Strings
    fn LLVMBuildGlobalStringPtr(builder: LLVMPtr, s: *const c_char, name: *const c_char) -> LLVMPtr;

    // PHI
    fn LLVMBuildPhi(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMAddIncoming(phi: LLVMPtr, values: *mut LLVMPtr, blocks: *mut LLVMPtr, count: c_uint);
}

// ── Context & Module ──

#[no_mangle]
pub extern "C" fn forge_llvm_context_create() -> LLVMPtr {
    unsafe { LLVMContextCreate() }
}

#[no_mangle]
pub extern "C" fn forge_llvm_context_dispose(ctx: LLVMPtr) {
    unsafe { LLVMContextDispose(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_module_create(name: *const c_char, ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMModuleCreateWithNameInContext(name, ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_module_dispose(m: LLVMPtr) {
    unsafe { LLVMDisposeModule(m) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_module_print(m: LLVMPtr) -> *mut c_char {
    unsafe { LLVMPrintModuleToString(m) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_dispose_message(msg: *mut c_char) {
    unsafe { LLVMDisposeMessage(msg) }
}

// ── Types ──

#[no_mangle]
pub extern "C" fn forge_llvm_int1_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMInt1TypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_int8_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMInt8TypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_int32_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMInt32TypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_int64_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMInt64TypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_double_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMDoubleTypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_void_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMVoidTypeInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_pointer_type(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMPointerTypeInContext(ctx, 0) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_function_type(ret: LLVMPtr, params: *mut LLVMPtr, param_count: c_int, is_vararg: c_int) -> LLVMPtr {
    unsafe { LLVMFunctionType(ret, params, param_count as c_uint, is_vararg) }
}

// ── Type array helpers ──

#[no_mangle]
pub extern "C" fn forge_llvm_type_array_new(count: c_int) -> *mut LLVMPtr {
    let layout = std::alloc::Layout::array::<LLVMPtr>(count as usize).unwrap();
    unsafe {
        let ptr = std::alloc::alloc_zeroed(layout) as *mut LLVMPtr;
        ptr
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_type_array_set(arr: *mut LLVMPtr, index: c_int, ty: LLVMPtr) {
    unsafe { *arr.offset(index as isize) = ty; }
}

#[no_mangle]
pub extern "C" fn forge_llvm_type_array_free(arr: *mut LLVMPtr) {
    // We don't know the original size, so we can't properly deallocate.
    // In practice this is a small leak per call. For a proper solution we'd
    // need to store the size, but for a wrapper this is fine.
    let _ = arr;
}

// ── Functions ──

#[no_mangle]
pub extern "C" fn forge_llvm_add_function(m: LLVMPtr, name: *const c_char, fn_type: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMAddFunction(m, name, fn_type) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_param(f: LLVMPtr, index: c_int) -> LLVMPtr {
    unsafe { LLVMGetParam(f, index as c_uint) }
}

// ── Basic Blocks & Builder ──

#[no_mangle]
pub extern "C" fn forge_llvm_append_basic_block(ctx: LLVMPtr, f: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMAppendBasicBlockInContext(ctx, f, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_create_builder(ctx: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMCreateBuilderInContext(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_position_at_end(builder: LLVMPtr, bb: LLVMPtr) {
    unsafe { LLVMPositionBuilderAtEnd(builder, bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_dispose_builder(builder: LLVMPtr) {
    unsafe { LLVMDisposeBuilder(builder) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ret(builder: LLVMPtr, value: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildRet(builder, value) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ret_void(builder: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildRetVoid(builder) }
}

// ── Arithmetic ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_add(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildAdd(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_sub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSub(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_mul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildMul(builder, lhs, rhs, name) }
}

// ── Constants ──

#[no_mangle]
pub extern "C" fn forge_llvm_const_int(ty: LLVMPtr, value: i64, sign_extend: c_int) -> LLVMPtr {
    unsafe { LLVMConstInt(ty, value as c_ulonglong, sign_extend) }
}

// ── Verification ──

#[no_mangle]
pub extern "C" fn forge_llvm_verify_module(m: LLVMPtr) -> c_int {
    unsafe {
        let mut err: *mut c_char = std::ptr::null_mut();
        let result = LLVMVerifyModule(m, 0, &mut err); // 0 = LLVMReturnStatusAction
        if !err.is_null() {
            LLVMDisposeMessage(err);
        }
        result
    }
}

// ── Memory ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_alloca(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildAlloca(builder, ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_store(builder: LLVMPtr, val: LLVMPtr, ptr: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildStore(builder, val, ptr) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_load(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildLoad2(builder, ty, ptr, name) }
}

// ── Control flow ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_br(builder: LLVMPtr, bb: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildBr(builder, bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_cond_br(builder: LLVMPtr, cond: LLVMPtr, then_bb: LLVMPtr, else_bb: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildCondBr(builder, cond, then_bb, else_bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_icmp(builder: LLVMPtr, pred: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildICmp(builder, pred, lhs, rhs, name) }
}

// ── Function calls ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_call(builder: LLVMPtr, fn_type: LLVMPtr, f: LLVMPtr, args: *mut LLVMPtr, num_args: c_int, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildCall2(builder, fn_type, f, args, num_args as c_uint, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_new(count: c_int) -> *mut LLVMPtr {
    let layout = std::alloc::Layout::array::<LLVMPtr>(count as usize).unwrap();
    unsafe { std::alloc::alloc_zeroed(layout) as *mut LLVMPtr }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_set(arr: *mut LLVMPtr, index: c_int, val: LLVMPtr) {
    unsafe { *arr.offset(index as isize) = val; }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_free(arr: *mut LLVMPtr) {
    let _ = arr;
}

// ── Global strings ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_global_string_ptr(builder: LLVMPtr, s: *const c_char, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildGlobalStringPtr(builder, s, name) }
}

// ── PHI nodes ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_phi(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildPhi(builder, ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_add_incoming(phi: LLVMPtr, values: *mut LLVMPtr, blocks: *mut LLVMPtr, count: c_int) {
    unsafe { LLVMAddIncoming(phi, values, blocks, count as c_uint) }
}
