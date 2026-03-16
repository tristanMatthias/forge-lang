# Forge Compiler — Development Guidelines

> This compiler is written in Forge. Read PRINCIPLES.md first. Then this. Then write code.

## What This Is

The self-hosted Forge compiler. Written in Forge. Compiles Forge. Every file you touch is `.fg`. Every pattern you use should be the most idiomatic Forge possible — this codebase IS the reference implementation of how to write Forge.

**If code in this compiler isn't beautiful, the language has failed.**

## Architecture

```
forgec/
├── forge.toml              # project config
├── src/
│   ├── main.fg             # CLI entry point
│   ├── lexer/
│   │   ├── mod.fg          # tokenizer
│   │   └── tokens.fg       # token types
│   ├── parser/
│   │   ├── mod.fg          # parser core
│   │   └── ast.fg          # AST node types
│   ├── checker/
│   │   ├── mod.fg          # type checker core
│   │   └── types.fg        # type system
│   ├── codegen/
│   │   ├── mod.fg          # LLVM IR generation
│   │   └── llvm.fg         # LLVM C API bindings
│   ├── features/           # every language feature is self-contained
│   │   ├── null_safety/
│   │   │   ├── mod.fg      # feature registration
│   │   │   ├── parser.fg   # parsing logic
│   │   │   ├── checker.fg  # type checking logic
│   │   │   ├── codegen.fg  # code generation
│   │   │   └── examples/   # .fg test files
│   │   ├── pattern_matching/
│   │   ├── pipe_operator/
│   │   ├── channels/
│   │   ├── traits/
│   │   └── ...
│   ├── diagnostics/
│   │   ├── mod.fg          # error rendering
│   │   └── registry.fg     # error code registry
│   └── utils/
│       ├── path.fg         # path utilities
│       └── json.fg         # json utilities
├── errors/
│   └── registry.toml       # error code definitions
└── specs/                   # test specs
    ├── lexer_spec.fg
    ├── parser_spec.fg
    └── ...
```

## The Golden Rule

**This codebase teaches the world how to write Forge.** Every pattern, every idiom, every design choice here will be copied by users and agents. Write accordingly.

## Writing Forge in This Codebase

### Types — use per-field mutability

```forge
type Token = {
  kind: TokenKind,
  lexeme: string,
  line: int,
  col: int,
}

type Lexer = {
  source: string,
  mut pos: int,
  mut line: int,
  mut col: int,
  mut tokens: List<Token>,
}
```

`source` never changes after creation. `pos`, `line`, `col`, `tokens` change as we lex. The type declaration tells you exactly what moves and what's stable.

### Enums — for AST nodes, token kinds, types

```forge
enum TokenKind {
  // Literals
  int_lit(value: int),
  float_lit(value: float),
  string_lit(value: string),

  // Keywords
  let_kw,
  mut_kw,
  fn_kw,
  if_kw,
  match_kw,

  // Operators
  plus,
  minus,
  arrow,        // ->
  pipe,         // |>
  question,     // ?
  question_dot, // ?.
  double_question, // ??
  channel_send, // <-

  // Structural
  lparen,
  rparen,
  lbrace,
  rbrace,
  eof,
}

enum Expr {
  int_literal(value: int),
  string_literal(value: string),
  ident(name: string),
  binary(left: Expr, op: BinOp, right: Expr),
  call(callee: Expr, args: List<Expr>),
  field_access(object: Expr, field: string),
  safe_access(object: Expr, field: string),     // ?.
  null_coalesce(left: Expr, right: Expr),       // ??
  pipe(left: Expr, right: Expr),                // |>
  is_check(value: Expr, pattern: Pattern, negated: bool),
  match_expr(value: Expr, arms: List<MatchArm>),
  match_table(value: Expr, columns: List<string>, rows: List<TableRow>),
  channel_send(channel: Expr, value: Expr),     // <-
  channel_receive(channel: Expr),               // <- ch
  with_expr(base: Expr, updates: List<FieldUpdate>),
  // ...
}
```

### Match — use match tables where appropriate

```forge
fn token_to_string(kind: TokenKind) -> string {
  match kind table {
    pattern        | label
    .let_kw        | "let"
    .mut_kw        | "mut"
    .fn_kw         | "fn"
    .if_kw         | "if"
    .match_kw      | "match"
    .plus          | "+"
    .minus         | "-"
    .arrow         | "->"
    .pipe          | "|>"
    .question      | "?"
    .question_dot  | "?."
    .eof           | "EOF"
    _              | "unknown"
  }.label
}
```

For complex dispatch, use regular match:

```forge
fn emit(node: Expr) -> LLVMValue {
  match node {
    .int_literal(v) -> emit_int(v)
    .string_literal(v) -> emit_string(v)
    .binary(l, op, r) -> emit_binary(l, op, r)
    .call(callee, args) -> emit_call(callee, args)
    .pipe(l, r) -> emit_pipe(l, r)
    .is_check(v, p, neg) -> emit_is(v, p, neg)
    .match_table(v, cols, rows) -> emit_match_table(v, cols, rows)
    _ -> ice("unhandled expr node")   // internal compiler error
  }
}
```

### Error handling — use ? and ?? throw

```forge
fn parse_function(self) -> Result<FnDecl, Diagnostic> {
  self.expect(.fn_kw)?
  let name = self.expect_ident()?
  self.expect(.lparen)?
  let params = self.parse_params()?
  self.expect(.rparen)?

  let return_type = if self.peek() is .arrow {
    self.advance()
    self.parse_type()?
  } else {
    Type.void
  }

  let body = self.parse_block()?

  Ok(FnDecl { name, params, return_type, body })
}
```

Never use unwrap. Never use panic. Propagate with `?`. Convert nulls with `?? throw`. If the compiler itself hits an unexpected state:

```forge
fn ice(msg: string) -> ! {
  Diagnostic.internal(
    code: "F9999",
    message: `internal compiler error: ${msg}`,
    help: "please report this at https://github.com/forge-lang/forge/issues",
  ) |> render |> eprintln
  process.exit(2)
}
```

### Traits — for AST visitors and dispatch

```forge
trait Node {
  fn emit(self) -> LLVMValue
  fn check(self, ctx: CheckContext) -> Result<Type, Diagnostic>
  fn span(self) -> Span
}

impl Node for Expr { ... }
impl Node for Stmt { ... }
impl Node for Decl { ... }
```

Traits as types — heterogeneous AST:

```forge
type MatchArm = {
  pattern: Pattern,
  body: Node,         // any AST node that implements Node
}

// Heterogeneous list
let nodes: List<Node> = [expr, stmt, decl]
```

### Path type — for file operations

```forge
let source_path = path("src") / "main.fg"
let content = source_path.read()?
let tokens = lex(content, source_path.name)
```

### Channels — for parallel compilation (future)

```forge
let files = path("src").glob("**/*.fg")?
let results = channel<CompileResult>(files.length)

files.each(f -> spawn {
  let content = f.read()?
  let tokens = lex(content, f.name)?
  let ast = parse(tokens)?
  results <- CompileResult { file: f, ast }
})

let modules: List<CompileResult> = results.drain()
```

### Diagnostics — always structured

```forge
fn type_mismatch(expected: Type, found: Type, span: Span) -> Diagnostic {
  Diagnostic {
    code: "F0012",
    level: .error,
    title: "type mismatch",
    labels: [
      Label { span, message: `expected ${expected}, found ${found}`, kind: .primary },
    ],
    suggestions: [
      Suggestion {
        message: `change type to ${found}`,
        edits: [Edit { span, replacement: found.to_string() }],
        confidence: 0.9,
      },
    ],
    tip: null,
  }
}
```

### Tests — use spec/given/then

```forge
use @std.test

spec "Lexer" {
  given "simple tokens" {
    let tokens = lex("let x = 5")

    then "produces correct count" { tokens.length == 5 }
    then "first is let keyword" { tokens[0].kind is .let_kw }
    then "second is identifier" { tokens[1].kind is .ident("x") }
    then "third is equals" { tokens[2].kind is .eq }
    then "fourth is int literal" { tokens[3].kind is .int_lit(5) }
  }

  given "template literal" {
    let tokens = lex("`hello ${name}`")

    then "is a template" { tokens[0].kind is .template_lit }
  }

  given "invalid character" {
    then "produces error" should_fail {
      lex("let x = §")
    }
  }
}

spec "Parser" {
  given "function declaration" {
    let ast = parse("fn add(a: int, b: int) -> int { a + b }")

    then "is a function" { ast[0] is .fn_decl }
    then "has correct name" { ast[0].name == "add" }
    then "has two params" { ast[0].params.length == 2 }
  }

  given "match table" {
    let ast = parse(`
      match x table {
        pattern | label
        .a      | "first"
        .b      | "second"
      }
    `)

    then "is a match table expr" { ast[0] is .match_table }
    then "has two columns" { ast[0].columns == ["pattern", "label"] }
    then "has two rows" { ast[0].rows.length == 2 }
  }
}
```

### Struct methods — self is explicit

