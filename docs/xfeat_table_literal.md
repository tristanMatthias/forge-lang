# Forge — Table Literal (TDD)

`table` is syntactic sugar that produces a `List<struct>`. The header row defines field names, the compiler infers types from values. That's it — one keyword, desugars to what you'd write by hand.

---

## Test 1: Basic table literal

```forge
fn main() {
  let users = table {
    name    | age | active
    "alice" | 30  | true
    "bob"   | 25  | false
  }

  println(string(users.length))       // 2
  println(users[0].name)              // alice
  println(string(users[1].age))       // 25
  println(string(users[1].active))    // false
}
```

## Test 2: Type inference from values

```forge
fn takes_users(users: List<{name: string, age: int}>) {
  users.each(u -> println(`${u.name}: ${u.age}`))
}

fn main() {
  // Table infers to List<{name: string, age: int}>
  // which matches the function parameter
  takes_users(table {
    name    | age
    "alice" | 30
    "bob"   | 25
  })
  // alice: 30
  // bob: 25
}
```

## Test 3: Filter, map, pipe

```forge
fn main() {
  let scores = table {
    name    | score | grade
    "alice" | 92    | "A"
    "bob"   | 67    | "D"
    "carol" | 85    | "B"
    "dave"  | 43    | "F"
  }

  let passing = scores
    |> filter(it.score >= 70)
    |> map(it.name)
    |> join(", ")

  println(passing)   // alice, carol
}
```

## Test 4: Table in variable, reuse

```forge
fn main() {
  let pricing = table {
    plan         | monthly | annual
    "starter"    | 9.99    | 99.0
    "pro"        | 29.99   | 299.0
    "enterprise" | 99.99   | 999.0
  }

  let pro = pricing.find(it.plan == "pro")
  println(string(pro?.monthly ?? 0.0))     // 29.99

  let affordable = pricing.filter(it.monthly < 50.0)
  println(string(affordable.length))        // 2
}
```

## Test 5: Table with expressions in cells

```forge
fn discount(price: float) -> float { price * 0.8 }

fn main() {
  let base = 100.0

  let products = table {
    name     | price          | discounted
    "Widget" | base           | discount(base)
    "Gadget" | base * 2.0     | discount(base * 2.0)
    "Gizmo"  | base * 0.5     | discount(base * 0.5)
  }

  println(string(products[0].price))         // 100
  println(string(products[0].discounted))    // 80
  println(string(products[1].discounted))    // 160
}
```

## Test 6: Inline table as function argument

```forge
fn total_score(entries: List<{name: string, score: int}>) -> int {
  entries.map(it.score).sum()
}

fn main() {
  let total = total_score(table {
    name    | score
    "alice" | 10
    "bob"   | 20
    "carol" | 30
  })

  println(string(total))   // 60
}
```

## Test 7: Single column table

```forge
fn main() {
  let names = table {
    name
    "alice"
    "bob"
    "carol"
  }

  println(names.map(it.name).join(", "))   // alice, bob, carol
}
```

## Test 8: Empty table

```forge
fn main() {
  let empty = table {
    name: string | age: int
  }

  println(string(empty.length))   // 0
}
```

Note: empty tables need type annotations in the header since there are no values to infer from.

## Test 9: Table with enum values

```forge
enum Role { admin, editor, viewer }

fn main() {
  let permissions = table {
    role     | can_read | can_write | can_delete
    .admin   | true     | true      | true
    .editor  | true     | true      | false
    .viewer  | true     | false     | false
  }

  let editors = permissions.find(it.role == .editor)
  println(string(editors?.can_write ?? false))    // true
  println(string(editors?.can_delete ?? false))   // false
}
```

## Test 10: Table with nullable values

```forge
fn main() {
  let contacts = table {
    name    | email              | phone
    "alice" | "alice@test.com"   | "+1234567"
    "bob"   | "bob@test.com"    | null
    "carol" | null               | "+9876543"
  }

  let has_email = contacts.filter(it.email is not null)
  println(string(has_email.length))   // 2

  let has_both = contacts.filter(it.email is not null && it.phone is not null)
  println(string(has_both.length))    // 1
}
```

## Test 11: Table serialization

```forge
fn main() {
  let data = table {
    name    | score
    "alice" | 92
    "bob"   | 87
  }

  let j = json.stringify(data)
  println(j)
  // [{"name":"alice","score":92},{"name":"bob","score":87}]

  fs.write_json("scores.json", data)?
  let back = fs.read_json<List<{name: string, score: int}>>("scores.json")?
  println(string(back.length))        // 2
  println(back[0].name)               // alice

  fs.remove("scores.json")?
}
```

## Test 12: State machine pattern

