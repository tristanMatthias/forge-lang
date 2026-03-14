# @std/cli + @std/term + process additions (TDD)

---

# Part 1: process.args() and process.exit()

## Test 1.1: Get raw args

```forge
// test_args.fg
use @std.process

fn main() {
  let args = process.args()
  args.each(println(it))
}
```

```bash
forge build test_args.fg -o test_args
./test_args hello world --flag
```

```
./test_args
hello
world
--flag
```

## Test 1.2: Exit with code

```forge
// test_exit.fg
use @std.process

fn main() {
  process.exit(42)
  println("never reached")
}
```

```bash
forge build test_exit.fg -o test_exit
./test_exit
echo $?
```

```
42
```

No output — `println` never runs.

## Test 1.3: Exit zero

```forge
fn main() {
  process.exit(0)
}
```

```bash
./test_exit_zero
echo $?
# 0
```

---

# Part 2: @std/term

Library package. No components. Just functions wrapping ANSI codes.

## Test 2.1: Colors

```forge
use @std.term

fn main() {
  println(term.red("error"))
  println(term.green("success"))
  println(term.yellow("warning"))
  println(term.blue("info"))
  println(term.dim("subtle"))
}
```

Output has ANSI codes:
```
\x1b[31merror\x1b[0m
\x1b[32msuccess\x1b[0m
\x1b[33mwarning\x1b[0m
\x1b[34minfo\x1b[0m
\x1b[2msubtle\x1b[0m
```

## Test 2.2: Styles

```forge
fn main() {
  println(term.bold("important"))
  println(term.italic("emphasis"))
  println(term.underline("linked"))
  println(term.strikethrough("removed"))
}
```

## Test 2.3: Composing styles

```forge
fn main() {
  println(term.bold(term.red("critical error")))
  println(term.dim(term.yellow("minor warning")))
}
```

## Test 2.4: Strip colors when not a TTY

```forge
fn main() {
  // When piped, colors are stripped automatically
  println(term.red("error"))
}
```

```bash
./test_term | cat
# error (no ANSI codes)

./test_term
# error (with red ANSI codes)
```

## Test 2.5: Spinner

```forge
fn main() {
  let s = term.spinner("Compiling...")
  sleep(1s)
  s.done(term.green("✓") + " compiled")
}
```

Shows animated spinner for 1 second, then replaces with done message.

## Test 2.6: Progress bar

```forge
fn main() {
  let bar = term.progress(total: 100, label: "Building")

  (0..100).each(i -> {
    bar.update(i + 1)
    sleep(10ms)
  })

  bar.done("Build complete")
}
```

```
Building ████████████████████ 100% (1.0s)
Build complete
```

## Test 2.7: Table formatting

```forge
fn main() {
  term.table(table {
    feature     | status  | tests
    "null_safe" | "stable"| "14/14"
    "channels"  | "wip"   | "3/20"
    "generics"  | "draft" | "0/8"
  })
}
```

```
  feature    status  tests
  ─────────────────────────
  null_safe  stable  14/14
  channels   wip     3/20
  generics   draft   0/8
```

Auto-aligns columns. Works with our `table` literal directly.

## Test 2.8: Styled table

```forge
fn main() {
  term.table(table {
    feature     | status    | tests
    "null_safe" | "stable"  | "14/14"
    "channels"  | "wip"     | "3/20"
    "generics"  | "draft"   | "0/8"
  }) {
    style status {
      "stable" -> term.green
      "wip" -> term.yellow
      "draft" -> term.dim
    }
  }
}
```

```
  feature    status  tests
  ─────────────────────────
  null_safe  stable  14/14    (stable in green)
  channels   wip     3/20     (wip in yellow)
  generics   draft   0/8      (draft in dim)
```

---

# Part 3: @std/cli

## Test 3.1: Minimal CLI

```forge
use @std.cli

cli hello {
  version "1.0.0"
  description "A greeting tool"

  arg name: string

  run {
    println(`hello, ${name}!`)
  }
}
```

```bash
forge build test_cli.fg -o hello
./hello world
```

```
hello, world!
```

