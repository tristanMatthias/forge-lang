 1. Bool and float still use i64

  What: llvm_type_for maps Bool → i64 and Float → i64 instead of i1 and double.
  Why deferred: float uses different ABI registers (d0-d7 vs x0-x7 on aarch64). Changing during bootstrap would cause calling convention mismatch between the seed-compiled bs2 and the new function signatures. Requires a dedicated seed cycle.
  Proper fix: Map Bool → i1, Float → double. Handle float↔i64 bitcast at function boundaries. This is a separate, clean change.

  2. Result slots still use alloca i64

  What: If/match/when/block expressions use alloca_i64 for result slots, then store_br_if_open casts ptr values to i64 before storing.
  Why: The result type isn't known until after the first branch is emitted. Creating a typed alloca requires restructuring the if/match codegen to emit the first branch, determine the type, THEN create the alloca.
  Proper fix: Emit phi nodes instead of alloca+store for SSA values. Or restructure to create the alloca after determining the branch type.

  3. forge_llvm_build_call_coerce auto-widens i32→i64

  What: When a C function returns i32 (like atoi, strcmp), the coercing call wrapper sign-extends to i64 automatically.
  Why: The value pipeline assumes integer values are i64. Mixing i32 and i64 causes LLVM type mismatches in comparisons and arithmetic.
  Proper fix: Track the actual integer width in EmitResult (or in ValueType — add .I32). Emit width-appropriate comparisons and arithmetic. This requires pervasive changes to the operator codegen.

  4. forge_llvm_build_call_coerce returns i64 0 for void calls

  What: Void function calls return i64 0 instead of void, so the value can flow through the pipeline without crashing.
  Why: The codegen treats every expression as producing a value. Void calls produce LLVM void values that can't be stored/returned/compared.
  Proper fix: Track voidness in EmitResult (add .Void type or a has_value: bool field). Block expressions that end in void calls should use their default value, not the void result. This requires changes to emit_stmt_as_value and block expression codegen.

  5. store_br_if_open unconditionally casts to i64

  What: Every store through store_br_if_open does to_i64(val), which is a no-op for i64 but emits a ptrtoint for ptr values.
  Why: Result slots are i64 allocas (see #2). Storing ptr values requires casting.
  Proper fix: Make result slots typed (see #2), then store_br_if_open doesn't need to cast.

  6. Operator type normalization casts both operands

  What: In emit_binary, when one operand is ptr and the other i64, the i64 is cast to ptr via inttoptr. This produces icmp eq ptr %x, inttoptr (i64 0 to ptr) instead of the cleaner icmp eq ptr %x, null.
  Why: Quick fix to make mixed-type comparisons work.
  Proper fix: Detect null literals specifically and emit null constant. For non-null cases, cast to the more specific type (ptr → i64 for arithmetic, keep ptr for comparisons).

  7. Struct/enum field loads still use i64

  What: Ctx.field() loads struct fields as i64 regardless of the field's actual type.
  Why: Struct field type tracking would require looking up the field's ValueType from the StructReg, then using llvm_type_for. The infrastructure exists but isn't wired.
  Proper fix: Change Ctx.field() to accept a ValueType for the field and load with the correct type.

  8. Global variables still use i64 allocas

  What: declare_globals uses forge_llvm_add_global(m, i64t, name) for all globals.
  Why: Overlooked — not part of the function-focused change.
  Proper fix: Use llvm_type_for for global variable types, same as function parameters.

  9. forge_llvm_is_void_value declared but not needed

  What: Added forge_llvm_is_void_value to C wrapper and extern declarations but it's no longer used (void is handled at call level now).
  Why: Was added during debugging, then the fix moved to the C level.
  Proper fix: Remove the unused function.

  10. forge_llvm_cast_to_type declared but only used inside coerce

  What: Exposed as an extern but only called from forge_llvm_build_call_coerce inside llvm_wrapper.c itself.
  Why: Originally planned for Forge-side use, ended up C-internal.
  Proper fix: Make it static in the C file and remove the extern declaration.

  11. Closure codegen doesn't infer its own return type properly

  What: Lambda return type comes from fn_ret_lookup using the mangled lambda name. If the lambda isn't registered (anonymous), this falls back to .Int.
  Why: Existing issue, not introduced by this change.
  Proper fix: Infer lambda return type from the body expression's type rather than looking up a registered name.

  12. Types are still strings in the AST

  What: The entire type system still uses ty: string in ParamList, FieldList, etc. The translate_param_type function parses strings like "List(int)" with starts_with.
  Why: This is a separate, larger architectural change (TODO item #2).
  Proper fix: Introduce a Type AST node, as described in TODO.md.
