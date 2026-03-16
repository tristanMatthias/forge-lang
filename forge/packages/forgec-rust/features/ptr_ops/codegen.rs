// Pointer operations codegen.
//
// All LLVM IR generation for ptr operations:
// - ptr[i] read: GEP i8 + load → zext to i64
// - ptr[i] = byte: GEP i8 + trunc to i8 + store
// - ptr + n: GEP i8 with offset
// - ptr - ptr: ptrtoint both + sub
// - ptr == ptr / ptr != ptr: ptrtoint both + icmp
// - string.from_ptr(p, len): call forge_string_new
// - ptr.from_string(s): extract_value 0 from string struct
// - null guard: check ptr is null before GEP, panic if so

use inkwell::IntPredicate;
use inkwell::values::{BasicValueEnum, PointerValue};

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;


impl<'ctx> Codegen<'ctx> {
    // ── ptr[index] read ────────────────────────────────────────────

    /// Compile ptr[index] → load one byte, zero-extend to i64
    pub(crate) fn compile_ptr_index_read(
        &mut self,
        ptr_val: PointerValue<'ctx>,
        index: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let idx = self.compile_expr(index)?.into_int_value();

        // Null guard
        self.emit_ptr_null_guard(ptr_val);

        // GEP to byte at offset
        let byte_ptr = unsafe {
            self.builder.build_gep(
                self.context.i8_type(),
                ptr_val,
                &[idx],
                "ptr_byte_ptr",
            ).unwrap()
        };

        // Load i8
        let byte_val = self.builder.build_load(
            self.context.i8_type(),
            byte_ptr,
            "ptr_byte",
        ).unwrap();

        // Zero-extend i8 → i64
        let int_val = self.builder.build_int_z_extend(
            byte_val.into_int_value(),
            self.context.i64_type(),
            "ptr_byte_ext",
        ).unwrap();

        Some(int_val.into())
    }

    // ── ptr[index] = byte write ────────────────────────────────────

    /// Compile ptr[index] = value → truncate to i8, store
    pub(crate) fn compile_ptr_index_write(
        &mut self,
        ptr_expr: &Expr,
        index: &Expr,
        value: &Expr,
    ) -> bool {
        let ptr_val = match self.compile_expr(ptr_expr) {
            Some(v) => v.into_pointer_value(),
            None => return false,
        };
        let idx = match self.compile_expr(index) {
            Some(v) => v.into_int_value(),
            None => return false,
        };
        let val = match self.compile_expr(value) {
            Some(v) => v.into_int_value(),
            None => return false,
        };

        // Null guard
        self.emit_ptr_null_guard(ptr_val);

        // GEP to byte at offset
        let byte_ptr = unsafe {
            self.builder.build_gep(
                self.context.i8_type(),
                ptr_val,
                &[idx],
                "ptr_store_ptr",
            ).unwrap()
        };

        // Truncate i64 → i8
        let byte_val = self.builder.build_int_truncate(
            val,
            self.context.i8_type(),
            "ptr_trunc_byte",
        ).unwrap();

        // Store
        self.builder.build_store(byte_ptr, byte_val).unwrap();
        true
    }

    // ── ptr + int (offset) ─────────────────────────────────────────

    /// Compile ptr + int → GEP with byte offset, returns ptr
    pub(crate) fn compile_ptr_add(
        &mut self,
        lhs: BasicValueEnum<'ctx>,
        rhs: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let ptr_val = lhs.into_pointer_value();
        let offset = rhs.into_int_value();

        let result = unsafe {
            self.builder.build_gep(
                self.context.i8_type(),
                ptr_val,
                &[offset],
                "ptr_offset",
            ).unwrap()
        };

        Some(result.into())
    }

    // ── ptr - ptr (distance) ───────────────────────────────────────