## Test 3.2: Auto-generated help

```forge
cli greeter {
  version "1.0.0"
  description "Greets people"

  arg name: string

  run { println(`hi ${name}`) }
}
```

```bash
./greeter --help
```

```
  greeter 1.0.0
  Greets people

  Usage: greeter <name>

  Arguments:
    name    (string)

  Options:
    -h, --help       Show this help
    -v, --version    Show version
```

```bash
./greeter --version
```

```
greeter 1.0.0
```

## Test 3.3: Flags and options

```forge
cli builder {
  version "0.1.0"
  description "Build tool"

  arg file: string
  flag release: bool = false, short: "r", description: "Enable optimizations"
  flag verbose: bool = false, short: "V", description: "Verbose output"
  option output: string = "build/out", short: "o", description: "Output path"

  run {
    if verbose { println(`building ${file}`) }
    println(`output: ${output}`)
    println(`release: ${release}`)
  }
}
```

```bash
./builder main.fg
```

```
output: build/out
release: false
```

```bash
./builder main.fg -r -o dist/app -V
```

```
building main.fg
output: dist/app
release: true
```

```bash
./builder --help
```

```
  builder 0.1.0
  Build tool

  Usage: builder <file> [options]

  Arguments:
    file                  (string)

  Options:
    -r, --release         Enable optimizations (default: false)
    -V, --verbose         Verbose output (default: false)
    -o, --output <value>  Output path (default: build/out)
    -h, --help            Show this help
    -v, --version         Show version
```

## Test 3.4: Subcommands

```forge
cli tool {
  version "0.1.0"
  description "Multi-command tool"

  command build {
    description "Build the project"
    arg file: string
    flag release: bool = false, short: "r"

    run {
      println(`building ${file} release=${release}`)
    }
  }

  command test {
    description "Run tests"
    option filter: string?, short: "f"

    run {
      if filter is string(f) {
        println(`testing with filter: ${f}`)
      } else {
        println("testing all")
      }
    }
  }

  command clean {
    description "Remove build artifacts"

    run {
      println("cleaning")
    }
  }
}
```

```bash
./tool --help
```

```
  tool 0.1.0
  Multi-command tool

  Commands:
    build    Build the project
    test     Run tests
    clean    Remove build artifacts

  Run `tool <command> --help` for details
```

```bash
./tool build main.fg -r
```

```
building main.fg release=true
```

```bash
./tool test -f "user"
```

```
testing with filter: user
```

```bash
./tool test
```

```
testing all
```

## Test 3.5: Subcommand help

```bash
./tool build --help
```

```
  tool build <file> [options]

  Build the project

  Arguments:
    file               (string)

  Options:
    -r, --release      (default: false)
    -h, --help         Show this help
```

## Test 3.6: Missing required argument

```bash
./tool build
```

```
  ✖ missing required argument: file

  Usage: tool build <file> [options]

  Run `tool build --help` for details
```

Exit code: 1

## Test 3.7: Unknown flag

```bash
./tool build main.fg --turbo
```

```
  ✖ unknown option: --turbo

  Did you mean --release?

  Run `tool build --help` for details
```

## Test 3.8: Optional positional args

```forge
cli greeter {
  version "1.0.0"

  arg name: string = "world"

  run {
    println(`hello ${name}`)
  }
}
```

```bash
./greeter
```

```
hello world
```

```bash
./greeter alice
```

```
hello alice
```

## Test 3.9: Multiple positional args

```forge
cli copy {
  version "1.0.0"

  arg source: string
  arg dest: string

  run {
    println(`copying ${source} to ${dest}`)
  }
}
```

```bash
./copy a.txt b.txt
```

```
copying a.txt to b.txt
```

## Test 3.10: Variadic args

```forge
cli runner {
  version "1.0.0"

  args files: List<string>

  run {
    println(`processing ${files.length} files`)
    files.each(println(it))
  }
}
```

```bash
./runner a.fg b.fg c.fg
```

```
processing 3 files
a.fg
b.fg
c.fg
```

## Test 3.11: Nested subcommands

