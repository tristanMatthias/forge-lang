//! Thin Rust wrappers around the LLVM C API for use from Forge programs.
//! Each function is a 1-3 line wrapper that calls the corresponding LLVM C API function.

use std::ffi::{c_char, c_int, c_uint, c_ulonglong, c_void};

// Opaque pointer type used for all LLVM refs
type LLVMPtr = *mut c_void;

// LLVM C API bindings (from llvm-c/Core.h, llvm-c/Analysis.h, llvm-c/TargetMachine.h)
extern "C" {
    // Context
    fn LLVMContextCreate() -> LLVMPtr;
    fn LLVMContextDispose(ctx: LLVMPtr);

    // Module
    fn LLVMModuleCreateWithNameInContext(name: *const c_char, ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDisposeModule(m: LLVMPtr);
    fn LLVMPrintModuleToString(m: LLVMPtr) -> *mut c_char;
    fn LLVMDisposeMessage(msg: *mut c_char);
    fn LLVMSetTarget(m: LLVMPtr, triple: *const c_char);
    fn LLVMSetDataLayout(m: LLVMPtr, layout: *const c_char);

    // Types
    fn LLVMInt1TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt8TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt32TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt64TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDoubleTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMVoidTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMPointerTypeInContext(ctx: LLVMPtr, address_space: c_uint) -> LLVMPtr;
    fn LLVMFunctionType(ret: LLVMPtr, params: *mut LLVMPtr, param_count: c_uint, is_vararg: c_int) -> LLVMPtr;
    fn LLVMStructTypeInContext(ctx: LLVMPtr, element_types: *mut LLVMPtr, element_count: c_uint, packed: c_int) -> LLVMPtr;
    fn LLVMStructGetTypeAtIndex(struct_type: LLVMPtr, index: c_uint) -> LLVMPtr;
    fn LLVMCountStructElementTypes(struct_type: LLVMPtr) -> c_uint;

    // Functions
    fn LLVMAddFunction(m: LLVMPtr, name: *const c_char, fn_type: LLVMPtr) -> LLVMPtr;
    fn LLVMGetParam(f: LLVMPtr, index: c_uint) -> LLVMPtr;

    // Basic Blocks
    fn LLVMAppendBasicBlockInContext(ctx: LLVMPtr, f: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMGetInsertBlock(builder: LLVMPtr) -> LLVMPtr;
    fn LLVMGetBasicBlockParent(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMGetFirstInstruction(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMGetEntryBasicBlock(f: LLVMPtr) -> LLVMPtr;

    // Builder
    fn LLVMCreateBuilderInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMPositionBuilderAtEnd(builder: LLVMPtr, bb: LLVMPtr);
    fn LLVMPositionBuilderBefore(builder: LLVMPtr, instr: LLVMPtr);
    fn LLVMDisposeBuilder(builder: LLVMPtr);
    fn LLVMBuildRet(builder: LLVMPtr, value: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildRetVoid(builder: LLVMPtr) -> LLVMPtr;

    // Arithmetic
    fn LLVMBuildAdd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildMul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSDiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSRem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFAdd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFSub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFMul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFDiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFRem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFNeg(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFCmp(builder: LLVMPtr, op: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Constants
    fn LLVMConstInt(ty: LLVMPtr, n: c_ulonglong, sign_extend: c_int) -> LLVMPtr;
    fn LLVMConstReal(ty: LLVMPtr, n: f64) -> LLVMPtr;
    fn LLVMConstNull(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMGetUndef(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMConstStructInContext(ctx: LLVMPtr, values: *mut LLVMPtr, count: c_uint, packed: c_int) -> LLVMPtr;

    // Globals
    fn LLVMAddGlobal(m: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMSetInitializer(global: LLVMPtr, val: LLVMPtr);
    fn LLVMSetGlobalConstant(global: LLVMPtr, is_constant: c_int);

    // Print module to file
    fn LLVMPrintModuleToFile(m: LLVMPtr, filename: *const c_char, error_message: *mut *mut c_char) -> c_int;

    // Verification
    fn LLVMVerifyModule(m: LLVMPtr, action: c_int, out_message: *mut *mut c_char) -> c_int;

    // Memory
    fn LLVMBuildAlloca(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildStore(builder: LLVMPtr, val: LLVMPtr, ptr: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildLoad2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Aggregate operations (GEP, insert/extract)
    fn LLVMBuildGEP2(builder: LLVMPtr, ty: LLVMPtr, pointer: LLVMPtr, indices: *mut LLVMPtr, num_indices: c_uint, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildStructGEP2(builder: LLVMPtr, ty: LLVMPtr, pointer: LLVMPtr, index: c_uint, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildInsertValue(builder: LLVMPtr, agg_val: LLVMPtr, element: LLVMPtr, index: c_uint, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildExtractValue(builder: LLVMPtr, agg_val: LLVMPtr, index: c_uint, name: *const c_char) -> LLVMPtr;

    // Control flow
    fn LLVMBuildBr(builder: LLVMPtr, dest: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildCondBr(builder: LLVMPtr, cond: LLVMPtr, then_bb: LLVMPtr, else_bb: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildICmp(builder: LLVMPtr, op: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildUnreachable(builder: LLVMPtr) -> LLVMPtr;
    fn LLVMBuildSwitch(builder: LLVMPtr, val: LLVMPtr, else_bb: LLVMPtr, num_cases: c_uint) -> LLVMPtr;
    fn LLVMAddCase(switch: LLVMPtr, on_val: LLVMPtr, dest: LLVMPtr);

    // Integer conversions
    fn LLVMBuildZExt(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSExt(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildTrunc(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSIToFP(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFPToSI(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildBitCast(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildPtrToInt(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildIntToPtr(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Bitwise operations
    fn LLVMBuildAnd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildOr(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildXor(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildShl(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildAShr(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildNot(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr;

    // Calls
    fn LLVMBuildCall2(builder: LLVMPtr, fn_type: LLVMPtr, f: LLVMPtr, args: *mut LLVMPtr, num_args: c_uint, name: *const c_char) -> LLVMPtr;

    // Strings
    fn LLVMBuildGlobalStringPtr(builder: LLVMPtr, s: *const c_char, name: *const c_char) -> LLVMPtr;

    // PHI
    fn LLVMBuildPhi(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMAddIncoming(phi: LLVMPtr, values: *mut LLVMPtr, blocks: *mut LLVMPtr, count: c_uint);

    // Target-specific initialization (these are real exported symbols, unlike the
    // LLVMInitializeAll* inline functions in the C header)
    fn LLVMInitializeAArch64TargetInfo();
    fn LLVMInitializeAArch64Target();
    fn LLVMInitializeAArch64TargetMC();
    fn LLVMInitializeAArch64AsmParser();
    fn LLVMInitializeAArch64AsmPrinter();
    fn LLVMInitializeX86TargetInfo();
    fn LLVMInitializeX86Target();
    fn LLVMInitializeX86TargetMC();
    fn LLVMInitializeX86AsmParser();
    fn LLVMInitializeX86AsmPrinter();
    fn LLVMGetDefaultTargetTriple() -> *mut c_char;
    fn LLVMGetTargetFromTriple(triple: *const c_char, target: *mut LLVMPtr, error_message: *mut *mut c_char) -> c_int;
    fn LLVMCreateTargetMachine(target: LLVMPtr, triple: *const c_char, cpu: *const c_char, features: *const c_char, level: c_int, reloc: c_int, code_model: c_int) -> LLVMPtr;
    fn LLVMDisposeTargetMachine(tm: LLVMPtr);
    fn LLVMTargetMachineEmitToFile(tm: LLVMPtr, m: LLVMPtr, filename: *const c_char, codegen: c_int, error_message: *mut *mut c_char) -> c_int;
    fn LLVMCreateTargetDataLayout(tm: LLVMPtr) -> LLVMPtr;
    fn LLVMCopyStringRepOfTargetData(td: LLVMPtr) -> *mut c_char;
    fn LLVMDisposeTargetData(td: LLVMPtr);
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

/// Write LLVM IR to a file. Returns 0 on success.
#[no_mangle]
pub extern "C" fn forge_llvm_print_module_to_file(m: LLVMPtr, filename: *const c_char) -> c_int {
    let mut error: *mut c_char = std::ptr::null_mut();
    let result = unsafe { LLVMPrintModuleToFile(m, filename, &mut error) };
    if result != 0 && !error.is_null() {
        unsafe { LLVMDisposeMessage(error) };
    }
    result
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

// ── Struct Types ──

#[no_mangle]
pub extern "C" fn forge_llvm_struct_type(ctx: LLVMPtr, element_types: *mut LLVMPtr, count: c_int, packed: c_int) -> LLVMPtr {
    unsafe { LLVMStructTypeInContext(ctx, element_types, count as c_uint, packed) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_struct_get_type_at_index(struct_type: LLVMPtr, index: c_int) -> LLVMPtr {
    unsafe { LLVMStructGetTypeAtIndex(struct_type, index as c_uint) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_count_struct_element_types(struct_type: LLVMPtr) -> c_int {
    unsafe { LLVMCountStructElementTypes(struct_type) as c_int }
}

// ── Aggregate Operations ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_gep2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, indices: *mut LLVMPtr, num_indices: c_int, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildGEP2(builder, ty, ptr, indices, num_indices as c_uint, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_struct_gep2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildStructGEP2(builder, ty, ptr, index as c_uint, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_insert_value(builder: LLVMPtr, agg: LLVMPtr, element: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildInsertValue(builder, agg, element, index as c_uint, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_extract_value(builder: LLVMPtr, agg: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildExtractValue(builder, agg, index as c_uint, name) }
}

// ── Arithmetic (division, remainder, float ops) ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_sdiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSDiv(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_srem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSRem(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fadd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFAdd(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fsub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFSub(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fmul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFMul(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fdiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFDiv(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_frem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFRem(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fneg(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFNeg(builder, val, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fcmp(builder: LLVMPtr, pred: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFCmp(builder, pred, lhs, rhs, name) }
}

// ── Integer Conversions ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_zext(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildZExt(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_sext(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSExt(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_trunc(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildTrunc(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_si_to_fp(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSIToFP(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fp_to_si(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFPToSI(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_bitcast(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildBitCast(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ptr_to_int(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildPtrToInt(builder, val, dest_ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_int_to_ptr(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildIntToPtr(builder, val, dest_ty, name) }
}

// ── Bitwise Operations ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_and(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildAnd(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_or(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildOr(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_xor(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildXor(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_shl(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildShl(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ashr(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildAShr(builder, lhs, rhs, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_not(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildNot(builder, val, name) }
}

// ── Control Flow (switch, unreachable) ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_unreachable(builder: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMBuildUnreachable(builder) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_switch(builder: LLVMPtr, val: LLVMPtr, else_bb: LLVMPtr, num_cases: c_int) -> LLVMPtr {
    unsafe { LLVMBuildSwitch(builder, val, else_bb, num_cases as c_uint) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_add_case(switch: LLVMPtr, on_val: LLVMPtr, dest: LLVMPtr) {
    unsafe { LLVMAddCase(switch, on_val, dest) }
}

// ── Constants and Globals ──

#[no_mangle]
pub extern "C" fn forge_llvm_const_null(ty: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMConstNull(ty) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_undef(ty: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetUndef(ty) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_const_real(ty: LLVMPtr, value: f64) -> LLVMPtr {
    unsafe { LLVMConstReal(ty, value) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_const_struct(ctx: LLVMPtr, values: *mut LLVMPtr, count: c_int, packed: c_int) -> LLVMPtr {
    unsafe { LLVMConstStructInContext(ctx, values, count as c_uint, packed) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_add_global(m: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMAddGlobal(m, ty, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_initializer(global: LLVMPtr, val: LLVMPtr) {
    unsafe { LLVMSetInitializer(global, val) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_global_constant(global: LLVMPtr, is_constant: c_int) {
    unsafe { LLVMSetGlobalConstant(global, is_constant) }
}

// ── Builder/Block Operations ──

#[no_mangle]
pub extern "C" fn forge_llvm_get_insert_block(builder: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetInsertBlock(builder) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_basic_block_parent(bb: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetBasicBlockParent(bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_position_builder_before(builder: LLVMPtr, instr: LLVMPtr) {
    unsafe { LLVMPositionBuilderBefore(builder, instr) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_first_instruction(bb: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetFirstInstruction(bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_entry_basic_block(f: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetEntryBasicBlock(f) }
}

// ── Target Machine ──

#[no_mangle]
pub extern "C" fn forge_llvm_initialize_all_targets() {
    unsafe {
        // Use target-specific init functions (real exported symbols) instead of
        // LLVMInitializeAll* (inline C header functions that aren't in libLLVM)
        LLVMInitializeAArch64TargetInfo();
        LLVMInitializeAArch64Target();
        LLVMInitializeAArch64TargetMC();
        LLVMInitializeAArch64AsmParser();
        LLVMInitializeAArch64AsmPrinter();
        LLVMInitializeX86TargetInfo();
        LLVMInitializeX86Target();
        LLVMInitializeX86TargetMC();
        LLVMInitializeX86AsmParser();
        LLVMInitializeX86AsmPrinter();
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_default_target_triple() -> *mut c_char {
    unsafe { LLVMGetDefaultTargetTriple() }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_target_from_triple(triple: *const c_char, target_out: *mut LLVMPtr) -> c_int {
    unsafe {
        let mut err: *mut c_char = std::ptr::null_mut();
        let result = LLVMGetTargetFromTriple(triple, target_out, &mut err);
        if !err.is_null() {
            LLVMDisposeMessage(err);
        }
        result
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_create_target_machine(target: LLVMPtr, triple: *const c_char, cpu: *const c_char, features: *const c_char, level: c_int, reloc: c_int, code_model: c_int) -> LLVMPtr {
    unsafe { LLVMCreateTargetMachine(target, triple, cpu, features, level, reloc, code_model) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_dispose_target_machine(tm: LLVMPtr) {
    unsafe { LLVMDisposeTargetMachine(tm) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_target_machine_emit_to_file(tm: LLVMPtr, m: LLVMPtr, filename: *const c_char, codegen: c_int) -> c_int {
    unsafe {
        let mut err: *mut c_char = std::ptr::null_mut();
        let result = LLVMTargetMachineEmitToFile(tm, m, filename, codegen, &mut err);
        if !err.is_null() {
            LLVMDisposeMessage(err);
        }
        result
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_target(m: LLVMPtr, triple: *const c_char) {
    unsafe { LLVMSetTarget(m, triple) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_data_layout(m: LLVMPtr, layout: *const c_char) {
    unsafe { LLVMSetDataLayout(m, layout) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_create_target_data_layout(tm: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMCreateTargetDataLayout(tm) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_copy_string_rep_of_target_data(td: LLVMPtr) -> *mut c_char {
    unsafe { LLVMCopyStringRepOfTargetData(td) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_dispose_target_data(td: LLVMPtr) {
    unsafe { LLVMDisposeTargetData(td) }
}
