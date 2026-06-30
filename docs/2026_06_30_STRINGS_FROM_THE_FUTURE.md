# Strings From the Future — and the Language That Follows From Them

> **Status:** Design / vision spec. **Aspirational syntax** — none of this compiles
> today. It is internally consistent so the model can be felt under real code.
> **Scope:** begins as a string-model redesign and generalizes into a language-wide
> thesis. Companion to the authoritative `docs/2026_04_18_FULL_SPEC.md`; where they
> disagree, this document is the *proposal* and the FULL_SPEC is *current law*.
>
> **Origin:** captured verbatim from a design conversation. All code snippets, ideas,
> tables, and slogans are preserved. Slogans appear as block quotes and are
> reproduced word-for-word.
>
> **Design philosophies driving every decision** (project axioms):
> - **Collapse the paradox** — don't pick a horn of a dilemma; find the synthesis
>   that dissolves the trade-off.
> - **The most beautiful language in the world** — clean, declarative; not terse,
>   not ugly, not functional-duct-tape.
> - **As performant as Rust** — zero-cost where it matters, no hidden allocations,
>   no hidden O(n), cost legible at the call site.
> - **Agent-first** — designed so an autonomous author (an LLM) either writes
>   correct code or is rejected with a machine-actionable error.
>
> **Related tickets:** `h78d` (typed string patterns in match), `29f3` (string
> `s[i]` → `u8` + `bytes` indexing), `bw1y` (nullable indexing diagnostic),
> `pmo3` (newtype-of-list indexing transparency).

---

## Table of contents

1. Part I — The string-indexing problem (`s[i]`: byte vs char)
2. Part II — Design from first principles: collapse the paradox
3. Part III — Dialing it in: Avra's pillars dissolve Rust's ceremony
4. Part IV — Worked code examples (complete)
5. Part V — Taking it further: a format is a value the compiler runs in every direction
6. Part VI — Even further: the five language-wide escalations + the apex
7. Part VII — Slogans & principles (verbatim)
8. Part VIII — Open questions
9. Appendix — decisions & ticket map

---

# Part I — The string-indexing problem

The presenting bug (`29f3`): the spec says `s[i]` returns `u8`; the implementation
returns a 1-char string by *byte* index, which can return **half a multibyte
character** — invalid UTF-8 masquerading as a string. That forced the deeper
question: what *should* `s[i]` do?

## The root issue

Avra strings are **UTF-8 bytes** under the hood, and a UTF-8 string is *not* an
array of characters — a "character" can be 1–4 bytes. So `s[i]` has to pick what
`i` counts (bytes? codepoints? graphemes?) and what it hands back. And Avra **has
no `char` type today**, which is what makes every option awkward.

## The head-to-head (byte vs 1-char string)

| | `s[i] → u8` (byte, spec's choice) | `s[i] → 1-char string` (Python/JS-style) |
|---|---|---|
| **Cost** | O(1), zero-alloc | O(n) to find the i-th codepoint (UTF-8 is variable-width), or allocates |
| **Correctness** | Honest about the byte model | Current impl indexes by *byte* and wraps it → can return **half a multibyte char** = invalid UTF-8 masquerading as a string |
| **Ergonomics** | `s[i] == "a"` doesn't typecheck; you're stuck writing `s[i] == 97` | `s[i] == "a"` reads naturally |
| **The trap** | none hidden — it's loud | `for i in 0..s.length { s[i] }` is silently **quadratic**, and that's the exact loop an LLM writes |

## The LLM-intuition lens (it cuts both ways)

- LLMs are trained on Python/JS, so their overwhelming prior is "`s[i]` is a
  1-char string I can compare with `==`." Returning `u8` violates that prior at
  *every* call site.
- But LLMs also write the *buggy* version of this constantly (assume
  `len == char count`, mishandle emoji/accents, O(n²) loops). Avra's superpower is
  **compile-time gating with teaching diagnostics** — turning those silent runtime
  bugs into a fixable F-code the model sees in-loop. That argues *for* the stricter
  choice, not the familiar one.

## Prior art (how other languages chose)

- **Go**: `s[i] → byte`. Simple, O(1), but indexes into multibyte chars give fragments.
- **Rust**: `s[i]` is a compile error; use `.bytes()`, `.chars()`, or `&s[i..j]` (panics on non-char boundary).
- **Python 3**: `s[i] → 1-char str` by codepoint, O(1) — but only because it abandons UTF-8 internally (flexible latin1/UCS2/UCS4 representation).
- **JS**: `s[i] → 1-char string` by UTF-16 code unit (surrogate-pair footgun).
- **Swift**: integer subscript forbidden; opaque `String.Index`. Correct model, hideous ergonomics.

## First recommendation (before the redesign)

Ranking, as designer:

> `char` (with a real char type) **>** `u8` (honest but unergonomic, and forces
> `== 97`) **>>** today's "1-char string at byte index" (silently wrong on
> anything non-ASCII — the worst of all worlds).