```forge
type Parser = {
  tokens: List<Token>,
  mut pos: int,
}

impl Parser {
  fn peek(self) -> TokenKind {
    if self.pos < self.tokens.length {
      self.tokens[self.pos].kind
    } else {
      .eof
    }
  }

  fn advance(self) -> Token {
    let token = self.tokens[self.pos]
    self.pos = self.pos + 1
    token
  }

  fn expect(self, kind: TokenKind) -> Result<Token, Diagnostic> {
    let token = self.advance()
    if token.kind is kind {
      Ok(token)
    } else {
      Err(unexpected_token(kind, token))
    }
  }
}
```

`self` is always written explicitly in methods. `pos` is `mut` so `advance` can modify it. `tokens` is not `mut` — the token list never changes after parsing begins.

### No hardcoding

```forge
// BAD — enumerating known types
fn is_numeric(t: Type) -> bool {
  t == .int || t == .float || t == .i8 || t == .i16 || ...
}

// GOOD — trait-based
fn is_numeric(t: Type) -> bool {
  t.implements(.numeric)
}

// BAD — string matching
fn is_keyword(s: string) -> bool {
  s == "let" || s == "mut" || s == "fn" || ...
}

// GOOD — registry lookup
fn is_keyword(s: string) -> bool {
  KEYWORDS.contains(s)
}

let KEYWORDS = table {
  keyword | token_kind
  "let"   | .let_kw
  "mut"   | .mut_kw
  "fn"    | .fn_kw
  "if"    | .if_kw
  "else"  | .else_kw
  "match" | .match_kw
  "for"   | .for_kw
  "while" | .while_kw
  "return"| .return_kw
  "true"  | .true_lit
  "false" | .false_lit
  "null"  | .null_lit
  "is"    | .is_kw
  "not"   | .not_kw
  "table" | .table_kw
  "use"   | .use_kw
  "type"  | .type_kw
  "enum"  | .enum_kw
  "trait" | .trait_kw
  "impl"  | .impl_kw
  "export"| .export_kw
  "extern"| .extern_kw
  "spawn" | .spawn_kw
  "select"| .select_kw
}
```

### Feature registration

Each feature directory has a `mod.fg` that exports its registration:

```forge
// features/null_safety/mod.fg
export let feature = Feature {
  name: "Null Safety",
  id: "null_safety",
  status: .stable,
  depends: ["types_core", "pattern_matching"],
  enables: ["error_propagation"],
  description: "Optional types with ?, ?., ??, and smart narrowing",
  tokens: [.question, .question_dot, .double_question, .bang],
  ast_nodes: [.safe_access, .null_coalesce, .force_unwrap],
}

export fn register_parser(p: Parser) { ... }
export fn register_checker(c: Checker) { ... }
export fn register_codegen(g: Codegen) { ... }
```

The compiler discovers features by scanning `features/*/mod.fg` and calling each `register_*` function. No manual list. Adding a feature = creating a directory.

### Language features as components

Language features that introduce new block syntax should be implemented as components. The component system IS the extension mechanism — for users AND for the compiler itself.

```forge
// features/for_loops/mod.fg
// A for loop is just a component that the compiler expands

component for_loop(binding: string, iterable: Expr, body: Block) {
  fn desugar(self) -> Expr {
    // Desugar to: iterable.iter() |> each(binding -> body)
    Expr.call(
      callee: Expr.method(self.iterable, "iter"),
      args: [Expr.closure(
        params: [self.binding],
        body: self.body,
      )],
    )
  }
}
```

```forge
// features/select/mod.fg
// select is a component that generates channel polling code

component select_block(arms: List<SelectArm>) {
  type SelectArm = {
    binding: string,
    channel: Expr,
    guard: Expr?,
    body: Block,
  }

  fn desugar(self) -> Expr {
    // Generate: loop over channels, check readiness, dispatch
    let channel_ids = self.arms.map(it.channel)
    Expr.loop_block(
      body: Expr.native_select(channel_ids, self.arms),
    )
  }
}
```

```forge
// features/match_table/mod.fg
// match table desugars to a regular match that returns a struct

component match_table(value: Expr, columns: List<string>, rows: List<TableRow>) {
  fn desugar(self) -> Expr {
    let result_type = Type.struct(
      self.columns.filter(it != "pattern")
        .map(col -> Field { name: col, type: infer_from_rows(col, self.rows) })
    )

    Expr.match_expr(
      value: self.value,
      arms: self.rows.map(row -> MatchArm {
        pattern: row.pattern,
        body: Expr.struct_literal(
          self.columns.zip(row.values)
            .filter((col, _) -> col != "pattern")
            .map((col, val) -> FieldInit { name: col, value: val })
        ),
      }),
      result_type: result_type,
    )
  }
}
```

