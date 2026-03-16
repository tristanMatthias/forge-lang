use inkwell::IntPredicate;
use inkwell::values::{BasicValueEnum, IntValue};

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_binary_op(
        &mut self,
        lhs: BasicValueEnum<'ctx>,
        op: BinaryOp,
        rhs: BasicValueEnum<'ctx>,
        left_expr: &Expr,
        right_expr: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let left_type = self.infer_type(left_expr);
        let right_type = self.infer_type(right_expr);

        // Handle comparison with null: `name != null` or `name == null`
        let is_null_compare = matches!(right_expr, Expr::NullLit(_)) || matches!(left_expr, Expr::NullLit(_));
        if is_null_compare && matches!(op, BinaryOp::Eq | BinaryOp::NotEq) {
            // Determine which side is nullable
            let (nullable_val, nullable_type) = if matches!(right_expr, Expr::NullLit(_)) {
                (lhs, &left_type)
            } else {
                (rhs, &right_type)
            };

            if nullable_type.is_nullable() && nullable_val.is_struct_value() {
                let struct_val = nullable_val.into_struct_value();
                let tag = self.builder.build_extract_value(struct_val, 0, "null_tag").ok()?;
                let cmp = if matches!(op, BinaryOp::Eq) {
                    // == null means tag == 0
                    self.builder.build_int_compare(
                        IntPredicate::EQ,
                        tag.into_int_value(),
                        self.context.i8_type().const_zero(),
                        "is_null",
                    ).unwrap()
                } else {
                    // != null means tag != 0
                    self.builder.build_int_compare(
                        IntPredicate::NE,
                        tag.into_int_value(),
                        self.context.i8_type().const_zero(),
                        "is_not_null",
                    ).unwrap()
                };
                return Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "null_cmp_ext").unwrap().into());
            }
        }

        // Pointer operations: ptr + int, ptr - ptr, ptr == ptr, ptr != ptr, ptr == null
        if left_type == Type::Ptr || right_type == Type::Ptr {
            match op {
                BinaryOp::Add if left_type == Type::Ptr && right_type == Type::Int => {
                    return self.compile_ptr_add(lhs, rhs);
                }
                BinaryOp::Sub if left_type == Type::Ptr && right_type == Type::Ptr => {
                    return self.compile_ptr_sub(lhs, rhs);
                }
                BinaryOp::Eq | BinaryOp::NotEq if left_type == Type::Ptr && right_type == Type::Ptr => {
                    return self.compile_ptr_compare(lhs, &op, rhs);
                }
                BinaryOp::Eq | BinaryOp::NotEq => {
                    // ptr == null or null == ptr: coerce null side to null pointer
                    let (ptr_side, null_side) = if left_type == Type::Ptr {
                        (lhs, rhs)
                    } else {
                        (rhs, lhs)
                    };
                    let null_ptr: BasicValueEnum<'ctx> = if null_side.is_pointer_value() {
                        null_side
                    } else {
                        self.context.ptr_type(inkwell::AddressSpace::default()).const_null().into()
                    };
                    return self.compile_ptr_compare(ptr_side, &op, null_ptr);
                }
                _ => {}
            }
        }

        // Float operations - check both inferred types AND actual LLVM values
        if left_type == Type::Float || right_type == Type::Float
            || lhs.is_float_value() || rhs.is_float_value()
        {
            let lhs_f = if lhs.is_int_value() {
                self.builder
                    .build_signed_int_to_float(lhs.into_int_value(), self.context.f64_type(), "itof")
                    .unwrap()
            } else {
                lhs.into_float_value()
            };
            let rhs_f = if rhs.is_int_value() {
                self.builder
                    .build_signed_int_to_float(rhs.into_int_value(), self.context.f64_type(), "itof")
                    .unwrap()
            } else {
                rhs.into_float_value()
            };

            return match op {
                BinaryOp::Add => Some(self.builder.build_float_add(lhs_f, rhs_f, "fadd").unwrap().into()),
                BinaryOp::Sub => Some(self.builder.build_float_sub(lhs_f, rhs_f, "fsub").unwrap().into()),
                BinaryOp::Mul => Some(self.builder.build_float_mul(lhs_f, rhs_f, "fmul").unwrap().into()),
                BinaryOp::Div => Some(self.builder.build_float_div(lhs_f, rhs_f, "fdiv").unwrap().into()),
                BinaryOp::Mod => Some(self.builder.build_float_rem(lhs_f, rhs_f, "fmod").unwrap().into()),
                BinaryOp::Eq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OEQ, lhs_f, rhs_f, "feq").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "feq_ext").unwrap().into())
                }
                BinaryOp::NotEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::ONE, lhs_f, rhs_f, "fne").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fne_ext").unwrap().into())
                }
                BinaryOp::Lt => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OLT, lhs_f, rhs_f, "flt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "flt_ext").unwrap().into())
                }
                BinaryOp::LtEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OLE, lhs_f, rhs_f, "fle").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fle_ext").unwrap().into())
                }
                BinaryOp::Gt => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OGT, lhs_f, rhs_f, "fgt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fgt_ext").unwrap().into())
                }
                BinaryOp::GtEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OGE, lhs_f, rhs_f, "fge").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fge_ext").unwrap().into())
                }
                _ => None,
            };
        }

        // Integer operations
        if lhs.is_int_value() && rhs.is_int_value() {
            let lhs_i = lhs.into_int_value();
            let rhs_i = rhs.into_int_value();

            // Make sure widths match (bool i8 vs int i64)
            let (lhs_i, rhs_i) = self.widen_ints(lhs_i, rhs_i);

            return match op {
                BinaryOp::Add => Some(self.builder.build_int_add(lhs_i, rhs_i, "add").unwrap().into()),
                BinaryOp::Sub => Some(self.builder.build_int_sub(lhs_i, rhs_i, "sub").unwrap().into()),
                BinaryOp::Mul => Some(self.builder.build_int_mul(lhs_i, rhs_i, "mul").unwrap().into()),
                BinaryOp::Div => Some(self.builder.build_int_signed_div(lhs_i, rhs_i, "div").unwrap().into()),
                BinaryOp::Mod => Some(self.builder.build_int_signed_rem(lhs_i, rhs_i, "mod").unwrap().into()),
                BinaryOp::Eq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::EQ, lhs_i, rhs_i, "eq").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "eq_ext").unwrap().into())
                }
                BinaryOp::NotEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::NE, lhs_i, rhs_i, "ne").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "ne_ext").unwrap().into())
                }
                BinaryOp::Lt => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SLT, lhs_i, rhs_i, "lt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "lt_ext").unwrap().into())
                }
                BinaryOp::LtEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SLE, lhs_i, rhs_i, "le").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "le_ext").unwrap().into())
                }
                BinaryOp::Gt => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SGT, lhs_i, rhs_i, "gt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "gt_ext").unwrap().into())
                }
                BinaryOp::GtEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SGE, lhs_i, rhs_i, "ge").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "ge_ext").unwrap().into())
                }
                BinaryOp::And => {
                    let lhs_bool = self.builder.build_int_compare(IntPredicate::NE, lhs_i, lhs_i.get_type().const_zero(), "lhs_bool").unwrap();
                    let rhs_bool = self.builder.build_int_compare(IntPredicate::NE, rhs_i, rhs_i.get_type().const_zero(), "rhs_bool").unwrap();
                    let result = self.builder.build_and(lhs_bool, rhs_bool, "and").unwrap();
                    Some(self.builder.build_int_z_extend(result, self.context.i8_type(), "and_ext").unwrap().into())
                }
                BinaryOp::Or => {
                    let lhs_bool = self.builder.build_int_compare(IntPredicate::NE, lhs_i, lhs_i.get_type().const_zero(), "lhs_bool").unwrap();
                    let rhs_bool = self.builder.build_int_compare(IntPredicate::NE, rhs_i, rhs_i.get_type().const_zero(), "rhs_bool").unwrap();
                    let result = self.builder.build_or(lhs_bool, rhs_bool, "or").unwrap();
                    Some(self.builder.build_int_z_extend(result, self.context.i8_type(), "or_ext").unwrap().into())
                }
                BinaryOp::BitAnd => Some(self.builder.build_and(lhs_i, rhs_i, "bitand").unwrap().into()),
                BinaryOp::BitOr => Some(self.builder.build_or(lhs_i, rhs_i, "bitor").unwrap().into()),
                BinaryOp::BitXor => Some(self.builder.build_xor(lhs_i, rhs_i, "bitxor").unwrap().into()),
                BinaryOp::Shl => Some(self.builder.build_left_shift(lhs_i, rhs_i, "shl").unwrap().into()),
                BinaryOp::Shr => Some(self.builder.build_right_shift(lhs_i, rhs_i, true, "shr").unwrap().into()),
            };
        }

        // String concat
        if lhs.is_struct_value() && rhs.is_struct_value() {
            if matches!(op, BinaryOp::Add) && left_type == Type::String {
                return self.call_runtime("forge_string_concat", &[lhs.into(), rhs.into()], "concat");
            }
        }

        // String equality
        if left_type == Type::String && right_type == Type::String {
            if matches!(op, BinaryOp::Eq | BinaryOp::NotEq) {
                let val = self.call_runtime("forge_string_eq", &[lhs.into(), rhs.into()], "string_eq")?;
                if matches!(op, BinaryOp::NotEq) {
                    let int_v = val.into_int_value();
                    let zero = int_v.get_type().const_zero();
                    let negated = self.builder.build_int_compare(
                        IntPredicate::EQ, int_v, zero, "string_neq"
                    ).unwrap();
                    return Some(self.builder.build_int_z_extend(negated, self.context.i8_type(), "neq_ext").unwrap().into());
                }
                return Some(val);
            }
        }

        // Operator overloading for user-defined types
        if let Some(type_name) = self.get_type_name(&left_type) {
            let (trait_name, method_name) = match op {
                BinaryOp::Add => ("Add", "add"),
                BinaryOp::Sub => ("Sub", "sub"),
                BinaryOp::Mul => ("Mul", "mul"),
                BinaryOp::Div => ("Div", "div"),
                BinaryOp::Eq => ("Eq", "eq"),
                BinaryOp::NotEq => ("Eq", "eq"),
                _ => ("", ""),
            };

            if !trait_name.is_empty() {
                if let Some(mangled) = self.find_operator_impl(&type_name, trait_name, method_name) {
                    if let Some(func) = self.functions.get(&mangled).copied() {
                        let result = self.builder.build_call(
                            func,
                            &[lhs.into(), rhs.into()],
                            "op_result",
                        ).unwrap();
                        let val = result.try_as_basic_value().left();

                        // For NotEq, negate the Eq result
                        if matches!(op, BinaryOp::NotEq) {
                            if let Some(v) = val {
                                if v.is_int_value() {
                                    let int_v = v.into_int_value();
                                    let zero = int_v.get_type().const_zero();
                                    let negated = self.builder.build_int_compare(
                                        IntPredicate::EQ, int_v, zero, "not_eq"
                                    ).unwrap();
                                    return Some(self.builder.build_int_z_extend(negated, self.context.i8_type(), "neq_ext").unwrap().into());
                                }
                            }
                        }
                        return val;
                    }
                }
            }
        }

        None
    }

    pub(crate) fn widen_ints(
        &self,
        a: IntValue<'ctx>,
        b: IntValue<'ctx>,
    ) -> (IntValue<'ctx>, IntValue<'ctx>) {
        let a_bits = a.get_type().get_bit_width();
        let b_bits = b.get_type().get_bit_width();
        if a_bits == b_bits {
            return (a, b);
        }
        if a_bits > b_bits {
            let b_ext = self
                .builder
                .build_int_s_extend(b, a.get_type(), "widen")
                .unwrap();
            (a, b_ext)
        } else {
            let a_ext = self
                .builder
                .build_int_s_extend(a, b.get_type(), "widen")
                .unwrap();
            (a_ext, b)
        }
    }
}