The concrete first lean (before the redesign): add a `char` type with `'x'`
literals, make `string` a sequence of `char` and `bytes` a sequence of `u8`
("the type you chose to hold the data decides what indexing means"); accept O(n)
string indexing but make iteration the idiomatic path and **lint `s[i]` inside a
counting loop** to catch the accidental-quadratic trap.

(The redesign in Parts II–III goes further: the *lint* becomes a hard
**compile error** — no bare `s[i]` and no bare iteration at all — everything goes
through typed lenses.)

## `29f3` is really two tickets hiding as one

1. **The small fix:** stop returning a byte-fragment-as-string (the current
   silent-invalid-UTF-8 bug).
2. **The real design call:** introduce a `char` type, make `string` char-indexed,
   and leave `u8` to `bytes` — likely a split-off `char`-type ticket.

This kicked off the from-scratch redesign in Part II.

---

# Part II — Design from first principles: collapse the paradox

## Name the real paradox

It's *not* "byte vs char." That's a symptom. The actual paradox is:

> `s[i]` is asked to be **O(1)** (Rust), **Unicode-correct** (chars, not bytes),
> and **obvious** (`s[i]` is "the i-th character"). On UTF-8, variable width makes
> O(1)-random-codepoint physically impossible — so all three can't hold *as long
> as `i` is an integer count*.

Every language picks a horn: Go drops correctness (bytes), Python drops the
representation (abandons UTF-8 to fake O(1)), Rust/Swift drop obviousness
(forbid / `String.Index`). Nobody collapses it.

## The collapse: `int` is conflating two different things

`i: int` is forced to mean both:

1. a **position** in the string — which *wants* to be O(1) to use, and
2. a **count** (the n-th codepoint) — which *is* O(n) to find on UTF-8.

Split them and the paradox evaporates, because each becomes exactly one thing at
its true cost:

- **Position → `Cursor`** — an opaque value holding a byte offset. O(1) to
  dereference, O(1) to advance. This is what iteration and search hand you.
- **Count → `s.char(n)`** — honestly O(n), and *named* like it.

That's the whole trick. Now everything beautiful falls out, and all of it is O(1):

```avra
for c in s            { … }      // c: char   — zero-cost UTF-8 walk
for (at, c) in s.cursors() { … } // at: Cursor — when you need the position
s.first                          // char?      O(1) front
s.last                           // char?      O(1) back
match s {
    ""              -> …
    "{head}{tail}"  -> …         // head: char (O(1) decode), tail: string (O(1) slice)
}
let c = s.find("x")?             // c: Cursor
s[c]                             // char,   O(1)
s[c..]                           // string, O(1)
```

The unit is named by the **type**, which kills bytes-vs-chars at the door:

- `string` = sequence of `char` (Unicode scalar). `'a'` is a `char`, so
  `s.first == 'a'` reads right.
- `bytes` = sequence of `u8`. Here `b[i: int] → u8` is honestly O(1), so integer
  indexing **is** allowed and pretty.
- `grapheme` = a *distinct* type via `s.graphemes()` for human-facing "characters"
  (emoji-correct). Kept separate so you never pay Unicode-segmentation cost or
  carry the tables unless you ask.

## The one deliberate "no" — and why it's *pro*-agent

`s[i: int]` on a `string` is a **compile error**, not a silent O(n) or a byte.
The F-code names the three intents:

```
error[F12xx]: an `int` doesn't name a position in a UTF-8 string
  help: iterate `for c in s`, take `s.first`/`s.last`, slice with a `Cursor`
        from `s.find(..)`, or — if you really want the n-th codepoint —
        `s.char(n)` (O(n)). For raw bytes use `s.bytes[i]`.
```

This is the *only* place we refuse Python's pretty-but-lying default, and it's
the right place: that default is the single root of every Unicode bug *and* every
accidental-quadratic loop LLMs write. An agent-first language's superpower is
turning a silent runtime bug into a fixable compile error in the model's loop — so
we spend it exactly here. The common paths (`for c in s`, `match "{head}{tail}"`)
are *more* intuitive than `s[i]` anyway, so we lose almost no ergonomics to gain
all the correctness.

## Two corollaries

**Slicing collapses Rust's `String`/`&str` split.** SSO (≤23 B inline) means a
slice of a small string is a sub-24-byte copy (free); a slice of a heap string is
a buffer-shared view (free). So one `string` type is *always* cheap to slice — the
user never sees owned-vs-borrowed, yet it's zero-copy where it matters. A second
paradox (ergonomics vs zero-copy) collapsed by leaning on a feature you already
have.

**`.length` gets the same treatment.** Bare `s.length` is its own little lie (LLM
expects char count, spec returns bytes). Same fix: no bare `.length` on a string —
`s.bytes.length` (O(1)) and `s.chars.count()` (O(n)). `s.bytes` is the `bytes`
view, `s.chars` the char sequence; the cost is legible from which one you reach for.

