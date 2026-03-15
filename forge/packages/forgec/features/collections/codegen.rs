use inkwell::values::{BasicValueEnum, IntValue, PointerValue};
use inkwell::types::{BasicType, BasicTypeEnum};
use inkwell::basic_block::BasicBlock;
use inkwell::IntPredicate;
use inkwell::AddressSpace;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::{feature_codegen, feature_check};
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::{ListLitData, MapLitData};

/// Result of setting up a list iteration loop.
/// Holds all the LLVM values needed for the method-specific body.
struct ListIterSetup<'ctx> {
    /// Pointer to the list's element data
    #[allow(dead_code)]
    data_ptr: PointerValue<'ctx>,
    /// Length of the list
    list_len: IntValue<'ctx>,
    /// Alloca for the loop index counter
    idx_alloca: PointerValue<'ctx>,
    /// The current index value (loaded at the start of each iteration)
    idx: IntValue<'ctx>,
    /// The current element value (loaded at the start of each iteration)
    elem_val: BasicValueEnum<'ctx>,
    /// The loop condition check block (branch back here to continue looping)
    loop_bb: BasicBlock<'ctx>,
    /// The loop body block (positioned here after setup)
    #[allow(dead_code)]
    body_bb: BasicBlock<'ctx>,
    /// The loop exit block (branch here to stop looping)
    end_bb: BasicBlock<'ctx>,
}

