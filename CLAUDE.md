## Project Structure

Features are self-contained modules in `forge/compiler/features/`.
Each feature has: mod.rs (parser + checker + codegen metadata), and examples/.

### Adding a feature
1. Create directory in compiler/features/
2. Add `forge_feature!` macro with metadata in mod.rs
3. Add examples with `/// expect:` comments (these are tests AND docs)
4. Add `pub mod` line to features/mod.rs

### Finding code for a feature
Everything for a feature lives in its directory. Don't grep — go to the directory.
`forge features` shows all features with status and test counts.
`forge features <name>` shows details for one feature.

### Rules
- Never put feature-specific code in core/
- Core is infrastructure only: lexer, AST types, type system, codegen context
- Every example file must have a `/// expect:` comment
- Feature status must be accurate: draft (no tests), wip (some pass), testing (most pass), stable (all pass)
- When adding a new feature, update `forge/tests/programs/comprehensive.fg` to include a test section for it

## Build

```bash
cd forge/
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
```

## CLI Commands

- `forge build <file.fg>` - compile
- `forge run <file.fg>` - compile and run
- `forge check <file.fg>` - type-check only
- `forge test` - run all feature example tests
- `forge test <feature>` - run tests for a specific feature
- `forge features` - list all features with status and test counts
- `forge features --graph` - show dependency graph
- `forge features <name>` - detailed info for one feature
- `forge explain <code>` - explain an error code
- `forge provider new <name>` - scaffold a new provider