## The escape hatch for true O(1) random access

For the genuine 1% — a parser hopping over a huge buffer *by codepoint count* —
the `Cursor`/`s.char(n)` split still leaves random access at O(n). The escape
hatch: an opt-in `IndexedString` that carries a codepoint→byte-offset table,
giving O(1) random codepoint access. Pay-for-what-you-use, never the default tax.
That closes the paradox even for the 1% case.

---

# Part III — Dialing it in: Avra's pillars dissolve Rust's ceremony

## The thesis

> Avra already has every piece Rust pays for with ceremony.

Rust's string design is correct but ugly because it solves each sub-problem with
*lifetimes and ceremony*. Avra has existing pillars that dissolve each one for
free. The dial-in isn't inventing features — it's noticing the pieces were already
on the board:

| Rust's pain point | Avra pillar that collapses it |
|---|---|
| `&str` vs `String` (borrow vs own) | **Refcounting** — a slice is a view that holds a ref to the buffer. No lifetimes. |
| `&s[0..1]` **panics** mid-codepoint | **Typed cursors per lens** — a `Chars`-cursor only lands on codepoint boundaries, so the bad slice is *unconstructable*. |
| Cursor/iterator invalidation | **Immutable strings** — a cursor into an immutable buffer never invalidates. No generation counters, no lifetimes. |
| `.chars().count()` is O(n) | **Comptime** — for literals/constants it folds to a constant (O(0)). The cost only exists for genuinely-runtime strings. |
| `String::new(); push_str` boilerplate | **Pre-sized interpolation** — `"{a}{b}{c}"` lowers to one sized alloc + fill, never iterative concat. |
| Slice view costs nothing (lifetimes) | **Escape analysis** — elide the refcount bump when the view doesn't escape; hot-path slicing is then *truly* zero-cost, escaping slices pay one cheap bump. |

> Unicode-correct strings, as easy as Python and as fast as Rust, fall out of
> guarantees Avra already makes — nobody had assembled them.

**Note (manual-memory `scopes`):** Avra will have `scope` blocks that drop
refcounting and move to manual/borrow memory management (Rust-like). Inside a
`scope` there is no refcount at all — slices become pure compile-time-checked
borrows, so string slicing is *unconditionally* zero-cost there. Escape analysis
is just what recovers that same zero-cost in the *refcounted* regions for the
common (non-escaping) case.

## Escape analysis, in plain terms

A slice is a *view* into a string's buffer. To keep that buffer alive while the
view exists you would normally bump a refcount. **Escape analysis is the compiler
asking: "does this view outlive the function that made it?"**

- **No** (you read it and drop it locally) → it can't dangle → skip the bump.
  **Free.**
- **Yes** (you return it or store it in a field) → it escapes → pay the one cheap
  bump.

So local throwaway slices cost nothing; only the ones you *keep* pay. And inside a
manual-memory `scope` there is no refcount at all — slices are pure
compile-time-checked borrows (Rust-like), so slicing there is *unconditionally*
zero-cost. Escape analysis is just what recovers that same zero-cost in the
refcounted regions for the common, non-escaping case.

## Resolve the open question: there is no bare `s[i]` *or* bare `for c in s`

Take "name the unit" all the way. `s` is a buffer; you always view it through a
**lens**, and each lens is a real sequence with its own cursor space:

```avra
s.bytes        // Seq<u8>        — O(1) index, O(1) length
s.chars        // Seq<char>      — codepoint cursors, ASCII-correct, fast
s.graphemes    // Seq<grapheme>  — human "characters", emoji-correct, opt-in tables
```

This kills the char-vs-grapheme default debate by **deleting the default**. No
silent wrong answer is possible because there's no bare answer — and `s.chars` is
short enough that beauty doesn't suffer. Cursors are typed by lens, so `s.chars[c]`
can't land mid-codepoint and `s.bytes[i]` is honest O(1). The three lenses share
the *same* underlying buffer and byte-offset cursor representation — one data
structure, three granularities, zero copies.

*(This supersedes the Part II sketch where `for c in s` was written bare; the
dialed-in model iterates a lens. Both are kept here for the record.)*

## The crown jewel: typed string patterns — parsing without a parser

This is where "most beautiful" becomes a *signature* feature. `match` on a string
destructures it, captures bind to O(1) slices, and typed captures parse-and-validate:

```avra
match req.line {
    "GET {path} HTTP/1.{minor: int}"  -> serve(path, minor)   // minor: int, parsed+checked
    "{method} {path} HTTP/{_}"         -> reject(method, path) // method,path: string slices (O(1))
    _                                   -> bad_request()
}
```

