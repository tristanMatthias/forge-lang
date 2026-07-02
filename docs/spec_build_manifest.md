# Avra Build Manifest (`avra.toml`)

**Status:** v1.0 build system schema. Authoritative for `avra build`.
**Related:** spec Axes 16.4 / 16.8 (modules + packages), TRD epic `forge-crafting-intepreters-a1el`.

This document defines the schema of `avra.toml` — the build manifest read
by the Avra build system. Every Avra project (library or binary) is
rooted at a directory containing an `avra.toml`. The manifest is the
single source of truth for: project identity, entry point(s),
dependencies, and build profiles.

## Goals

The manifest serves three audiences, in priority order:

1. **The build system** — discover sources, fingerprint inputs, resolve
   deps, drive parallel compilation.
2. **Other Avra projects** — declare what's importable and at what
   version.
3. **Humans** — readable, diffable, predictable.

Modeled on Cargo's `Cargo.toml` and Go's `go.mod`. We borrow proven
conventions; we do not invent novelty here.

## Locating the manifest

The build system locates `avra.toml` by walking up from the current
directory until found, mirroring `cargo` and `go` behavior. The
directory containing `avra.toml` is the **project root**. All paths in
the manifest are relative to the project root.

A project may declare itself as part of a workspace by naming a parent
manifest as a workspace root (deferred to v1.1; v1.0 is single-project).

## Schema

The manifest is TOML. The following sections are recognized in v1.0.
Unknown sections are tolerated with a warning so that future additions
do not break older compilers.

### `[package]`

```toml
[package]
name    = "myapp"        # required, snake_case or kebab-case
version = "0.1.0"        # required, semver
edition = "2026"         # optional, language edition
authors = ["..."]        # optional
license = "MIT"          # optional, SPDX identifier
description = "..."      # optional
```

| Key           | Type       | Required | Notes                                                |
| ------------- | ---------- | -------- | ---------------------------------------------------- |
| `name`        | string     | yes      | Identifies the package. Used as the import root.     |
| `version`     | string     | yes      | Semver `MAJOR.MINOR.PATCH`. Pre-release suffix ok.   |
| `edition`     | string     | no       | Defaults to current edition; future-proofs syntax.   |
| `authors`     | string\[]  | no       |                                                      |
| `license`     | string     | no       | SPDX expression (e.g. `MIT OR Apache-2.0`).          |
| `description` | string     | no       | One-line summary.                                    |

The `[package]` section is **required**. A manifest without one is an
error.

### `[bin]` / `[lib]`

Declares the project's compile targets.

```toml
[bin]
path = "src/main.av"     # default: src/main.av if present
name = "myapp"           # default: package name

[lib]
path = "src/lib.av"      # default: src/lib.av if present
name = "myapp"           # default: package name
```

A project may have:
- A `[bin]` only (executable, no public library surface)
- A `[lib]` only (library, no entrypoint)
- Both (library that also ships a CLI binary)
- Neither (error: nothing to build)

If `[bin]` is present and `path` is omitted, the build system looks for
`src/main.av`. If `[lib]` is present and `path` is omitted, it looks
for `src/lib.av`. Multiple binaries are deferred to v1.1 (Cargo's
`[[bin]]` array-of-tables).

### `[dependencies]`

Direct dependencies on other Avra packages.

```toml
[dependencies]
http     = "1.2"                                       # version-only (registry)
parser   = { version = "0.5", features = ["regex"] }   # with feature flags
local    = { path = "../local-pkg" }                   # path dependency
upstream = { git = "https://example.com/x.git", rev = "abc123" }
```

| Form               | Resolution             | v1.0 status |
| ------------------ | ---------------------- | ----------- |
| `"X.Y"` / `"X.Y.Z"`| registry lookup        | deferred (no registry exists yet) |
| `{ path = "..." }` | local filesystem       | **v1.0 supported**                |
| `{ git = "..." }`  | git clone + checkout   | deferred                          |

In v1.0 the only fully-supported form is path dependencies. Registry
and git deps parse and are forwarded to a stub resolver that reports a
clear error pointing at the unresolved name.

### `[dev-dependencies]`

Same shape as `[dependencies]`, but only used for building tests and
benchmarks. Not propagated to consumers of this package.

### `[profile.<name>]`

Build profiles control compilation flags. Two profiles are recognized
by default:

```toml
[profile.dev]
opt_level   = 0          # 0 | 1 | 2 | 3 | "s" | "z"
debug       = true       # emit debug info
overflow_checks = true
incremental = true       # use the cache (default true)

[profile.release]
opt_level   = 2
debug       = false
overflow_checks = false
incremental = true
```

| Key               | Type             | Default (dev) | Default (release) |
| ----------------- | ---------------- | ------------- | ----------------- |
| `opt_level`       | int 0–3 / "s"/"z"| `0`           | `2`               |
| `debug`           | bool             | `true`        | `false`           |
| `overflow_checks` | bool             | `true`        | `false`           |
| `incremental`     | bool             | `true`        | `true`            |
| `coverage`        | bool             | `false`       | `false`           |

Profile selection: `avra build` uses `dev` by default, `avra build
--release` uses `release`. Custom profiles (`[profile.bench]`) may be
declared and selected via `--profile <name>`.

**Profile flags are part of the fingerprint.** Switching profiles
forces a rebuild of every unit (correct: object code differs).

### `[features]`

Optional named feature toggles, propagated as compile-time flags.
Deferred to v1.1; the section parses but does not yet drive
compilation.

### `[build]`

Reserved for build-script (`build.av`) hooks. Deferred to v1.1.

## Reference manifest (the bootstrap)

```toml
[package]
name    = "bootstrap"
version = "0.1.0"

[bin]
path = "packages/cli/src/main.av"
name = "bs2"

[dependencies]
"@std/avrac" = { path = "packages/std-avrac" }

[profile.dev]
opt_level = 0
debug     = true

[profile.release]
opt_level = 2
debug     = false
```

This is the manifest the bootstrap dogfoods. The `@std/avrac` library
is a path dependency on a sibling directory; the bootstrap CLI is a
binary that consumes it.

## Validation rules

The build system rejects manifests that violate any of these rules:

1. Missing `[package]` section.
2. Missing or empty `name` / `version` in `[package]`.
3. `version` not parseable as semver.
4. Neither `[bin]` nor `[lib]` declared and no defaults found at
   `src/main.av` / `src/lib.av`.
5. A dependency name that collides with the project's own `name`.
6. A path dependency pointing at a non-existent or non-Avra directory.
7. `opt_level` outside the recognized set.
8. A profile name containing characters outside `[a-z0-9_-]`.

All errors emit a stable F-code (range F4000–F4099 reserved for
manifest errors) with a helpful message and a pointer to this document.

## Forward compatibility

Unknown top-level sections produce a warning, not an error. Unknown
keys inside known sections produce a warning. This lets newer
manifests load on older toolchains with degraded behavior, matching
Cargo's policy. Strict validation is opt-in via `avra build
--strict-manifest`.

## Out of scope (v1.0)

- Workspaces (multiple packages sharing a target dir + lockfile)
- Build scripts (`build.av`)
- Registry index and version resolution
- Git dependencies
- `[features]` resolution
- Conditional compilation (`#[cfg(...)]`-equivalent)
- Per-target dep tables (`[target.'cfg(...)'.dependencies]`)

These are tracked under the build-system epic for future phases.
