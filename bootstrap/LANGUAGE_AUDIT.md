Bootstrap Compiler Audit

  What's Already Good

  The codebase already uses many features well: with expressions in resolve/, match guards throughout, ? operator on results, string templates in error messages, is keyword in several places, and feature-modular
  structure. Recent refactoring (the dogfood commits) already eliminated ~84 manual error checks.

  ---
  Top Immediate Wins (existing features, not yet used)

  1. setup.fg — 40× repeated LLVM boilerplate (biggest DRY issue in the codebase)

  Every function declaration is 5 lines of identical structure:
  // codegen/setup.fg:24-28, :37-41, :43-47, :57-63, :65-70, ... (×40)
  let puts_param_arr = forge_llvm_type_array_new(1)
  forge_llvm_type_array_set(puts_param_arr, 0, pt)
  let puts_type = forge_llvm_function_type(forge_llvm_int32_type(lc), puts_param_arr, 1, 0)
  forge_llvm_type_array_free(puts_param_arr)
  forge_llvm_add_function(m, "puts", puts_type)

  With a helper + list literals, this becomes one line per function:
  declare_extern(m, lc, "puts", i32t, [pt])
  declare_extern(m, lc, "strlen", i64t, [pt])
  declare_extern(m, lc, "malloc", pt, [i64t])
  declare_extern(m, lc, "memcpy", pt, [pt, pt, i64t])
  // etc.
  This alone shrinks setup.fg from ~786 lines to ~100.

  2. p_keyword_kind — 30+ if-chain should be a match expression

  // parse/mod.fg:161-196 — 35 consecutive if-return statements
  if text == "and" { return Tk.KwAnd }
  if text == "const" { return Tk.KwConst }
  // ...
  →
  match text {
      "and" -> Tk.KwAnd
      "const" -> Tk.KwConst
      "else" -> Tk.KwElse
      // ...
      _ -> Tk.Identifier
  }

  3. ctx_with_* helpers are redundant with with expressions

  codegen/types.fg has ctx_with_fn, ctx_with_loops, ctx_with_top_level, etc. These just wrap with {}. Every call site can inline them directly:
  // Before:
  let body_cg = ctx_with_fn(ctx, fn_val, name)
  // After:
  let body_cg = ctx with { current_fn: fn_val, current_fn_name: name }
  Eliminates a layer of indirection and makes the code self-documenting.

  4. Every registry is the same shape — generics would unify all of them

  FnRetTypes, FnParamTypes, StructReg, EnumReg, TraitDeclReg, TopLevelVars, LoopStack, DeferStack, ParamTypeList — all are linked-list enums with matching *_lookup functions that are structurally identical. With
  generics this is one Map<K, V> type.

  5. eval/mod.fg — 816 lines, 18 manual had_error checks

  The eval is the most error-propagation-heavy file. With ? it would shrink dramatically. Also has many match arms that assign to a mut result variable before returning — all of these should be
  match-as-expression.

  ---
  Patterns That Need New Features

  These are pain points where the language itself needs to grow:

  ---
  New Language Feature Proposals

  1. Generics (highest value)

  The single biggest quality issue. The codebase has 10+ nearly-identical linked-list types:
  ExprList, StmtList, ParamList, FieldList, VariantList, MatchArmList,
  AnnotationList, FnRetTypes, FnParamTypes, ParamTypeList, StructReg,
  EnumReg, TraitDeclReg, TopLevelVars, LoopStack, DeferStack, ...
  Every one is enum Foo { End, Node(..., next: Foo) } with its own foo_lookup, foo_length, etc. With generics:
  enum List<T> {
      End
      Node(value: T, next: List<T>)
  }
  // Or better: use the built-in [] dynamic array for everything
  Impact: would eliminate hundreds of lines of boilerplate and unify all list/registry operations.

  2. Result<T> built-in type

  The codebase has three manual Result shapes (EmitResult, StmtResult, ParseResult/ProgramParseResult) plus ad-hoc { found: bool, ... } types in lookups. A proper:
  enum Result<T> {
      Ok(value: T)
      Err(message: string)
  }
  ...with ? already working on it would eliminate all had_error: bool, error_message: string field pairs. ok_emit(v) becomes Ok(v), err_emit(msg) becomes Err(msg).

  3. when expression

  Multi-condition branching without a match subject:
  let label = when {
      n < 0  -> "negative"
      n == 0 -> "zero"
      n < 10 -> "small"
      else   -> "large"
  }
  This fills the gap between if/else if chains (ugly) and match (needs a subject). The codebase has many if/else if/else if chains that don't match on a value — they check conditions. when would clean all of them
  up.

  4. OR patterns in match

  match token {
      .KwAnd | .KwOr | .KwNot -> "logic operator"
      .Plus | .Minus          -> "arithmetic"
      _                       -> "other"
  }
  The codebase has many match arms that do the same thing for several variants. Without OR patterns, you either duplicate the body or use is checks — neither is clean.

  5. Variadic functions

  fn declare_extern(m: ptr, lc: ptr, name: string, ret: ptr, params: ptr...) { ... }
  The LLVM declaration boilerplate is the sharpest example, but variadic is generally useful for builder-style APIs. Even if implemented as syntax sugar for params: [ptr], it cleans up call sites.

  6. String patterns in match

  match keyword {
      "and"    -> Tk.KwAnd
      "if"     -> Tk.KwIf
      "while"  -> Tk.KwWhile
      _        -> Tk.Identifier
  }
  p_keyword_kind in parse/mod.fg is the canonical example — 35 if text == branches that should be a single match. String match is conceptually simple (just equality), clean to implement, and broadly useful.

  7. Spread operator for lists

  let all_params = [...existing_params, new_param]
  let combined = [...list_a, ...list_b]
  Currently building a list from two existing lists requires a recursive helper. The spread operator makes functional list construction natural.

  8. Named / default arguments

  fn parse_expr(source: string, allow_structs: bool = true, allow_dots: bool = true) -> Expr? { ... }

  // Call site:
  parse_expr(source, allow_structs: false)
  The Parser struct has allow_struct_lit, allow_dot_postfix, allow_it_sugar — all flags that get set/reset around specific parses. Named defaults would make these intent-revealing at call sites instead of
  requiring a with {} dance.

  9. Pattern binding (@)

  match expr {
      e @ .BinOp(_, _, _) -> {
          emit_binary(ctx, e)  // e is still Expr, not deconstructed
      }
  }
  Sometimes you need both the whole value and its destructured parts. Currently you can't get both in one arm — you either destructure or keep the whole thing.

  10. in operator for membership

  if op in [.Plus, .Minus, .Star, .Slash] { ... }
  if keyword in ["export", "fn", "type", "enum"] { ... }
  Eliminates long == chains in conditions. The parser has many places checking self.current_kind == X || self.current_kind == Y || ....

  11. Compile-time constants (const)

  const ENUM_TAG_SIZE = 8
  const PAYLOAD_SIZE = 8
  const ENUM_TOTAL_SIZE = ENUM_TAG_SIZE + PAYLOAD_SIZE  // = 16

  // Used everywhere in codegen:
  let buf = cg_malloc(ctx, const_i64(ctx, ENUM_TOTAL_SIZE))
  Magic numbers like 16 (enum layout), 8 (field stride), 112 (statement size) appear throughout. Named constants make the intent clear and changes safe.

  12. List comprehensions

  let param_types = [translate_type(ty) for (_, ty, _) in params]
  let names = [name for .Node(name, _, _) in struct_fields]
  Many recursive helpers that build a list by mapping over another list would become one-liners.

  13. Trait objects / dynamic dispatch

  trait Emittable { fn emit(self, ctx: Ctx) -> EmitResult }

  impl Emittable for Expr.BinOp { ... }
  impl Emittable for Expr.Call  { ... }
  The registry dispatch system (lookup_decl_parser, lookup_stmt_parser) is hand-rolling dynamic dispatch. With trait objects this becomes the natural mechanism.

  14. Range patterns

  match char_code {
      'a'..'z' -> "lowercase"
      'A'..'Z' -> "uppercase"
      '0'..'9' -> "digit"
      _        -> "other"
  }
  The lexer has manual range checks everywhere: ch >= "a" && ch <= "z". Range patterns in match would make these significantly cleaner.