The guarantee that keeps it Rust-fast: a pattern compiles to a **single anchored
left-to-right scan** — each `{cap}` consumes until the next literal, no
backtracking, no catastrophic regex blowup. Linear time, by construction. This
collapses the "reach for a regex/parser lib" paradox: simple structured text is
handled *in the language*, typed, and O(n). Combined with head/tail recursion
(`"{head}{tail}"` → `char` + O(1) slice) and guards, it's a tiny declarative
parser language hiding inside `match`.

**Is it performant?** Yes — single left-to-right scan, each capture consuming up
to the next literal, no backtracking → linear time O(n), identical to a
hand-written parser. Typed captures (`{n: int}`) are just an inline parse on that
slice.

**Does any other language have it?** The *pieces* exist; the clean combo is rare:
**Raku (Perl 6) grammars** (closest built-in declarative parser, heavier),
**Scala** (regex/string extractors in `match`, `case r"(\d+)" =>`), **F# active
patterns** (can express it, less literal), **C `sscanf` / Python `parse`** (same
idea, runtime, not in `match`). No mainstream language appears to offer
*format-string-as-pattern with **typed** captures, **inside match arms**, with a
**linear-time guarantee***. Strong differentiator, not a clone.

**No regex, then?** Not "no regex" — regex stops being your *first* reach. The
patterns handle fixed-shape text; regex stays for genuinely *variable* patterns
(alternation, repetition, character classes, optionals). If/when regex ships it
should be the **linear-time kind** (RE2 / Thompson-NFA — no catastrophic
backtracking) so it doesn't break the performance story.

## The invariants that make it sound

> An **invariant** is a fact the code guarantees is always true, so nothing
> downstream has to re-check it. Enforce it at one chokepoint → everything else
> gets simpler *and* faster.

1. **A `string` is always valid UTF-8.** Enforced at the *only* entry point — the
   bytes→text boundary:
   ```avra
   bytes.text()         // string?   validated (the safe default)
   bytes.text_lossy()   // string    U+FFFD-replaced, infallible
   ```
   Because the invariant holds, every downstream `.chars` walk skips per-step
   validity checks — that's where Rust-speed iteration comes from.
2. **Cursors are valid for their string forever** (immutability) and **aligned to
   their lens** (typed). Two whole error classes (invalidation, mid-codepoint
   slice) simply don't exist.
3. **Construction is always O(n).** Interpolation pre-sizes; `parts.join(sep)` is
   one pass; a `text { }` builder block uses amortized growth. The pretty syntax
   *is* the optimal builder — so the O(n²)-concat trap is unwritable.

## The unification that ties it shut

None of this is string-special. `list`, `s.bytes`, `s.chars`, `s.graphemes` all
implement **one `Seq` protocol** (cursor, slice, `find`, iterate, pattern-match).
You learn sequences *once* and it works everywhere — strings are just sequences you
reach through a lens. That's the final collapse: there is no separate "string API"
to memorize, which is itself a huge beauty + LLM-intuition win.

## The dialed-in one-liner

> A `string` is an immutable, always-valid-UTF-8 buffer you view through typed
> lenses, where every operation's cost is legible in its name and every Rust-style
> hazard is dissolved by a guarantee Avra already makes.

---

# Part IV — Worked code examples (complete)

> Illustrative, aspirational syntax — internally consistent so the model can be
> felt under real code.

## Flagship: parse an HTTP request from raw bytes

Combines the UTF-8 invariant, zero-copy slices, the crown-jewel typed match,
iteration, and `Result`/`?`.

```avra
type Request = {
    method: string
    path: string
    version: (int, int)
    headers: Map<string, string>
}

enum HttpError { InvalidUtf8, BadRequestLine(string), BadHeader(string) }

fn parse_http(raw: bytes) -> Result<Request, HttpError> {
    // 1. bytes -> string: the ONE UTF-8 checkpoint. Nothing downstream re-checks.
    let text = raw.text() ?? return Err(.InvalidUtf8)

    // 2. Split request line from the header block. `lines` yields O(1) slices
    //    that share `text`'s buffer — no copies.
    let (line, rest) = text.split_first('\n') ?? return Err(.BadRequestLine(text))

    // 3. Crown jewel: parse the line declaratively. `{major: int}` parses AND
    //    validates; if it isn't an int the arm fails and we fall through.
    let (method, path, version) = match line.trim() {
        "{method} {path} HTTP/{major: int}.{minor: int}" -> (method, path, (major, minor))
        _ -> return Err(.BadRequestLine(line))
    }

    // 4. Headers: iterate slices, match each. `name`/`value` are O(1) views.
    mut headers = {}
    for h in rest.lines() {
        match h.trim() {
            ""                -> {}                      // end of headers
            "{name}: {value}" -> headers[name] = value
            _                 -> return Err(.BadHeader(h))
        }
    }

    Ok(Request { method, path, version, headers })
}
```

## Grapheme-correct truncation — the lens *names the intent*

Shows: lens correctness (emoji-safe), O(1) slice, pre-sized interpolation, comptime const.

