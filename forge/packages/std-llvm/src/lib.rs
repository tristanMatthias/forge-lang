//! Thin Rust wrappers around the LLVM C API for use from Forge programs.
//! Each function is a 1-3 line wrapper that calls the corresponding LLVM C API function.
//!
//! **Type cache**: The bootstrap compiler's list operations corrupt global variables.
//! LLVM type pointers (i64, i32, etc.) stored as Forge globals get overwritten with
//! garbage. This module maintains a Rust-side thread-local cache of the correct types.
//! All wrapper functions that accept type parameters auto-correct corrupted types
//! by checking LLVMGetTypeKind and substituting from the cache.

use std::ffi::{c_char, c_int, c_uint, c_ulonglong, c_void};
use std::cell::RefCell;
use std::sync::atomic::{AtomicI64, AtomicBool, Ordering};
use std::io::Write;

// ─── Builder Trace (FORGE_DEBUG_BUILDER) ─────────────────────────
//
// When the env var FORGE_DEBUG_BUILDER=1 is set, every builder-mutating
// LLVM call below logs `[BLD] <op> bld=<addr> cur=<addr> arg=<addr> id=<n>`
// to stderr (or to FORGE_DEBUG_BUILDER_FILE if set). This makes builder
// drift bugs trivial to localize: grep for the operation that moved
// the insert block away from where you expected it.

static BLD_TRACE_INIT: AtomicBool = AtomicBool::new(false);
static BLD_TRACE_ON:   AtomicBool = AtomicBool::new(false);
static BLD_OP_ID:      AtomicI64  = AtomicI64::new(0);

fn bld_trace_enabled() -> bool {
    if !BLD_TRACE_INIT.load(Ordering::Relaxed) {
        let on = std::env::var("FORGE_DEBUG_BUILDER")
            .map(|v| v == "1" || v == "true")
            .unwrap_or(false);
        BLD_TRACE_ON.store(on, Ordering::Relaxed);
        BLD_TRACE_INIT.store(true, Ordering::Relaxed);
    }
    BLD_TRACE_ON.load(Ordering::Relaxed)
}

#[inline]
fn bld_trace(op: &str, builder: LLVMPtr, arg: LLVMPtr) {
    if !bld_trace_enabled() { return; }
    let id = BLD_OP_ID.fetch_add(1, Ordering::Relaxed);
    let cur = if builder.is_null() {
        std::ptr::null_mut()
    } else {
        unsafe { LLVMGetInsertBlock(builder) }
    };
    let _ = writeln!(
        std::io::stderr(),
        "[BLD] #{:06} {:<22} bld={:p} cur={:p} arg={:p}",
        id, op, builder, cur, arg
    );
}

#[inline]
fn bld_trace2(op: &str, builder: LLVMPtr, a: LLVMPtr, b: LLVMPtr) {
    if !bld_trace_enabled() { return; }
    let id = BLD_OP_ID.fetch_add(1, Ordering::Relaxed);
    let cur = if builder.is_null() {
        std::ptr::null_mut()
    } else {
        unsafe { LLVMGetInsertBlock(builder) }
    };
    let _ = writeln!(
        std::io::stderr(),
        "[BLD] #{:06} {:<22} bld={:p} cur={:p} a={:p} b={:p}",
        id, op, builder, cur, a, b
    );
}

// Opaque pointer type used for all LLVM refs
type LLVMPtr = *mut c_void;

// Use empty string for value names — LLVM auto-numbers them.
// Basic blocks get unique names via unique_block_name() to prevent collisions.
const EMPTY_NAME: &[u8] = b"\0";

fn safe_name(_name: *const c_char) -> *const c_char {
    EMPTY_NAME.as_ptr() as *const c_char
}

// Pending alloca name: set before build_alloca to ensure the name survives
// even if the Forge wrapper corrupts the ForgeString during the call.
static mut PENDING_ALLOCA_NAME: [u8; 64] = [0u8; 64];

#[no_mangle]
pub extern "C" fn forge_set_alloca_name(name_ptr: *const c_char, name_len: i64) {
    extern "C" {
        // C-side: sets pending alloca name AND arms the flag
        fn forge_set_alloca_name_c_raw(name_ptr: *const c_char, name_len: i64);
    }
    // Delegate to C version which sets both the name AND the armed flag
    // (_use_pending_for_next_alloca). Without the flag, build_alloca's
    // auto-cache ignores the pending name entirely.
    unsafe { forge_set_alloca_name_c_raw(name_ptr, name_len); }
    // Also store in Rust-side buffer for backward compat
    unsafe {
        PENDING_ALLOCA_NAME = [0u8; 64];
        if !name_ptr.is_null() && name_len > 0 && name_len < 64 {
            std::ptr::copy_nonoverlapping(name_ptr as *const u8, PENDING_ALLOCA_NAME.as_mut_ptr(), name_len as usize);
        }
    }
}

// Generate unique block names: "bb0", "bb1", ... to avoid colliding with %N registers
thread_local! {
    static BB_COUNTER: std::cell::Cell<u64> = const { std::cell::Cell::new(0) };
    static BB_NAME_BUF: RefCell<Vec<u8>> = RefCell::new(Vec::with_capacity(16));
}

fn unique_block_name() -> *const c_char {
    BB_COUNTER.with(|c| {
        let n = c.get();
        c.set(n + 1);
        BB_NAME_BUF.with(|buf| {
            let mut buf = buf.borrow_mut();
            buf.clear();
            buf.extend_from_slice(b"bb");
            buf.extend_from_slice(n.to_string().as_bytes());
            buf.push(0); // null terminator
            buf.as_ptr() as *const c_char
        })
    })
}

// ── Type Cache (immune to bootstrap global corruption) ──────────────
// Stored in Rust thread-local, populated when context is created.

#[derive(Default)]
struct TypeCache {
    ctx: LLVMPtr,
    i1: LLVMPtr,
    i8: LLVMPtr,
    i32: LLVMPtr,
    i64: LLVMPtr,
    f64: LLVMPtr,
    void: LLVMPtr,
    ptr: LLVMPtr,
}

thread_local! {
    static TYPE_CACHE: RefCell<TypeCache> = RefCell::new(TypeCache::default());
}

/// If `ty` should be an integer type but got corrupted, return the cached i64.
/// Returns the original type if it's already an integer, or the cached i64 otherwise.
fn ensure_int_type(ty: LLVMPtr) -> LLVMPtr {
    if ty.is_null() {
        return TYPE_CACHE.with(|c| c.borrow().i64);
    }
    unsafe {
        let kind = LLVMGetTypeKind(ty);
        if kind == 8 { return ty; } // Already integer
        TYPE_CACHE.with(|c| c.borrow().i64)
    }
}

/// If `ty` should be a valid LLVM type but is null, return cached i64.
fn ensure_type(ty: LLVMPtr) -> LLVMPtr {
    if ty.is_null() {
        return TYPE_CACHE.with(|c| c.borrow().i64);
    }
    ty
}

