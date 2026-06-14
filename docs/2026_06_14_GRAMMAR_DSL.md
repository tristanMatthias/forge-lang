# Grammar DSL — Proof Slice

**Status:** design / proof-of-concept (2026-06-14)
**Parent:** `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` (Layer 4 — derive the parser)

Goal of this doc: show the **whole** grammar DSL on one realistic slice (Avra
expressions) — the notation, the tokens, the parser it lowers to, what stays
*out* of it, and the seed that reads it — to prove it stays **small** while being
able to define **all of Avra**.

The reframe that makes "small but defines all of Avra" non-contradictory:
**small is the *notation*; the *grammar* (rules written in it) can be huge.** A
tiny EBNF defines C, Java, Python. Small tool, big artifact.

---

## 1. The notation — the whole DSL (~9 constructs)

| Construct | Syntax | Meaning |
|---|---|---|
| rule | `name = body` | define a rule |
| sequence | `a b c` | a then b then c |
| alternation | `a \| b` | a or b |
| grouping | `( … )` | group |
| repetition | `*` `+` `?` | zero+, one+, optional |
| terminal | `"lit"` / `NUMBER` | exact text / named token |
| reference | another rule's name | recurse / compose |
| **capture** | `name:thing` | bind a sub-result |
| **build** | `-> Ctor(a, b)` | construct the AST node from captures |
| errors | `@expect(tok, msg)` `@recover(sync_to: tok)` | message + panic-mode recovery |

`capture` + `build` are the only additions beyond textbook EBNF — they're what
make the grammar *produce the AST* instead of merely validating. Everything else
is Crafting Interpreters Ch5 §5.1.2–3 verbatim.

**Hard line (keeps it lightweight):** no inline semantic actions / arbitrary
code in rules. Anything needing real logic drops to a hand-written rule (§5).

---

## 2. The grammar — Avra's expression slice

Nystrom's precedence-stratified expression grammar, in the DSL. Precedence and
associativity are expressed by **rule stratification** — no extra notation:

```avra
grammar Expr {
    expression = equality
    equality   = l:comparison ( op:("!=" | "==") r:comparison )*    -> fold_binary(l, op, r)
    comparison = l:term       ( op:("<"|"<="|">"|">=") r:term )*    -> fold_binary(l, op, r)
    term       = l:factor     ( op:("+" | "-")  r:factor )*         -> fold_binary(l, op, r)
    factor     = l:unary      ( op:("*" | "/")  r:unary )*          -> fold_binary(l, op, r)
    unary      = op:("!" | "-") operand:unary                       -> Unary(op, operand)
               | primary
    primary    = NUMBER | STRING | "true" | "false"
               | "(" e:expression ")"
                     @expect(")", "expected ')' to close the group")
                     @recover(sync_to: ")")                         -> e
}
```

`fold_binary(l, op, r)` left-folds the repeated `(op r)*` into a left-associative
`Expr.Binary` chain (a tiny library helper, not grammar syntax).

---

## 3. Tokens the lexer feeds it

Named terminals (`NUMBER`, `STRING`) and the literal terminals (`"=="`, `"("`, …)
come from the lexer. The lexer — not the grammar — owns the lexical concerns:

```
NUMBER  STRING  IDENT  "true"  "false"
"(" ")" "!" "-" "+" "*" "/" "==" "!=" "<" "<=" ">" ">="
```

---

## 4. What it lowers to — the generated parser

Each rule becomes one function, by Nystrom's grammar→RD correspondence
(terminal → match/consume, nonterminal → call its fn, `|` → if, `*` → loop). The
generator emits this (via `quote`); it's the parser you'd have hand-written:

