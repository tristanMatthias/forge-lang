# Forge Principles

These principles govern every decision in the Forge language, compiler, tooling, and community. They apply to humans and AI equally. When in doubt, return here.

---

## 1. The code is the spec

Forge code should read like a description of what the program does, not instructions for how to do it. If you can't understand a Forge program by skimming it, the code is wrong — not the reader.

```forge
server :8080 {
  GET /users -> Users.list()
}

model User {
  name: string
  email: string @unique
}
```

That's a running application. Not a framework. The language itself.

## 2. Describe what you want, the compiler figures out how

The programmer expresses intent. The compiler chooses strategy. Static vs dynamic dispatch? The compiler decides. Memory management? The compiler handles it. Vtable vs monomorphization? The compiler picks. The programmer never thinks about implementation details unless they choose to.

## 3. Immutable by default, explicit mutation

Data doesn't change unless you say it does. `let` bindings can't be reassigned. Fields without `mut` can't be modified. This isn't a restriction — it's a guarantee. When you see data, you know it's stable. When you see `mut`, you know it moves.

## 4. Components describe the world

Servers, queues, models, agents, CLIs — these aren't libraries bolted onto a language. They're components: typed, validated, composable values with config, events, methods, and lifecycle. The language extends itself through components. Adding a new domain is adding a new component, not modifying the compiler.

## 5. No magic, no black magic

Forge has sugar. Sugar is good — it makes code readable. But every piece of sugar must desugar to something the programmer can write by hand. `GET /health -> { ok: true }` desugars to `route("GET", "/health", (req) -> { ok: true })`. Match tables desugar to match expressions. The `.` prefix desugars to contextual resolution. If you can't explain the desugaring, the feature is too magical.

## 6. One way to be right, many ways to be helped

When code is wrong, the compiler doesn't just say "no." It says what's wrong, where it's wrong, why it's wrong, and how to fix it — with corrected code the programmer can copy. Error messages are the primary user interface of a compiler.

## 7. Composition over inheritance

There is no inheritance. There is no `extends`. There is no class hierarchy. There are traits (shared behavior), type operators (shared structure), and composition (values containing values). If you need something from another type, compose it in or implement a trait. Don't inherit.

## 8. Traits are types

Trait names are types. `let x: Printable = anything_printable`. The compiler decides static vs dynamic dispatch based on usage. No `dyn` keyword. No programmer-visible distinction between "using a trait as a constraint" and "using a trait as a type."

## 9. Fields own their mutability

`mut` lives on the field declaration, not the binding. A `Counter` with `mut count: int` and `name: string` means `count` can change and `name` can't — regardless of how the counter is bound. Methods can mutate `mut` fields without special syntax. The struct declares what's stable and what moves.

## 10. Errors are conversations

Every error has: a code, a title, a source location with caret, a concrete fix suggestion, and a docs link. Errors trace causality — "this is wrong because that returns this type because it was declared here." Errors generate examples from type signatures. Errors never leak — no raw panics, no stack traces, no LLVM output reaches the user.

## 11. Tests are specs are docs

A test file is a spec document. `spec "User registration" { given "valid email" { then "user is created" { ... } } }`. The test runner output mirrors the spec structure. An agent reads the spec and knows what to build. A human reads the spec and understands the requirements. One artifact, three purposes.

## 12. The compiler is extensible, not modifiable

Adding a language feature means creating a feature directory with parser, checker, codegen, and examples. It does NOT mean editing core files. Features register themselves. Features declare their dependencies. Features include their own tests and docs. The compiler discovers features, it doesn't enumerate them.

## 13. No hardcoding, ever

No string matching to detect behavior. No special cases for specific types. No if/else chains that enumerate known variants. Everything is generic, table-driven, or registry-based. If something needs special handling, use annotations, type system checks, or structural analysis.

## 14. Beauty is not optional

Forge code should be beautiful. Error messages should be beautiful. Test output should be beautiful. Terminal output should be beautiful. The CLI should be beautiful. This isn't vanity — beauty signals clarity. If the output is ugly, the thinking is muddled.

## 15. AI-native, human-readable

Forge is designed for a world where AI writes most code. The syntax is unambiguous for parsers. The error format is machine-readable (JSON). The `forge features` command tells agents what's available. The `forge lang` command explains features in detail. But the code must always be readable by humans — AI-native doesn't mean AI-only.

## 16. Single binary, zero dependencies

A Forge program compiles to one binary. No runtime. No VM. No framework. `forge build` → binary → deploy. The binary includes everything it needs. This is non-negotiable for deployment simplicity.

## 17. The pipe is the program

Data flows through pipes, channels, and transforms. `items |> filter(it.active) |> map(it.name) |> join(", ")`. Channels connect components. `<-` sends, `<- ch` receives. `select` waits on multiple channels. The language is built around data flow, not control flow.

## 18. Null is a type, not a surprise

`T?` means "T or null." The compiler enforces handling. `?.` for safe access, `??` for defaults, `?? throw` to convert null to error. You cannot access a nullable value without acknowledging the null case. No null pointer exceptions. Ever.

## 19. Errors are values, not exceptions

`?` propagates errors. `catch` handles them inline. `Result<T, E>` is explicit. No invisible exception paths. No try/catch blocks that swallow errors. When a function can fail, its type says so.

## 20. Context resolves ambiguity

The `.` prefix resolves names from context. `.active` inside `Status.where()` means `Status.active`. `.publisher` inside `@auth()` means the publisher role. `.name` inside `Package.where()` means the name field. The compiler validates contextual references against declarations. Wrong context = compile error with suggestions.

## 21. Tables are data

`table { name | age ... }` is a literal data structure — `List<struct>` with named columns. `match x table { pattern | col | col }` is pattern matching with tabular results. Tables bridge code and data. CSV-like readability, type-safe semantics.

## 22. The feature is the documentation

Every language feature carries its own metadata: name, status, dependencies, syntax, grammar, description, examples. `forge features` lists them. `forge lang <feature>` explains them in detail. An agent with no context can read `forge lang --full` and write correct Forge code. If a feature can't be explained in its own metadata, it's too complex.

## 23. Tests are sacred

Never delete a test to fix a failure. Fix the compiler instead. A test represents a requirement someone expects to work. Removing it silently drops the requirement. Commit tests early. Red tests are a roadmap, not a problem.

## 24. Forge writes Forge

The CLI, the test runner, the package manager — these should be written in Forge. Self-hosting isn't just a milestone, it's a validation. If Forge can't build its own tooling beautifully, it's not ready.

## 25. Ship the right thing, not everything

Every feature must pass: does the benefit justify the complexity? Features that are "cool but niche" wait. Features that unlock the next 100 programs ship now. Scope is the enemy. Simplicity is the weapon.