impl<'ctx> Codegen<'ctx> {
    /// Set up the common scaffolding for iterating over a list with an index.
    ///
    /// Creates idx_alloca, loop/body/end blocks, the index bounds check,
    /// and loads the current element. Positions the builder at the body block
    /// after the element load, ready for method-specific logic.
    ///
    /// After calling this, the caller should:
    /// 1. Do method-specific work with `setup.elem_val`
    /// 2. Increment the index: `self.increment_i64(setup.idx_alloca, 1)`
    /// 3. Branch back to loop: `self.builder.build_unconditional_branch(setup.loop_bb)`
    /// 4. Position at end: `self.builder.position_at_end(setup.end_bb)`
    fn setup_list_iter(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        prefix: &str,
    ) -> Option<ListIterSetup<'ctx>> {
        let (data_ptr, list_len) = self.extract_list_fields(list_val)?;
        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);

        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), &format!("{}_idx", prefix)).unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let (loop_bb, body_bb, end_bb) = self.setup_loop_blocks(prefix);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, list_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        let elem_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, data_ptr, &[idx], "ep").unwrap() };
        let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

        Some(ListIterSetup {
            data_ptr,
            list_len,
            idx_alloca,
            idx,
            elem_val,
            loop_bb,
            body_bb,
            end_bb,
        })
    }

    /// Set up the common scaffolding for searching through an array by index.
    ///
    /// Creates idx_alloca (zeroed), loop/body/end blocks, the SLT bounds check,
    /// and positions the builder at the body block. Returns
    /// `(loop_bb, body_bb, end_bb, idx_alloca, idx)`.
    ///
    /// The caller is responsible for:
    /// 1. Loading the element / doing match logic
    /// 2. On match:    branch to a caller-created `found_bb`, then to `end_bb`
    /// 3. On no match: call `self.increment_i64(idx_alloca, 1)` + branch to `loop_bb`
    /// 4. After the loop: `self.builder.position_at_end(end_bb)`
    fn setup_search_loop(
        &mut self,
        len: IntValue<'ctx>,
        prefix: &str,
    ) -> (BasicBlock<'ctx>, BasicBlock<'ctx>, BasicBlock<'ctx>, PointerValue<'ctx>, IntValue<'ctx>) {
        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), &format!("{}_idx", prefix)).unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let (loop_bb, body_bb, end_bb) = self.setup_loop_blocks(prefix);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);

        (loop_bb, body_bb, end_bb, idx_alloca, idx)
    }

    /// Complete a simple list iteration loop: increment index and branch back.
    /// Call this after the method-specific body logic.
    fn finish_list_iter(&self, setup: &ListIterSetup<'ctx>) {
        self.increment_i64(setup.idx_alloca, 1);
        self.builder.build_unconditional_branch(setup.loop_bb).unwrap();
        self.builder.position_at_end(setup.end_bb);
    }

    /// Compile a predicate-based early-exit loop (used by any, all, find).
    ///
    /// Iterates over the list, evaluates the closure on each element.
    /// When `match_on_true` is true, the `on_match` block is entered when
    /// the predicate returns true (like `any` and `find`).
    /// When `match_on_true` is false, the `on_match` block is entered when
    /// the predicate returns false (like `all`).
    ///
    /// Returns (setup, on_match_bb, next_bb) with builder positioned at on_match_bb.
    fn setup_predicate_iter(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        closure_arg: &CallArg,
        prefix: &str,
        match_label: &str,
        match_on_true: bool,
    ) -> Option<(ListIterSetup<'ctx>, BasicBlock<'ctx>, BasicBlock<'ctx>)> {
        let setup = self.setup_list_iter(list_val, elem_type, prefix)?;

        let function = self.current_function();
        let on_match_bb = self.context.append_basic_block(function, match_label);
        let next_bb = self.context.append_basic_block(function, &format!("{}_next", prefix));

        let pred_result = self.compile_closure_inline(closure_arg, setup.elem_val, elem_type)?;
        let pred_bool = self.to_i1(pred_result);

        if match_on_true {
            self.builder.build_conditional_branch(pred_bool, on_match_bb, next_bb).unwrap();
        } else {
            self.builder.build_conditional_branch(pred_bool, next_bb, on_match_bb).unwrap();
        }

        // Set up the next block: increment and loop back
        self.builder.position_at_end(next_bb);
        self.increment_i64(setup.idx_alloca, 1);
        self.builder.build_unconditional_branch(setup.loop_bb).unwrap();

        // Position at the match block for caller to add match-specific logic
        self.builder.position_at_end(on_match_bb);

        Some((setup, on_match_bb, next_bb))
    }

    pub(crate) fn compile_list_lit(
        &mut self,
        elements: &[Expr],
    ) -> Option<BasicValueEnum<'ctx>> {
        if elements.is_empty() {
            // Empty list: {null, 0}
            let list_type = self.context.struct_type(
                &[
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.i64_type().into(),
                ],
                false,
            );
            let mut list_val = list_type.get_undef();
            list_val = self.builder
                .build_insert_value(
                    list_val,
                    self.context.ptr_type(AddressSpace::default()).const_null(),
                    0,
                    "null_ptr",
                )
                .unwrap()
                .into_struct_value();
            list_val = self.builder
                .build_insert_value(
                    list_val,
                    self.context.i64_type().const_zero(),
                    1,
                    "zero_len",
                )
                .unwrap()
                .into_struct_value();
            return Some(list_val.into());
        }

        // Compile all elements
        let mut elem_vals = Vec::new();
        let mut elem_type = Type::Unknown;
        for expr in elements {
            let val = self.compile_expr(expr)?;
            if elem_type == Type::Unknown {
                elem_type = self.infer_type(expr);
            }
            elem_vals.push(val);
        }

        let elem_llvm_ty = self.type_to_llvm_basic(&elem_type);
        let count = elem_vals.len() as u64;

        // Allocate memory: forge_alloc(count * sizeof(elem))
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total_size = self.builder
            .build_int_mul(
                elem_size,
                self.context.i64_type().const_int(count, false),
                "total_size",
            )
            .unwrap();

        let data_ptr = self.call_runtime("forge_alloc", &[total_size.into()], "list_data")?
            .into_pointer_value();

        // Store each element
        for (i, val) in elem_vals.iter().enumerate() {
            let idx = self.context.i64_type().const_int(i as u64, false);
            let elem_ptr = unsafe {
                self.builder.build_gep(
                    elem_llvm_ty,
                    data_ptr,
                    &[idx],
                    &format!("elem_{}_ptr", i),
                ).unwrap()
            };
            self.builder.build_store(elem_ptr, *val).unwrap();
        }

        // Build list struct {ptr, len}
        let list_type = self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.i64_type().into(),
            ],
            false,
        );
        let mut list_val = list_type.get_undef();
        list_val = self.builder
            .build_insert_value(list_val, data_ptr, 0, "list_ptr")
            .unwrap()
            .into_struct_value();
        list_val = self.builder
            .build_insert_value(
                list_val,
                self.context.i64_type().const_int(count, false),
                1,
                "list_len",
            )
            .unwrap()
            .into_struct_value();

        Some(list_val.into())
    }

    pub(crate) fn compile_map_lit(&mut self, entries: &[(Expr, Expr)]) -> Option<BasicValueEnum<'ctx>> {
        if entries.is_empty() {
            let map_type = self.context.struct_type(
                &[
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.ptr_type(AddressSpace::default()).into(),
                    self.context.i64_type().into(),
                ],
                false,
            );
            return Some(map_type.const_zero().into());
        }

        let count = entries.len() as u64;

        // Infer key and value types
        let key_type = self.infer_type(&entries[0].0);
        let val_type = self.infer_type(&entries[0].1);
        let key_llvm_ty = self.type_to_llvm_basic(&key_type);
        let val_llvm_ty = self.type_to_llvm_basic(&val_type);

        // Allocate keys array
        let key_size = key_llvm_ty.size_of().unwrap();
        let keys_total = self.builder.build_int_mul(
            key_size,
            self.context.i64_type().const_int(count, false),
            "keys_total",
        ).unwrap();
        let keys_ptr = self.call_runtime("forge_alloc", &[keys_total.into()], "keys_ptr")?
            .into_pointer_value();

        // Allocate values array
        let val_size = val_llvm_ty.size_of().unwrap();
        let vals_total = self.builder.build_int_mul(
            val_size,
            self.context.i64_type().const_int(count, false),
            "vals_total",
        ).unwrap();
        let vals_ptr = self.call_runtime("forge_alloc", &[vals_total.into()], "vals_ptr")?
            .into_pointer_value();

        // Store entries
        for (i, (key_expr, val_expr)) in entries.iter().enumerate() {
            let key_val = self.compile_expr(key_expr)?;
            let val_val = self.compile_expr(val_expr)?;

            let idx = self.context.i64_type().const_int(i as u64, false);
            let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
            self.builder.build_store(kp, key_val).unwrap();

            let vp = unsafe { self.builder.build_gep(val_llvm_ty, vals_ptr, &[idx], "vp").unwrap() };
            self.builder.build_store(vp, val_val).unwrap();
        }

        // Build map struct {keys_ptr, vals_ptr, length}
        let map_struct_ty = self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.i64_type().into(),
            ],
            false,
        );
        let mut map_val = map_struct_ty.get_undef();
        map_val = self.builder.build_insert_value(map_val, keys_ptr, 0, "mp_keys").unwrap().into_struct_value();
        map_val = self.builder.build_insert_value(map_val, vals_ptr, 1, "mp_vals").unwrap().into_struct_value();
        map_val = self.builder.build_insert_value(map_val, self.context.i64_type().const_int(count, false), 2, "mp_len").unwrap().into_struct_value();

        Some(map_val.into())
    }

    /// Compile a list literal expression via the Feature dispatch system.
    pub(crate) fn compile_list_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, ListLitData, |data| self.compile_list_lit(&data.elements))
    }

    /// Compile a map literal expression via the Feature dispatch system.
    pub(crate) fn compile_map_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, MapLitData, |data| self.compile_map_lit(&data.entries))
    }

    /// Infer the type of a list literal expression.
    pub(crate) fn infer_list_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ListLitData, |data| {
            let elem_type = if let Some(first) = data.elements.first() {
                self.infer_type(first)
            } else {
                Type::Unknown
            };
            Type::List(Box::new(elem_type))
        })
    }

    /// Infer the type of a map literal expression.
    pub(crate) fn infer_map_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MapLitData, |data| {
            let (key_type, val_type) = if let Some((k, v)) = data.entries.first() {
                (self.infer_type(k), self.infer_type(v))
            } else {
                (Type::Unknown, Type::Unknown)
            };
            Type::Map(Box::new(key_type), Box::new(val_type))
        })
    }

    /// Compile list.push(item) - reallocates and appends
    pub(crate) fn compile_list_push(
        &mut self,
        list_expr: &Expr,
        list_val: &BasicValueEnum<'ctx>,
        list_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let elem_type = match list_type {
            Type::List(inner) => inner.as_ref().clone(),
            _ => return None,
        };
        let new_val = self.compile_expr(&args.first()?.value)?;
        let elem_llvm_ty = self.type_to_llvm_basic(&elem_type);

        // Extract current data ptr and len
        let (data_ptr, old_len) = self.extract_list_fields(list_val)?;

        // New length = old_len + 1
        let new_len = self.builder.build_int_add(
            old_len,
            self.context.i64_type().const_int(1, false),
            "new_len",
        ).unwrap();

        // Allocate new buffer
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let new_total = self.builder.build_int_mul(elem_size, new_len, "new_total").unwrap();
        let new_ptr = self.call_runtime("forge_alloc", &[new_total.into()], "new_data")?
            .into_pointer_value();

        // Copy old data: memcpy old_len * elem_size bytes
        let old_total = self.builder.build_int_mul(elem_size, old_len, "old_total").unwrap();
        self.builder.build_memcpy(
            new_ptr, 1, data_ptr, 1, old_total
        ).ok();

        // Store new element at index old_len
        let new_elem_ptr = unsafe {
            self.builder.build_gep(elem_llvm_ty, new_ptr, &[old_len], "new_elem_ptr").unwrap()
        };
        self.builder.build_store(new_elem_ptr, new_val).unwrap();

        // Build new list struct
        let new_list = self.build_list_struct(&elem_type, new_ptr, new_len);

        // Update the mutable variable
        if let Expr::Ident(name, _) = list_expr {
            if let Some((ptr, _)) = self.lookup_var(name) {
                self.builder.build_store(ptr, new_list).unwrap();
            }
        }

        None // push returns void
    }

    /// list.filter(closure) -> new list
    pub(crate) fn compile_list_filter(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;
        let (_, list_len) = self.extract_list_fields(list_val)?;

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);

        // Allocate result buffer (max size = list_len)
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(elem_size, list_len, "total").unwrap();
        let result_ptr = self.call_runtime("forge_alloc", &[total.into()], "filter_buf")?
            .into_pointer_value();

        // Result count alloca
        let count_alloca = self.builder.build_alloca(self.context.i64_type(), "filter_count").unwrap();
        self.builder.build_store(count_alloca, self.context.i64_type().const_zero()).unwrap();

        let (setup, _store_bb, _next_bb) = self.setup_predicate_iter(
            list_val, elem_type, closure_arg, "filter", "filter_store", true,
        )?;

        // Store element (we're positioned at store_bb)
        let count = self.builder.build_load(self.context.i64_type(), count_alloca, "c").unwrap().into_int_value();
        let dest_ptr = unsafe { self.builder.build_gep(elem_llvm_ty, result_ptr, &[count], "dp").unwrap() };
        self.builder.build_store(dest_ptr, setup.elem_val).unwrap();
        self.increment_i64(count_alloca, 1);
        // Note: setup_predicate_iter already set up the next_bb with increment+loop-back.
        // We need to rejoin the next_bb flow after storing. But the next_bb is already wired.
        // We need to branch from store_bb to the increment logic.
        // Actually, store_bb should branch to the next iteration, not to next_bb
        // (which already has its own increment). Let's branch directly to increment+loop.
        // The predicate iter's next_bb already increments and loops. We just need to go there
        // after the store. But next_bb already has a terminator. We need a merge point.

        // Actually, let me reconsider - the setup_predicate_iter wired next_bb with
        // increment + branch to loop. store_bb needs to also increment and branch to loop.
        // This is slightly different from any/all/find where on_match branches to end.
        // For filter, we need to go back to looping after the store.
        self.increment_i64(setup.idx_alloca, 1);
        self.builder.build_unconditional_branch(setup.loop_bb).unwrap();

        // End: build result list
        self.builder.position_at_end(setup.end_bb);
        let final_count = self.builder.build_load(self.context.i64_type(), count_alloca, "fc").unwrap();
        let result_list = self.build_list_struct(elem_type, result_ptr, final_count);
        Some(result_list.into())
    }

    /// list.map(closure) -> new list
    pub(crate) fn compile_list_map(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;

        // Infer the output element type from the closure body
        let out_type = self.infer_closure_return_type(closure_arg, elem_type);
        let out_llvm_ty = self.type_to_llvm_basic(&out_type);

        // We need list_len before setup_list_iter to allocate the buffer
        let (_, list_len) = self.extract_list_fields(list_val)?;

        // Allocate result buffer
        let out_size = out_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(out_size, list_len, "total").unwrap();
        let result_ptr = self.call_runtime("forge_alloc", &[total.into()], "map_buf")?
            .into_pointer_value();

        let setup = self.setup_list_iter(list_val, elem_type, "map")?;

        let mapped = self.compile_closure_inline(closure_arg, setup.elem_val, elem_type)?;
        let dest_ptr = unsafe { self.builder.build_gep(out_llvm_ty, result_ptr, &[setup.idx], "dp").unwrap() };
        self.builder.build_store(dest_ptr, mapped).unwrap();

        self.finish_list_iter(&setup);
        let result_list = self.build_list_struct(&out_type, result_ptr, setup.list_len);
        Some(result_list.into())
    }

    /// list.sum() -> int
    pub(crate) fn compile_list_sum(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let sum_alloca = self.builder.build_alloca(self.context.i64_type(), "sum").unwrap();
        self.builder.build_store(sum_alloca, self.context.i64_type().const_zero()).unwrap();

        let setup = self.setup_list_iter(list_val, elem_type, "sum")?;

        let acc = self.builder.build_load(self.context.i64_type(), sum_alloca, "acc").unwrap().into_int_value();
        let elem_i64 = if setup.elem_val.is_int_value() {
            let iv = setup.elem_val.into_int_value();
            if iv.get_type().get_bit_width() < 64 {
                self.builder.build_int_s_extend(iv, self.context.i64_type(), "ext").unwrap()
            } else {
                iv
            }
        } else {
            setup.elem_val.into_int_value()
        };
        let new_acc = self.builder.build_int_add(acc, elem_i64, "nacc").unwrap();
        self.builder.build_store(sum_alloca, new_acc).unwrap();

        self.finish_list_iter(&setup);
        let result = self.builder.build_load(self.context.i64_type(), sum_alloca, "sum_result").unwrap();
        Some(result)
    }

    /// list.find(predicate) -> nullable elem
    pub(crate) fn compile_list_find(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;

        let nullable_type = Type::Nullable(Box::new(elem_type.clone()));
        let nullable_llvm_ty = self.type_to_llvm_basic(&nullable_type);

        // Result alloca (initialized to null/zero)
        let result_alloca = self.builder.build_alloca(nullable_llvm_ty, "find_result").unwrap();
        self.builder.build_store(result_alloca, nullable_llvm_ty.into_struct_type().const_zero()).unwrap();

        let (setup, _found_bb, _next_bb) = self.setup_predicate_iter(
            list_val, elem_type, closure_arg, "find", "find_found", true,
        )?;

        // Found: store nullable with tag=1 and exit loop
        let wrapped = self.wrap_in_nullable(setup.elem_val, &nullable_type);
        self.builder.build_store(result_alloca, wrapped).unwrap();
        self.builder.build_unconditional_branch(setup.end_bb).unwrap();

        self.builder.position_at_end(setup.end_bb);
        let result = self.builder.build_load(nullable_llvm_ty, result_alloca, "find_val").unwrap();
        Some(result)
    }

    /// list.any(predicate) -> bool
    pub(crate) fn compile_list_any(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "any_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();

        let (setup, _found_bb, _next_bb) = self.setup_predicate_iter(
            list_val, elem_type, closure_arg, "any", "any_found", true,
        )?;

        // Found: set result to true and exit loop
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();
        self.builder.build_unconditional_branch(setup.end_bb).unwrap();

        self.builder.position_at_end(setup.end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "any_val").unwrap();
        Some(result)
    }

    /// list.all(predicate) -> bool
    pub(crate) fn compile_list_all(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "all_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();

        let (setup, _fail_bb, _next_bb) = self.setup_predicate_iter(
            list_val, elem_type, closure_arg, "all", "all_fail", false,
        )?;

        // Fail: set result to false and exit loop
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();
        self.builder.build_unconditional_branch(setup.end_bb).unwrap();

        self.builder.position_at_end(setup.end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "all_val").unwrap();
        Some(result)
    }

    /// list.enumerate() -> list of (int, T) tuples
    pub(crate) fn compile_list_enumerate(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let tuple_type = Type::Tuple(vec![Type::Int, elem_type.clone()]);
        let tuple_llvm_ty = self.type_to_llvm_basic(&tuple_type);

        // We need list_len before setup to allocate buffer
        let (_, list_len) = self.extract_list_fields(list_val)?;

        // Allocate result buffer
        let tuple_size = tuple_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(tuple_size, list_len, "total").unwrap();
        let result_ptr = self.call_runtime("forge_alloc", &[total.into()], "enum_buf")?
            .into_pointer_value();

        let setup = self.setup_list_iter(list_val, elem_type, "enum")?;

        // Build tuple (idx, elem)
        let tuple_struct_ty = tuple_llvm_ty.into_struct_type();
        let mut tuple_val = tuple_struct_ty.get_undef();
        tuple_val = self.builder.build_insert_value(tuple_val, setup.idx, 0, "t0").unwrap().into_struct_value();
        tuple_val = self.builder.build_insert_value(tuple_val, setup.elem_val, 1, "t1").unwrap().into_struct_value();

        let dest_ptr = unsafe { self.builder.build_gep(tuple_llvm_ty, result_ptr, &[setup.idx], "dp").unwrap() };
        self.builder.build_store(dest_ptr, tuple_val).unwrap();

        self.finish_list_iter(&setup);
        let result_list = self.build_list_struct(&tuple_type, result_ptr, setup.list_len);
        Some(result_list.into())
    }

    /// list.join(separator) -> string
    pub(crate) fn compile_list_join(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        _elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let sep_val = self.compile_expr(&args.first()?.value)?;
        let (data_ptr, list_len) = self.extract_list_fields(list_val)?;

        let string_llvm_ty = self.string_type();
        let string_basic_ty: BasicTypeEnum = string_llvm_ty.into();
        let function = self.current_function();

        // Result string alloca
        let result_alloca = self.builder.build_alloca(string_llvm_ty, "join_result").unwrap();
        let empty_str = self.build_string_literal("");
        self.builder.build_store(result_alloca, empty_str).unwrap();

        let (loop_bb, _body_bb, end_bb, idx_alloca, idx) =
            self.setup_search_loop(list_len, "join");

        let elem_ptr = unsafe {
            self.builder.build_gep(string_llvm_ty, data_ptr, &[idx], "ep").unwrap()
        };
        let elem_val = self.builder.build_load(string_basic_ty, elem_ptr, "elem").unwrap();

        // Add separator if not first element
        let is_first = self.builder.build_int_compare(IntPredicate::EQ, idx, self.context.i64_type().const_zero(), "first").unwrap();
        let current = self.builder.build_load(string_basic_ty, result_alloca, "cur").unwrap();

        let sep_block = self.context.append_basic_block(function, "join_sep");
        let nosep_block = self.context.append_basic_block(function, "join_nosep");
        let merge_block = self.context.append_basic_block(function, "join_merge");

        self.builder.build_conditional_branch(is_first, nosep_block, sep_block).unwrap();

        // With separator
        self.builder.position_at_end(sep_block);
        let with_sep = self.call_runtime("forge_string_concat", &[current.into(), sep_val.into()], "ws").unwrap();
        let with_elem = self.call_runtime("forge_string_concat", &[with_sep.into(), elem_val.into()], "we").unwrap();
        let sep_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        // Without separator (first element)
        self.builder.position_at_end(nosep_block);
        let just_elem = self.call_runtime("forge_string_concat", &[current.into(), elem_val.into()], "je").unwrap();
        let nosep_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        self.builder.position_at_end(merge_block);
        let phi = self.builder.build_phi(string_llvm_ty, "merged").unwrap();
        phi.add_incoming(&[(&with_elem, sep_end), (&just_elem, nosep_end)]);
        self.builder.build_store(result_alloca, phi.as_basic_value()).unwrap();

        self.increment_i64(idx_alloca, 1);
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(string_basic_ty, result_alloca, "join_val").unwrap();
        Some(result)
    }

    /// list.reduce(init, closure) -> value
    pub(crate) fn compile_list_reduce(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }
        let init_val = self.compile_expr(&args[0].value)?;
        let closure_arg = &args[1];
        let acc_type = self.infer_type(&args[0].value);

        let acc_alloca = self.builder.build_alloca(init_val.get_type(), "reduce_acc").unwrap();
        self.builder.build_store(acc_alloca, init_val).unwrap();

        let setup = self.setup_list_iter(list_val, elem_type, "reduce")?;

        let acc_val = self.builder.build_load(init_val.get_type(), acc_alloca, "acc").unwrap();
        let new_acc = self.compile_closure_inline_2(closure_arg, acc_val, &acc_type, setup.elem_val, elem_type)?;
        self.builder.build_store(acc_alloca, new_acc).unwrap();

        self.finish_list_iter(&setup);
        let result = self.builder.build_load(init_val.get_type(), acc_alloca, "reduce_val").unwrap();
        Some(result)
    }

    /// list.sorted() -> new sorted list (int only for now)
    pub(crate) fn compile_list_sorted(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let (data_ptr, list_len) = self.extract_list_fields(list_val)?;

        let elem_llvm_ty = self.type_to_llvm_basic(elem_type);
        let elem_size = elem_llvm_ty.size_of().unwrap();
        let total = self.builder.build_int_mul(elem_size, list_len, "total").unwrap();

        // Clone the list data
        let new_ptr = self.call_runtime("forge_alloc", &[total.into()], "sort_buf")?
            .into_pointer_value();
        self.builder.build_memcpy(new_ptr, 1, data_ptr, 1, total).ok();

        // Sort in place
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let sort_fn = self.module.get_function("forge_list_sort_int").unwrap_or_else(|| {
            let ft = self.context.void_type().fn_type(
                &[ptr_type.into(), self.context.i64_type().into()],
                false,
            );
            self.module.add_function("forge_list_sort_int", ft, None)
        });
        self.builder.build_call(sort_fn, &[new_ptr.into(), list_len.into()], "").unwrap();

        // Build new list struct
        let result_list = self.build_list_struct(elem_type, new_ptr, list_len);
        Some(result_list.into())
    }

    /// list.each(closure) -> void (side-effect iteration)
    pub(crate) fn compile_list_each(
        &mut self,
        list_val: &BasicValueEnum<'ctx>,
        elem_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let closure_arg = args.first()?;

        let setup = self.setup_list_iter(list_val, elem_type, "each")?;

        self.compile_closure_inline(closure_arg, setup.elem_val, elem_type);

        // Create a next block for the increment logic
        let function = self.current_function();
        let next_bb = self.context.append_basic_block(function, "each_next");

        // Branch to next block if no terminator (closure may have added one)
        let current_bb = self.builder.get_insert_block().unwrap();
        if current_bb.get_terminator().is_none() {
            self.builder.build_unconditional_branch(next_bb).unwrap();
        }

        // Increment and loop back from next_bb
        self.builder.position_at_end(next_bb);
        self.increment_i64(setup.idx_alloca, 1);
        self.builder.build_unconditional_branch(setup.loop_bb).unwrap();

        self.builder.position_at_end(setup.end_bb);
        None // each returns void
    }

    /// map.has(key) -> bool
    pub(crate) fn compile_map_has(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        _val_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let search_key = self.compile_expr(&args.first()?.value)?;
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        let key_llvm_ty = self.type_to_llvm_basic(key_type);
        let function = self.current_function();

        let result_alloca = self.builder.build_alloca(self.context.i8_type(), "has_result").unwrap();
        self.builder.build_store(result_alloca, self.context.i8_type().const_zero()).unwrap();

        let (loop_bb, _body_bb, end_bb, idx_alloca, idx) =
            self.setup_search_loop(map_len, "has");

        let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
        let key_val = self.builder.build_load(key_llvm_ty, kp, "key").unwrap();

        let found_bb = self.context.append_basic_block(function, "has_found");
        let next_bb = self.context.append_basic_block(function, "has_next");

        let eq = self.compile_key_eq(key_val, search_key, key_type);
        self.builder.build_conditional_branch(eq, found_bb, next_bb).unwrap();

        self.builder.position_at_end(found_bb);
        self.builder.build_store(result_alloca, self.context.i8_type().const_int(1, false)).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        self.increment_i64(idx_alloca, 1);
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(self.context.i8_type(), result_alloca, "has_val").unwrap();
        Some(result)
    }

    /// map.get(key) -> nullable value
    pub(crate) fn compile_map_get(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        val_type: &Type,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let search_key = self.compile_expr(&args.first()?.value)?;
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let vals_ptr = self.builder.build_extract_value(struct_val, 1, "vals").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        let key_llvm_ty = self.type_to_llvm_basic(key_type);
        let val_llvm_ty = self.type_to_llvm_basic(val_type);
        let nullable_type = Type::Nullable(Box::new(val_type.clone()));
        let nullable_llvm_ty = self.type_to_llvm_basic(&nullable_type);
        let function = self.current_function();

        let result_alloca = self.builder.build_alloca(nullable_llvm_ty, "get_result").unwrap();
        self.builder.build_store(result_alloca, nullable_llvm_ty.into_struct_type().const_zero()).unwrap();

        let (loop_bb, _body_bb, end_bb, idx_alloca, idx) =
            self.setup_search_loop(map_len, "get");

        let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
        let key_val = self.builder.build_load(key_llvm_ty, kp, "key").unwrap();

        let found_bb = self.context.append_basic_block(function, "get_found");
        let next_bb = self.context.append_basic_block(function, "get_next");

        let eq = self.compile_key_eq(key_val, search_key, key_type);
        self.builder.build_conditional_branch(eq, found_bb, next_bb).unwrap();

        self.builder.position_at_end(found_bb);
        let vp = unsafe { self.builder.build_gep(val_llvm_ty, vals_ptr, &[idx], "vp").unwrap() };
        let found_val = self.builder.build_load(val_llvm_ty, vp, "val").unwrap();
        let wrapped = self.wrap_in_nullable(found_val, &nullable_type);
        self.builder.build_store(result_alloca, wrapped).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        self.builder.position_at_end(next_bb);
        self.increment_i64(idx_alloca, 1);
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        self.builder.position_at_end(end_bb);
        let result = self.builder.build_load(nullable_llvm_ty, result_alloca, "get_val").unwrap();
        Some(result)
    }

    /// map.keys() -> list of keys
    pub(crate) fn compile_map_keys(
        &mut self,
        map_val: &BasicValueEnum<'ctx>,
        key_type: &Type,
        _val_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let struct_val = map_val.into_struct_value();
        let keys_ptr = self.builder.build_extract_value(struct_val, 0, "keys").ok()?.into_pointer_value();
        let map_len = self.builder.build_extract_value(struct_val, 2, "len").ok()?.into_int_value();

        // Return a list {keys_ptr, length}
        let result = self.build_list_struct(key_type, keys_ptr, map_len);
        Some(result.into())
    }

    /// map[key] = value — insert or update a key-value pair in a mutable map variable.
    ///
    /// Strategy: search for existing key; if found, overwrite value in-place.
    /// If not found, reallocate both arrays with +1 capacity, copy old data,
    /// append new key+value, and store the updated map struct back into the variable.
    pub(crate) fn compile_map_index_assign(
        &mut self,
        object: &Expr,
        index: &Expr,
        value: &Expr,
    ) {
        let obj_type = self.infer_type(object);
        let (key_type, val_type) = match &obj_type {
            Type::Map(k, v) => (k.as_ref().clone(), v.as_ref().clone()),
            _ => return,
        };

        let var_name = match object {
            Expr::Ident(name, _) => name.clone(),
            _ => return,
        };

        let (var_ptr, _) = match self.lookup_var(&var_name) {
            Some(v) => v,
            None => return,
        };

        let new_key = match self.compile_expr(index) { Some(v) => v, None => return };
        let new_val = match self.compile_expr(value) { Some(v) => v, None => return };

        let key_llvm_ty = self.type_to_llvm_basic(&key_type);
        let val_llvm_ty = self.type_to_llvm_basic(&val_type);
        let map_llvm_ty = self.type_to_llvm_basic(&obj_type);

        // Load current map struct from variable
        let map_val = self.builder.build_load(map_llvm_ty, var_ptr, "map_cur").unwrap().into_struct_value();
        let keys_ptr = self.builder.build_extract_value(map_val, 0, "keys").unwrap().into_pointer_value();
        let vals_ptr = self.builder.build_extract_value(map_val, 1, "vals").unwrap().into_pointer_value();
        let map_len = self.builder.build_extract_value(map_val, 2, "len").unwrap().into_int_value();

        let function = self.current_function();

        // Search for existing key
        let idx_alloca = self.builder.build_alloca(self.context.i64_type(), "ms_idx").unwrap();
        self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

        let loop_bb = self.context.append_basic_block(function, "ms_loop");
        let body_bb = self.context.append_basic_block(function, "ms_body");
        let found_bb = self.context.append_basic_block(function, "ms_found");
        let not_found_bb = self.context.append_basic_block(function, "ms_notfound");
        let end_bb = self.context.append_basic_block(function, "ms_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "i").unwrap().into_int_value();
        let cond = self.builder.build_int_compare(IntPredicate::SLT, idx, map_len, "cond").unwrap();
        self.builder.build_conditional_branch(cond, body_bb, not_found_bb).unwrap();

        // Body: compare keys
        self.builder.position_at_end(body_bb);
        let kp = unsafe { self.builder.build_gep(key_llvm_ty, keys_ptr, &[idx], "kp").unwrap() };
        let key_val = self.builder.build_load(key_llvm_ty, kp, "key").unwrap();
        let eq = self.compile_key_eq(key_val, new_key, &key_type);
        let next_bb = self.context.append_basic_block(function, "ms_next");
        self.builder.build_conditional_branch(eq, found_bb, next_bb).unwrap();

        // Next: increment and loop
        self.builder.position_at_end(next_bb);
        self.increment_i64(idx_alloca, 1);
        self.builder.build_unconditional_branch(loop_bb).unwrap();

        // Found: overwrite value in-place
        self.builder.position_at_end(found_bb);
        let found_idx = self.builder.build_load(self.context.i64_type(), idx_alloca, "fi").unwrap().into_int_value();
        let vp = unsafe { self.builder.build_gep(val_llvm_ty, vals_ptr, &[found_idx], "vp").unwrap() };
        self.builder.build_store(vp, new_val).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        // Not found: grow arrays and append
        self.builder.position_at_end(not_found_bb);
        let new_len = self.builder.build_int_add(
            map_len,
            self.context.i64_type().const_int(1, false),
            "new_len",
        ).unwrap();

        // Allocate new keys array
        let key_size = key_llvm_ty.size_of().unwrap();
        let new_keys_total = self.builder.build_int_mul(key_size, new_len, "nkt").unwrap();
        let new_keys_ptr = self.call_runtime("forge_alloc", &[new_keys_total.into()], "new_keys")
            .unwrap().into_pointer_value();

        // Allocate new vals array
        let val_size = val_llvm_ty.size_of().unwrap();
        let new_vals_total = self.builder.build_int_mul(val_size, new_len, "nvt").unwrap();
        let new_vals_ptr = self.call_runtime("forge_alloc", &[new_vals_total.into()], "new_vals")
            .unwrap().into_pointer_value();

        // Only copy old data when the map is non-empty (avoids memcpy from null ptr)
        let has_old = self.builder.build_int_compare(
            IntPredicate::SGT, map_len, self.context.i64_type().const_zero(), "has_old",
        ).unwrap();
        let copy_bb = self.context.append_basic_block(function, "ms_copy");
        let append_bb = self.context.append_basic_block(function, "ms_append");
        self.builder.build_conditional_branch(has_old, copy_bb, append_bb).unwrap();

        self.builder.position_at_end(copy_bb);
        let old_keys_total = self.builder.build_int_mul(key_size, map_len, "okt").unwrap();
        self.builder.build_memcpy(new_keys_ptr, 1, keys_ptr, 1, old_keys_total).ok();
        let old_vals_total = self.builder.build_int_mul(val_size, map_len, "ovt").unwrap();
        self.builder.build_memcpy(new_vals_ptr, 1, vals_ptr, 1, old_vals_total).ok();
        self.builder.build_unconditional_branch(append_bb).unwrap();

        self.builder.position_at_end(append_bb);

        // Append new key and value at index map_len
        let new_key_ptr = unsafe { self.builder.build_gep(key_llvm_ty, new_keys_ptr, &[map_len], "nkp").unwrap() };
        self.builder.build_store(new_key_ptr, new_key).unwrap();
        let new_val_ptr = unsafe { self.builder.build_gep(val_llvm_ty, new_vals_ptr, &[map_len], "nvp").unwrap() };
        self.builder.build_store(new_val_ptr, new_val).unwrap();

        // Build updated map struct and store back
        let map_struct_ty = map_llvm_ty.into_struct_type();
        let mut updated = map_struct_ty.get_undef();
        updated = self.builder.build_insert_value(updated, new_keys_ptr, 0, "uk").unwrap().into_struct_value();
        updated = self.builder.build_insert_value(updated, new_vals_ptr, 1, "uv").unwrap().into_struct_value();
        updated = self.builder.build_insert_value(updated, new_len, 2, "ul").unwrap().into_struct_value();
        self.builder.build_store(var_ptr, updated).unwrap();
        self.builder.build_unconditional_branch(end_bb).unwrap();

        // Continue after the set operation
        self.builder.position_at_end(end_bb);
    }

    /// Compare two keys for equality
    pub(crate) fn compile_key_eq(
        &mut self,
        a: BasicValueEnum<'ctx>,
        b: BasicValueEnum<'ctx>,
        key_type: &Type,
    ) -> IntValue<'ctx> {
        match key_type {
            Type::String => {
                let val = self.call_runtime("forge_string_eq", &[a.into(), b.into()], "str_eq").unwrap().into_int_value();
                self.builder.build_int_compare(IntPredicate::NE, val, self.context.i8_type().const_zero(), "eq_bool").unwrap()
            }
            Type::Int => {
                self.builder.build_int_compare(IntPredicate::EQ, a.into_int_value(), b.into_int_value(), "int_eq").unwrap()
            }
            _ => {
                self.context.bool_type().const_int(0, false)
            }
        }
    }
}
