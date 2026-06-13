# WIP: vndt.2 `bs2 fix --rule=no-wildcard` — auto-expand wildcard match arms

Status: **blocked** on a codegen bug (see below). The pass logic below is
written and self-contained; it cannot land until the blocker is fixed.

## Design (sound, no typeck entanglement)

`bs2 fix --rule=no-wildcard` expands `match x { .A -> body, _ -> dflt }` over a
declared enum into one explicit arm per uncovered variant, each running the
wildcard's body. The subject enum is pinned from the match's **explicit variant
arms** (no subject typing needed) via a variant→enum index built by scanning
`EnumDecl`s. Matches with no variant arms (e.g. an `int` match) are left alone.
A hand-rolled mutual `Stmt`↔`Expr` walker reaches every match (the derived
per-enum `Stmt.map`/`Expr.map` don't cross the Stmt↔Expr boundary). Output is
reprinted via the existing faithful `fmt_stmt_list`. CLI: build the enum catalog
from the full resolved set (imported enums included) but rewrite only the target
file's own stmts.

## BLOCKER (codegen)

Constructing any `Stmt` value inside this fresh module fails codegen with
`unknown struct Annotation` (struct_decl/codegen.av). The `Stmt` enum has an
`Annotated(annots: List<Annotation>, ...)` variant; constructing *any* `Stmt`
requires the `Annotation` payload struct materialized in the module's codegen
unit, but materialization is only triggered by a direct `Annotation { ... }`
StructLit. Established AST-rewriting passes (desugar / lower / resolve) avoid it
only because `resolve/names.av` constructs `Annotation { ... }` directly in the
same shared unit. A new module that reconstructs `Stmt` but never builds an
`Annotation` directly never materializes it.

Fix options:
1. (foundation) codegen should materialize every enum-variant payload struct
   before constructing an enum value of that type — pre-register all struct
   TypeDecls in codegen setup, OR materialize on enum-construct. This unblocks
   any future AST-rewriting module/tool, not just this one.
2. (relocate) host the pass in a module compiled into the unit that already
   materialises `Annotation` — fragile; depends on the unit model.

Repro: create `packages/std-avrac/src/fix/mod.av` reconstructing `Stmt.Function`
(or any `Stmt`) and `make build-quick` → `unknown struct Annotation`.

## Pass source (preserved)

```avra
// WHY: `bs2 fix --rule=no-wildcard` migration support for the REMOVE
// WILDCARDS rollout (epic vndt). A wildcard arm over a declared enum
// silently swallows any variant added later; this pass rewrites
// `match x { .A -> body, _ -> dflt }` into one explicit arm per
// uncovered variant, each running the wildcard's body. The author then
// reviews — keeping the default where it's genuinely wanted, writing a
// real impl where it isn't.
//
// Subject typing is NOT needed: a variant-dispatching match's explicit
// arms already name the enum's variants, so the subject enum is pinned
// from the arms via a variant→enum index built by scanning EnumDecls.
// A match with no variant arms (e.g. matching an int with literal arms
// + `_`) has no enum to expand against and is left untouched — those
// wildcards are legitimate (the variant set isn't closed).

use core.{Stmt, SStmt, Expr, SExpr, MatchArm, Pattern, ParamEntry, Variant, ValueType, Annotation, type_short_name}
use list_ops.{list_contains_str}

// ── Enum registry (variant → owning enum, enum → variants) ──

/// One declared enum: its (possibly qualified) name and full variant
/// set. Arity per variant is `variant.fields.length`.
type EnumInfo = {
    name: string,
    variants: List<Variant>,
}

/// Registry of every declared enum reachable in the compiled stmt set
/// (the file plus its resolved imports). Built by scanning EnumDecl
/// nodes; Module bodies are walked so imported enums are included.
export type EnumCatalog = {
    enums: List<EnumInfo>,
}

/// Scan `stmts` for every `EnumDecl` (recursing Module + Annotated
/// wrappers) and collect them into an EnumCatalog.
export fn build_enum_catalog(stmts: List<SStmt>) -> EnumCatalog {
    mut acc: List<EnumInfo> = []
    for ss in stmts {
        acc = collect_enums_from_stmt(acc, ss.node)
    }
    EnumCatalog { enums: acc }
}

fn collect_enums_from_stmt(acc: List<EnumInfo>, stmt: Stmt) -> List<EnumInfo> {
    match stmt {
        .EnumDecl(name, _, variants) -> {
            mut cur = acc
            cur.push(EnumInfo { name, variants })
            cur
        }
        .Module(_, body) -> {
            mut cur = acc
            for ss in body { cur = collect_enums_from_stmt(cur, ss.node) }
            cur
        }
        .Annotated(_, inner) -> collect_enums_from_stmt(acc, inner)
        _ -> acc
    }
}

/// Find the enum whose variant set contains every name in
/// `matched_names`. Returns the EnumInfo on a unique match, null when
/// no enum covers them all or more than one does (ambiguous — the
/// caller leaves such a match untouched rather than guess).
fn enum_for_variants(cat: EnumCatalog, matched_names: List<string>) -> EnumInfo? {
    if matched_names.length == 0 { return null }
    mut found: EnumInfo? = null
    for e in cat.enums {
        if enum_covers_all(e, matched_names) {
            if found != null { return null }   // ambiguous — two enums fit
            found = e
        }
    }
    found
}

/// True when every name in `names` is a variant of `e`. Variant names
/// in arm patterns may be short (`.Let`) while the decl is qualified;
/// compare on short names to bridge that.
fn enum_covers_all(e: EnumInfo, names: List<string>) -> bool {
    for n in names {
        if !enum_has_variant(e, n) { return false }
    }
    true
}

fn enum_has_variant(e: EnumInfo, name: string) -> bool {
    let short = type_short_name(name)
    for v in e.variants {
        if v.name == name || type_short_name(v.name) == short { return true }
    }
    false
}

// ── Per-match arm expansion ──

/// Result of trying to expand one match's arms. `changed` is false
/// when the match had no wildcard, no variant arms, or an ambiguous /
/// unknown enum — in which case `arms` is returned unchanged.
export type ArmExpansion = {
    arms: List<MatchArm>,
    changed: bool,
}

/// Expand a wildcard arm in `arms` into one arm per uncovered variant
/// of the enum the explicit arms dispatch on. No-op (changed=false)
/// unless there is exactly one wildcard arm AND the explicit arms pin
/// a unique declared enum AND that enum has variants the arms miss.
export fn expand_match_arms(cat: EnumCatalog, arms: List<MatchArm>) -> ArmExpansion {
    if !arms_has_wildcard(arms) { return ArmExpansion { arms, changed: false } }
    let matched = explicit_variant_names(arms)
    let e_opt = enum_for_variants(cat, matched)
    if e_opt == null { return ArmExpansion { arms, changed: false } }
    let e = e_opt!
    let missing = missing_variants(e, matched)
    if missing.length == 0 { return ArmExpansion { arms, changed: false } }
    ArmExpansion { arms: rebuild_arms(arms, missing), changed: true }
}

/// True when any arm's pattern is the bare `_` wildcard.
fn arms_has_wildcard(arms: List<MatchArm>) -> bool {
    for a in arms {
        if a.pattern is .Wildcard { return true }
    }
    false
}

/// Short variant names named by the explicit (variant) arms. Literal /
/// wildcard / type-pattern arms contribute nothing — only `.Variant`
/// and `.NestedVariant` name an enum variant.
fn explicit_variant_names(arms: List<MatchArm>) -> List<string> {
    mut out: List<string> = []
    for a in arms {
        let n = arm_variant_name(a.pattern)
        if n != "" { out.push(n) }
    }
    out
}

fn arm_variant_name(p: Pattern) -> string {
    match p {
        .Variant(name, _) -> name
        .NestedVariant(name, _) -> name
        _ -> ""
    }
}

/// The enum's variants whose (short) name is not already matched.
fn missing_variants(e: EnumInfo, matched: List<string>) -> List<Variant> {
    mut shorts: List<string> = []
    for m in matched { shorts.push(type_short_name(m)) }
    mut out: List<Variant> = []
    for v in e.variants {
        if !list_contains_str(shorts, type_short_name(v.name)) { out.push(v) }
    }
    out
}

/// Rebuild the arm list with the single wildcard arm replaced, in
/// place, by one arm per missing variant. Each new arm reuses the
/// wildcard arm's guard + body verbatim, with a `.Variant(_, …)`
/// pattern whose underscore count matches the variant's field arity.
fn rebuild_arms(arms: List<MatchArm>, missing: List<Variant>) -> List<MatchArm> {
    mut out: List<MatchArm> = []
    for a in arms {
        if a.pattern is .Wildcard {
            for v in missing {
                out.push(MatchArm {
                    pattern: variant_pattern(v),
                    guard: a.guard,
                    body: a.body,
                })
            }
        } else {
            out.push(a)
        }
    }
    out
}

/// `.Name(_, _, …)` with one `_` binding per declared field.
fn variant_pattern(v: Variant) -> Pattern {
    mut binds: List<ParamEntry> = []
    for _f in v.fields {
        binds.push(ParamEntry { name: "_", vtype: ValueType.Unknown })
    }
    Pattern.Variant(type_short_name(v.name), binds)
}

// ── Whole-program rewrite walk ──
//
// A wildcard match can sit anywhere, and its arm bodies can contain
// further matches, so the rewrite recurses across Stmt↔Expr (a match
// subject + arm bodies are Exprs whose blocks hold Stmts). The derived
// per-enum Stmt.map / Expr.map don't cross that boundary, so this is a
// hand-rolled mutual walker mirroring the variant enumeration in
// quote_expr/lower.av's quote walkers. Each fix_* returns the rewritten
// node plus the count of wildcard arms it expanded, so --dry-run can
// report how many sites changed.

/// Rewritten Stmt + number of wildcard expansions performed within it.
type SFix = { node: Stmt, n: int }
/// Rewritten Expr + number of wildcard expansions performed within it.
type EFix = { node: Expr, n: int }

/// Top-level entry: expand every wildcard-over-declared-enum match in
/// `stmts`. Returns the rewritten program and the total sites expanded.
export type FixResult = { stmts: List<SStmt>, count: int }

export fn fix_no_wildcard(stmts: List<SStmt>) -> FixResult {
    let cat = build_enum_catalog(stmts)
    fix_sstmt_list(cat, stmts)
}

/// Same as fix_no_wildcard but with a pre-built catalog. The CLI builds
/// the catalog from the full resolved set (so imported enums are known)
/// yet rewrites only the target file's own stmts — passing the file's
/// stmts here while the catalog spans the imports.
export fn fix_no_wildcard_with_catalog(cat: EnumCatalog, stmts: List<SStmt>) -> FixResult {
    fix_sstmt_list(cat, stmts)
}

fn fix_sstmt_list(cat: EnumCatalog, stmts: List<SStmt>) -> FixResult {
    mut out: List<SStmt> = []
    mut total = 0
    for ss in stmts {
        let r = fix_stmt(cat, ss.node)
        out.push(SStmt { node: r.node, line: ss.line, col: ss.col, file: ss.file, from_macro: ss.from_macro })
        total = total + r.n
    }
    FixResult { stmts: out, count: total }
}

fn fix_stmt(cat: EnumCatalog, stmt: Stmt) -> SFix {
    match stmt {
        .Let(name, vt, init) -> {
            let e = fix_expr(cat, init)
            SFix { node: Stmt.Let(name, vt, e.node), n: e.n }
        }
        .Mut(name, vt, init) -> {
            let e = fix_expr(cat, init)
            SFix { node: Stmt.Mut(name, vt, e.node), n: e.n }
        }
        .Const(name, vt, init) -> {
            let e = fix_expr(cat, init)
            SFix { node: Stmt.Const(name, vt, e.node), n: e.n }
        }
        .Expr(e) -> {
            let r = fix_expr(cat, e)
            SFix { node: Stmt.Expr(r.node), n: r.n }
        }
        .Return(e) -> {
            let r = fix_expr(cat, e)
            SFix { node: Stmt.Return(r.node), n: r.n }
        }
        .Block(body) -> {
            let r = fix_sstmt_list(cat, body)
            SFix { node: Stmt.Block(r.stmts), n: r.count }
        }
        .If(cond, then_b, else_b) -> {
            let c = fix_expr(cat, cond)
            let t = fix_stmt(cat, then_b)
            if else_b == null {
                SFix { node: Stmt.If(c.node, t.node, null), n: c.n + t.n }
            } else {
                let e = fix_stmt(cat, else_b!)
                SFix { node: Stmt.If(c.node, t.node, e.node), n: c.n + t.n + e.n }
            }
        }
        .While(cond, body) -> {
            let c = fix_expr(cat, cond)
            let b = fix_stmt(cat, body)
            SFix { node: Stmt.While(c.node, b.node), n: c.n + b.n }
        }
        .For(v, start, end, body) -> {
            let s = fix_expr(cat, start)
            let e = fix_expr(cat, end)
            let b = fix_stmt(cat, body)
            SFix { node: Stmt.For(v, s.node, e.node, b.node), n: s.n + e.n + b.n }
        }
        .ForIn(v, coll, body) -> {
            let c = fix_expr(cat, coll)
            let b = fix_stmt(cat, body)
            SFix { node: Stmt.ForIn(v, c.node, b.node), n: c.n + b.n }
        }
        .Function(name, tp, params, ret, body) -> {
            let r = fix_sstmt_list(cat, body)
            SFix { node: Stmt.Function(name, tp, params, ret, r.stmts), n: r.count }
        }
        .Impl(target, methods) -> {
            let r = fix_sstmt_list(cat, methods)
            SFix { node: Stmt.Impl(target, r.stmts), n: r.count }
        }
        .TraitDecl(name, methods) -> {
            let r = fix_sstmt_list(cat, methods)
            SFix { node: Stmt.TraitDecl(name, r.stmts), n: r.count }
        }
        .Parallel(body) -> {
            let r = fix_sstmt_list(cat, body)
            SFix { node: Stmt.Parallel(r.stmts), n: r.count }
        }
        .Module(name, body) -> {
            let r = fix_sstmt_list(cat, body)
            SFix { node: Stmt.Module(name, r.stmts), n: r.count }
        }
        .Annotated(annots, inner) -> {
            let r = fix_stmt(cat, inner)
            SFix { node: .Annotated(annots, r.node), n: r.n }
        }
        .Defer(e) -> {
            let r = fix_expr(cat, e)
            SFix { node: Stmt.Defer(r.node), n: r.n }
        }
        .Errdefer(e) -> {
            let r = fix_expr(cat, e)
            SFix { node: Stmt.Errdefer(r.node), n: r.n }
        }
        .Match(subject, arms) -> fix_match_stmt(cat, subject, arms)
        _ -> SFix { node: stmt, n: 0 }
    }
}

/// Rewrite a statement-position `match`: recurse the subject + every
/// arm body, then expand a wildcard arm against the dispatched enum.
fn fix_match_stmt(cat: EnumCatalog, subject: Expr, arms: List<MatchArm>) -> SFix {
    let s = fix_expr(cat, subject)
    let inner = fix_arm_bodies(cat, arms)
    let exp = expand_match_arms(cat, inner.arms)
    let expanded = if exp.changed { 1 } else { 0 }
    SFix { node: Stmt.Match(s.node, exp.arms), n: s.n + inner.n + expanded }
}

fn fix_expr(cat: EnumCatalog, expr: Expr) -> EFix {
    match expr {
        .Binary(l, op, r) -> {
            let a = fix_expr(cat, l)
            let b = fix_expr(cat, r)
            EFix { node: Expr.Binary(a.node, op, b.node), n: a.n + b.n }
        }
        .Logical(l, op, r) -> {
            let a = fix_expr(cat, l)
            let b = fix_expr(cat, r)
            EFix { node: Expr.Logical(a.node, op, b.node), n: a.n + b.n }
        }
        .Unary(op, r) -> {
            let a = fix_expr(cat, r)
            EFix { node: Expr.Unary(op, a.node), n: a.n }
        }
        .Grouping(inner) -> {
            let a = fix_expr(cat, inner)
            EFix { node: Expr.Grouping(a.node), n: a.n }
        }
        .Call(callee, args) -> {
            let c = fix_expr(cat, callee)
            let r = fix_sexpr_list(cat, args)
            EFix { node: Expr.Call(c.node, r.exprs), n: c.n + r.count }
        }
        .GenericCall(callee, ta, args) -> {
            let c = fix_expr(cat, callee)
            let r = fix_sexpr_list(cat, args)
            EFix { node: Expr.GenericCall(c.node, ta, r.exprs), n: c.n + r.count }
        }
        .FieldAccess(obj, f) -> {
            let a = fix_expr(cat, obj)
            EFix { node: Expr.FieldAccess(a.node, f), n: a.n }
        }
        .OptionalChain(obj, f) -> {
            let a = fix_expr(cat, obj)
            EFix { node: Expr.OptionalChain(a.node, f), n: a.n }
        }
        .Index(obj, idx) -> {
            let a = fix_expr(cat, obj)
            let b = fix_expr(cat, idx)
            EFix { node: Expr.Index(a.node, b.node), n: a.n + b.n }
        }
        .NullCoalesce(l, r) -> {
            let a = fix_expr(cat, l)
            let b = fix_expr(cat, r)
            EFix { node: Expr.NullCoalesce(a.node, b.node), n: a.n + b.n }
        }
        .Try(inner) -> {
            let a = fix_expr(cat, inner)
            EFix { node: Expr.Try(a.node), n: a.n }
        }
        .Spawn(inner) -> {
            let a = fix_expr(cat, inner)
            EFix { node: Expr.Spawn(a.node), n: a.n }
        }
        .Isolated(inner) -> {
            let a = fix_expr(cat, inner)
            EFix { node: Expr.Isolated(a.node), n: a.n }
        }
        .Assign(name, v) -> {
            let a = fix_expr(cat, v)
            EFix { node: Expr.Assign(name, a.node), n: a.n }
        }
        .Tuple(elems) -> {
            let r = fix_sexpr_list(cat, elems)
            EFix { node: Expr.Tuple(r.exprs), n: r.count }
        }
        .ListLit(elems) -> {
            let r = fix_sexpr_list(cat, elems)
            EFix { node: Expr.ListLit(r.exprs), n: r.count }
        }
        .MapLit(entries) -> {
            let r = fix_sexpr_list(cat, entries)
            EFix { node: Expr.MapLit(r.exprs), n: r.count }
        }
        .InCheck(needle, items) -> {
            let a = fix_expr(cat, needle)
            let r = fix_sexpr_list(cat, items)
            EFix { node: Expr.InCheck(a.node, r.exprs), n: a.n + r.count }
        }
        .Lambda(params, body) -> {
            let a = fix_expr(cat, body)
            EFix { node: Expr.Lambda(params, a.node), n: a.n }
        }
        .IsCheck(subj, vn) -> {
            let a = fix_expr(cat, subj)
            EFix { node: Expr.IsCheck(a.node, vn), n: a.n }
        }
        .Block(body) -> {
            let r = fix_sstmt_list(cat, body)
            EFix { node: Expr.Block(r.stmts), n: r.count }
        }
        .IfExpr(c, t, e) -> {
            let cc = fix_expr(cat, c)
            let tt = fix_expr(cat, t)
            let ee = fix_expr(cat, e)
            EFix { node: Expr.IfExpr(cc.node, tt.node, ee.node), n: cc.n + tt.n + ee.n }
        }
        .MatchExpr(subject, arms) -> fix_match_expr(cat, subject, arms)
        _ -> EFix { node: expr, n: 0 }
    }
}

/// Rewrite an expression-position `match`: same shape as the statement
/// form but rebuilds an Expr.MatchExpr.
fn fix_match_expr(cat: EnumCatalog, subject: Expr, arms: List<MatchArm>) -> EFix {
    let s = fix_expr(cat, subject)
    let inner = fix_arm_bodies(cat, arms)
    let exp = expand_match_arms(cat, inner.arms)
    let expanded = if exp.changed { 1 } else { 0 }
    EFix { node: Expr.MatchExpr(s.node, exp.arms), n: s.n + inner.n + expanded }
}

/// Result of recursing into a match's arm bodies (before this match's
/// own wildcard expansion runs).
type ArmsFix = { arms: List<MatchArm>, n: int }

/// Recurse the rewrite into each arm's guard + body, leaving patterns
/// untouched. Nested matches inside arm bodies are expanded here.
fn fix_arm_bodies(cat: EnumCatalog, arms: List<MatchArm>) -> ArmsFix {
    mut out: List<MatchArm> = []
    mut total = 0
    for a in arms {
        let body = fix_expr(cat, a.body.node)
        let new_body = SExpr { node: body.node, line: a.body.line, col: a.body.col, ty: a.body.ty, file: a.body.file }
        out.push(MatchArm { pattern: a.pattern, guard: a.guard, body: new_body })
        total = total + body.n
    }
    ArmsFix { arms: out, n: total }
}

/// List-of-SExpr counterpart to fix_sstmt_list.
type SExprListFix = { exprs: List<SExpr>, count: int }

fn fix_sexpr_list(cat: EnumCatalog, exprs: List<SExpr>) -> SExprListFix {
    mut out: List<SExpr> = []
    mut total = 0
    for se in exprs {
        let r = fix_expr(cat, se.node)
        out.push(SExpr { node: r.node, line: se.line, col: se.col, ty: se.ty, file: se.file })
        total = total + r.n
    }
    SExprListFix { exprs: out, count: total }
}
```