```forge
cli forge_cli {
  version "0.1.0"
  description "The Forge programming language"

  command package {
    description "Package management"

    command new {
      description "Create a new package"
      arg name: string

      run {
        println(`creating package: ${name}`)
      }
    }

    command list {
      description "List installed packages"

      run {
        println("listing packages")
      }
    }
  }
}
```

```bash
./forge_cli package new my-redis
```

```
creating package: my-redis
```

```bash
./forge_cli package --help
```

```
  forge_cli package

  Package management

  Commands:
    new     Create a new package
    list    List installed packages
```

## Test 3.12: Before/after hooks

```forge
cli tool {
  version "1.0.0"

  flag verbose: bool = false, short: "V"

  on before_command {
    if verbose { println("verbose mode on") }
  }

  on after_command {
    if verbose { println("done") }
  }

  command build {
    arg file: string
    run { println(`building ${file}`) }
  }
}
```

```bash
./tool build main.fg -V
```

```
verbose mode on
building main.fg
done
```

## Test 3.13: Custom error handling

```forge
cli tool {
  version "1.0.0"

  on error(err) {
    term.red(`✖ ${err}`)
    process.exit(1)
  }

  command deploy {
    arg target: string

    run {
      if target != "staging" && target != "production" {
        fail("invalid target: ${target}. Use 'staging' or 'production'")
      }
      println(`deploying to ${target}`)
    }
  }
}
```

```bash
./tool deploy banana
```

```
✖ invalid target: banana. Use 'staging' or 'production'
```

## Test 3.14: CLI with term integration

```forge
use @std.cli
use @std.term

cli builder {
  version "0.1.0"

  command build {
    arg file: string
    flag release: bool = false, short: "r"

    run {
      let s = term.spinner(`Compiling ${file}...`)

      let result = $"forge-compiler ${file}"
      
      if result.code == 0 {
        s.done(term.green("✓") + ` compiled ${file}`)
      } else {
        s.done(term.red("✖") + " failed")
        println(result.stderr)
        process.exit(1)
      }
    }
  }

  command features {
    flag graph: bool = false

    run {
      term.table(table {
        feature        | status   | tests
        "null_safety"  | "stable" | "14/14 ✓"
        "channels"     | "wip"    | "3/20 ●"
        "generics"     | "draft"  | "0/8 ○"
      })
    }
  }
}
```

---

# Package Definitions

## @std/term — package.toml

```toml
[package]
name = "term"
namespace = "std"
version = "0.1.0"
description = "Terminal colors, styles, spinners, and formatting"

[native]
library = "forge_term"
```

## @std/term — package.fg

