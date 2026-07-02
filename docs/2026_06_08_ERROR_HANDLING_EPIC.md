# Error Handling — Full Design Spec (Avra)

**Status:** design / ratified-in-discussion — not yet implemented.
**Date:** 2026-06-08
**Depends on:** the `?`-split (spec Axis 10 §10.5 / 12.x, F1202) shipped in the
Nullability/Option epic (`docs/2026_06_05_NULLABILITY_OPTION_EPIC.md`). `?` is
already Result-only; this epic builds the rest of the error story on top.
**Supersedes/extends:** spec Axis 12 (Error Handling) in
`docs/2026_04_18_FULL_SPEC.md` — that axis stays the source of truth for
`Result`, union error types, the `Error` trait, and panic-at-task-boundary;
this doc specifies the *ergonomics and intelligence layer* over it.

This spec is self-contained for a no-context implementer. Every construct
discussed is captured here; §14 is a kitchen-sink example with a completeness
checklist so nothing is lost.

---

## §0 Vision & principles

Errors are not control flow. Treat them as **a typed effect the compiler tracks
end-to-end**, with **handlers as installable (optionally resumable) policies**,
and the program's **entire failure surface as queryable, provable data.**

Three load-bearing rules — every feature below serves at least one:

1. **The happy path is a straight line.** Recovery attaches to the side and
   never interrupts the flow being read.
2. **You dial in exactly which failures you take responsibility for.**
   Everything you don't explicitly handle keeps propagating — with its trace
   intact. `?` and `catch` are the *same mechanism at different granularities*:
   `?` propagates all errors; `catch Pat -> v` propagates all-but-the-named.
3. **The compiler knows the exact error set and forces exhaustiveness when you
   claim to handle it.** Adding a failure mode anywhere breaks every now-incomplete
   handler. An agent (or a tired human) *cannot* silently forget an error case.

The whole system is paid for once by **inferred error unions** (§3.4) and the
**failure topology** (§8), then cashed out as: retry boilerplate gone, failure
paths provably handled and auto-tested, and a program you can *ask* how it breaks.

Design tension to respect throughout (the same one the `?`-split resolved):
**local legibility for agents.** Any feature whose meaning depends on distant
context must be gated so the compiler/tooling can always answer "what happens
here, and where is it decided?" locally. (The postfix `catch with` form in §6 is
designed precisely so handler application is *always* lexically local.)

---

## §1 The vocabulary — one verb per intent

The complete surface. Each token has exactly one meaning (the `?`-split discipline):

| intent | form | §  |
|---|---|---|
| propagate the error | `f()?` | 5.1 |
| propagate + attach context frame | `f()? context "…"` | 5.2 |
| raise an error | `fail e` | 3.1 |
| produce success (implicit) | bare tail value → `Ok(value)` | 3.2 |
| test structurally (bool) | `x is .Ok(.Pat)` | 4.2 |
| recover with a value | `f() catch v` | 5.3 |
| recover with logic | `f() catch { … it … }` / `catch e -> { … }` | 5.4–5.5 |
| recover one kind, bubble the rest | `f() catch .NotFound -> v` | 5.6 |
| chain fallbacks | `f() catch _ -> g() catch _ -> v` | 5.10 |
| handle all kinds (exhaustive boundary) | `f() catch { … }` / `{ block } catch { … }` | 5.7 / 6.1 |
| recover from the error's own remedy | `f() catch auto` | 7.3 |
| roll back on the error path | `errdefer …` | 5.11 |
| resume / give up inside a handler arm | `retry(…)` / `abort e` | 6.3–6.4 |
| build a reusable handler value | `handler { … }` | 6.7 |
| apply a handler value (postfix, chains) | `f() catch with policy` (compose `+`) | 6.7 |

`?`, `??`, `catch`, `fail` are **not interchangeable**: `?` = Result
error-propagation, `??` = Option none-coalesce (Axis 10), `catch` = recover from
a Result error (inline arms/value, or `catch with` a handler value), `fail` = raise.

### §1.1 The boilerplate that dies

The point of the whole epic, in one table — the most common error chores today
vs. what they collapse to:

| the thing everyone writes | today (Rust-ish) | Avra |
|---|---|---|
| propagate | `if let Err(e) = … { return e }` | `f()?` |
| produce success | `Ok(value)` | bare `value` (implicit, §3.2) |
| raise | `return Err(e)` | `fail e` |
| recover with a value | `f().unwrap_or(d)` | `f() catch d` |
| recover one kind, bubble rest | `match … { Err(NotFound) => …, Err(e) => return e, Ok }` | `f() catch .NotFound -> d` |
| fallback chain | nested matches | `f() catch _ -> g() catch _ -> d` |
| retry w/ backoff | a 10-line loop, every site | a `retry` arm in a handler |
| convert lib error → mine | `From` impls / `map_err` | nothing (inferred unions, §3.4) |
| add context | `.context("…")?` | `f()? context "…"` |
| test the failure paths | you don't | `@derive(failure_tests)` (§9.2) |
| "how can this fail?" | read the tree by hand | `avra explain-failures` (§8.5) |