```avra
// Truncate to `width` user-perceived characters. `.graphemes` means we never
// split an emoji or a combining sequence — `.bytes`/`.chars` would.
fn ellipsize(s: string, width: int) -> string {
    if s.graphemes.count() <= width { return s }
    let cut = s.graphemes.cursor_at(width - 1)   // walk to a real boundary
    "{s[..cut]}…"                                // O(1) slice + one sized alloc
}

const FLAG_WIDTH = "🇺🇸🇬🇧🇫🇷".graphemes.count()   // == 3, folded at COMPILE time (O(0))

ellipsize("café ☕ time", 6)   // "café ☕…"  — the ☕ stays whole
```

## A lexer — cursors, head/tail, O(1) slices, the `Seq` protocol

```avra
enum Token { Ident(string), Number(int), Symbol(char) }

fn lex(src: string) -> List<Token> {
    mut toks = []
    mut rest = src
    while rest != "" {
        match rest {
            // head/tail: `c` is a char (O(1) decode), `tail` an O(1) slice
            "{c}{tail}" if c.is_space() -> rest = tail
            "{c}{_}"    if c.is_digit() -> {
                let end = rest.chars.find((ch) -> !ch.is_digit()) ?? rest.chars.end
                toks.push(.Number(rest[..end].parse()!))   // slice -> int
                rest = rest[end..]                          // advance, O(1)
            }
            "{c}{_}"    if c.is_alpha() -> {
                let end = rest.chars.find((ch) -> !ch.is_alnum()) ?? rest.chars.end
                toks.push(.Ident(rest[..end]))             // Ident holds a view
                rest = rest[end..]
            }
            "{c}{tail}" -> { toks.push(.Symbol(c)); rest = tail }
        }
    }
    toks
}
```

## The bytes→string boundary — the invariant, made of one call

```avra
fn decode(raw: bytes) -> Result<string, int> {
    raw.text() ?? Err(raw.first_invalid_offset())   // string? -> Result; the only check
}

fn log(raw: bytes) {
    print(raw.text_lossy())   // bad bytes -> U+FFFD, infallible, still valid UTF-8
}
```

## Manual-memory `scope` vs escaping slice — the RC note + escape analysis

```avra
// In a `scope`: no refcounting. Every slice is a compile-time-checked borrow of
// `src`, can't outlive it — so all of this is unconditionally zero-cost.
fn count_words(src: string) -> int scope {
    mut n = 0
    for w in src.split(' ') {     // `w` borrows `src`
        if w != "" { n += 1 }     // read-only, never escapes -> free
    }
    n
}

// Outside a scope (refcounted region):
fn longest(src: string) -> string {
    src.split(' ').max_by((w) -> w.chars.count()) ?? ""
    // the returned slice ESCAPES -> one refcount bump keeps src's buffer alive.
}

fn has_tab(src: string) -> bool {
    src.bytes.contains('\t')      // view never escapes -> escape analysis elides the bump
}
```

## `Seq` unification — strings aren't special

```avra
// Works over ANY Seq — a list, the chars lens, the bytes lens. Learn it once.
fn first_run<T>(xs: Seq<T>, same: (T, T) -> bool) -> (Cursor, Cursor)? {
    let start = xs.first_cursor ?? return null
    let end = xs.find_from(start, (x) -> !same(x, xs[start])) ?? xs.end
    (start, end)
}

first_run([3, 3, 3, 9], (a, b) -> a == b)        // list
first_run(name.chars, (a, b) -> a == b)          // run of repeated chars
first_run(packet.bytes, (a, b) -> a == b)        // run-length over bytes
```

## Building strings — the pretty form *is* the optimal builder

```avra
let banner = "Hello, {user.name}! You have {inbox.count} unread."  // ONE sized alloc

let csv = rows
    |> map((r) -> r.join(","))   // each row: one pass
    |> join("\n")                // whole doc: one pass, total length pre-computed

// And the classic trap is made harmless — `+=` in a loop lowers to amortized
// append (capacity doubling), never realloc-every-iteration:
mut out = ""
for line in lines { out += "> {line}\n" }
```

> **Observation writing these:** the crown-jewel match + slices + the `Seq`
> protocol carry almost every example, and they all lean on the same **two
> guarantees** — *immutable* + *valid-UTF-8*. That's a good sign the model is
> actually **one idea, not a bag of features**.

---

# Part V — Taking it further: a format is a value the compiler runs in every direction

The reframe that gets to "holy shit." Everything above treats a format as *code
you run forward*. Take the leap:

> A format is a value the compiler can run in every direction — forward (parse),
> backward (print), symbolically (prove things about it), and generatively
> (fuzz/document it) — and the data it yields are zero-copy views the language
> already keeps safe.

Text stops being fragile imperative code and becomes a *declarative artifact the
compiler reasons about*. Six moves.

## Move 1 — Bidirectional: one format, both directions, *proven* inverse