---
Feature Roadmap

## Definition of Done

Every feature on this list must complete ALL of the following before being marked done:

1. **Implement** — parser, codegen, resolver, type checker, eval stub (follow CLAUDE.md Phase 3 checklist)
2. **Test** — create `src/features/<name>/` with examples and `/// expect:` comments; add edge cases and combinatorial tests; all `make test` tests pass
3. **Dogfood** — grep the entire bootstrap source for patterns the feature replaces; refactor every applicable site to use the new feature; no old pattern left standing
4. **Commit** — one commit per feature: `feat: <name> — <what it does>`; the pre-commit hook (regression + selfhost check) must pass clean

No partial credit. A feature is not done until the codebase actually uses it.

---

| # | Feature                     | Status          | Complexity | Impact       | Notes |
|---|-----------------------------|-----------------|------------|--------------|-------|
| 1 | Generics                    | [ ] Not started | High       | 🔥 Critical  | Unifies all 15+ linked-list types; unlocks Result<T>, List<T>, Map<K,V> |
| 2 | Result<T> built-in          | [ ] Not started | Medium     | 🔥 Critical  | Depends on generics; eliminates had_error boilerplate everywhere |
| 3 | `when` expression           | [x] Done        | Low        | High         | `match { cond -> body }` subjectless form; dogfooded in lexer, typeck, resolve |
| 4 | OR patterns in match        | [x] Done        | Low        | High         | `.A or .B -> body`; dogfooded in codegen, eval, resolve, typeck |
| 5 | Variadic functions          | [ ] Not started | Medium     | High         | Sugar for `params: [T]`; `setup.fg` is canonical use case |
| 6 | String patterns in match    | [x] Done        | Low        | High         | `match s { "hello" -> ... }`; p_keyword_kind → 35-arm string match |
| 7 | Spread operator             | [ ] Not started | Medium     | Medium       | `[...a, ...b]`; recursive list-concat helpers become one-liners |
| 8 | Named / default arguments   | [ ] Not started | Medium     | Medium       | `fn f(x: int = 0)`; kills Parser flag-dance with `with {}` |
| 9 | Pattern binding (`@`)       | [ ] Not started | Low        | Medium       | `e @ .BinOp(...)` — keep whole value AND destructure in one arm |
|10 | `in` operator               | [x] Done        | Low        | Medium       | `x in [a, b, c]`; dogfooded in resolver, lexer, codegen, eval, parser |
|11 | Compile-time `const`        | [ ] Not started | Medium     | Medium       | Named constants for magic numbers (16, 8, 112...); safer refactors |
|12 | List comprehensions         | [ ] Not started | Medium     | Medium       | `[f(x) for x in list]`; recursive map/filter helpers → one-liners |
|13 | Trait objects (dyn dispatch)| [ ] Not started | High       | Medium       | Replace hand-rolled registry dispatch with virtual trait calls |
|14 | Range patterns              | [x] Done        | Low        | Medium       | `x in "a".."z"` range membership; dogfooded in lexer, parser, resolver, codegen |