---

## §2 Existing foundations (already shipped or in the language)

Reuse, don't reinvent.

- **`Result<T, E>`**, `.Ok` / `.Err` — Axis 12.
- **`?` is Result-only** — F1202 makes `?` on a `T?` a compile error. (Axis 10 §10.5.)
- **Union error types** `Result<T, A | B>` with **auto-widening at `?`** — Axis 12.x.
- **`Error` trait**: `message()`, `kind()` (hierarchical), `cause()`, `context()`, `trace()` — Axis 12.
- **Panic at task boundary** — Axis 18. `fail` (§3.1) is recoverable and **distinct from `panic`**.
- **`errdefer`** (LIFO, error-path cleanup) — Axis 9 / Axis 12.
- **Nested match patterns** — already parseable; §4.1 is mostly *dogfooding*.
- **Green threads / fibers** — Axis 18. The substrate for resumable handlers (§6.5).
- **`@derive`/`@expand`**, **traits**, **the `it` closure pronoun**, **`with` struct-update** — reused by §7, §9, §5.4. (Note `with` is already a postfix struct-update keyword; `catch with` in §6.7 is a distinct two-token sequence — no grammar conflict.)

---

## §3 PRODUCE side — making a `Result`

### 3.1 `fail e` — raise (sugar for `return .Err(e)`)

**Syntax:** `fail <expr>` (diverging). **Desugar:** `fail e` ≡ `return .Err(e)`.
**Semantics:** valid only inside a `Result<_, E>` function where `typeof(e)` is a
member of `E` (subject to union widening, §3.6). Diverges, so usable in any
expression position (e.g. a `catch` arm).
**Naming:** NOT `throw`/`raise` — Avra is not exceptions; `fail` keeps it honest
that you return an `Err` value, and is lexically distinct from `panic`.
**Errors:** `F1217` — `fail` in a non-`Result` function.

```
fn parse_config(raw: string) -> Result<Config, ConfigError> {
    if raw == "" { fail .Missing("<stdin>") }
    let port = field_int(raw, "port")
    if port < 0 { fail .Parse(1, "port must be > 0") }
    Config { url: field(raw, "url"), port: port, admin: field(raw, "admin") }  // §3.2
}
```

### 3.2 Implicit `Ok`-wrap of the tail/return value

**Decided (2026-06-08): implicit.** Avra goes the Gleam way — a bare success
value is `Ok`-wrapped — not the Rust way (explicit `Ok(...)`). Terseness wins;
the guard rule keeps it unambiguous.
**Rule:** in a `Result<T, E>` function, a tail expression (or `return x`) whose
type is exactly `T` auto-wraps to `.Ok(x)`.
**Guard rule (non-negotiable):** auto-wrap applies **only** when the produced
type is exactly `T` and is **not itself a `Result`/error-union member** — never
silent `Ok(Ok(x))`; a Result-shaped value needs explicit `.Ok`/`.Err`/`?`/`fail`.
**Local-legibility:** the return type is in the signature (local, already needed
for type-checking), so a bare tail value's meaning is locally determined.
**Mechanism:** a return-boundary coercion `T → Ok(T)`, architecturally identical
to the optional-box coercion (`emit_optional_coerce`) from the nullability epic.
**Combined story:** auto-`Ok` + `fail` + `?` make a `Result` function read like
exception-style code while staying a pure value.

### 3.3 Record-and-abort helper pattern (parser idiom; not new syntax)