A `grammar` is a first-class value. Read forward it parses; read backward it
prints. You write it **once**, and parser/serializer can never drift:

```avra
grammar RequestLine = "{method} {path} HTTP/{major: int}.{minor: int}"

let req  = RequestLine.parse("GET /x HTTP/1.1")?          // forward
let line = RequestLine.print(method: "GET", path: "/x", major: 1, minor: 1)  // backward → "GET /x HTTP/1.1"

#assert RequestLine.round_trips        // print ∘ parse == id, proven at COMPILE time
RequestLine.sample(seed)               // a random VALID line — a fuzzer, for free
RequestLine.railroad()                 // a syntax diagram / spec — docs, for free
```

**Collapses:** the parser-vs-serializer duplication (and their eternal drift).
**Holy shit:** you get a parser, a printer, a fuzzer, and a spec from one line —
and the compiler *proves* they agree.

## Move 2 — Illegal strings are *unrepresentable*

Provenance rides in the type. Untrusted text is `Tainted`; sinks demand escaped
types. Injection becomes a **type error**:

```avra
fn handler(input: Tainted<string>) -> Response {
    // db.query("… name = {input}")        // ❌ compile error: tainted into a SQL sink
    db.query(sql"… name = {input}")        // ✅ sql"" escapes → produces Sql
    html"<p>Hello {input}</p>"             // ✅ html"" escapes → produces Html
}
```

And refinement types — a `string` carrying a *proof*, validated once, then free:

```avra
type Email = string where it.matches(EMAIL)
type Port  = int    where 1 <= it && it <= 65535

let e: Email = "a@b.com"        // literal → checked at COMPILE time
let e2 = Email.parse(raw)?       // boundary → Result
fn send(to: Email) { … }         // a raw string simply won't type-check here
```

**Collapses:** security-vs-ergonomics. **Holy shit:** SQLi/XSS aren't bugs you
avoid — they're programs that don't compile, at zero runtime cost.

## Move 3 — Zero-copy structured views + SIMD scanners

Generalize "a string slice is a view" to *all* data. Deserialization stops
allocating:

```avra
let doc  = json.view(buf)?            // `doc` borrows `buf` — no allocation
let name = doc["user"]["name"].text   // a slice of `buf`, zero copy
// safe because: buf is immutable (can't mutate under the view) + cursors can't dangle

buf.bytes.find('\n')                  // the scanners are SIMD — simdjson-fast, for free
```

**Collapses:** safety-vs-performance. **Holy shit:** parsing is free (views, no
copy) and faster than naïve hand-written Rust, because the stdlib scans vectorize.

## Move 4 — The same grammar runs on a literal *or* a live stream

One declaration, batch and streaming. The matcher suspends when it needs more bytes:

```avra
for req in socket.bytes.parse_stream(RequestLine) {   // resumable, backpressure-aware
    handle(req)
}
```

**Collapses:** the batch-parser-vs-streaming-parser fork everyone maintains twice.
**Holy shit:** you never write a streaming parser again — the grammar already is one.

## Move 5 — The compiler proves your protocol is backward-compatible

Because grammars are *data*, you can diff two versions and have the compiler verify
the wire contract:

```avra
#assert RequestLine_v2.accepts_all(RequestLine_v1)   // v2 can still parse every v1 input
#assert Router.routes.no_overlap                      // no two routes ambiguous
#assert Router.routes.exhaustive(over: Method × Path) // no unreachable / missing route
```

**Collapses:** "move fast" vs "don't break the wire." **Holy shit:** breaking a
protocol or shadowing a route becomes a *compile error*, like exhaustiveness
checking — but for grammars and APIs.

## Move 6 — Mutable text, collapsed (the open question, answered)

A `string` is a **persistent rope**: edits are O(log n), value semantics, and old
cursors/slices stay valid because edits share structure:

```avra
let v2 = doc.replace(span, "new")    // O(log n); `doc` and every cursor into it unchanged
```

**Collapses:** immutable-value-semantics vs in-place editing — the last paradox
left open. **Holy shit:** editor-grade text with pure value semantics and no
separate "mutable buffer" type.

## The Part V synthesis

> In Avra you declare the *shape* of data once, and the compiler hands you the
> parser, the printer, the validator, the fuzzer, the docs, the streaming version,
> world-class error messages, and a machine-checked proof that they all agree —
> over zero-copy views the language keeps safe for free.

And the agent-first tie-in: because formats are introspectable values, the
toolchain can autocomplete *inside* a string literal against its grammar and tell
an LLM exactly which tokens are valid next. An agent writing Avra **cannot emit a
malformed route or a broken format** — the grammar is right there as typed context.

> The string model and the "agent-first" thesis turn out to be the same idea: make
> the structure of data legible to the compiler, and both humans and models stop
> being able to get it wrong.

---

# Part VI — Even further: the five language-wide escalations + the apex