// LLVM C API bindings (from llvm-c/Core.h, llvm-c/Analysis.h, llvm-c/TargetMachine.h)
extern "C" {
    // Context
    fn LLVMContextCreate() -> LLVMPtr;
    fn LLVMContextDispose(ctx: LLVMPtr);
    fn LLVMGetGlobalContext() -> LLVMPtr;

    // Type inspection
    fn LLVMTypeOf(val: LLVMPtr) -> LLVMPtr;
    fn LLVMGetTypeKind(ty: LLVMPtr) -> c_uint;

    // Module
    fn LLVMModuleCreateWithNameInContext(name: *const c_char, ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDisposeModule(m: LLVMPtr);
    fn LLVMPrintModuleToString(m: LLVMPtr) -> *mut c_char;
    fn LLVMDisposeMessage(msg: *mut c_char);
    fn LLVMSetTarget(m: LLVMPtr, triple: *const c_char);
    fn LLVMSetDataLayout(m: LLVMPtr, layout: *const c_char);

    // Size
    fn LLVMSizeOf(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMGetHostCPUName() -> *mut c_char;
    fn LLVMGetHostCPUFeatures() -> *mut c_char;

    // Types
    fn LLVMInt1TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt8TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt32TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMInt64TypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMDoubleTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMVoidTypeInContext(ctx: LLVMPtr) -> LLVMPtr;
    fn LLVMPointerTypeInContext(ctx: LLVMPtr, address_space: c_uint) -> LLVMPtr;
    fn LLVMFunctionType(ret: LLVMPtr, params: *mut LLVMPtr, param_count: c_uint, is_vararg: c_int) -> LLVMPtr;
    fn LLVMGetReturnType(fn_type: LLVMPtr) -> LLVMPtr;
    fn LLVMGetElementType(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMGlobalGetValueType(global: LLVMPtr) -> LLVMPtr;
    fn LLVMGetTypeContext(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMGetIntTypeWidth(ty: LLVMPtr) -> c_uint;
    fn LLVMGetGlobalParent(val: LLVMPtr) -> LLVMPtr;
    fn LLVMStructTypeInContext(ctx: LLVMPtr, element_types: *mut LLVMPtr, element_count: c_uint, packed: c_int) -> LLVMPtr;
    fn LLVMStructCreateNamed(ctx: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMGetTypeByName2(ctx: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMStructSetBody(struct_type: LLVMPtr, element_types: *mut LLVMPtr, element_count: c_uint, packed: c_int);
    fn LLVMStructGetTypeAtIndex(struct_type: LLVMPtr, index: c_uint) -> LLVMPtr;
    fn LLVMCountStructElementTypes(struct_type: LLVMPtr) -> c_uint;
    fn LLVMGetStructName(struct_type: LLVMPtr) -> *const c_char;

    // Functions
    fn LLVMAddFunction(m: LLVMPtr, name: *const c_char, fn_type: LLVMPtr) -> LLVMPtr;
    fn LLVMGetNamedFunction(m: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMGetNamedGlobal(m: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMGetBasicBlockTerminator(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMGetBasicBlockName(bb: LLVMPtr) -> *const c_char;
    fn LLVMGetFirstBasicBlock(f: LLVMPtr) -> LLVMPtr;
    fn LLVMGetNextBasicBlock(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMCountBasicBlocks(f: LLVMPtr) -> c_uint;
    fn LLVMGetFirstUse(val: LLVMPtr) -> LLVMPtr;
    fn LLVMGetNextUse(u: LLVMPtr) -> LLVMPtr;
    fn LLVMGetNextInstruction(instr: LLVMPtr) -> LLVMPtr;
    fn LLVMVerifyFunction(f: LLVMPtr, action: c_int) -> c_int;
    fn LLVMGetParam(f: LLVMPtr, index: c_uint) -> LLVMPtr;
    fn LLVMCountParams(f: LLVMPtr) -> c_uint;
    fn LLVMCountParamTypes(fn_ty: LLVMPtr) -> c_uint;
    fn LLVMGetParamTypes(fn_ty: LLVMPtr, dest: *mut LLVMPtr);

    // Basic Blocks
    fn LLVMAppendBasicBlockInContext(ctx: LLVMPtr, f: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMGetInsertBlock(builder: LLVMPtr) -> LLVMPtr;
    fn LLVMGetBasicBlockParent(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMGetFirstInstruction(bb: LLVMPtr) -> LLVMPtr;
    fn LLVMGetEntryBasicBlock(f: LLVMPtr) -> LLVMPtr;
    fn LLVMGetInstructionParent(inst: LLVMPtr) -> LLVMPtr;

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
    fn LLVMIsConstant(val: LLVMPtr) -> c_int;
    fn LLVMIsNull(val: LLVMPtr) -> c_int;
    fn LLVMConstIntGetSExtValue(val: LLVMPtr) -> i64;
    fn LLVMConstInt(ty: LLVMPtr, n: c_ulonglong, sign_extend: c_int) -> LLVMPtr;
    fn LLVMConstReal(ty: LLVMPtr, n: f64) -> LLVMPtr;
    fn LLVMConstNull(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMGetUndef(ty: LLVMPtr) -> LLVMPtr;
    fn LLVMConstStructInContext(ctx: LLVMPtr, values: *mut LLVMPtr, count: c_uint, packed: c_int) -> LLVMPtr;
    fn LLVMConstNamedStruct(struct_ty: LLVMPtr, values: *mut LLVMPtr, count: c_uint) -> LLVMPtr;
    fn LLVMConstStringInContext(ctx: LLVMPtr, str: *const c_char, len: c_uint, dont_null_terminate: c_int) -> LLVMPtr;
    fn LLVMConstBitCast(val: LLVMPtr, ty: LLVMPtr) -> LLVMPtr;
    fn LLVMArrayType(element_type: LLVMPtr, count: c_uint) -> LLVMPtr;
    fn LLVMConstGEP2(ty: LLVMPtr, constant: LLVMPtr, indices: *mut LLVMPtr, count: c_uint) -> LLVMPtr;

    // Globals
    fn LLVMAddGlobal(m: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMSetInitializer(global: LLVMPtr, val: LLVMPtr);
    fn LLVMSetGlobalConstant(global: LLVMPtr, is_constant: c_int);
    fn LLVMSetLinkage(global: LLVMPtr, linkage: c_uint);

    // Data layout / type size
    fn LLVMGetModuleDataLayout(m: LLVMPtr) -> LLVMPtr;
    fn LLVMStoreSizeOfType(td: LLVMPtr, ty: LLVMPtr) -> c_ulonglong;

    // Print module to file
    fn LLVMPrintModuleToFile(m: LLVMPtr, filename: *const c_char, error_message: *mut *mut c_char) -> c_int;

    // Verification
    fn LLVMVerifyModule(m: LLVMPtr, action: c_int, out_message: *mut *mut c_char) -> c_int;

    // Memory
    fn LLVMBuildAlloca(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildStore(builder: LLVMPtr, val: LLVMPtr, ptr: LLVMPtr) -> LLVMPtr;
    fn LLVMGetAllocatedType(alloca: LLVMPtr) -> LLVMPtr;
    fn LLVMGetStructElementTypes(struct_type: LLVMPtr, dest: *mut LLVMPtr);
    fn LLVMGetInstructionOpcode(inst: LLVMPtr) -> c_uint;
    fn LLVMGetOperand(val: LLVMPtr, index: c_uint) -> LLVMPtr;
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
    fn LLVMBuildPtrToInt(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildSIToFP(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildFPToSI(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
    fn LLVMBuildBitCast(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr;
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
    unsafe {
        let ctx = LLVMContextCreate();
        // Populate the type cache — these pointers are stable for the context's lifetime
        TYPE_CACHE.with(|c| {
            let mut cache = c.borrow_mut();
            cache.ctx = ctx;
            cache.i1 = LLVMInt1TypeInContext(ctx);
            cache.i8 = LLVMInt8TypeInContext(ctx);
            cache.i32 = LLVMInt32TypeInContext(ctx);
            cache.i64 = LLVMInt64TypeInContext(ctx);
            cache.f64 = LLVMDoubleTypeInContext(ctx);
            cache.void = LLVMVoidTypeInContext(ctx);
            cache.ptr = LLVMPointerTypeInContext(ctx, 0);
        });
        ctx
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_context_dispose(ctx: LLVMPtr) {
    unsafe { LLVMContextDispose(ctx) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_module_create(name: *const c_char, ctx: LLVMPtr) -> LLVMPtr {
    if name.is_null() || ctx.is_null() { return std::ptr::null_mut(); }
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
    if ret.is_null() { return std::ptr::null_mut(); }
    if params.is_null() && param_count > 0 { return std::ptr::null_mut(); }
    unsafe {
        // Validate ret type is a real LLVM type (kind > 0)
        let ret_kind = LLVMGetTypeKind(ret);
        if ret_kind > 20 {
            eprintln!("[GUARD] forge_llvm_function_type: ret has bad kind {}", ret_kind);
            return std::ptr::null_mut();
        }
        // Replace NULL param types with i64 to prevent LLVM crash
        let ctx = LLVMGetTypeContext(ret);
        for i in 0..param_count as usize {
            let p = *params.add(i);
            if p.is_null() || LLVMGetTypeKind(p) > 20 {
                *params.add(i) = LLVMInt64TypeInContext(ctx);
            }
        }
        LLVMFunctionType(ret, params, param_count as c_uint, is_vararg)
    }
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
    if m.is_null() || fn_type.is_null() || name.is_null() {
        let n = if !name.is_null() { unsafe { std::ffi::CStr::from_ptr(name).to_string_lossy().into_owned() } } else { "null".to_string() };
        eprintln!("WARNING: add_function null arg: m={:?} name={} type={:?}", m, n, fn_type);
        return std::ptr::null_mut();
    }
    unsafe {
        let s = std::ffi::CStr::from_ptr(name).to_str().unwrap_or("?");
        if s.contains("find_nmod") {
            eprintln!("  [AF] CAUGHT find_nmod creation!");
            // Print backtrace hint
            let bt = std::backtrace::Backtrace::force_capture();
            eprintln!("  [AF] backtrace: {:?}", bt);
        }
        LLVMAddFunction(m, name, fn_type)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_named_function(m: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if m.is_null() || name.is_null() { return std::ptr::null_mut(); }
    unsafe {
        static mut GNF_TRACE: i32 = 50;
        if GNF_TRACE > 0 {
            let s = std::ffi::CStr::from_ptr(name).to_str().unwrap_or("?");
            if s.contains("index_of") || s.contains("find_nmod") || s.contains("find_byte") {
                let result = LLVMGetNamedFunction(m, name);
                eprintln!("  [GNF] '{}' → {:p}", s, result);
                GNF_TRACE -= 1;
                return result;
            }
        }
        LLVMGetNamedFunction(m, name)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_named_global(m: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if m.is_null() || name.is_null() { return std::ptr::null_mut(); }
    unsafe { LLVMGetNamedGlobal(m, name) }
}

#[no_mangle]
pub extern "C" fn llvm_get_named_global(m: LLVMPtr, name: *const c_char) -> LLVMPtr {
    forge_llvm_get_named_global(m, name)
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_param(f: LLVMPtr, index: c_int) -> LLVMPtr {
    if f.is_null() { return std::ptr::null_mut(); }
    unsafe {
        let count = LLVMCountParams(f);
        if (index as c_uint) >= count {
            eprintln!("[GUARD] get_param index {} >= count {} for fn", index, count);
            return std::ptr::null_mut();
        }
        LLVMGetParam(f, index as c_uint)
    }
}

// ── Basic Blocks & Builder ──

#[no_mangle]
pub extern "C" fn forge_llvm_append_basic_block(ctx: LLVMPtr, f: LLVMPtr, _name: *const c_char) -> LLVMPtr {
    if ctx.is_null() || f.is_null() { return std::ptr::null_mut(); }
    extern "C" { fn forge_alloca_cache_set_fn(f: *mut c_void); }
    unsafe {
        forge_alloca_cache_set_fn(f);
        let bb = LLVMAppendBasicBlockInContext(ctx, f, unique_block_name());
        bld_trace("append_basic_block", std::ptr::null_mut(), bb);
        bb
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_create_builder(ctx: LLVMPtr) -> LLVMPtr {
    extern "C" {
        fn forge_alloca_cache_set_builder(b: *mut c_void);
        fn forge_alloca_cache_set_context(ctx: *mut c_void);
    }
    let b = unsafe { LLVMCreateBuilderInContext(ctx) };
    unsafe {
        forge_alloca_cache_set_builder(b);
        forge_alloca_cache_set_context(ctx);
    }
    b
}

#[no_mangle]
pub extern "C" fn forge_llvm_position_at_end(builder: LLVMPtr, bb: LLVMPtr) {
    bld_trace("position_at_end", builder, bb);
    unsafe { LLVMPositionBuilderAtEnd(builder, bb) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_dispose_builder(builder: LLVMPtr) {
    unsafe { LLVMDisposeBuilder(builder) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ret(builder: LLVMPtr, value: LLVMPtr) -> LLVMPtr {
    if builder.is_null() { return std::ptr::null_mut(); }
    unsafe {
        // Skip if the block already has a terminator (defense against
        // double-terminator bugs from emit_return inside if/match arms).
        let cur = LLVMGetInsertBlock(builder);
        if !cur.is_null() {
            let term = LLVMGetBasicBlockTerminator(cur);
            if !term.is_null() {
                return term;
            }
        }
        if value.is_null() {
            return LLVMBuildRetVoid(builder);
        }
        // Check if value type matches the function's return type
        let bb = LLVMGetInsertBlock(builder);
        if !bb.is_null() {
            let func = LLVMGetBasicBlockParent(bb);
            if !func.is_null() {
                let fn_ty = LLVMGlobalGetValueType(func);
                let ret_ty = LLVMGetReturnType(fn_ty);
                let val_ty = LLVMTypeOf(value);
                if ret_ty != val_ty {
                    let ret_kind = LLVMGetTypeKind(ret_ty);
                    let val_kind = LLVMGetTypeKind(val_ty);
                    if ret_kind == 0 { // Void
                        return LLVMBuildRetVoid(builder);
                    }
                    // Both struct types with same layout: bitcast via alloca
                    // (handles named %ForgeString vs anonymous {ptr, i64})
                    if ret_kind == 10 && val_kind == 10 {
                        let ret_fields = LLVMCountStructElementTypes(ret_ty);
                        let val_fields = LLVMCountStructElementTypes(val_ty);
                        if ret_fields == val_fields && ret_fields > 0 {
                            let alloca = LLVMBuildAlloca(builder, ret_ty, safe_name(std::ptr::null()));
                            LLVMBuildStore(builder, value, alloca);
                            let loaded = LLVMBuildLoad2(builder, ret_ty, alloca, safe_name(std::ptr::null()));
                            return LLVMBuildRet(builder, loaded);
                        }
                    }
                    // If return is ForgeString {ptr, i64} but value is integer,
                    // build ForgeString{inttoptr(val), 0}
                    if ret_kind == 10 && val_kind == 8 {
                        let field_count = LLVMCountStructElementTypes(ret_ty);
                        if field_count == 2 {
                            // Check that field 0 is ptr (ForgeString) not i8 (enum tag)
                            let mut field_types = [std::ptr::null_mut(); 2];
                            LLVMGetStructElementTypes(ret_ty, field_types.as_mut_ptr());
                            let f0_kind = LLVMGetTypeKind(field_types[0]);
                            if f0_kind == 12 { // PointerTypeKind — this is a ForgeString
                                let undef = LLVMGetUndef(ret_ty);
                                let ptr_ty = TYPE_CACHE.with(|c| c.borrow().ptr);
                                let val_i64 = ensure_i64(builder, value);
                                let as_ptr = LLVMBuildIntToPtr(builder, val_i64, ptr_ty, safe_name(std::ptr::null()));
                                let with_ptr = LLVMBuildInsertValue(builder, undef, as_ptr, 0, safe_name(std::ptr::null()));
                                let i64_ty = TYPE_CACHE.with(|c| c.borrow().i64);
                                let zero = LLVMConstInt(i64_ty, 0, 0);
                                let with_len = LLVMBuildInsertValue(builder, with_ptr, zero, 1, safe_name(std::ptr::null()));
                                return LLVMBuildRet(builder, with_len);
                            }
                        }
                    }
                    // Always coerce value to match return type
                    let coerced = ensure_i64(builder, value);
                    let coerced_ty = LLVMTypeOf(coerced);
                    if coerced_ty == ret_ty {
                        return LLVMBuildRet(builder, coerced);
                    }
                    // If coercion produced wrong type, use undef
                    return LLVMBuildRet(builder, LLVMGetUndef(ret_ty));
                }
            }
        }
        LLVMBuildRet(builder, value)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ret_void(builder: LLVMPtr) -> LLVMPtr {
    unsafe {
        // Check if the current function returns void. If not, return undef of the return type.
        let bb = LLVMGetInsertBlock(builder);
        if !bb.is_null() {
            let func = LLVMGetBasicBlockParent(bb);
            if !func.is_null() {
                let fn_ty = LLVMGlobalGetValueType(func);
                let ret_ty = LLVMGetReturnType(fn_ty);
                let ret_kind = LLVMGetTypeKind(ret_ty);
                if ret_kind != 0 { // 0 = VoidTypeKind
                    return LLVMBuildRet(builder, LLVMGetUndef(ret_ty));
                }
            }
        }
        LLVMBuildRetVoid(builder)
    }
}

// ── Arithmetic ──

/// Guard for integer binary operations: both operands must be matching integer types.
fn guard_int_binop(lhs: LLVMPtr, rhs: LLVMPtr) -> bool {
    if lhs.is_null() || rhs.is_null() { return false; }
    unsafe {
        let lhs_ty = LLVMTypeOf(lhs);
        let rhs_ty = LLVMTypeOf(rhs);
        if lhs_ty.is_null() || rhs_ty.is_null() { return false; }
        lhs_ty == rhs_ty && LLVMGetTypeKind(lhs_ty) == 8 // IntegerTypeKind
    }
}

// Ensure an LLVM value is i64 — widen if narrower, extract from struct if needed
unsafe fn ensure_i64(builder: LLVMPtr, val: LLVMPtr) -> LLVMPtr {
    if val.is_null() { return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0)); }
    let ty = LLVMTypeOf(val);
    let kind = LLVMGetTypeKind(ty);
    let i64_ty = TYPE_CACHE.with(|c| c.borrow().i64);
    if kind == 8 { // IntegerTypeKind
        let w = LLVMGetIntTypeWidth(ty);
        if w < 64 { return LLVMBuildZExt(builder, val, i64_ty, safe_name(std::ptr::null())); }
        return val;
    }
    if kind == 12 { // PointerTypeKind — convert to i64
        return LLVMBuildPtrToInt(builder, val, i64_ty, safe_name(std::ptr::null()));
    }
    if kind == 10 { // StructTypeKind — extract field 0 and convert to i64
        let f0 = LLVMBuildExtractValue(builder, val, 0, safe_name(std::ptr::null()));
        if !f0.is_null() {
            let f0_kind = LLVMGetTypeKind(LLVMTypeOf(f0));
            if f0_kind == 12 { // PointerTypeKind
                return LLVMBuildPtrToInt(builder, f0, i64_ty, safe_name(std::ptr::null()));
            }
            if f0_kind == 8 { return f0; }
        }
    }
    // For constants like null pointer: use const 0
    if LLVMIsConstant(val) != 0 {
        return LLVMConstInt(i64_ty, 0, 0);
    }
    val
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_add(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || lhs.is_null() || rhs.is_null() { return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) }); }
    // Try to coerce both operands to i64 first
    let (lhs, rhs) = unsafe { (ensure_i64(builder, lhs), ensure_i64(builder, rhs)) };
    if !guard_int_binop(lhs, rhs) {
        // Auto-detect string concatenation: if either operand is a struct (ForgeString),
        // call forge_string_concat. Convert i64 operands to string first.
        unsafe {
            let lhs_kind = LLVMGetTypeKind(LLVMTypeOf(lhs));
            let rhs_kind = LLVMGetTypeKind(LLVMTypeOf(rhs));
            if lhs_kind == 10 || rhs_kind == 10 {
                let bb = LLVMGetInsertBlock(builder);
                if !bb.is_null() {
                    let func = LLVMGetBasicBlockParent(bb);
                    if !func.is_null() {
                        let module = LLVMGetGlobalParent(func);
                        let concat_fn = LLVMGetNamedFunction(module, b"forge_string_concat\0".as_ptr() as *const c_char);
                        let i2s_fn = LLVMGetNamedFunction(module, b"forge_int_to_string\0".as_ptr() as *const c_char);
                        if !concat_fn.is_null() {
                            // Convert non-struct operands to string via forge_int_to_string
                            let mut real_lhs = lhs;
                            let mut real_rhs = rhs;
                            if lhs_kind != 10 && !i2s_fn.is_null() {
                                let i2s_ty = LLVMGlobalGetValueType(i2s_fn);
                                let mut i2s_args = [lhs];
                                real_lhs = LLVMBuildCall2(builder, i2s_ty, i2s_fn, i2s_args.as_mut_ptr(), 1, safe_name(std::ptr::null()));
                            }
                            if rhs_kind != 10 && !i2s_fn.is_null() {
                                let i2s_ty = LLVMGlobalGetValueType(i2s_fn);
                                let mut i2s_args = [rhs];
                                real_rhs = LLVMBuildCall2(builder, i2s_ty, i2s_fn, i2s_args.as_mut_ptr(), 1, safe_name(std::ptr::null()));
                            }
                            let fn_ty = LLVMGlobalGetValueType(concat_fn);
                            let mut args = [real_lhs, real_rhs];
                            return LLVMBuildCall2(builder, fn_ty, concat_fn, args.as_mut_ptr(), 2, safe_name(name));
                        }
                    }
                }
            }
        }
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) });
    }
    unsafe { LLVMBuildAdd(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_sub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || lhs.is_null() || rhs.is_null() { return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) }); }
    let (lhs, rhs) = unsafe { (ensure_i64(builder, lhs), ensure_i64(builder, rhs)) };
    if !guard_int_binop(lhs, rhs) {
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) });
    }
    unsafe { LLVMBuildSub(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_mul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if lhs.is_null() || rhs.is_null() { return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) }); }
    let (lhs, rhs) = unsafe { (ensure_i64(builder, lhs), ensure_i64(builder, rhs)) };
    if !guard_int_binop(lhs, rhs) {
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) });
    }
    unsafe { LLVMBuildMul(builder, lhs, rhs, safe_name(name)) }
}

// ── Constants ──

#[no_mangle]
pub extern "C" fn forge_llvm_const_int(ty: LLVMPtr, value: i64, sign_extend: c_int) -> LLVMPtr {
    unsafe { LLVMConstInt(ensure_int_type(ty), value as c_ulonglong, sign_extend) }
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

/// Verify module and print all errors to stderr.
/// Returns 0 if valid, 1 if errors found.
#[no_mangle]
pub extern "C" fn forge_llvm_verify_module_print(m: LLVMPtr) -> i64 {
    if m.is_null() { return 1; }
    unsafe {
        let mut err: *mut c_char = std::ptr::null_mut();
        let result = LLVMVerifyModule(m, 0, &mut err); // 0 = LLVMReturnStatusAction
        if result == 0 {
            if !err.is_null() { LLVMDisposeMessage(err); }
            return 0;
        }
        if !err.is_null() {
            let err_str = std::ffi::CStr::from_ptr(err);
            eprintln!("{}", err_str.to_string_lossy());
            LLVMDisposeMessage(err);
        }
        1
    }
}

/// Verify module and write errors to a file.
/// Returns 0 if valid, number of error lines if errors found.
#[no_mangle]
pub extern "C" fn forge_llvm_verify_module_to_file(m: LLVMPtr, path: *const c_char) -> i64 {
    if m.is_null() || path.is_null() { return -1; }
    unsafe {
        let mut err: *mut c_char = std::ptr::null_mut();
        let result = LLVMVerifyModule(m, 0, &mut err);
        if result == 0 {
            if !err.is_null() { LLVMDisposeMessage(err); }
            return 0;
        }
        if !err.is_null() {
            let path_str = std::ffi::CStr::from_ptr(path).to_string_lossy();
            let err_str = std::ffi::CStr::from_ptr(err).to_string_lossy();
            let line_count = err_str.lines().count() as i64;
            if let Ok(mut f) = std::fs::File::create(path_str.as_ref()) {
                use std::io::Write;
                let _ = f.write_all(err_str.as_bytes());
            }
            LLVMDisposeMessage(err);
            return line_count;
        }
        -1
    }
}

// ── Memory ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_alloca(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    bld_trace("build_alloca", builder, ty);
    if builder.is_null() {
        eprintln!("WARNING: build_alloca with null builder, ty={:?} name={:?}", ty, name);
        return std::ptr::null_mut();
    }
    let ty = ensure_type(ty);
    if ty.is_null() {
        eprintln!("WARNING: build_alloca with null type, builder={:?}", builder);
        return std::ptr::null_mut();
    }
    let result = unsafe { LLVMBuildAlloca(builder, ty, safe_name(name)) };
    // Auto-cache: store alloca in C-side cache (bypasses Forge variable clobbering)
    if !result.is_null() {
        extern "C" {
            fn forge_alloca_cache_set_raw(name_ptr: *const c_char, name_len: i64, ptr: *mut c_void) -> i64;
            fn forge_str_var_add_raw(name_ptr: *const c_char, name_len: i64) -> i64;
        }
        let mut cache_name: *const c_char = std::ptr::null();
        let mut cache_len: i64 = 0;

        // Check if define_var armed the pending flag
        extern "C" {
            fn forge_check_pending_alloca() -> c_int;
            static mut forge_pending_alloca_name: [c_char; 64];
            static mut forge_pending_alloca_name_len: i64;
        }
        let armed = unsafe { forge_check_pending_alloca() };
        if armed != 0 {
            // define_var: ALWAYS use pending name (direct name from Forge is corrupted)
            unsafe {
                if forge_pending_alloca_name_len > 0 && forge_pending_alloca_name_len < 64 {
                    cache_name = forge_pending_alloca_name.as_ptr();
                    cache_len = forge_pending_alloca_name_len;
                }
            }
        }
        // For non-define_var allocas: try direct name
        if cache_len == 0 && !name.is_null() {
            let name_bytes = unsafe { std::ffi::CStr::from_ptr(name).to_bytes() };
            let valid = !name_bytes.is_empty() && name_bytes.len() < 64 &&
                name_bytes.iter().all(|&b| b >= b'!' && b <= b'~');
            if valid {
                cache_name = name;
                cache_len = name_bytes.len() as i64;
            }
        }
        // Last fallback: pending name for params (from forge_param_name_get)
        if cache_len == 0 {
            unsafe {
                if forge_pending_alloca_name_len > 0 && forge_pending_alloca_name_len < 64 {
                    cache_name = forge_pending_alloca_name.as_ptr();
                    cache_len = forge_pending_alloca_name_len;
                }
            }
        }
        if cache_len > 0 && cache_len < 100 {
            unsafe {
                forge_alloca_cache_set_raw(cache_name, cache_len, result);
                // Debug: trace auto-cache storage
                if VAS_TRACE > 0 && cache_len <= 4 {
                    let s = std::slice::from_raw_parts(cache_name as *const u8, cache_len as usize);
                    eprintln!("  [AUTO_CACHE] name='{}' result={:p} armed={}",
                        std::str::from_utf8_unchecked(s), result, armed);
                    VAS_TRACE -= 1;
                }
                // Detect ForgeString-typed allocas (struct with 2 elements)
                let alloca_ty = LLVMGetAllocatedType(result);
                if !alloca_ty.is_null() {
                    let kind = LLVMGetTypeKind(alloca_ty);
                    if kind == 10 { // LLVMStructTypeKind
                        let ec = LLVMCountStructElementTypes(alloca_ty);
                        if ec == 2 {
                            forge_str_var_add_raw(cache_name, cache_len);
                        }
                    }
                    if kind == 12 { // LLVMPointerTypeKind
                        extern "C" { fn forge_ptr_var_add_raw(name_ptr: *const c_char, name_len: i64); }
                        forge_ptr_var_add_raw(cache_name, cache_len);
                    }
                }
                // Pending names persist — cleared by next set_last_let_name or param_name_get
            }
        }
    }
    result
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_store(builder: LLVMPtr, val: LLVMPtr, ptr: LLVMPtr) -> LLVMPtr {
    bld_trace2("build_store", builder, val, ptr);
    if builder.is_null() || val.is_null() || ptr.is_null() { return std::ptr::null_mut(); }
    unsafe {
        // store requires a pointer destination
        let ptr_ty = LLVMTypeOf(ptr);
        if ptr_ty.is_null() { return std::ptr::null_mut(); }
        let ptr_kind = LLVMGetTypeKind(ptr_ty);
        if ptr_kind != 12 { return std::ptr::null_mut(); }
        // If storing i1 (boolean), zero-extend to i64 first
        // (prevents garbage upper bits when loaded back as i64)
        let val_ty = LLVMTypeOf(val);
        let val_kind = LLVMGetTypeKind(val_ty);
        // Try to get the alloca's type for compatibility check (only for alloca instructions)
        let opcode_pre = LLVMGetInstructionOpcode(ptr);
        let alloca_ty = if opcode_pre == 26 { LLVMGetAllocatedType(ptr) } else { std::ptr::null_mut() };
        let alloca_kind = if !alloca_ty.is_null() { LLVMGetTypeKind(alloca_ty) } else { 0 };
        let mut real_val = val;
        // Widen narrow ints to match alloca type (only if alloca is wider)
        if val_kind == 8 { // IntegerTypeKind
            let bit_width = LLVMGetIntTypeWidth(val_ty);
            let target_ty = if !alloca_ty.is_null() && alloca_kind == 8 { alloca_ty }
                else { TYPE_CACHE.with(|c| c.borrow().i64) };
            let target_width = if !target_ty.is_null() && LLVMGetTypeKind(target_ty) == 8 {
                LLVMGetIntTypeWidth(target_ty)
            } else { 64 };
            if bit_width < target_width {
                real_val = LLVMBuildZExt(builder, val, target_ty, safe_name(std::ptr::null()));
            }
        }
        // Only check type compat for ALLOCA instructions (opcode 26), not GEP results
        let opcode = LLVMGetInstructionOpcode(ptr);
        if opcode == 26 { // Alloca instruction
            // Struct value → i64 alloca: coerce to i64
            if val_kind == 10 && alloca_kind == 8 {
                real_val = ensure_i64(builder, val);
            }
            // i64 value (especially i64 0) → struct alloca: replace with a
            // typed zero of the alloca's struct type. Storing a bare i64 0
            // into a multi-field struct alloca leaves the upper bytes
            // uninitialized — when the alloca is 16 bytes ({ptr,i64} list)
            // this means subsequent loads see whatever happened to be on
            // the stack, and length-tracking goes haywire. Replacing with
            // const_null of the alloca type guarantees full zero-init.
            if val_kind == 8 && alloca_kind == 10 && !alloca_ty.is_null() {
                // Only if val is a constant zero (i.e., a freshly-defaulted
                // value) — non-zero i64s might legitimately mean "store the
                // pointer bits of an LLVM ValueRef I'm passing through".
                if LLVMIsConstant(val) != 0 && LLVMConstIntGetSExtValue(val) == 0 {
                    real_val = LLVMConstNull(alloca_ty);
                }
            }
        }
        LLVMBuildStore(builder, real_val, ptr)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_load(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, name: *const c_char) -> LLVMPtr {
    bld_trace("build_load", builder, ptr);
    let ty = ensure_type(ty);
    if ptr.is_null() || ty.is_null() {
        return std::ptr::null_mut();
    }
    unsafe {
        // Trust the caller's type — LLVM is the source of truth
        // Safety check: verify ptr is a valid LLVM value before calling LLVMTypeOf
        if builder.is_null() {
            return std::ptr::null_mut();
        }
        let ptr_kind = LLVMGetTypeKind(LLVMTypeOf(ptr));
        if ptr_kind != 12 { // Not PointerTypeKind
            let ty_kind = LLVMGetTypeKind(ty);
            if ty_kind == 8 { return LLVMConstInt(ty, 0, 0); }
            return LLVMGetUndef(ty);
        }
        LLVMBuildLoad2(builder, ty, ptr, safe_name(name))
    }
}

// ── Control flow ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_br(builder: LLVMPtr, bb: LLVMPtr) -> LLVMPtr {
    bld_trace("build_br", builder, bb);
    if builder.is_null() || bb.is_null() { return std::ptr::null_mut(); }
    unsafe {
        // Skip if the current block already has a terminator (e.g., a ret
        // emitted by a `return` statement inside a match/if arm). Without
        // this guard the codegen would emit `ret X; br merge` in the same
        // block, producing invalid IR — and LLVM would silently drop the
        // ret, losing the return value. This is the SINGLE place that
        // protects against double-terminator bugs across the whole
        // self-hosted codegen.
        let cur = LLVMGetInsertBlock(builder);
        if !cur.is_null() {
            let term = LLVMGetBasicBlockTerminator(cur);
            if !term.is_null() {
                return term;
            }
        }
        LLVMBuildBr(builder, bb)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_cond_br(builder: LLVMPtr, cond: LLVMPtr, then_bb: LLVMPtr, else_bb: LLVMPtr) -> LLVMPtr {
    bld_trace2("build_cond_br", builder, then_bb, else_bb);
    if builder.is_null() { return std::ptr::null_mut(); }
    unsafe {
        // Same terminator guard as forge_llvm_build_br.
        let cur = LLVMGetInsertBlock(builder);
        if !cur.is_null() {
            let term = LLVMGetBasicBlockTerminator(cur);
            if !term.is_null() {
                return term;
            }
        }
        LLVMBuildCondBr(builder, cond, then_bb, else_bb)
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_icmp(builder: LLVMPtr, pred: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    bld_trace("build_icmp", builder, std::ptr::null_mut());
    if builder.is_null() || lhs.is_null() || rhs.is_null() {
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i1, 0, 0) });
    }
    unsafe {
        // Coerce both operands to i64 for comparison
        let lhs = ensure_i64(builder, lhs);
        let rhs = ensure_i64(builder, rhs);
        let lhs_ty = LLVMTypeOf(lhs);
        let rhs_ty = LLVMTypeOf(rhs);
        let lhs_kind = LLVMGetTypeKind(lhs_ty);
        // icmp only works on integer (8) and pointer (12) types
        if lhs_kind != 8 && lhs_kind != 12 {
            // For struct types (10), try string comparison via forge_string_compare
            if lhs_kind == 10 {
                // Look up forge_string_compare in the module
                let bb = LLVMGetInsertBlock(builder);
                if !bb.is_null() {
                    let func = LLVMGetBasicBlockParent(bb);
                    if !func.is_null() {
                        let module = LLVMGetGlobalParent(func);
                        let cmp_fn = LLVMGetNamedFunction(module, b"forge_string_compare\0".as_ptr() as *const c_char);
                        if !cmp_fn.is_null() {
                            // Call forge_string_compare(lhs, rhs) → i64, then icmp result with 0
                            let fn_ty = LLVMGlobalGetValueType(cmp_fn);
                            let mut args = [lhs, rhs];
                            let cmp_result = LLVMBuildCall2(builder, fn_ty, cmp_fn, args.as_mut_ptr(), 2, safe_name(std::ptr::null()));
                            let i64_ty = TYPE_CACHE.with(|c| c.borrow().i64);
                            let zero = LLVMConstInt(i64_ty, 0, 0);
                            return LLVMBuildICmp(builder, pred, cmp_result, zero, safe_name(name));
                        }
                    }
                }
            }
            let i1 = TYPE_CACHE.with(|c| c.borrow().i1);
            return LLVMConstInt(i1, 0, 0);
        }
        if lhs_ty != rhs_ty {
            let i1 = TYPE_CACHE.with(|c| c.borrow().i1);
            return LLVMConstInt(i1, 0, 0);
        }
        LLVMBuildICmp(builder, pred, lhs, rhs, safe_name(name))
    }
}

// ── Function calls ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_call(builder: LLVMPtr, fn_type: LLVMPtr, f: LLVMPtr, args: *mut LLVMPtr, num_args: c_int, name: *const c_char) -> LLVMPtr {
    bld_trace("build_call", builder, f);
    if builder.is_null() || fn_type.is_null() || f.is_null() { return std::ptr::null_mut(); }
    unsafe {
        static mut BC_TRACE: i32 = 200;
        if BC_TRACE > 0 {
            let s = if !name.is_null() { std::ffi::CStr::from_ptr(name).to_str().unwrap_or("?") } else { "?" };
            eprintln!("  [BC] f={:p} args={} name={}", f, num_args, s);
            BC_TRACE -= 1;
        }
    }
    // Auto-coerce arguments: if param expects ptr but arg is i64 (or vice versa), convert
    unsafe {
        // Get expected param types
        let n = num_args as usize;
        let param_tys_layout = std::alloc::Layout::array::<LLVMPtr>(n.max(1)).unwrap();
        let param_tys = std::alloc::alloc_zeroed(param_tys_layout) as *mut LLVMPtr;
        LLVMGetParamTypes(fn_type, param_tys);
        for i in 0..n {
            let arg = *args.add(i);
            if arg.is_null() { continue; }
            let param_ty = *param_tys.add(i);
            if param_ty.is_null() { continue; }
            let arg_ty = LLVMTypeOf(arg);
            if arg_ty == param_ty { continue; }
            let param_kind = LLVMGetTypeKind(param_ty);
            let arg_kind = LLVMGetTypeKind(arg_ty);
            // i64 → ptr coercion
            if param_kind == 12 && arg_kind == 8 {
                *args.add(i) = LLVMBuildIntToPtr(builder, arg, param_ty, b"coerce\0".as_ptr() as *const c_char);
            }
            // ptr → i64 coercion
            if param_kind == 8 && arg_kind == 12 {
                *args.add(i) = LLVMBuildPtrToInt(builder, arg, param_ty, b"coerce\0".as_ptr() as *const c_char);
            }
            // struct → ptr coercion (extract field 0, which is ptr for ForgeString)
            if param_kind == 12 && arg_kind == 10 {
                let extracted = LLVMBuildExtractValue(builder, arg, 0, b"coerce\0".as_ptr() as *const c_char);
                if !extracted.is_null() {
                    *args.add(i) = extracted;
                }
            }
            // struct → i64 coercion (extract field 0)
            if param_kind == 8 && arg_kind == 10 {
                let extracted = LLVMBuildExtractValue(builder, arg, 0, b"coerce\0".as_ptr() as *const c_char);
                if !extracted.is_null() {
                    let ext_ty = LLVMTypeOf(extracted);
                    if LLVMGetTypeKind(ext_ty) == 12 {
                        *args.add(i) = LLVMBuildPtrToInt(builder, extracted, param_ty, b"coerce2\0".as_ptr() as *const c_char);
                    } else {
                        *args.add(i) = extracted;
                    }
                }
            }
            // i64 → struct coercion: the i64 was loaded from an alloca that
            // actually holds a struct. Re-derive from the load's source operand.
            if param_kind == 10 && arg_kind == 8 {
                let opcode = LLVMGetInstructionOpcode(arg);
                let mut fixed = false;
                // Try to reload from source alloca (opcode 27=Load, 33=Load2)
                if opcode == 27 || opcode == 33 {
                    let src_ptr = LLVMGetOperand(arg, 0);
                    if !src_ptr.is_null() {
                        *args.add(i) = LLVMBuildLoad2(builder, param_ty, src_ptr, b"reload\0".as_ptr() as *const c_char);
                        fixed = true;
                    }
                }
                // Fallback: use undef to prevent LLVM assertion (produces garbage but doesn't crash)
                if !fixed {
                    *args.add(i) = LLVMGetUndef(param_ty);
                }
            }
        }
        // Final verification: check all args match expected types
        // Re-get param types (may have changed due to coercion)
        let verify_tys = std::alloc::alloc_zeroed(param_tys_layout) as *mut LLVMPtr;
        LLVMGetParamTypes(fn_type, verify_tys);
        for i in 0..n {
            let arg = *args.add(i);
            if arg.is_null() { continue; }
            let param_ty = *verify_tys.add(i);
            if param_ty.is_null() { continue; }
            let arg_ty = LLVMTypeOf(arg);
            if arg_ty != param_ty {
                // Still mismatched after coercion — use undef to prevent crash
                *args.add(i) = LLVMGetUndef(param_ty);
            }
        }
        std::alloc::dealloc(verify_tys as *mut u8, param_tys_layout);
        std::alloc::dealloc(param_tys as *mut u8, param_tys_layout);
        LLVMBuildCall2(builder, fn_type, f, args, num_args as c_uint, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_new(count: c_int) -> *mut LLVMPtr {
    let layout = std::alloc::Layout::array::<LLVMPtr>(count as usize).unwrap();
    unsafe { std::alloc::alloc_zeroed(layout) as *mut LLVMPtr }
}

#[no_mangle]
static mut VAS_TRACE: i32 = 0;

#[no_mangle]
pub extern "C" fn forge_vas_trace(n: i64) {
    unsafe { VAS_TRACE = n as i32; }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_set(arr: *mut LLVMPtr, index: c_int, val: LLVMPtr) {
    if arr.is_null() { return; }
    unsafe {
        if VAS_TRACE > 0 {
            eprintln!("  [VAS] arr={:p} idx={} val={:p}", arr, index, val);
            VAS_TRACE -= 1;
        }
        *arr.offset(index as isize) = val;
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_get(arr: *mut LLVMPtr, index: c_int) -> LLVMPtr {
    unsafe { *arr.offset(index as isize) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_value_array_free(arr: *mut LLVMPtr) {
    let _ = arr;
}

// ── Global strings ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_global_string_ptr(builder: LLVMPtr, s: *const c_char, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildGlobalStringPtr(builder, s, safe_name(name)) }
}

/// Create a constant ForgeString {ptr, i64} value without using the builder.
/// The string data becomes a global constant; the ForgeString is a constant struct.
/// This is position-independent — safe to use anywhere in the function.
#[no_mangle]
pub extern "C" fn forge_llvm_const_string(module: LLVMPtr, text: *const c_char, len: i64) -> LLVMPtr {
    if module.is_null() { return std::ptr::null_mut(); }
    TYPE_CACHE.with(|c| {
        let cache = c.borrow();
        unsafe {
            // Create the string data as a global constant (null-terminated for C interop)
            let str_const = LLVMConstStringInContext(cache.ctx, text, len as c_uint, 0);
            let arr_ty = LLVMArrayType(cache.i8, (len + 1) as c_uint);
            let global = LLVMAddGlobal(module, arr_ty, safe_name(std::ptr::null()));
            LLVMSetInitializer(global, str_const);
            LLVMSetGlobalConstant(global, 1);
            // Get a ptr to the first byte
            let mut indices = [LLVMConstInt(cache.i64, 0, 0), LLVMConstInt(cache.i64, 0, 0)];
            let str_ptr = LLVMConstGEP2(arr_ty, global, indices.as_mut_ptr(), 2);
            // Build the ForgeString struct constant: {ptr, i64}
            let len_val = LLVMConstInt(cache.i64, len as c_ulonglong, 0);
            let mut fields = [str_ptr, len_val];
            // Get ForgeString type from cache context
            let str_ty = LLVMGetTypeByName2(cache.ctx, b"ForgeString\0".as_ptr() as *const c_char);
            if str_ty.is_null() {
                // Fallback: use anonymous struct
                return LLVMConstStructInContext(cache.ctx, fields.as_mut_ptr(), 2, 0);
            }
            // Use named struct type so LLVM IR prints %ForgeString, not { ptr, i64 }
            LLVMConstNamedStruct(str_ty, fields.as_mut_ptr(), 2)
        }
    })
}

// ── PHI nodes ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_phi(builder: LLVMPtr, ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if builder.is_null() { return std::ptr::null_mut(); }
    let ty = ensure_type(ty);
    if ty.is_null() { return std::ptr::null_mut(); }
    unsafe { LLVMBuildPhi(builder, ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_add_incoming_array(phi: LLVMPtr, values: *mut LLVMPtr, blocks: *mut LLVMPtr, count: c_int) {
    unsafe { LLVMAddIncoming(phi, values, blocks, count as c_uint) }
}

// Legacy 3-arg entry point — the self-hosted compiler's `llvm.add_incoming`
// wrapper auto-mangles to this name and expects the 3-arg convention.
// Delegates to the _one variant.
#[no_mangle]
pub extern "C" fn forge_llvm_add_incoming(phi: LLVMPtr, value: LLVMPtr, block: LLVMPtr) {
    forge_llvm_add_incoming_one(phi, value, block)
}

#[no_mangle]
pub extern "C" fn forge_llvm_add_incoming_one(phi: LLVMPtr, value: LLVMPtr, block: LLVMPtr) {
    unsafe {
        if phi.is_null() || value.is_null() || block.is_null() { return; }
        // Sanity-check pointer alignment: LLVM objects are at least
        // 8-byte aligned. Unaligned pointers are almost certainly
        // corrupt Forge List<ptr> slots holding garbage.
        if ((phi as usize) & 0x7) != 0 { return; }
        if ((block as usize) & 0x7) != 0 { return; }
        // Validate block: must belong to same function as the phi's
        // parent block. Forge List<ptr> occasionally hands back a
        // stale/corrupt BasicBlockRef.
        let phi_block = LLVMGetInstructionParent(phi);
        if phi_block.is_null() { return; }
        let phi_fn = LLVMGetBasicBlockParent(phi_block);
        let block_fn = LLVMGetBasicBlockParent(block);
        if phi_fn.is_null() || block_fn.is_null() || phi_fn != block_fn { return; }
        // Auto-correct type mismatch: if phi expects i64 but value is null/ptr, use i64 0
        let safe_value = {
            let phi_ty = LLVMTypeOf(phi);
            let val_ty = LLVMTypeOf(value);
            let phi_kind = LLVMGetTypeKind(phi_ty);
            let val_kind = LLVMGetTypeKind(val_ty);
            if phi_kind != val_kind {
                // Type mismatch — create zero of the phi's type
                if phi_kind == 8 { // phi is integer
                    LLVMConstInt(phi_ty, 0, 0)
                } else if phi_kind == 10 { // phi is struct
                    LLVMGetUndef(phi_ty)
                } else {
                    LLVMConstNull(phi_ty)
                }
            } else {
                value
            }
        };
        let mut values = [safe_value];
        let mut blocks = [block];
        LLVMAddIncoming(phi, values.as_mut_ptr(), blocks.as_mut_ptr(), 1);
    }
}

// ── Struct Types ──

#[no_mangle]
pub extern "C" fn forge_llvm_struct_type(ctx: LLVMPtr, element_types: *mut LLVMPtr, count: c_int, packed: c_int) -> LLVMPtr {
    if element_types.is_null() && count > 0 { return std::ptr::null_mut(); }
    unsafe { LLVMStructTypeInContext(ctx, element_types, count as c_uint, packed) }
}

#[no_mangle]
#[no_mangle]
pub extern "C" fn forge_llvm_type_of(val: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMTypeOf(val) }
}

/// Alias without forge_ prefix (method dispatch tries llvm_type_of first)
#[no_mangle]
pub extern "C" fn llvm_type_of(val: LLVMPtr) -> LLVMPtr {
    forge_llvm_type_of(val)
}



#[no_mangle]
pub extern "C" fn forge_llvm_get_type_kind(ty: LLVMPtr) -> c_int {
    if ty.is_null() { return 0; }
    unsafe { LLVMGetTypeKind(ty) as c_int }
}

#[no_mangle]
pub extern "C" fn forge_llvm_struct_create_named(ctx: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMStructCreateNamed(ctx, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_type_by_name(ctx: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMGetTypeByName2(ctx, name) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_struct_set_body(struct_type: LLVMPtr, element_types: *mut LLVMPtr, count: c_int, packed: c_int) {
    unsafe { LLVMStructSetBody(struct_type, element_types, count as c_uint, packed) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_struct_get_type_at_index(struct_type: LLVMPtr, index: c_int) -> LLVMPtr {
    unsafe { LLVMStructGetTypeAtIndex(struct_type, index as c_uint) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_count_struct_element_types(struct_type: LLVMPtr) -> c_int {
    unsafe { LLVMCountStructElementTypes(struct_type) as c_int }
}

/// Get the name of a named struct type as a ForgeString.
/// Returns empty string for anonymous structs.
#[no_mangle]
pub extern "C" fn forge_llvm_get_struct_name(struct_type: LLVMPtr) -> i64 {
    if struct_type.is_null() { return 0; }
    unsafe {
        let name = LLVMGetStructName(struct_type);
        if name.is_null() { return 0; }
        // Return as i64 pointer to the static LLVM string (no allocation needed)
        // The caller should use this pointer with forge_string_new
        name as i64
    }
}


/// Get the store size of a type in bytes (using module's data layout)
#[no_mangle]
pub extern "C" fn forge_llvm_store_size_of_type(m: LLVMPtr, ty: LLVMPtr) -> i64 {
    if m.is_null() || ty.is_null() { return 8; }
    unsafe {
        let dl = LLVMGetModuleDataLayout(m);
        if dl.is_null() { return 8; }
        LLVMStoreSizeOfType(dl, ty) as i64
    }
}

// ── Function Type Introspection ──

#[no_mangle]
pub extern "C" fn forge_llvm_fn_get_param_type(fn_ty: LLVMPtr, index: c_int) -> LLVMPtr {
    if fn_ty.is_null() { return std::ptr::null_mut(); }
    unsafe {
        let count = LLVMCountParamTypes(fn_ty) as c_int;
        if index < 0 || index >= count { return std::ptr::null_mut(); }
        let mut params = vec![std::ptr::null_mut(); count as usize];
        LLVMGetParamTypes(fn_ty, params.as_mut_ptr());
        params[index as usize]
    }
}

// ── Aggregate Operations ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_gep2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, indices: *mut LLVMPtr, num_indices: c_int, name: *const c_char) -> LLVMPtr {
    if builder.is_null() { return std::ptr::null_mut(); }
    let ty = ensure_type(ty);
    if ptr.is_null() || ty.is_null() || indices.is_null() || num_indices <= 0 {
        return std::ptr::null_mut();
    }
    unsafe {
        // GEP requires a pointer base
        let ptr_kind = LLVMGetTypeKind(LLVMTypeOf(ptr));
        if ptr_kind != 12 { return std::ptr::null_mut(); }
        // Validate indices — each must be an integer value
        for i in 0..num_indices as usize {
            let idx = *indices.add(i);
            if idx.is_null() { return std::ptr::null_mut(); }
            let idx_kind = LLVMGetTypeKind(LLVMTypeOf(idx));
            if idx_kind != 8 { // Not IntegerTypeKind
                // Try to coerce to i64
                let coerced = ensure_i64(builder, idx);
                *indices.add(i) = coerced;
            }
        }
        LLVMBuildGEP2(builder, ty, ptr, indices, num_indices as c_uint, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_struct_gep2(builder: LLVMPtr, ty: LLVMPtr, ptr: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || ty.is_null() || ptr.is_null() { return std::ptr::null_mut(); }
    unsafe {
        let n = LLVMCountStructElementTypes(ty);
        if (index as c_uint) >= n { return std::ptr::null_mut(); }
        LLVMBuildStructGEP2(builder, ty, ptr, index as c_uint, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_insert_value(builder: LLVMPtr, agg: LLVMPtr, element: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || agg.is_null() || element.is_null() { return agg; }
    unsafe {
        // Verify type compatibility before insert
        let agg_ty = LLVMTypeOf(agg);
        let n = LLVMCountStructElementTypes(agg_ty);
        if (index as c_uint) >= n {
            let name_s = if name.is_null() { "<null>" } else { std::ffi::CStr::from_ptr(name).to_str().unwrap_or("?") };
            eprintln!("WARNING: insertvalue index {} >= struct field count {} for {}", index, n, name_s);
            return agg;
        }
        // Check type compatibility — if element is struct but field expects i64, extract field 1
        let field_ty = LLVMStructGetTypeAtIndex(agg_ty, index as c_uint);
        let elem_ty = LLVMTypeOf(element);
        let field_kind = LLVMGetTypeKind(field_ty);
        let elem_kind = LLVMGetTypeKind(elem_ty);
        let mut real_element = element;
        if field_kind != elem_kind {
            if field_kind == 8 && elem_kind == 10 {
                // Field expects integer but got struct — extract field 1 (i64 part)
                let elem_n = LLVMCountStructElementTypes(elem_ty);
                if elem_n > 1 {
                    real_element = LLVMBuildExtractValue(builder, element, 1, safe_name(std::ptr::null()));
                } else {
                    real_element = LLVMBuildExtractValue(builder, element, 0, safe_name(std::ptr::null()));
                }
            } else if field_kind == 12 && elem_kind == 8 {
                // Field expects ptr but got i64 — inttoptr
                let ptr_ty = TYPE_CACHE.with(|c| c.borrow().ptr);
                real_element = LLVMBuildIntToPtr(builder, element, ptr_ty, safe_name(std::ptr::null()));
            }
        }
        LLVMBuildInsertValue(builder, agg, real_element, index as c_uint, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_extract_value(builder: LLVMPtr, agg: LLVMPtr, index: c_int, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || agg.is_null() {
        eprintln!("WARNING: build_extract_value called with null aggregate");
        return std::ptr::null_mut();
    }
    // Safety: verify the value is an aggregate type and index is in bounds
    unsafe {
        let ty = LLVMTypeOf(agg);
        let kind = LLVMGetTypeKind(ty);
        // 10 = struct, 11 = array. Other kinds crash ExtractValue.
        if kind != 10 && kind != 11 {
            return std::ptr::null_mut();
        }
        // Bounds check for struct types
        if kind == 10 {
            let count = LLVMCountStructElementTypes(ty);
            if index as c_uint >= count {
                return std::ptr::null_mut();
            }
        }
        LLVMBuildExtractValue(builder, agg, index as c_uint, safe_name(name))
    }
}

// ── Arithmetic (division, remainder, float ops) ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_sdiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if !guard_int_binop(lhs, rhs) {
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) });
    }
    unsafe { LLVMBuildSDiv(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_srem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if !guard_int_binop(lhs, rhs) {
        return TYPE_CACHE.with(|c| unsafe { LLVMConstInt(c.borrow().i64, 0, 0) });
    }
    unsafe { LLVMBuildSRem(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fadd(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFAdd(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fsub(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFSub(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fmul(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFMul(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fdiv(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFDiv(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_frem(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFRem(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fneg(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFNeg(builder, val, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fcmp(builder: LLVMPtr, pred: c_int, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFCmp(builder, pred, lhs, rhs, safe_name(name)) }
}

// ── Integer Conversions ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_zext(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    let dest_ty = ensure_int_type(dest_ty);
    unsafe {
        let val_kind = LLVMGetTypeKind(LLVMTypeOf(val));
        if val_kind == 12 { // PointerTypeKind — use ptrtoint instead of zext
            return LLVMBuildPtrToInt(builder, val, dest_ty, safe_name(name));
        }
        if val_kind != 8 { // Not integer — return i64 0
            return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0));
        }
        LLVMBuildZExt(builder, val, dest_ty, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_sext(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    let dest_ty = ensure_int_type(dest_ty);
    unsafe { LLVMBuildSExt(builder, val, dest_ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_trunc(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    let dest_ty = ensure_int_type(dest_ty);
    unsafe {
        let val_kind = LLVMGetTypeKind(LLVMTypeOf(val));
        if val_kind != 8 { // Not integer — can't trunc, return i1 0
            let i1 = TYPE_CACHE.with(|c| c.borrow().i1);
            return LLVMConstInt(i1, 0, 0);
        }
        LLVMBuildTrunc(builder, val, dest_ty, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_si_to_fp(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildSIToFP(builder, val, dest_ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_fp_to_si(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildFPToSI(builder, val, dest_ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_bitcast(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildBitCast(builder, val, dest_ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ptrtoint(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildPtrToInt(builder, val, dest_ty, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_inttoptr(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if builder.is_null() || val.is_null() { return std::ptr::null_mut(); }
    unsafe {
        let val_kind = LLVMGetTypeKind(LLVMTypeOf(val));
        // struct → ptr: extract field 0 (the data pointer) instead of inttoptr
        if val_kind == 10 {
            return LLVMBuildExtractValue(builder, val, 0, safe_name(name));
        }
        // ptr → ptr: no conversion needed
        if val_kind == 12 {
            return val;
        }
        LLVMBuildIntToPtr(builder, val, dest_ty, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ptr_to_int(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if val.is_null() || dest_ty.is_null() { return std::ptr::null_mut(); }
    unsafe {
        let val_kind = LLVMGetTypeKind(LLVMTypeOf(val));
        // struct → i64: extract field 0 (ptr), then ptrtoint
        if val_kind == 10 {
            let extracted = LLVMBuildExtractValue(builder, val, 0, b"s0\0".as_ptr() as *const c_char);
            if !extracted.is_null() && LLVMGetTypeKind(LLVMTypeOf(extracted)) == 12 {
                return LLVMBuildPtrToInt(builder, extracted, dest_ty, safe_name(name));
            }
            return extracted;
        }
        // i64 → i64: no conversion needed
        if val_kind == 8 {
            return val;
        }
        LLVMBuildPtrToInt(builder, val, dest_ty, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_int_to_ptr(builder: LLVMPtr, val: LLVMPtr, dest_ty: LLVMPtr, name: *const c_char) -> LLVMPtr {
    if val.is_null() || dest_ty.is_null() { return std::ptr::null_mut(); }
    unsafe { LLVMBuildIntToPtr(builder, val, dest_ty, safe_name(name)) }
}

// ── Bitwise Operations ──

#[no_mangle]
pub extern "C" fn forge_llvm_build_and(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe {
        if LLVMTypeOf(lhs) != LLVMTypeOf(rhs) || LLVMGetTypeKind(LLVMTypeOf(lhs)) != 8 {
            return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0));
        }
        LLVMBuildAnd(builder, lhs, rhs, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_or(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe {
        if LLVMTypeOf(lhs) != LLVMTypeOf(rhs) || LLVMGetTypeKind(LLVMTypeOf(lhs)) != 8 {
            return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0));
        }
        LLVMBuildOr(builder, lhs, rhs, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_xor(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe {
        if LLVMTypeOf(lhs) != LLVMTypeOf(rhs) || LLVMGetTypeKind(LLVMTypeOf(lhs)) != 8 {
            return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0));
        }
        LLVMBuildXor(builder, lhs, rhs, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_shl(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe {
        if LLVMTypeOf(lhs) != LLVMTypeOf(rhs) || LLVMGetTypeKind(LLVMTypeOf(lhs)) != 8 {
            return TYPE_CACHE.with(|c| LLVMConstInt(c.borrow().i64, 0, 0));
        }
        LLVMBuildShl(builder, lhs, rhs, safe_name(name))
    }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_ashr(builder: LLVMPtr, lhs: LLVMPtr, rhs: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildAShr(builder, lhs, rhs, safe_name(name)) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_build_not(builder: LLVMPtr, val: LLVMPtr, name: *const c_char) -> LLVMPtr {
    unsafe { LLVMBuildNot(builder, val, safe_name(name)) }
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
// Named forge_is_null_val (not forge_llvm_*) to avoid mini auto-declare
// treating it as ptr-returning (all forge_llvm_* default to ptr return)
#[no_mangle]
pub extern "C" fn forge_is_null_val(val: LLVMPtr) -> i64 {
    if val.is_null() { return 1; }
    unsafe { LLVMIsNull(val) as i64 }
}

#[no_mangle]
pub extern "C" fn forge_llvm_size_of(ty: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMSizeOf(ty) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_get_undef(ty: LLVMPtr) -> LLVMPtr {
    unsafe { LLVMGetUndef(ty) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_global_get_value_type(val: LLVMPtr) -> LLVMPtr {
    if val.is_null() { return std::ptr::null_mut(); }
    unsafe {
        static mut GGVT_TRACE: i32 = 50;
        if GGVT_TRACE > 0 {
            eprintln!("  [GGVT] val={:p}", val);
            GGVT_TRACE -= 1;
        }
        LLVMGlobalGetValueType(val)
    }
}


#[no_mangle]
pub extern "C" fn forge_llvm_get_allocated_type(alloca: LLVMPtr) -> LLVMPtr {
    if alloca.is_null() { return std::ptr::null_mut(); }
    unsafe {
        // Only valid for alloca instructions (opcode 26)
        let opcode = LLVMGetInstructionOpcode(alloca);
        if opcode != 26 { return std::ptr::null_mut(); }
        LLVMGetAllocatedType(alloca)
    }
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
    if m.is_null() || ty.is_null() || name.is_null() { return std::ptr::null_mut(); }
    let result = unsafe { LLVMAddGlobal(m, ty, name) };
    // Auto-cache global Value* so emit_ident can find globals via alloca cache
    if !name.is_null() && !result.is_null() {
        extern "C" {
            fn forge_alloca_cache_set_raw(name_ptr: *const c_char, name_len: i64, ptr: *mut c_void) -> i64;
            fn forge_str_var_add_raw(name_ptr: *const c_char, name_len: i64) -> i64;
        }
        let len = unsafe { std::ffi::CStr::from_ptr(name).to_bytes().len() } as i64;
        if len > 0 && len < 100 {
            unsafe {
                forge_alloca_cache_set_raw(name, len, result);
                // Don't auto-register as string var — only string-typed
                // globals should be registered (done by Forge code via str_mask)
            }
        }
    }
    result
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_initializer(global: LLVMPtr, val: LLVMPtr) {
    unsafe { LLVMSetInitializer(global, val) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_global_constant(global: LLVMPtr, is_constant: c_int) {
    unsafe { LLVMSetGlobalConstant(global, is_constant) }
}

#[no_mangle]
pub extern "C" fn forge_llvm_set_linkage(global: LLVMPtr, linkage: c_int) {
    unsafe { LLVMSetLinkage(global, linkage as c_uint) }
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
pub extern "C" fn forge_llvm_position_before(builder: LLVMPtr, instr: LLVMPtr) {
    bld_trace("position_before", builder, instr);
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

/// Check if a basic block already has a terminator instruction (ret, br, etc.).
/// Returns 1 if it has a terminator, 0 if not.
#[no_mangle]
pub extern "C" fn forge_llvm_block_has_terminator(builder: LLVMPtr) -> c_int {
    unsafe {
        let bb = LLVMGetInsertBlock(builder);
        if bb.is_null() { return 0; }
        let term = LLVMGetBasicBlockTerminator(bb);
        if term.is_null() { 0 } else { 1 }
    }
}

/// High-level: emit an LLVM module to an object file. Returns 0 on success.
#[no_mangle]
pub extern "C" fn forge_llvm_emit_object_file(m: LLVMPtr, filename: *const c_char) -> c_int {
    unsafe {
        forge_llvm_initialize_all_targets();

        let triple = LLVMGetDefaultTargetTriple();
        LLVMSetTarget(m, triple);

        let mut target: LLVMPtr = std::ptr::null_mut();
        let mut err: *mut c_char = std::ptr::null_mut();
        if LLVMGetTargetFromTriple(triple, &mut target, &mut err) != 0 {
            if !err.is_null() { LLVMDisposeMessage(err); }
            return 1;
        }

        let cpu = LLVMGetHostCPUName();
        let features = LLVMGetHostCPUFeatures();
        // OptLevel=0 (None), Reloc=0 (Default), CodeModel=0 (Default)
        let tm = LLVMCreateTargetMachine(target, triple, cpu, features, 0, 0, 0);
        LLVMDisposeMessage(cpu);
        LLVMDisposeMessage(features);
        if tm.is_null() { return 2; }

        // Set data layout from target machine (critical for correct ABI)
        let dl = LLVMCreateTargetDataLayout(tm);
        let dl_str = LLVMCopyStringRepOfTargetData(dl);
        LLVMSetDataLayout(m, dl_str);
        LLVMDisposeMessage(dl_str);
        LLVMDisposeTargetData(dl);

        err = std::ptr::null_mut();
        // codegen=1 = ObjectFile (0 = Assembly)
        let result = LLVMTargetMachineEmitToFile(tm, m, filename, 1, &mut err);
        if !err.is_null() { LLVMDisposeMessage(err); }

        LLVMDisposeTargetMachine(tm);
        LLVMDisposeMessage(triple);

        result
    }
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

// ─── Diagnostic helpers (#2 #3 #5) ────────────────────────────────

/// #2 — Assert that the builder's current insert block matches `expected_bb`.
/// No-op when FORGE_DEBUG_BUILDER is not set. When set and the assertion
/// fails, prints a diagnostic to stderr and aborts the process so the
/// stack trace shows the exact call site.
#[no_mangle]
pub extern "C" fn forge_llvm_assert_at(builder: LLVMPtr, expected_bb: LLVMPtr, label_ptr: *const c_char, label_len: i64) -> i64 {
    if !bld_trace_enabled() { return 1; }
    if builder.is_null() { return 0; }
    let actual = unsafe { LLVMGetInsertBlock(builder) };
    if actual == expected_bb { return 1; }
    let label = if !label_ptr.is_null() && label_len > 0 && label_len < 256 {
        let s = unsafe { std::slice::from_raw_parts(label_ptr as *const u8, label_len as usize) };
        std::str::from_utf8(s).unwrap_or("?")
    } else {
        "(no label)"
    };
    eprintln!(
        "[BLD ASSERT FAIL] label={} expected_bb={:p} actual_bb={:p} bld={:p}",
        label, expected_bb, actual, builder
    );
    std::process::abort();
}

/// #3 — Run LLVMVerifyFunction. Returns 0 on success, non-zero on failure.
/// Action 0 = AbortProcess, 1 = PrintMessage, 2 = ReturnStatus.
/// We use 2 (ReturnStatus) so the caller can decide what to do.
#[no_mangle]
pub extern "C" fn forge_llvm_verify_function(f: LLVMPtr) -> i64 {
    if f.is_null() { return -1; }
    unsafe { LLVMVerifyFunction(f, 2) as i64 }
}

/// #5 — Dump every basic block in `f` to stderr with `(name, term?, instr_count, pred_count)`.
/// Useful between emit_* steps to spot orphan blocks the moment they appear.
/// Pred-count is computed via LLVMGetFirstUse on the block's value (each
/// use is a branch instruction that targets it).
#[no_mangle]
pub extern "C" fn forge_llvm_dump_blocks(f: LLVMPtr) {
    if f.is_null() {
        eprintln!("[DUMP_BLOCKS] null function");
        return;
    }
    unsafe {
        let count = LLVMCountBasicBlocks(f);
        eprintln!("[DUMP_BLOCKS] function={:p} blocks={}", f, count);
        let mut bb = LLVMGetFirstBasicBlock(f);
        let mut idx = 0;
        while !bb.is_null() {
            let name_ptr = LLVMGetBasicBlockName(bb);
            let name = if !name_ptr.is_null() {
                std::ffi::CStr::from_ptr(name_ptr).to_string_lossy().into_owned()
            } else {
                String::from("?")
            };
            let term = LLVMGetBasicBlockTerminator(bb);
            let term_str = if term.is_null() { "NO_TERM" } else { "term" };
            // Count instructions
            let mut instr_count = 0;
            let mut instr = LLVMGetFirstInstruction(bb);
            while !instr.is_null() {
                instr_count += 1;
                instr = LLVMGetNextInstruction(instr);
            }
            // Pred count via uses of the block-as-value (each use is a branch).
            // LLVMBasicBlockAsValue is the right way; if we don't have it,
            // GetFirstUse on the bb pointer works for blocks too.
            let mut pred_count = 0;
            let mut use_iter = LLVMGetFirstUse(bb);
            while !use_iter.is_null() {
                pred_count += 1;
                use_iter = LLVMGetNextUse(use_iter);
                if pred_count > 9999 { break; } // safety
            }
            eprintln!(
                "  [{:3}] bb={:p} name={:<20} {:7} instrs={:3} preds={}",
                idx, bb, name, term_str, instr_count, pred_count
            );
            bb = LLVMGetNextBasicBlock(bb);
            idx += 1;
        }
    }
}

/// #6 — Depth-tracked enter/exit tracing. Pair calls to
/// `forge_dbg_enter` with `forge_dbg_exit`. Output is indented by depth.
/// Active only when FORGE_DEBUG_BUILDER is set so it costs nothing in
/// release runs. (Named `forge_dbg_*` to avoid colliding with the
/// pre-existing `forge_trace_enter`/`exit` in runtime.c which has
/// a different signature.)
static TRACE_DEPTH: AtomicI64 = AtomicI64::new(0);

#[no_mangle]
pub extern "C" fn forge_dbg_enter(name_ptr: *const c_char, name_len: i64) {
    if !bld_trace_enabled() { return; }
    let depth = TRACE_DEPTH.fetch_add(1, Ordering::Relaxed);
    let name = if !name_ptr.is_null() && name_len > 0 && name_len < 256 {
        let s = unsafe { std::slice::from_raw_parts(name_ptr as *const u8, name_len as usize) };
        std::str::from_utf8(s).unwrap_or("?")
    } else { "?" };
    let pad = "  ".repeat(depth.max(0) as usize);
    eprintln!("{}[ENTER {}]", pad, name);
}

#[no_mangle]
pub extern "C" fn forge_dbg_exit(name_ptr: *const c_char, name_len: i64) {
    if !bld_trace_enabled() { return; }
    let depth = TRACE_DEPTH.fetch_sub(1, Ordering::Relaxed) - 1;
    let name = if !name_ptr.is_null() && name_len > 0 && name_len < 256 {
        let s = unsafe { std::slice::from_raw_parts(name_ptr as *const u8, name_len as usize) };
        std::str::from_utf8(s).unwrap_or("?")
    } else { "?" };
    let pad = "  ".repeat(depth.max(0) as usize);
    eprintln!("{}[EXIT  {}]", pad, name);
}
// rebuild Sat Mar 28 23:33:49 PDT 2026