```forge
extern fn forge_term_is_tty() -> bool
extern fn forge_term_width() -> int
extern fn forge_term_spinner_start(msg: string) -> int
extern fn forge_term_spinner_done(id: int, msg: string)
extern fn forge_term_progress_start(total: int, label: string) -> int
extern fn forge_term_progress_update(id: int, current: int)
extern fn forge_term_progress_done(id: int, msg: string)

let is_tty = forge_term_is_tty()

fn wrap(code: string, text: string) -> string {
  if is_tty { `\x1b[${code}m${text}\x1b[0m` } else { text }
}

// Colors
export fn red(text: string) -> string { wrap("31", text) }
export fn green(text: string) -> string { wrap("32", text) }
export fn yellow(text: string) -> string { wrap("33", text) }
export fn blue(text: string) -> string { wrap("34", text) }
export fn magenta(text: string) -> string { wrap("35", text) }
export fn cyan(text: string) -> string { wrap("36", text) }

// Styles
export fn bold(text: string) -> string { wrap("1", text) }
export fn dim(text: string) -> string { wrap("2", text) }
export fn italic(text: string) -> string { wrap("3", text) }
export fn underline(text: string) -> string { wrap("4", text) }
export fn strikethrough(text: string) -> string { wrap("9", text) }

// Width
export fn width() -> int { forge_term_width() }

// Spinner
export type Spinner = { id: int }

export fn spinner(msg: string) -> Spinner {
  Spinner { id: forge_term_spinner_start(msg) }
}

impl Spinner {
  fn done(self, msg: string) { forge_term_spinner_done(self.id, msg) }
}

// Progress
export type Progress = { id: int }

export fn progress(total: int, label: string = "") -> Progress {
  Progress { id: forge_term_progress_start(total, label) }
}

impl Progress {
  fn update(self, current: int) { forge_term_progress_update(self.id, current) }
  fn done(self, msg: string) { forge_term_progress_done(self.id, msg) }
}

// Table formatting
export fn print_table(data: List<any>) {
  // Auto-detect column widths, print aligned
  // Works directly with table literals since they're List<struct>
  // Native lib handles alignment and box drawing
  forge_term_print_table(json.stringify(data))
}
```

## @std/cli — package.toml

```toml
[package]
name = "cli"
namespace = "std"
version = "0.1.0"
description = "Declarative CLI framework"

[native]
library = "forge_cli"

[components.cli]
kind = "block"
context = "top_level"
body = "mixed"
```

## @std/cli — package.fg

```forge
extern fn forge_cli_parse_args(schema_json: string, raw_args_json: string) -> string
extern fn forge_cli_print_help(schema_json: string)
extern fn forge_cli_print_version(name: string, version: string)

component cli(name: string) {
  config {
    version: string = "0.0.0"
    description: string = ""
  }

  event before_command()
  event after_command()
  event error(err: string)

  fn command(name: string, config, body: fn()) {
    // Register subcommand with its args/flags/options
    // Parsed at runtime from process.args()
  }

  fn arg(name: string, type: Type, default: any? = null) {
    // Register positional argument
  }

  fn args(name: string, type: Type) {
    // Register variadic positional arguments
  }

  fn flag(name: string, type: bool, default: bool = false, short: string? = null, description: string = "") {
    // Register boolean flag
  }

  fn option(name: string, type: Type, default: any? = null, short: string? = null, description: string = "") {
    // Register option with value
  }

  fn fail(msg: string) {
    error(msg)
    process.exit(1)
  }

  on startup {
    let raw = process.args()

    // Check for --help and --version first
    if raw.contains("--help") || raw.contains("-h") {
      forge_cli_print_help(schema_json())
      process.exit(0)
    }

    if raw.contains("--version") || raw.contains("-v") {
      forge_cli_print_version(name, config.version)
      process.exit(0)
    }

    // Parse args against registered schema
    let parsed = forge_cli_parse_args(schema_json(), json.stringify(raw))
    let result = json.parse(parsed)

    if result.error is string(err) {
      error(err)
      process.exit(1)
    }

    // Bind parsed values and run
    before_command()
    run_matched_command(result)
    after_command()
  }
}
```

## process additions — two new extern fns

```forge
// Added to @std/process package.fg

extern fn forge_process_get_args() -> string
extern fn forge_process_exit(code: int)

export fn args() -> List<string> {
  json.parse(forge_process_get_args())
}

export fn exit(code: int) {
  forge_process_exit(code)
}
```

---

# What's Needed

| Feature | Package | Implementation |
|---|---|---|
| `process.args()` | @std/process | Wrap `std::env::args()` |
| `process.exit(code)` | @std/process | Wrap `std::process::exit()` |
| `term.red/green/...` | @std/term | ANSI escape code wrapping |
| `term.bold/dim/...` | @std/term | ANSI escape code wrapping |
| TTY detection | @std/term | Wrap `atty::is(Stream::Stdout)` |
| `term.spinner()` | @std/term | Native thread for animation |
| `term.progress()` | @std/term | Native thread for bar rendering |
| `term.print_table()` | @std/term | Column width calculation + padding |
| `cli` component | @std/cli | Arg schema + parser + help generator |
| `command` nesting | @std/cli | Recursive command tree |
| `arg/flag/option` | @std/cli | Schema builders in component scope |
| Auto-generated help | @std/cli | Render schema as formatted text |
| Did-you-mean flags | @std/cli | Levenshtein on unknown flags |
| `before/after` hooks | @std/cli | Component events |
| `error` handler | @std/cli | Component event |