The pattern: a language feature is a component with a `desugar` method that transforms custom syntax into core AST nodes. The compiler calls `desugar` during expansion, then type-checks and codegens the result through the normal pipeline. No special cases in the core.

### Registries, not lists

**Never maintain a manual list.** If you find yourself adding an item to a list when creating something new, the architecture is wrong.

```forge
// BAD — manual list that someone will forget to update
let ALL_FEATURES = [
  null_safety.feature,
  pattern_matching.feature,
  pipe_operator.feature,
  channels.feature,
  // ... someone adds a feature and forgets this list
]

// GOOD — discovered from filesystem
let ALL_FEATURES = path("features").dirs()?
  .map(dir -> import(dir / "mod.fg").feature)
```

```forge
// BAD — manual visitor dispatch
fn visit(node: Expr) {
  match node {
    .binary(l, op, r) -> visit_binary(l, op, r)
    .call(c, args) -> visit_call(c, args)
    // ... 40 more arms, one per node type
  }
}

// GOOD — trait dispatch via Node trait
fn visit(node: Node) {
  node.accept(self)    // each node type handles its own dispatch
}
```

```forge
// BAD — known type list
let BUILTIN_TYPES = ["int", "float", "string", "bool"]

// GOOD — type registry
let type_registry = TypeRegistry.new()
type_registry.register("int", Type.int)
type_registry.register("float", Type.float)
// ... or auto-discovered from features
```

```forge
// BAD — error codes scattered in code
Diagnostic { code: "F0012", ... }  // magic string, no validation

// GOOD — codes from registry
Diagnostic.from_registry(.type_mismatch, { expected, found, span })
// registry validates code exists, fills template, adds docs link
```

The rule: **if a new feature/type/error requires editing an existing file to add itself to a list, refactor to use a registry or discovery mechanism.** The only file a new feature should touch is its own directory.

## Error System Rules

- NEVER let a raw panic, LLVM error, or stack trace reach the user
- ALL errors go through the Diagnostic system with a registered code
- Every new error code goes in `errors/registry.toml`
- Error messages must include a concrete fix suggestion
- Internal compiler errors use F9999 with context
- Use `ice("message")` for "this should be unreachable" paths

## CLI Structure

```forge
use @std.cli

cli forgec {
  version "0.2.0"
  description "The Forge compiler"

  command build {
    arg file: string
    flag release: bool = false, short: "r"
    option output: string?, short: "o"
    flag profile: bool = false

    run {
      let source = path(file).read()?
      let result = compile(source, file, { release, output, profile })
      if result is Err(diagnostics) {
        diagnostics.each(it.render() |> eprintln)
        process.exit(1)
      }
    }
  }

  command test {
    option filter: string?, short: "f"
    flag bench: bool = false
    flag fuzz: bool = false

    run {
      run_tests({ filter, bench, fuzz })
    }
  }

  command features {
    flag graph: bool = false

    run {
      if graph {
        print_feature_graph()
      } else {
        print_feature_table()
      }
    }
  }

  command lang {
    arg feature: string?
    flag full: bool = false

    run {
      if full {
        print_full_lang_spec()
      } else if feature is string(f) {
        print_feature_docs(f)
      } else {
        print_feature_summary()
      }
    }
  }
}
```

## Build & Test

```bash
# Bootstrap: use the Rust compiler to build the Forge compiler
forgec build src/main.fg -o forgec-next

# Self-test: new compiler compiles itself
./forgec-next build src/main.fg -o forgec-verify

# Verify: both produce identical output
diff <(./forgec-next --version) <(./forgec-verify --version)

# Run all tests
./forgec-next test

# Run one feature's tests
./forgec-next test null_safety

# View all features
./forgec-next features
```

## Checklist Before Declaring Done

```
[ ] Code is idiomatic Forge — no Rust patterns leaking through
[ ] Per-field mutability used correctly (mut only where needed)
[ ] Error handling uses ? and ?? throw, never unwrap/panic
[ ] Match tables used for lookup-style mappings
[ ] Contextual .field references used in queries and annotations
[ ] Path type used for file operations (not string manipulation)
[ ] Template literals used (not string concatenation)
[ ] Shorthand fields used ({ name } not { name: name })
[ ] Traits used as types where appropriate (no dyn)
[ ] Tests written as spec/given/then
[ ] No hardcoded lists — use registries, discovery, or tables
[ ] No manual list edited — new features self-register via directory convention
[ ] Language features implemented as components with desugar methods where possible
[ ] Error messages include suggestions with corrected code
[ ] Feature directory is self-contained (parser + checker + codegen + examples)
[ ] forgec test — ALL tests pass
[ ] Code would make a good example in the Forge documentation
```