Stop talking about strings. Everything above was a *keyhole*. The language from
the future is what you get when those properties hold for **every dimension of a
program, not just text.** Each escalation generalizes a string insight to the whole
language.

## 1. Invertible by default — define a relationship once, run it both ways

`parse ⟷ print` was a special case. Make *relationships* first-class and the
compiler derives + proves the inverse:

```avra
iso CelsiusF       { c <-> c * 9/5 + 32 }
migration V1 <-> V2 { add email = "" }      // write UP, DOWN is derived & proven inverse
```

Every encode/decode, schema up/down, redo/undo, get/set, optimistic-update/rollback
pair — **written once.** **Collapses:** the entire "now write the inverse" half of
your codebase. **Holy shit:** that half stops existing, and the compiler proves the
two directions agree.

## 2. Incremental & time-traveling by default — a spreadsheet that's as fast as Rust

Persistent ropes generalize: *all* state is a persistent value, every computation
tracks its inputs, so changing an input recomputes only what it touched:

```avra
let total = cart.map(price).sum()   // a derived value, not a snapshot
cart.push(item)                     // recompute is O(change), not O(n)
app.at(yesterday)                   // any past state — free (persistent history)
why(total)                          // provenance: exactly which inputs produced this
```

**Collapses:** "fast" vs "reactive/observable." **Holy shit:** it recomputes like
a spreadsheet, runs like Rust, and time-travel debugging + incremental rebuild are
*language features*, not tools you bolt on.

## 3. One lattice for everything illegal — effects, capabilities, units, taint, refinements

`Tainted<string>` was one axis. Unify all of them into a single, mostly-*inferred*
qualifier system:

```avra
fn charge(amount: USD, card: Cap<Charge>) -> Result<Receipt> uses {Net, !Panic}
pure fn price(...)         // does IO? compile error.
// USD ≠ EUR (units), Cap gates the action, `uses {Net}` is the effect row,
// `!Panic` proves it can't crash — all one mechanism, annotated only at boundaries.
```

**Collapses:** safety-vs-ergonomics, across *five* classic systems folded into one.
**Holy shit:** effect tracking, capability security, units-of-measure, taint, and
refinement types are the *same feature* — "illegal programs are unrepresentable,"
not just illegal strings.

## 4. Cost is part of the type — performance regressions are compile errors

"The compiler owns the builder's perf" generalizes to: cost is *checked.*

```avra
fn handler(req) -> Resp within O(1)        // accidental O(n) won't compile
fn sort<T>(xs: List<T>) -> List<T> within O(n log n)
```

**Collapses:** "fast" vs "*stays* fast." **Holy shit:** "as performant as Rust"
becomes "performance is a contract the type system enforces" — the O(n²) concat
trap and all its cousins become *unrepresentable* in a cost-bounded region.

## 5. The language is made of itself, and addressed by meaning

"The grammar is a value the compiler runs" generalizes: the AST, type checker, and
optimizer are **in-language libraries.** The whole string feature designed here
would just be a *package*, not a builtin:

```avra
@derive(Json, Diff, Fuzz, Wire)     // these are Avra comptime libraries, not magic
syntax sql = grammar { … }          // add SQL-as-syntax as a typed package
```

…and every definition is identified by the **hash of its meaning** (Unison-style):
no version conflicts, perfect build caching, refactors are graph renames, the
codebase is a queryable database. **Collapses:** "rich builtins" vs "small core,"
and "move fast" vs "dependency hell." **Holy shit:** the language *grows from
libraries*, builds are perfectly incremental, and dependency hell is gone because
identity is meaning, not a version string.

## The meta-thesis

> The more the compiler knows, the less the program costs *and* the less anyone —
> human or AI — can get it wrong.

> A language from the future is just one that maximizes what the compiler knows
> about every dimension — shape, provenance, effect, cost, history, identity — and
> spends that knowledge *twice*: once to erase the runtime cost, once to erase the
> footgun.

## The apex — and why it has to be *this* language

Avra is **agent-first**, and that's not a feature, it's the *point* of all of the
above. Every property an AI could break — a wire format, an effect boundary, a cost
bound, a refinement, a route's exhaustiveness — is machine-checked, and every error
carries a **machine-applicable fix.** So:

> Avra is the first language where an AI literally cannot merge a regression. The
> type system is the senior reviewer that never sleeps — and when it rejects the
> agent's edit, it hands back the patch. The loop provably converges to correct.

That's the "holy shit." Not any single feature — the realization that

> legibility to the compiler and safety for an autonomous author are the same axis,
> and you can crank it until writing a bug is, for a whole class of bugs,
> impossible.

---

# Part VII — Slogans & principles (verbatim)

Reproduced word-for-word from the design conversation.

1. > It's *not* "byte vs char." That's a symptom.

2. > `s[i]` is asked to be **O(1)** (Rust), **Unicode-correct** (chars, not bytes),
   > and **obvious** (`s[i]` is "the i-th character"). On UTF-8, variable width
   > makes O(1)-random-codepoint physically impossible — so all three can't hold
   > *as long as `i` is an integer count*.

