# Self-Hosted Compiler: Known Hacks & Workarounds

These are deviations from ideal Forge code in the self-hosted compiler (`packages/forgec/`), caused by bootstrap compiler limitations. Each should be reverted once the corresponding bootstrap bug is fixed.

## 1. Fully-Qualified Enum Variants in Struct Literals

**Hack:** `Token { kind: TokenKind.Eof, span }` instead of `Token { kind: .Eof, span }`

**Reason:** Bootstrap contextual resolution fails to find the correct enum when constructing struct field values in merged modules. The `.Eof` variant might resolve to a different enum's variant due to name collisions or scope issues.

**Files affected:** `lexer/mod.fg` (107 occurrences), `parser/mod.fg`, `parser/expressions.fg`

**Bootstrap fix needed:** Improve contextual enum resolution to prefer the field's declared type when resolving `.Variant` inside struct literal field values.

---

## 2. Simplified Error Messages

**Hack:** `self.error("expected identifier")` instead of `self.error("expected identifier, got ${self.peek().kind}")`

**Reason:** Bootstrap codegen fails to compile complex template string expressions (method calls, member access) as function arguments in merged modules. The template string compilation returns None, causing the function to be called with wrong argument count.

**Files affected:** `parser/mod.fg` (5 messages), `checker/mod.fg` (2 messages)

**Bootstrap fix needed:** Fix template string codegen for complex expressions in function call arguments.

---

## 3. Inlined Error Codes

**Hack:** `self.add_error("F0001", ...)` instead of `self.add_error(E_SYNTAX, ...)`

**Reason:** Cross-module `let` constants (e.g., `export let E_SYNTAX = "F0001"` in `core/error.fg`) are not resolved by the codegen when used in merged module function calls.

**Files affected:** `lexer/mod.fg` (2 inlined codes)

**Bootstrap fix needed:** Fix codegen variable resolution for `let` constants from merged modules.

---

## 4. `peek_ch()` Non-Nullable Workaround

**Hack:** Added `fn peek_ch(self) -> string` that returns `""` instead of `null` at EOF, used instead of `fn peek(self) -> string?` in `while` conditions.

**Reason:** `while !self.is_at_end() && fn(self.peek()!)` crashes the bootstrap codegen. The force-unwrap `!` inside an `&&` expression in a `while` condition fails because `compile_expr` returns None for the right-hand side in the while_cond basic block.

**Files affected:** `lexer/mod.fg` (23 usages of `peek_ch`)

**Bootstrap fix needed:** Fix `&&` evaluation with force-unwrap in while-loop conditions (likely a basic block positioning issue after function calls with internal branches).

---

## 5. Type Definition Ordering

**Hack:** `Block → Expr → Statement → Program` in `core/ast.fg`, not the logical grouping order.

**Reason:** Bootstrap type checker processes type declarations in file order during `register_top_level`. Forward references to types not yet registered resolve as `Type::Error` or `Type::Unknown`.

**Mitigation already applied:** Second-pass type alias re-resolution in `check_program`. But enum variants still need their referenced types available at registration time.

**Files affected:** `core/ast.fg`

**Bootstrap fix needed:** Multi-pass type registration or lazy type resolution.

---

## 6. Void Match Arm Discard

**Hack:** `let _ = self.infer_expr(expr)` instead of `self.infer_expr(expr)`

**Reason:** In a `void` function's match, an arm that calls a non-void function adds a PHI entry while other void arms don't. The PHI entry count mismatches the predecessor count.

**Files affected:** `checker/mod.fg` (1 occurrence in `check_statement`)

**Bootstrap fix needed:** Match codegen should detect void context and not build PHI nodes for void functions.

---

## 7. Fully-Qualified Severity Variants

**Hack:** `Severity.Error` instead of `.Error` in Diagnostic constructors.

**Reason:** Contextual `.Error` resolves to `Type.Error` (from the `Type` enum) instead of `Severity.Error` because both enums have a variant named `Error`.

**Files affected:** `core/error.fg` (4 occurrences)

**Bootstrap fix needed:** Contextual resolution should prefer the type implied by the struct field's declared type, not the first matching enum in scope.

---

## Summary

| # | Severity | Occurrences | Ideal Code Impact |
|---|----------|------------|-------------------|
| 1 | Medium | ~120 | Verbose but correct |
| 2 | Low | 7 | Less helpful errors |
| 3 | Low | 2 | Slightly less maintainable |
| 4 | Medium | 23 | Extra function, different null semantics |
| 5 | Low | 1 file | Just ordering, no semantic change |
| 6 | Low | 1 | Minor readability |
| 7 | Low | 4 | Verbose but correct |

None of these hacks change the compiler's correctness — they're all workarounds for bootstrap codegen limitations that produce identical results.