Fallible helpers return `Result` and record their diagnostic *before* aborting,
so callers write `self.expect(Tk.RightParen, "expected `)`")?` instead of
`if !cond { return .Err("parse error") }`. (Tracked separately as parser
hardening; listed because it's part of the produce story.)

### 3.4 Inferred error unions — `Result<T, _>`

`_` in the error position ⇒ the compiler computes `E` as the union of every
error type the body can raise (every `?`-propagated callee union + every `fail`).
No hand-rolled enum, no `From`, no `Box<dyn Error>`. **Self-maintaining:** adding
a `?` widens the union → every non-exhaustive `catch` over it breaks (§5.8),
guiding the author to the new failure. Published APIs usually **name** the union
(§3.5) for stability; `_` is for internal plumbing (a lint may forbid `_` in
exported signatures).

### 3.5 Named error unions at boundaries

`fn connect(url: string) -> Result<Db, NetError | ConfigError>` — explicit,
stable, published. Same machinery as inferred; just written out. Widening (§3.6)
still applies at `?` inside.

### 3.6 Auto-widening at `?`

(Axis 12.x — restated.) At a `?` site the callee's error type widens into the
enclosing union; `IoError` from one call and `ConfigError` from another merge
into `IoError | ConfigError`. This is what makes inferred unions and selective
`catch` compose.

---

## §4 TEST side — structural boolean checks

### 4.1 Nested `match` patterns (dogfood; mostly existing)

`match s { .Ok(.ReturnEmpty) -> true  _ -> false }` collapses Ok-then-inner-match
into one `match`. Pattern grammar already supports nested constructors; the work
is (a) confirm `.Ok(.Variant)` lowers for the Result-wrapping case, (b) dogfood.
Wildcard `_` is fine here (boolean test, not exhaustive *handling* — §5.8).

### 4.2 `is` + pattern (a `matches!`)

**Syntax:** `expr is <pattern>`, including nested (`x is .Ok(.ReturnEmpty)`,
`e is .Err(.Missing(_))`). **Semantics:** a `bool` expression.
**Binding-free, deliberately:** `is` never binds; want a binding? use `match`.
Keeping `is` a pure test avoids scope/ambiguity and keeps it a one-liner.
**Today:** `IsCheck` stores only a flat variant-name `string`; extend it to carry
a full `Pattern` routed through the match pattern-matcher to emit an `i1`. No
non-local ambiguity (pure expression).

```
fn is_missing(c: Result<Config, ConfigError>) -> bool { c is .Err(.Missing(_)) }
```

---

## §5 HANDLE side — recovering from a `Result`

### 5.0 `catch` grammar, disambiguation & precedence

`catch` is one postfix operator with a single right-hand operand; its **shape is
read off the operand** with no keyword soup:

```
<guarded> catch <recovery>

<guarded>   ::= <expr> | <block-expr>          // a value OR a multi-statement { … }
<recovery>  ::= <value-expr>                   // (a) no top-level `->` → recover with this value
              | <pattern> -> <result>          // (b) has a top-level `->` → ONE arm (selective)
              | "{" <arms> "}"                 // (c) braces of `pat -> result` → arms (selective/total)
              | "{" <block> "}"                // (d) braces, NOT arms → recovery block, `it`-bound
              | with <policy>                  // (e) apply a handler value (§6.7); chains
              | auto                            // (f) apply each error's Remediation (§7.3)
<result>    ::= <value-expr> | fail <e> | retry(…) | abort <e> | "{" <block> "}"
```

**Disambiguation — local rules, no type info:**

1. **`catch with …`** → apply a handler *value* (e). The `with` keyword is the
   tell; this never collides with `catch <value>`.
2. **`catch {` …** → form (c)/(d). `{ … }` is arms (c) iff its top level is a
   sequence of `pattern ->`; otherwise a recovery block (d). A block is sugar for
   the single wildcard arm `_ -> { … }` with `it` bound — so (c) and (d) are one
   construct ("a match over the error"), (d) being its one-armed case.
3. **No braces, no `with`:** a top-level `->` ⇒ a single arm (b); none ⇒ a value
   (a). `catch 8080`/`catch fallback()` are values; `catch .NotFound -> d`/
   `catch e -> {…}` are arms. A closure used as a recovery *value* must be
   parenthesized (`catch ((x)->…)`) so its `->` isn't read as an arm — rare wart.

**Precedence & associativity:** `catch` binds **looser** than `?`/`|>`/calls/
arithmetic and is **left-associative**, so chaining (§5.10) falls out:
`a().b()? catch g() catch d` → `(((a().b())?) catch g()) catch d`. `?`/`context`
bind to their immediate operand; arm/result bodies are full expressions (so
`catch _ -> read(b)?` applies `?` inside the arm).

### 5.1 `?` — propagate (Result-only)

Unwrap `.Ok(v)`; on `.Err(e)`, widen and early-return. Appends a trace frame
(§5.2/§8). Already shipped.

### 5.2 `? context "…"` — propagate with a context frame

Postfix `<expr>? context <string>` (interpolated). Identical to `?` except on the
error path it attaches the rendered frame to the error's `trace()`/`context()`
before propagating. **Zero cost on success.** Block form `with context "…" { … }`
frames several `?`s (see §13.1). Desugar: `expr catch e -> fail e.context("…")`.

### 5.3 `catch <value>` — recover with a value

`let port = read_env("PORT") catch 8080`. On `.Err`, the expression is the RHS
value (type `T`). Terminal (§5.10).

### 5.4 `catch { … }` with the `it` binding

`f() catch { log.warn("degraded: {it.message()}"); fallback() }`. The error binds
to **`it`** (consistent with the closure pronoun). The block produces a `T` or
diverges (`return`/`fail`/`panic`/`exit`).
**`it` shadowing:** `it` refers to the caught error; an inner closure's own `it`
shadows it within that closure (innermost wins, standard lexical scoping). When
both are needed, bind the error explicitly via `catch e -> …` (§5.5).

### 5.5 `catch e -> { … }` — explicit error binding

`f() catch e -> { log(e); default }`. Same as 5.4 with a named binding.

### 5.6 Selective catch — recover one kind, propagate the rest

`f() catch <pattern> -> <expr>` (arms that don't cover the whole union). Matched
kinds recover (arm produces `T` or diverges); **unmatched kinds keep
propagating** (widening the enclosing union — so selective catch requires an
enclosing `Result`, like `?`). The "dial in responsibility" rule; the most common
real case.

```
let raw = read_file(path) catch .NotFound -> Config.default().raw   // others bubble
```

### 5.7 Total catch — the exhaustive boundary

`f() catch { <arms over every variant> }` handles **all** kinds → yields a `T`
with no propagation → usable in *any* function (incl. a non-`Result` `main`).
Each arm recovers, re-`fail`s, or diverges (§5.9).

### 5.8 Exhaustiveness & arm-validity rules

- **Total catch is exhaustive** over the known union (no-wildcard discipline,
  epic `vndt`). Missing a variant ⇒ `F1210`. A `_` hiding >2 variants ⇒ existing
  wildcard lint.
- **Arms are checked against the union of the guarded expression** (§6.2).
- **Dead arm:** an arm for an error the topology proves can't occur ⇒ warning `F9xxx`.
- **Ambiguous variant:** if two error types share a variant name, a bare
  `.Timeout` ⇒ `F1212`; qualify it (`NetError.Timeout`).

### 5.9 Catch-arm outcomes

(a) **recover** — produce `T`; (b) **re-raise** — `fail e'` (possibly a different
error type, transforming it); (c) **diverge** — `return`/`panic`/`exit`. The arm's
static outcome type drives §5.10.

### 5.10 Chaining `catch` — ordered fallbacks (one type rule)

**Rule:** `expr catch arm` is **still `Result<T, E'>`** if `arm` produces a
fallible value, and becomes **`T`** (terminal) if `arm` produces a plain `T` or
diverges. Left-associative.

```
let raw = read_file(a)                      // Result<string, IoError>
    catch _ -> read_file("/etc/app.default")   // arm fallible → still Result, chains
    catch _ -> read_file("/etc/app.fallback")  // still Result
    catch "{ }"                                  // plain string → TERMINAL: raw : string
```

Selective arms and `catch with <policy>` links mix freely in a chain; anything no
link matches keeps propagating. This is `or_else`, read top-to-bottom.

### 5.11 `errdefer` — error-path rollback (restated)

`errdefer <stmt>` runs **only if a later `?`/`fail` in scope fails**, LIFO,
**disarmed on success**. Declared next to the resource it protects.

### 5.12 Unifying statement

`?`, selective `catch`, total `catch` are one mechanism at three granularities of
*coverage*: nothing / a subset / everything. And (§6.6) `catch` is itself the
handler primitive; `retry`/`abort` are just additional arm results.

---

## §6 HANDLERS — scoped, composable, optionally resumable

### 6.1 There is no separate handler syntax — `catch` *is* the handler

A handler is just `catch` (§5.0) whose guarded operand may be a **block-expr** and
whose arms may use the full `Resolution` (`retry`/`abort`, §6.2). §5 and §6 are
one construct, one reading order — *do the thing, then say how it recovers* —
single brace:

```
let conn = {
    let c = open_db(url)?
    c.ping()?
    c
} catch {
    .Timeout            -> retry(max: 3, backoff: exponential)
    .RateLimited(after) -> retry(after: after)
    .Refused(h)         -> abort h
}
```

Inline `catch` is **always lexically local** — the recovery sits next to the
scope it guards — so it needs no guardrails; `retry`/`abort` work because the
guarded thing is a re-runnable `?`-bearing scope (fiber-suspend, §6.5).

The double-brace `with handler { arms } { block }` is **dropped**. Applying a
reusable handler *value* is also postfix — `catch with <policy>` (§6.7).

### 6.2 How arms are known — the `Resolution` type

Arms are checked against **the error union of the guarded block** (its failure
topology, §8) — the single answer to "how are arms known": the compiler
statically knows the set of errors a scope can raise, and arms match over it,
identically for `match`, `catch`, and handlers.

The type distinction that makes resumption work:

```
catch arm (recovery) : produces  T                       | diverges
handler arm          : produces  Resolution<T, E>
                       = retry(spec) | abort(E) | use(T) | propagate
```

A handler arm yields a **control decision**, not a value. `retry`, `abort`,
`use` (value-substitution), `propagate` unify under `Resolution`. A plain
recovery arm is the `use(T) | propagate` subset.

### 6.3 `retry(…)` — resume the failed operation

`retry(max: N, backoff: <fn(attempt)->duration>)` and `retry(after: <duration>)`.
Re-executes **the exact `?` call that raised** (not the whole block), bounded by
`max`; on exhausting `max`, the error propagates (or a follow-on link decides).
`backoff`/`after` sleep the fiber. **Bound mandatory:** unbounded `retry` ⇒ `F1215`.

### 6.4 `abort e` — give up from within a handler

Stops resumption and propagates `e` (possibly transformed) past the handler.

### 6.5 Fiber-suspension model (implementation)

Resumption is feasible because Avra runs **green threads**. A `?` raising a
*handled* error **suspends the current fiber** at the call site; the handler runs
on the side; `retry` **resumes the fiber**, re-entering the suspended call;
`abort`/`propagate`/`use` unwind or substitute. The continuation is the fiber —
no exotic compiler machinery beyond the scheduler. Handler state (attempt counts)
lives in the suspended frame.

### 6.6 One primitive, two surfaces

One underlying primitive — *match-over-the-error-with-a-Resolution*. Two surfaces:
- **inline:** `… catch { arms }` (§5.0/§6.1) — lexically local, no guardrails.
- **as a value, applied postfix:** `… catch with <policy>` (§6.7) — reusable,
  composable; lexically applied (so guardrail §6.8 #1 is satisfied by construction).

Everything in §5 (selective/total/chaining/exhaustiveness/`it`) applies to both.

### 6.7 First-class, composable handler values — `handler { … }` + `catch with`

A handler is a value, built with `handler { arms }`, applied **postfix** with
`catch with <policy>`, composed with `+` or by chaining:

```
let net   = handler { .Timeout -> retry(max: 3, backoff: exponential)
                      .RateLimited(after) -> retry(after: after) }
let fatal = handler { .Refused(h) -> abort h }

boot() catch with net                       // apply one policy (postfix, chains)
boot() catch with (net + fatal)             // compose into one; left = tried first
boot() catch with net catch with fatal      // chain: net's kinds handled, rest fall to fatal
{ a()?; b()? } catch with net               // guard a multi-statement block
boot() catch with net catch _ -> App.defaults()   // mix policy + inline arm in one chain
```

`with` (after `catch`) is the tell that the operand is a handler **value**, not a
recovery value — so `catch x` always means "recover with value `x`" and
`catch with x` always means "apply handler `x`", with **no type-directed
disambiguation**. The prefix `with policy { block }` form is **dropped**; there is
one application surface, and it is postfix and chainable.

**Resolution order:** in a chain, handlers are tried **left-to-right** (written
order); within a composed `a + b`, `a` first. Unresolved errors fall to the next
link, else propagate past the whole chain. A resumption (`retry`) re-enters from
the same point.

Non-resumable recovery is just a handler whose arms never `retry` — no separate
construct. A reusable pure-recovery policy:
`let recover = handler { .NotFound -> Config.default()  .Io(e) -> fail e }`
applied with `… catch with recover`.

### 6.8 Guardrails for resumable handlers (REQUIRED)

Resumable handler *values* can make a `?`'s meaning depend on the policy applied
to its enclosing scope. Postfix `catch with` keeps that application lexical, but
the value's *contents* live elsewhere — so these still hold:

1. **Lexical application only.** `catch with` is always written next to the
   guarded scope; **no** dynamic/global/thread-local install. Violation ⇒ `F1216`.
   (Satisfied by construction by the postfix form.)
2. **Deterministic resolution.** Left-to-right / `a` before `b`; an unqualified
   overlap between composed handlers is a **compile error** (`F1212`), never silent.
3. **Bounded resumption.** Every `retry` arm carries a bound (`F1215` otherwise),
   so composition can't create unbounded retry storms.
4. **Tooling closes the value-contents gap.** `avra explain-failures` and the IDE
   MUST show *"`Timeout` here is resolved by `net` applied at boot.av:42"* —
   non-locality of *what a policy does* becomes queryable, not spooky.

### 6.9 Scope verdict (ratified pushback)

- **Inline `catch` (incl. `retry`/`abort`):** ship — lexically local, no risk.
- **Reusable, composable handler values via `catch with`:** ship behind §6.8
  #2–#4 (#1 is automatic). The composability is worth it because application is
  postfix-local and the tooling makes the policy's behavior queryable. If we
  cannot commit to #4 (tooling), keep handler values single (no `+`/chaining of
  *resumable* ones) and let only non-resumable policies compose.

---

## §7 Error model & traits

### 7.1 `Error` trait (Axis 12)
`message()`, `kind()` (hierarchical), `cause()`, `context()`, `trace()`.
`@derive(Error)` provides them; all of §5/§6/§8/§9 key off this trait.

### 7.2 `Transient` trait + auto-retry
```
impl Transient for NetError { fn transient(self) -> bool { self is .Timeout || self is .RateLimited(_) } }
```
A default policy / `retry` can auto-retry `Transient` errors without an explicit
arm per kind — transience is a **type property**, not a flag.

### 7.3 `Remediation` trait + `catch auto`
```
impl Remediation for ConfigError {
    fn recover(self) -> Recover<Config> {
        match self { .Missing(_) -> .Use(Config.default())   .Parse(_, _) -> .Reraise }
    }
}
```
`f() catch auto` applies each error's `recover()` — `.Use(v)` recovers,
`.Reraise` keeps propagating. The trivial synthesis case of §9.1.

### 7.4 `fail` vs `panic`
`fail` returns a recoverable `Err` (Result channel). `panic` is unrecoverable and
(Axis 18) becomes an error to the parent task at the boundary. Never conflate.

---

## §8 Whole-program failure topology (compiler intelligence)

### 8.1 The failure graph
From inferred unions (§3.4): for any point, the complete set of errors that can
reach it and where each originates (provenance, hop counts).

### 8.2 Provable totality
`fn f() -> T` (no `Result`) compiles **only if** the inferred union is provably
empty. The absence of `Result` is a **guarantee**. A fallible call in a total
function ⇒ `F1213`.

### 8.3 Global exhaustiveness
A new variant five layers down lights up **every** total-`catch` boundary that can
now receive it — a precise red worklist (`F1210` each).

### 8.4 "No error left behind"
A non-`Result` `main` (or any total boundary) compiles only if every error that
can reach it is handled. Unhandled ⇒ `F1214`.

### 8.5 `avra explain-failures <fn>`
```
$ avra explain-failures serve
serve can fail with:
  Timeout       ← net.av:12   (via fetch→open_db, 3 hops)   [retried by `net` @ boot.av:42]
  RateLimited   ← net.av:19
  Parse         ← config.av:14 (via boot→load_config, 2 hops)
  Missing       ← config.av:11   [HANDLED at main]
```
Plus rendered traces (§5.2/§7.1) on unhandled errors.

### 8.6 Capabilities tie (future / cross-epic)
With a capability system, a function lacking an IO capability provably cannot
produce `IoError` — error inference becomes partly derivable from capabilities.
North-star interaction, not required here.

---

## §9 Agent layer — handling that writes & tests itself

### 9.1 Synthesis (`catch auto`, `avra fix`)
The union is known at every `catch`, so handling can be materialized: `catch
auto` / an agent / `avra fix` generates the exhaustive arms, each typed, each
stubbed with the likely recovery (`retry` for `Transient`, `.Use(default)` for
`Remediation`, `fail` for fatal) to confirm. Author a decision, not a match.

### 9.2 `@derive(failure_tests)`
Enumerates the error union → generates **one test per error variant** that injects
that failure at its source and asserts the handler/invariant holds. Points the
existing source→tests machinery at the failure graph.

---

## §10 Interactions

- **`?`-split / Option (Axis 10):** orthogonal. `?`=Result, `??`=Option; `catch`
  is Result-only.
- **Union types / monomorphization:** inferred unions are ordinary `A | B`
  ValueTypes; the substitution walkers recurse through unions (they already do).
  Auto-`Ok` mirrors the optional-box coercion already in codegen.
- **Green threads (Axis 18):** the substrate for resumable handlers (§6.5).
- **`@derive` infra:** `Error`/`Transient`/`Remediation`/`failure_tests` reuse the macro system.

---

## §11 Diagnostics (F-codes)

Type-system range (F1000–1999), error-handling sub-block F1202 + F1210–F1219.
Stable identifiers (Axis 20); each actionable, with a source location and a fix.

| code | meaning |
|---|---|
| `F1202` | `?` applied to an optional `T?` (the `?`-split; **already shipped**). |
| `F1210` | non-exhaustive total `catch`/handler over its error union. |
| `F1212` | ambiguous error variant in a `catch`/handler arm — qualify it. |
| `F1213` | totality violation — fallible call / `fail` reachable in a non-`Result` function. |
| `F1214` | unhandled error reaches a no-`Result` boundary ("no error left behind"). |
| `F1215` | unbounded `retry` in a handler arm — give it a `max`. |
| `F1216` | non-lexical (dynamic/global) handler install — not allowed. |
| `F1217` | `fail` used in a non-`Result` function. |
| `F9xxx` | (warning) dead `catch`/handler arm — error kind cannot occur in scope. |

---

## §12 Staged rollout

Each phase green + selfhost fixed-point before the next.

**Phase A — cheap / today (foundation):**
1. Dogfood **nested match patterns** (§4.1).
2. **`is` + pattern** (§4.2) — extend `IsCheck` to carry a `Pattern`.
3. **`fail`** (§3.1) — new keyword (seed cycle), parser desugar; `F1217`.
4. **Auto-`Ok` wrap** (§3.2) — return-boundary coercion + guard rule.
5. **`? context`** (§5.2).

**Phase B — handle core:**
6. **`catch`** — value / `{it}` / `e ->` / selective / total / chaining (§5.0,
   §5.3–5.10), exhaustiveness + arm-validity (§5.8), `F1210`/`F1212`.
7. **Inferred error unions** `Result<T, _>` (§3.4) + confirm widening (§3.6).

**Phase C — intelligence:**
8. **Failure topology** (§8.1) + **provable totality** (§8.2, `F1213`) + **global
   exhaustiveness** (§8.3) + **no error left behind** (§8.4, `F1214`).
9. **`avra explain-failures`** (§8.5).

**Phase D — showpiece:**
10. **Resumable `catch` arms** (`retry`/`abort`) on fibers (§6.1–6.6), `F1215`.
11. **Handler values + `catch with` composition** (§6.7) behind §6.8 (`F1216`).

**Phase E — agent layer:**
12. **`catch auto`** + `Remediation`/`Transient` (§7.2–7.3, §9.1).
13. **`@derive(failure_tests)`** (§9.2).

Each feature: AST + lexer/scanner (if keyword) + parser + codegen/desugar +
resolver + typeck + feature registry + AST renderer + `tests/*_test.av`
(spec/given/then incl. negative F-code tests) + `grammar.md`. Follow CLAUDE.md
"Adding a Feature — MANDATORY PROCESS". New keywords (`fail`, `handler`,
`context`, `retry`, `abort`, plus `catch`/`with`-after-`catch`/`auto`) need a
seed cycle; sequence types-only first, then implementation.

---

## §13 Open questions

**Decided 2026-06-08:** auto-`Ok` implicit (§3.2); `it` binds the caught error
(§5.4); `catch` grammar & precedence (§5.0); the double-brace `with handler {}{}`
dropped; handler values applied **postfix** as `catch with policy` (§6.1/§6.7),
chainable, no prefix form.

Still open:
1. **`context` surface:** postfix `? context "…"` only, or also a block form?
   With prefix-`with` gone, a block form would be postfix too — `{ block } context
   "…"`. Confirm grammar stays unambiguous.
2. **`catch auto` with no `Remediation` impl:** compile error or `propagate`?
   (Lean: compile error.)
3. **Explicit `else -> propagate`:** selective-by-default is the rule; keep an
   optional explicit `else` for readability? (Lean: yes, optional.)
4. **`retry` × `errdefer`:** does a resumed call re-run `errdefer`s armed before
   it? (Lean: no — the call is re-entered; surrounding defers unchanged.)
5. **`Resolution`/`Recover` user-visible** or compiler-internal?
6. **`catch with` keyword choice:** `with` reads naturally ("catch with net") but
   double-duties the existing struct-update `with`. Alternatives if that bothers
   us: `catch using net` / `catch via net`. (Lean: `with`; position disambiguates.)

---

## §14 Kitchen-sink example + completeness checklist

Tags: `[P#]` produce, `[T#]` test, `[C#]` consume/handle, `[F#]` futuristic.

```
use @std.io.{read_file}
use @std.net.{open_db, fetch}
use @std.time.{exponential}

@derive(Error)                                                   // [F13]
enum ConfigError { Missing(path: string), Parse(line: int, why: string) }
@derive(Error)
enum NetError { Timeout, RateLimited(after_ms: int), Refused(host: string) }

impl Transient for NetError {                                    // [F12]
    fn transient(self) -> bool { self is .Timeout || self is .RateLimited(_) }   // [T2]
}
impl Remediation for ConfigError {                               // [F14]
    fn recover(self) -> Recover<Config> {
        match self { .Missing(_) -> .Use(Config.default())   .Parse(_, _) -> .Reraise }
    }
}

type Config = { url: string, port: int, admin: string }
type App    = { cfg: Config, db: Db }

fn parse_config(raw: string) -> Result<Config, ConfigError> {
    if raw == "" { fail .Missing("<stdin>") }                   // [P1]
    let port = field_int(raw, "port")
    if port < 0 { fail .Parse(1, "port must be > 0") }          // [P1]
    Config { url: field(raw, "url"), port: port, admin: field(raw, "admin") }  // [P2]
}

fn load_config(path: string) -> Result<Config, _> {             // [P4]
    let raw = read_file(path)? context "reading config {path}"  // [P3][C2][P6]
    parse_config(raw)?                                          // [C1]
}

fn is_blank_config(c: Result<Config, ConfigError>) -> bool {
    match c { .Ok({ url: "", .. }) -> true  _ -> false }        // [T1]
}
fn is_missing(c: Result<Config, ConfigError>) -> bool { c is .Err(.Missing(_)) }  // [T2]

let net = handler {                                             // [F1] reusable handler value
    .Timeout            -> retry(max: 3, backoff: exponential)  // [F2][F5]
    .RateLimited(after) -> retry(after: after)                 // [F3]
    .Refused(h)         -> abort h                             // [F4]
}

fn connect(url: string, fallback: string) -> Result<Db, NetError> {   // [P5]
    let db = { let c = open_db(url)?  c.ping()?  c } catch with net    // [F1] postfix apply
    db catch .Refused(_) -> open_db(fallback)?                  // [C6] selective, chains
}

@derive(failure_tests)                                          // [F11]
fn boot(path: string) -> Result<App, NetError | ConfigError> {
    let cfg_path = read_env("CONFIG") catch path                // [C3]
    let raw = read_file(cfg_path) catch _ -> read_file("/etc/app.default")?   // [C10]
    let cfg = parse_config(raw)?
    let db = connect(cfg.url, "db-backup:5432")?
    errdefer db.close()                                         // [C11]
    warm_cache(db)?
    App { cfg: cfg, db: db }                                    // [P2]
}

fn fee_cents(amount_cents: int) -> int { amount_cents * 3 / 100 }   // [F7] provably total

fn handle_request(db: Db, body: string) -> Result<Response, NetError> {
    let upstream = fetch(body) catch { log.warn("degraded: {it.message()}"); cached() }  // [C4][C5]
    Response { ok: true, data: upstream }                       // [P2]
}

fn main() {                                                     // [F9] no-Result boundary
    let app = boot("/etc/app.toml") catch {                     // [C7] total, [C8] exhaustive, [F8]
        .Missing(p)     -> { log.error("no config at {p}"); App.defaults() }
        .Parse(line, w) -> { log.error("config:{line}: {w}"); exit(2) }   // [C9] diverge
        .Timeout        -> { log.error("db timed out"); exit(3) }
        .RateLimited(_) -> { log.error("rate limited"); exit(3) }
        .Refused(h)     -> fail_fatal("db refused: {h}")        // [C9] re-raise
    }
    let cfg = load_config("/etc/app.toml") catch auto           // [F10][F14]
    serve(app)
}

// [C12] unhandled/logged error prints its trace chain (? frames + context):
//   ConfigError::Parse: port must be > 0
//     while reading config /etc/app.toml      ← context
//     at parse_config (config.av:14)          ← ?
//     at load_config  (config.av:31)
//
// [F6] $ avra explain-failures serve   → whole-program failure provenance + handler resolution.
```

### Completeness checklist (every construct from the design thread)

**Produce:** `[P1]` `fail` (§3.1) · `[P2]` auto-`Ok` + guard rule (§3.2) ·
`[P3]` record-and-abort helper (§3.3) · `[P4]` inferred union `_` (§3.4) ·
`[P5]` named union (§3.5) · `[P6]` auto-widening at `?` (§3.6).

**Test:** `[T1]` nested match pattern (§4.1) · `[T2]` `is`+pattern / matches! (§4.2).

**Handle:** `[C1]` `?` (§5.1) · `[C2]` `? context` (§5.2) · `[C3]` `catch value`
(§5.3) · `[C4]` `catch {logic}` (§5.4) · `[C5]` `it` binding (§5.4) ·
`[C6]` selective catch (§5.6) · `[C7]` total catch (§5.7) · `[C8]` exhaustiveness
(§5.8) · `[C9]` arm re-fail/diverge (§5.9) · `[C10]` catch chaining (§5.10) ·
`[C11]` `errdefer` (§5.11) · `[C12]` structured trace (§5.2/§7.1/§8.5) ·
unifying "`?`/`catch` one mechanism" (§5.12).

**Futuristic:** `[F1]` resumable handler / `catch with` (§6.1/§6.7) · `[F2]`
`retry(max,backoff)` (§6.3) · `[F3]` `retry(after)` (§6.3) · `[F4]` `abort`
(§6.4) · `[F5]` fiber suspend/resume (§6.5) · `[F6]` `explain-failures` (§8.5) ·
`[F7]` provable totality (§8.2) · `[F8]` global exhaustiveness (§8.3) · `[F9]` no
error left behind (§8.4) · `[F10]` synthesis / `catch auto` (§9.1) · `[F11]`
`@derive(failure_tests)` (§9.2) · `[F12]` `Transient` + auto-retry (§7.2) ·
`[F13]` `Error` trait (§7.1) · `[F14]` `Remediation` / error-knows-its-fix (§7.3).

**Design decisions captured:** how arms are known (§6.2) · `catch` = the handler
primitive (§6.1/§6.6) · chaining type rule (§5.10) · postfix `catch with` +
composition + the four guardrails + scope verdict (§6.7–6.9) · implicit auto-`Ok`
(§3.2) · `it` (§5.4) · `catch` grammar (§5.0).

---

## §15 — North star (deferred, beyond v1; captured, not specced)

Out of scope for now; recorded so it isn't lost. (User: "ignore the rest, leave
for later.")

1. **Errors are one effect; the handler machinery is a universal typed effect
   system** — same `catch`/handler shape handles IO, time, randomness, logging;
   gives deterministic tests / mocking / DI "for free" (`{…} catch with fake_clock + in_memory_fs`).
   If pursued, build §6 effect-generic from the start (errors = the `Fail` effect).
2. **Bidirectional resumption** — a suspended call *requests* a value the context
   supplies, then continues (full algebraic effects; natural on fibers).
3. **Replayable failure capsules** — errors capture the inputs along their path →
   deterministic repro; production failures arrive as runnable tests.
4. **Failures → compile-time impossibilities** — the compiler suggests the type
   refactor that deletes a failure mode (parse-don't-validate, actively).
5. **Self-runbook / observability / self-heal** — from the live (telemetry-fed)
   failure topology: generated SRE runbook, per-error metrics/alerts, and
   agent-proposed fix diffs. Bonus: failure-surface-as-semver CI gate.