3. > char (with a real char type) **>** u8 (honest but unergonomic, and forces
   > `== 97`) **>>** today's "1-char string at byte index" (silently wrong on
   > anything non-ASCII — the worst of all worlds).

4. > Avra already has every piece Rust pays for with ceremony.

5. > Unicode-correct strings, as easy as Python and as fast as Rust, fall out of
   > guarantees Avra already makes — nobody had assembled them.

6. > A `string` is an immutable, always-valid-UTF-8 buffer you view through typed
   > lenses, where every operation's cost is legible in its name and every
   > Rust-style hazard is dissolved by a guarantee Avra already makes.

7. > A format is a value the compiler can run in every direction — forward (parse),
   > backward (print), symbolically (prove things about it), and generatively
   > (fuzz/document it) — and the data it yields are zero-copy views the language
   > already keeps safe.

8. > In Avra you declare the *shape* of data once, and the compiler hands you the
   > parser, the printer, the validator, the fuzzer, the docs, the streaming
   > version, world-class error messages, and a machine-checked proof that they all
   > agree — over zero-copy views the language keeps safe for free.

9. > The string model and the "agent-first" thesis turn out to be the same idea:
   > make the structure of data legible to the compiler, and both humans and models
   > stop being able to get it wrong.

10. > The more the compiler knows, the less the program costs *and* the less anyone
    > — human or AI — can get it wrong.

11. > A language from the future is just one that maximizes what the compiler knows
    > about every dimension — shape, provenance, effect, cost, history, identity —
    > and spends that knowledge *twice*: once to erase the runtime cost, once to
    > erase the footgun.

12. > Avra is the first language where an AI literally cannot merge a regression.
    > The type system is the senior reviewer that never sleeps — and when it rejects
    > the agent's edit, it hands back the patch. The loop provably converges to
    > correct.

13. > legibility to the compiler and safety for an autonomous author are the same
    > axis, and you can crank it until writing a bug is, for a whole class of bugs,
    > impossible.

---

# Part VIII — Open questions

1. **Grapheme default** — posed in the conversation as "the next paradox in the
   stack": codepoints (`char`) are fast/simple/ASCII-correct but split emoji;
   graphemes are human-correct but need Unicode tables. Resolved in this doc by
   *deleting* the default (iterate a lens: `.chars` / `.bytes` / `.graphemes`).
   Confirm this beats a defaulted `for c in s` on real code ergonomics.
2. **Mutable text.** Proposed: `string` is a persistent rope (Move 6). Confirm the
   O(log n) edit / value-semantics / cursor-survival story holds against an
   editor/streaming workload, and that it composes with `scope` manual memory.
3. **`char` vs `grapheme` literals.** `'a'` is a `char` (scalar). Do we want
   grapheme literals at all, or only `grapheme` values produced by `.graphemes`?
4. **Cost types (Part VI.4).** How much can be inferred vs annotated? What is the
   cost lattice, and how does it interact with generics and `scope`?
5. **Effect/qualifier lattice (Part VI.3).** Inference rules, boundary annotations,
   and how units/taint/capabilities/effects/refinements share one mechanism without
   becoming ceremony.
6. **Bidirectional totality (Part V.1, VI.1).** What class of `grammar`/`iso` is
   provably invertible at comptime, and what falls back to a runtime check?
7. **Content-addressed code (Part VI.5).** Interaction with the existing seed-train
   / bootstrap-window model and the package system.

---

# Appendix — decisions & ticket map

**Decisions captured:**
- `s[i: int]` on a `string` → **compile error** with a teaching F-code (not `u8`,
  not a 1-char string). Byte access is `s.bytes[i]` (honest O(1) `u8`).
- `string` is viewed through **lenses** (`.bytes` / `.chars` / `.graphemes`); no
  bare integer index, no bare iteration, no bare `.length`.
- `char` is a real type with `'a'` literals; `grapheme` is a distinct type.
- Invariant: a `string` is **always valid UTF-8**, enforced only at the
  bytes→string boundary (`bytes.text()` / `bytes.text_lossy()`).
- The crown-jewel **typed string patterns** are a committed goal (ticket `h78d`).

**Tickets:**
- `h78d` (P2, feature) — Typed string patterns in match (the crown jewel).
- `29f3` (P3, bug) — String `s[i]` → `u8` spec divergence + `bytes[i]` indexing.
- `bw1y` (P3, bug) — Nullable indexing (`int?[0]`) ICEs; needs an unwrap-first diagnostic.
- `pmo3` (P3, bug) — Newtype-of-list indexing should be transparent, not rejected.

**Recommended next step:** promote this document to a structured epic
(`avra-from-the-future`) with one child per Part V move and Part VI escalation, so
the vision is tracked, not just narrated.