    /// Compile ptr - ptr → ptrtoint both, subtract, returns int
    pub(crate) fn compile_ptr_sub(
        &mut self,
        lhs: BasicValueEnum<'ctx>,
        rhs: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let lhs_ptr = lhs.into_pointer_value();
        let rhs_ptr = rhs.into_pointer_value();

        let lhs_int = self.builder.build_ptr_to_int(
            lhs_ptr,
            self.context.i64_type(),
            "ptr_to_int_l",
        ).unwrap();

        let rhs_int = self.builder.build_ptr_to_int(
            rhs_ptr,
            self.context.i64_type(),
            "ptr_to_int_r",
        ).unwrap();

        let diff = self.builder.build_int_sub(lhs_int, rhs_int, "ptr_diff").unwrap();
        Some(diff.into())
    }

    // ── ptr == ptr / ptr != ptr ────────────────────────────────────

    /// Compile ptr comparison (eq/neq), including ptr == null
    pub(crate) fn compile_ptr_compare(
        &mut self,
        lhs: BasicValueEnum<'ctx>,
        op: &BinaryOp,
        rhs: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let lhs_int = self.builder.build_ptr_to_int(
            lhs.into_pointer_value(),
            self.context.i64_type(),
            "ptr_cmp_l",
        ).unwrap();

        let rhs_int = self.builder.build_ptr_to_int(
            rhs.into_pointer_value(),
            self.context.i64_type(),
            "ptr_cmp_r",
        ).unwrap();

        let pred = match op {
            BinaryOp::Eq => IntPredicate::EQ,
            BinaryOp::NotEq => IntPredicate::NE,
            _ => return None,
        };

        let cmp = self.builder.build_int_compare(pred, lhs_int, rhs_int, "ptr_cmp").unwrap();
        let result = self.builder.build_int_z_extend(
            cmp,
            self.context.i8_type(),
            "ptr_cmp_ext",
        ).unwrap();

        Some(result.into())
    }

    // ── string.from_ptr(ptr, len) ──────────────────────────────────

    /// Compile string.from_ptr(ptr, len) → call forge_string_new
    pub(crate) fn compile_string_from_ptr(
        &mut self,
        args: &[Expr],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() != 2 { return None; }
        let ptr_val = self.compile_expr(&args[0])?;
        let len_val = self.compile_expr(&args[1])?;
        self.call_runtime("forge_string_new", &[ptr_val.into(), len_val.into()], "str_from_ptr")
    }

    // ── ptr.from_string(string) ────────────────────────────────────

    /// Compile ptr.from_string(s) → extract ptr field (index 0) from string struct
    pub(crate) fn compile_ptr_from_string(
        &mut self,
        args: &[Expr],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() != 1 { return None; }
        let str_val = self.compile_expr(&args[0])?;
        let struct_val = str_val.into_struct_value();
        let ptr_val = self.builder.build_extract_value(struct_val, 0, "str_ptr").ok()?;
        Some(ptr_val)
    }

    // ── Null guard ─────────────────────────────────────────────────

    /// Emit a null check before ptr[i] access. If null, abort with message.
    fn emit_ptr_null_guard(&mut self, ptr_val: PointerValue<'ctx>) {
        let ptr_int = self.builder.build_ptr_to_int(
            ptr_val,
            self.context.i64_type(),
            "null_check",
        ).unwrap();

        let is_null = self.builder.build_int_compare(
            IntPredicate::EQ,
            ptr_int,
            self.context.i64_type().const_zero(),
            "is_null",
        ).unwrap();

        let current_fn = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let panic_block = self.context.append_basic_block(current_fn, "ptr_null_panic");
        let ok_block = self.context.append_basic_block(current_fn, "ptr_ok");

        self.builder.build_conditional_branch(is_null, panic_block, ok_block).unwrap();

        // Panic block: call abort
        self.builder.position_at_end(panic_block);
        // Print message to stderr via forge_panic if available, otherwise abort
        if let Some(abort_fn) = self.module.get_function("abort") {
            self.builder.build_call(abort_fn, &[], "").unwrap();
        } else {
            // Declare abort
            let abort_type = self.context.void_type().fn_type(&[], false);
            let abort_fn = self.module.add_function("abort", abort_type, None);
            self.builder.build_call(abort_fn, &[], "").unwrap();
        }
        self.builder.build_unreachable().unwrap();

        // Continue in OK block
        self.builder.position_at_end(ok_block);
    }
}