```avra
// equality = l:comparison ( op:("!=" | "==") r:comparison )* -> fold_binary(l, op, r)
fn parse_equality(p: Parser) -> ExprId {
    mut acc = parse_comparison(p)            // l:comparison   → call + capture
    while p.match("!=", "==") {              // ( … )*         → while + alt terminals
        let op = p.previous()                // op:(…)         → capture matched token
        let r  = parse_comparison(p)         // r:comparison   → call + capture
        acc = fold_binary(acc, op, r)        // -> fold_binary(l, op, r)
    }
    acc
}

// unary = op:("!" | "-") operand:unary -> Unary(op, operand) | primary
fn parse_unary(p: Parser) -> ExprId {
    if p.match("!", "-") {                   // first alternative's leading terminal
        let op = p.previous()
        let operand = parse_unary(p)         // recursion
        return p.node(Expr.Unary(op, operand))   // -> Unary(op, operand)
    }
    parse_primary(p)                         // | primary
}

// primary = NUMBER | STRING | "true" | "false"
//         | "(" e:expression ")" @expect(")", …) @recover(sync_to: ")") -> e
fn parse_primary(p: Parser) -> ExprId {
    if p.match(NUMBER, STRING, "true", "false") {
        return p.node(Expr.Literal(p.previous()))
    }
    if p.match("(") {
        let e = parse_expression(p)
        p.expect(")", "expected ')' to close the group",
                      recover_to: ")")       // @expect + @recover (panic-mode synchronize)
        return e                             // -> e
    }
    p.error_node("expected an expression")   // error-tolerant: emit error-node, never bail
}
```

The `p.error_node(...)` and `recover_to:` paths are how the grammar satisfies
Layer 1's **error-tolerant** requirement — a broken input yields a partial tree
plus diagnostics, not a hard stop.

---

## 5. The boundary — what stays OUT (the gnarly 5%)

A small CFG notation cannot cleanly express context-sensitive / lexical things.
Avra's handful live in the **lexer** or a **hand-written escape-hatch rule** —
they never grow the grammar notation:

| Construct | Why it resists EBNF | Where it goes |
|---|---|---|
| `"…{expr}…"` string interpolation | nested grammar inside a token | **lexer mode** |
| newline-sensitivity (no `;`) | layout, not CFG | **lexer** emits `NEWLINE` |
| `~` = splice in `quote`, bitnot outside | context-dependent meaning | **lexer/escape-hatch** |
| `<T>` generics vs `<` less-than | needs lookahead/disambiguation | **escape-hatch rule** |

This boundary is the discipline that keeps the DSL at ~9 constructs even though
the grammar it expresses is all of Avra.

---

## 6. The seed — the grammar-of-grammars

The DSL is read by one small, hand-written recursive-descent parser (the seed,
~200 lines, written **once**, never churns — EBNF is stable). Its own grammar is
~8 rules and self-describing:

```
grammar  = rule+
rule     = NAME "=" alt
alt      = seq ( "|" seq )*
seq      = labeled+ ( "->" build )? annot*
labeled  = ( NAME ":" )? postfix
postfix  = primary ( "*" | "+" | "?" )?
primary  = NAME | STRING | "(" alt ")"
annot    = "@expect" "(" … ")" | "@recover" "(" … ")"
```

No bootstrap circularity: the seed parser is hand-written, exactly as yacc has a
hand-written parser for yacc input and tree-sitter for its grammar DSL. It reads
grammar files into a grammar-AST; the generator turns that into the functions of
§4.

---

## 7. Why this is just "recursive descent, automated"

Nystrom proves the grammar→recursive-descent translation is **mechanical and
1:1** — in the book he does it *by hand*, rule by rule, including `synchronize()`
for recovery. This DSL changes exactly one thing: the **generator does that same
mechanical translation**, and `@expect`/`@recover` lift the by-hand
`synchronize()` into the grammar so the error story is authored in the one source
of truth.

- **Nystrom:** grammar (notation) + by-hand translation + by-hand `synchronize()`.
- **Ours:** the same grammar notation, auto-translated, recovery folded in.

No information is lost in generation, because the mapping is deterministic — that
is the whole reason "derive the parser" is safe.

---

## 8. Next step

Prove §2 → §4 for real on the expression slice: build the ~200-line seed parser
(§6) + the generator (grammar-AST → the §4 functions), run it, and show it
producing real `Expr` nodes. If clean, scale rule-by-rule to the rest of Avra,
honoring the bootstrap window (feature + tests land before dogfooding into
compiler `src/`).