```forge
enum State { idle, running, paused, done }
enum Event { start, pause, resume, complete }

fn main() {
  let transitions = table {
    from     | event     | to
    .idle    | .start    | .running
    .running | .pause    | .paused
    .running | .complete | .done
    .paused  | .resume   | .running
  }

  fn next(current: State, event: Event) -> State? {
    transitions.find(it.from == current && it.event == event)?.to
  }

  mut state = State.idle
  state = next(state, .start) ?? state
  println(string(state))              // running

  state = next(state, .pause) ?? state
  println(string(state))              // paused

  state = next(state, .resume) ?? state
  println(string(state))              // running

  state = next(state, .complete) ?? state
  println(string(state))              // done
}
```

## Test 13: Table in test spec (where clause)

```forge
use @std.test

spec "email validation" {
  given "various inputs" {
    then "validates correctly" where table {
      input            | expected
      "alice@test.com" | true
      "bob@example.org"| true
      "not-an-email"   | false
      ""               | false
    } {
      validate_email(input) == expected
    }
  }
}
```

```bash
forge test
```

```
  email validation
    given various inputs
      ✓ validates correctly (alice@test.com → true)
      ✓ validates correctly (bob@example.org → true)
      ✓ validates correctly (not-an-email → false)
      ✓ validates correctly ("" → false)

  4 passed
```

## Test 14: Table in component config

```forge
server :8080 {
  cors true

  routes table {
    method | path        | handler
    "GET"  | "/health"   | (req) -> { status: "ok" }
    "GET"  | "/users"    | (req) -> User.list()
    "POST" | "/users"    | (req) -> User.create(req.body)
  }
}
```

---

## Implementation

### Parser

`table` is a keyword that starts a block. The block has a header row (identifiers separated by `|`) followed by value rows (expressions separated by `|`).

```rust
#[forge_feature(
    name = "Table Literal",
    status = "draft",
    depends = ["types_core"],
    enables = [],
    tokens = [Table, Pipe],
    ast_nodes = [TableLiteral],
    description = "Inline typed table literals that desugar to List<struct>",
)]

pub fn register_parser(p: &mut ParserRegistry) {
    p.prefix("table", parse_table);
}

fn parse_table(parser: &mut Parser) -> Result<Expr, Diagnostic> {
    parser.expect(Token::LBrace)?;

    // Parse header row: name | age | active
    let columns = parse_pipe_separated_idents(parser)?;

    // Parse value rows: "alice" | 30 | true
    let mut rows = vec![];
    while !parser.check(Token::RBrace) {
        let values = parse_pipe_separated_exprs(parser, columns.len())?;
        rows.push(values);
    }

    parser.expect(Token::RBrace)?;

    Ok(Expr::TableLiteral { columns, rows })
}
```

### Type Checker

Infers column types from the first row. Verifies all subsequent rows match.

```rust
pub fn register_checker(c: &mut CheckerRegistry) {
    c.register(AstNode::TableLiteral, check_table);
}

fn check_table(checker: &mut Checker, expr: &TableExpr) -> Result<Type, Diagnostic> {
    // Infer struct type from first row
    let field_types: Vec<(String, Type)> = expr.columns.iter()
        .zip(expr.rows[0].iter())
        .map(|(name, val)| (name.clone(), checker.infer(val)?))
        .collect()?;

    let row_type = Type::Struct(field_types);

    // Verify all other rows match
    for (i, row) in expr.rows.iter().skip(1).enumerate() {
        for (j, val) in row.iter().enumerate() {
            let val_type = checker.infer(val)?;
            if val_type != field_types[j].1 {
                return Err(diagnostic(
                    "F0012",
                    format!("row {} column '{}': expected {}, found {}",
                        i + 2, expr.columns[j], field_types[j].1, val_type),
                ));
            }
        }
    }

    Ok(Type::List(Box::new(row_type)))
}
```

### Codegen

Desugars to a list of struct literals:

```rust
pub fn register_codegen(g: &mut CodegenRegistry) {
    g.register(AstNode::TableLiteral, emit_table);
}

fn emit_table(ctx: &mut CodegenCtx, expr: &TableExpr) -> Result<LLVMValue, Diagnostic> {
    // Desugar each row to a struct literal
    let structs: Vec<Expr> = expr.rows.iter().map(|row| {
        Expr::StructLiteral {
            fields: expr.columns.iter().zip(row.iter())
                .map(|(name, val)| (name.clone(), val.clone()))
                .collect()
        }
    }).collect();

    // Emit as a list literal
    ctx.emit_list(&structs)
}
```

---

## Precedence / Grammar

```
table_literal = "table" "{" header_row value_row* "}"
header_row    = ident ("|" ident)* NEWLINE
value_row     = expr ("|" expr)* NEWLINE
```

The `|` inside a table block is a column separator, not the bitwise OR operator. The parser knows this because it's inside a `table { }` block.
