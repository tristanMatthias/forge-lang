# Forge — Package Registry & Dependency Management

**Version:** 0.1.0-draft
**Status:** Design Specification
**Date:** March 2026

---

## Table of Contents

1. [Overview](#1-overview)
2. [Design Principles](#2-design-principles)
3. [Package Format](#3-package-format)
4. [Package Manifest](#4-package-manifest)
5. [Dependency Resolution](#5-dependency-resolution)
6. [Registry API](#6-registry-api)
7. [Local Cache & Storage](#7-local-cache--storage)
8. [Security Model](#8-security-model)
9. [Versioning](#9-versioning)
10. [Quality Signals](#10-quality-signals)
11. [Toolchain Commands](#11-toolchain-commands)
12. [forge.toml Dependency Syntax](#12-forgetoml-dependency-syntax)
13. [Lockfile](#13-lockfile)
14. [Publishing](#14-publishing)
15. [Git-Based Dependencies](#15-git-based-dependencies)
16. [Forge Context Integration](#16-forge-context-integration)
17. [Error Catalog](#17-error-catalog)
18. [Future: Local Index](#18-future-local-index)

---

## 1. Overview

The Forge package registry is the system for discovering, distributing, installing, and verifying third-party packages. A package is the unit of reuse in Forge — it may contain Forge source code, native libraries (Rust/Go/C), provider keyword definitions, or any combination of these.

The registry is a centralized API service maintained by the Forge project. It stores package metadata, content hashes, pre-compiled artifacts, and quality signals. Source code is hosted by package authors (typically in Git repositories) and verified against content hashes stored in the registry.

### What Makes Forge Packaging Different

- **One format.** Providers and libraries are the same thing. A package declares what it contains; the compiler adjusts trust accordingly.
- **Compiler-enforced semver.** The compiler computes the minimum version bump by diffing the public API surface. Authors can bump higher, never lower.
- **Capability sandboxing.** Packages declare capabilities (network, filesystem, native code). The compiler statically verifies these claims. Capability escalation in patch updates is a hard error.
- **No install scripts.** Nothing runs until `forge build`. The compiler is the only execution environment.
- **Content-addressed storage.** Every version is identified by a content hash. Published versions are immutable. Mutation is detectable and rejected.
- **Global cache, zero per-project duplication.** One copy of each package version, shared across all projects. No `node_modules`. No `vendor/`. No per-project dependency folders.
- **Pre-compiled artifacts.** Native providers ship as pre-compiled static libraries. Pure Forge packages ship as LLVM bitcode. First builds are fast; subsequent builds are near-instant.
- **Dead code elimination.** The compiler links only the functions you actually call. Large packages don't bloat your binary.
- **Rich machine-readable metadata.** Every package ships a Forge context — the full typed API surface — queryable without downloading source.

---

## 2. Design Principles

### 2.1 No Code Runs Until Compilation

The npm ecosystem's `postinstall` scripts are the root cause of most supply chain attacks. In Forge, `forge add` downloads source and metadata. Nothing executes. The first time any package code runs is inside `forge build`, within the compiler's capability sandbox. There is no mechanism for a package to execute arbitrary code at install time.

### 2.2 Capabilities Are Compiler-Enforced

A package's manifest declares what system resources it needs — network, filesystem, native code execution. Unlike advisory systems (npm audit), the Forge compiler statically verifies these claims. If a package says `capabilities = ["network"]` but its code also touches the filesystem, the compiler refuses to build. Native code packages are verified against their `.wit` interface contracts at the FFI boundary.

### 2.3 Immutability Is Cryptographic

Once published, a version is immutable. The registry stores content hashes. The lockfile stores content hashes. `forge build` verifies hashes before compilation. If upstream source changes after you locked a version, the build fails. There is no mechanism to silently mutate a published version.

### 2.4 The Registry Is Thin

The registry stores metadata, hashes, pre-compiled artifacts, and quality signals. The actual source is hosted by authors in Git repositories. This means no single point of failure for source availability, mirrors are trivial, and authors retain full control of their code.

### 2.5 Storage Is Minimal

Forge compiles to a single binary. Dependencies don't need to exist on disk at runtime. The global cache stores only compilation artifacts (bitcode, static libs, type signatures). Full source is evictable. A typical project's dependency footprint is 10-30MB in the global cache, zero bytes in the project directory.

---

## 3. Package Format

### 3.1 Unified Format

Providers and libraries use the same package format. A package is a directory containing:

```
my-package/
├── package.toml            # package manifest (required)
├── src/
│   ├── lib.fg              # Forge source (the entry point for this package)
│   └── ...                 # additional Forge source files
├── native/                 # native code (optional, only for packages with native = true)
│   ├── Cargo.toml          # Rust project for native library
│   └── src/
│       └── lib.rs
├── context.fg              # machine-readable API surface (auto-generated on publish)
├── tests/
│   └── ...                 # package tests
├── examples/
│   └── ...                 # runnable examples
├── CHANGELOG.md            # human-readable changelog
└── README.md               # package documentation
```

### 3.2 What Differentiates a Provider From a Library

Nothing structural. The `package.toml` declares what the package contains:

- A **pure Forge package** contains only `.fg` source files. It is inherently sandboxed by the language.
- A **native package** contains a `native/` directory with Rust/Go/C code that compiles to a static library. It requires `native = true` in the manifest and must declare capabilities.
- A **keyword package** (provider) defines new syntax keywords via `keyword` declarations in its Forge source. It may or may not include native code.

The compiler adjusts its trust model based on these declarations. The user sees a single `forge add` experience regardless.

### 3.3 Package Naming

Packages are namespaced:

- `@std/*` — Standard library packages. Ship with Forge. Maintained by the core team. Cannot be published to by third parties.
- `@org-name/*` — Organization-scoped packages. The organization must be registered with the registry. Example: `@acme/internal-auth`.
- `name` — Community packages. Any registered author can publish. First-come-first-served naming.

Package names must match `[a-z][a-z0-9_-]*`. Maximum 64 characters. No uppercase, no special characters beyond hyphen and underscore.

Organization names must match `[a-z][a-z0-9_-]*`. Maximum 32 characters. Must be registered and verified (email or domain verification).

---

## 4. Package Manifest

The `package.toml` file is the source of truth for a package's identity, capabilities, and dependencies.

### 4.1 Full Example

```toml
[package]
name = "graphql"
namespace = "community"                  # "std", "community", or an org name
version = "3.1.0"                        # semver, subject to compiler floor enforcement
description = "Full GraphQL server and client for Forge"
license = "MIT"
authors = ["Alice <alice@example.com>"]
repository = "https://github.com/alice/forge-graphql"
documentation = "https://forge-graphql.dev"
keywords = ["graphql", "api", "schema"]
forge_version = ">=0.2.0"               # minimum compatible Forge compiler version

[native]
enabled = true                           # this package includes native code
library = "forge_graphql"               # name of the compiled static library
targets = [                              # pre-compiled artifact targets
  "x86_64-unknown-linux-gnu",
  "aarch64-unknown-linux-gnu",
  "x86_64-apple-darwin",
  "aarch64-apple-darwin",
]

[capabilities]
# Compiler-enforced declarations of what this package accesses.
# If the code does something not declared here, compilation fails.
network = true                           # makes outbound network connections
filesystem = false                       # does not touch the filesystem
compile_time_codegen = false             # does not generate code at compile time

[keywords]
# Keywords this package registers (making it a "provider")
graphql = { kind = "block", context = "top_level" }

[dependencies]
"@std/http" = ">=0.1.0"
"http-client" = "^1.0.0"

[dev-dependencies]
"@std/test" = ">=0.1.0"

[context]
# Auto-populated on publish — the machine-readable API surface
exports = "context.fg"
```

### 4.2 Capability Declarations

Capabilities are the security boundary between packages and the host system. Every capability a package uses must be declared. The compiler verifies these statically.

| Capability | Meaning | Verification |
|---|---|---|
| `network` | Makes outbound network connections | Native code audited for socket/HTTP calls; Forge code checked for `@std/http` client usage |
| `filesystem` | Reads or writes files | Native code audited for file I/O syscalls; Forge code checked for `@std/fs` usage |
| `compile_time_codegen` | Generates Forge code at compile time | Checked by compiler: does the package emit AST nodes? |
| `native` | Includes compiled native code | Presence of `native/` directory and `[native]` section |
| `ffi` | Calls external system libraries | Native code audited for dynamic linking |

Undeclared capabilities are a compile error:

```
ERROR[E0460]: undeclared capability in package "graphql"

  Package "graphql" uses network I/O but does not declare
  capabilities.network = true in package.toml.

  Either:
    1. Add capabilities.network = true to package.toml
    2. Remove the network-dependent code path
```

---

## 5. Dependency Resolution

### 5.1 Version Ranges

Forge uses semver ranges in `forge.toml`:

```toml
[dependencies]
"@std/http" = "0.1.0"           # exact version
"graphql" = "^3.1.0"            # >=3.1.0, <4.0.0 (compatible updates)
"http-client" = "~1.2.0"        # >=1.2.0, <1.3.0 (patch updates only)
"utils" = ">=1.0.0, <3.0.0"     # explicit range
```

### 5.2 Resolution Algorithm

The resolver computes a dependency graph satisfying all version constraints:

1. Read `forge.toml` for direct dependencies and their version ranges.
2. For each dependency, query the registry for available versions.
3. Select the newest version satisfying the range.
4. Recursively resolve transitive dependencies.
5. Detect conflicts (two packages requiring incompatible versions of the same dependency).
6. Write the resolved graph to `forge.lock`.

If resolution fails, the compiler emits an actionable error:

```
ERROR[E0470]: dependency conflict

  Package "graphql" v3.1.0 requires "http-client" ^1.0.0
  Package "analytics" v2.0.0 requires "http-client" ^2.0.0

  These ranges are incompatible. Options:
    1. Update "graphql" to v4.0.0 (supports http-client ^2.0.0)
    2. Pin "analytics" to v1.x (supports http-client ^1.0.0)
    3. Run `forge deps explain http-client` for the full dependency chain
```

### 5.3 Deduplication

Forge does not allow multiple versions of the same package in a single build. This is stricter than npm (which allows duplication) but prevents an entire class of bugs where different parts of your codebase use different versions of the same type. If the resolver cannot find a single version satisfying all constraints, it's a hard error.

---

## 6. Registry API

The Forge package registry is a centralized HTTP API service. It is the source of truth for package metadata, content hashes, and pre-compiled artifacts.

### 6.1 Responsibilities

- **Package metadata storage**: names, versions, manifests, descriptions, authors.
- **Content hash storage**: SHA-256 hashes of every published version's source tree.
- **Pre-compiled artifact hosting**: LLVM bitcode (`.bc`) for pure Forge packages, static libraries (`.a`) for native packages, per target platform.
- **Quality signal computation**: test status, documentation coverage, maintenance activity, dependency health.
- **Forge context hosting**: machine-readable API surfaces for every package version, queryable without downloading source.
- **Transparency log**: append-only record of every publish event. Every entry is signed by the registry. Clients can audit the log.

### 6.2 API Endpoints

```
GET    /v1/packages?q=graphql&limit=20       # search packages
GET    /v1/packages/{name}                    # package metadata
GET    /v1/packages/{name}/versions           # all versions
GET    /v1/packages/{name}/{version}          # specific version metadata
GET    /v1/packages/{name}/{version}/context  # Forge context (typed API surface)
GET    /v1/packages/{name}/{version}/artifact/{target}  # pre-compiled artifact
GET    /v1/packages/{name}/{version}/hash     # content hash
POST   /v1/packages                           # publish new package
POST   /v1/packages/{name}/versions           # publish new version
GET    /v1/transparency-log                   # audit log
POST   /v1/auth/register                      # register author account
POST   /v1/auth/token                         # get auth token
```

### 6.3 Authentication

Publishing requires authentication. Authors register with the registry and receive an API token. Tokens are scoped: a token can be limited to specific packages or organizations. Token management is done via the CLI:

```bash
forge auth login                   # authenticate with the registry
forge auth token create            # create a scoped publish token
forge auth token list              # list active tokens
forge auth token revoke <id>       # revoke a token
```

### 6.4 Rate Limiting and Abuse Prevention

The registry enforces rate limits on all endpoints. Publishing is throttled to prevent spam. Automated quality checks run on every publish (see Section 10). Malicious packages are removed by the Forge team upon report.

---

## 7. Local Cache & Storage

### 7.1 Global Cache Structure

All packages are stored in a single global cache, shared across every project on the machine. There is no per-project dependency directory. No `node_modules`. No `vendor/`.

```
~/.forge/
├── cache/
│   ├── artifacts/                         # content-addressed compilation artifacts
│   │   ├── a3f2b1c4...                   # LLVM bitcode (.bc) or static lib (.a)
│   │   ├── 7e91d4af...
│   │   └── ...
│   ├── source/                            # evictable full source archives
│   │   ├── b8c3e2d1...                   # compressed source tree
│   │   └── ...
│   ├── context/                           # Forge context files (typed API surfaces)
│   │   ├── graphql@3.1.0.fg
│   │   └── ...
│   └── index/                             # name@version → hash mapping
│       ├── graphql@3.1.0.toml            # { artifact_hash, source_hash, ... }
│       └── ...
├── auth/
│   └── credentials.toml                   # registry auth tokens (user-readable only)
└── config.toml                            # global Forge configuration
```

### 7.2 Storage Tiers

The cache stores two tiers of data with different retention policies:

**Tier 1 — Compilation artifacts (pinned):** Pre-compiled LLVM bitcode (`.bc`) for pure Forge packages, pre-compiled static libraries (`.a`) for native packages, type signatures, and manifests. This is everything the compiler needs to build. It is never automatically evicted. Typical size: 1-5MB per package.

**Tier 2 — Full source (evictable):** The complete source archive of each package. Only needed for reading source, running package tests, or recompiling native code from source. Can be re-downloaded on demand. Evicted by `forge cache gc`.

### 7.3 Cache Operations

```bash
forge cache status                  # show cache size breakdown
forge cache gc                      # evict Tier 2 (source archives)
forge cache gc --aggressive         # evict everything not used by current project
forge cache clear                   # wipe entire cache (requires confirmation)
forge cache prefetch                # download all deps for current project (for offline work)
```

### 7.4 Size Estimates

| Scenario | Cache Size | Per-Project Size |
|---|---|---|
| 5 pure Forge dependencies | ~8MB | 0 bytes |
| 10 deps, 3 with native code | ~25MB | 0 bytes |
| 50 deps, heavy project | ~80MB | 0 bytes |
| After `forge cache gc` | ~40% of above | 0 bytes |

Compare: a hello-world Next.js project creates ~300MB of `node_modules` **per project**.

### 7.5 Pre-Compiled Artifacts

Native packages (those with `native = true`) are expensive to compile from source. The registry distributes pre-compiled static libraries for common targets:

- `x86_64-unknown-linux-gnu`
- `aarch64-unknown-linux-gnu`
- `x86_64-apple-darwin`
- `aarch64-apple-darwin`
- `wasm32-wasi` (edge target)

When `forge add` fetches a native package, it downloads the pre-compiled `.a` for the current platform. No Rust/Go/C toolchain required. If no pre-compiled artifact exists for the target, the compiler falls back to building from source (requires the appropriate toolchain).

### 7.6 LLVM Bitcode Caching

Pure Forge packages are compiled to LLVM bitcode (`.bc`) by the registry at publish time. When `forge build` runs:

1. Your source code is compiled from source (full pipeline: parse → type check → LLVM IR → bitcode).
2. Dependencies are loaded as pre-compiled bitcode from the cache. No parsing, no type checking, no IR generation.
3. LLVM's link-time optimization (LTO) runs across your code and dependency bitcode, enabling cross-package inlining.
4. Final machine code generation produces the binary.

This means first builds download bitcode from the registry. Subsequent builds are near-instant because everything is cached locally. Build times scale with the size of *your* code, not your dependency tree.

### 7.7 Dead Code Elimination

Because Forge compiles to a single binary via LLVM, the linker performs aggressive dead code elimination. If you use 3 of a package's 47 exported functions, only those 3 (and their transitive dependencies) are included in the binary. Adding a large package with a rich API does not meaningfully bloat your binary.

---

## 8. Security Model

Forge's security model is designed to make the entire class of npm/PyPI supply chain attacks structurally impossible, not merely unlikely.

### 8.1 Layer 1 — No Install Scripts

There is no mechanism for a package to execute code at install time. `forge add` downloads source and metadata. Nothing runs. The first execution happens inside `forge build`, which applies all capability checks before compilation proceeds. This eliminates the attack vector used by `event-stream`, `ua-parser-js`, and most npm supply chain attacks.

### 8.2 Layer 2 — Compiler-Enforced Capabilities

Capability declarations in `package.toml` are not advisory. The compiler statically verifies that a package's code does not exceed its declared capabilities.

For pure Forge code, this is checked by analyzing imports and function calls against known capability-granting APIs (e.g., `@std/fs` requires `filesystem`, `@std/http` client requires `network`).

For native code, the `.wit` interface contract defines the FFI boundary. The compiler verifies that the native library's exported functions match the declared interface. Functions that perform I/O operations outside the declared capabilities are rejected at the FFI boundary.

If a package claims `capabilities.network = true` but its code also touches the filesystem, the compiler emits:

```
ERROR[E0461]: capability violation in package "suspicious-pkg"

  Package "suspicious-pkg" declares capabilities: [network]
  But code at native/src/lib.rs:42 performs filesystem I/O.

  This is a capability violation. Either:
    1. The package should declare capabilities.filesystem = true
    2. The filesystem access is unintentional and should be removed

  This may indicate a compromised package. Proceed with caution.
```

### 8.3 Layer 3 — Capability Propagation and Escalation Detection

When you add a package, the compiler shows the full capability tree:

```
forge add graphql

  graphql v3.1.0
    capabilities: [network, native]
    └─ http-client v1.0.0
       capabilities: [network, native]

  New capabilities introduced to your project: [network, native]
  Accept? (y/n)
```

Capabilities are tracked per-dependency. If a **patch update** to a dependency introduces a new capability, `forge build` fails with a hard error:

```
ERROR[E0462]: capability escalation detected

  Package "graphql" updated from 3.1.0 → 3.1.1
  New capability requested: [filesystem]

  3.1.0 capabilities: [network, native]
  3.1.1 capabilities: [network, native, filesystem]

  A patch update should not introduce new capabilities.
  This may indicate a compromised package.

  To proceed: forge allow graphql filesystem
  To rollback: forge update graphql@3.1.0
```

This is a critical security boundary. Legitimate patch releases should never need new capabilities. Capability escalation in a patch is the exact fingerprint of a compromised package.

### 8.4 Layer 4 — Content-Addressable Lockfile

The `forge.lock` file stores SHA-256 content hashes for every resolved dependency:

```toml
[[package]]
name = "graphql"
version = "3.1.0"
source = "https://github.com/alice/forge-graphql"
hash = "sha256:a3f2b1c4e8d9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5"
artifact_hash = "sha256:7e91d4af..."
```

At build time, the compiler verifies that the cached content matches the lockfile hash. If the upstream source for a version has changed since the lock was created (a "mutation attack"), the build fails:

```
ERROR[E0463]: content hash mismatch for "graphql" v3.1.0

  Expected: sha256:a3f2b1c4...
  Got:      sha256:9x8y7z6w...

  The source for this version has changed since forge.lock was created.
  This may indicate a compromised package or a registry inconsistency.

  To investigate: forge audit graphql
  To re-resolve: forge update graphql (updates lock with new hash)
```

### 8.5 Layer 5 — Transparency Log

Every publish event is recorded in an append-only transparency log maintained by the registry. The log is publicly auditable. Each entry contains:

- Package name and version
- Content hash of the published source
- Author identity (verified)
- Timestamp
- Registry signature

The log guarantees:

- A version cannot be silently unpublished and re-published with different content.
- The history of all publishes is tamper-evident.
- Third-party auditors can verify that the registry has not been compromised.

Clients can optionally verify their lockfile hashes against the transparency log:

```bash
forge audit --verify-log          # verify all deps against transparency log
```

### 8.6 Layer 6 — Native Code Sandboxing

Packages with `native = true` are the highest-risk category because native code can perform arbitrary operations. Forge mitigates this through:

1. **Pre-compiled artifacts from the registry are built in a sandboxed CI environment.** The registry compiles native code from source in a reproducible, auditable build environment. The resulting `.a` files are signed by the registry.

2. **Users can verify pre-compiled artifacts by building from source.** `forge build --from-source` compiles all native dependencies from source and compares the output against the pre-compiled artifacts. A mismatch is a red flag.

3. **Capability enforcement at the FFI boundary.** The compiler generates wrapper functions around every FFI call that enforce declared capabilities. A native function that attempts to open a network socket when only `filesystem` is declared will fail at runtime with a capability violation error.

4. **Reproducible builds.** Given the same lockfile and compiler version, `forge build` produces a byte-identical binary. This makes it possible to verify that a binary was built from the claimed source.

### 8.7 Security Summary

| Attack Vector | npm/PyPI Status | Forge Mitigation |
|---|---|---|
| Malicious install scripts | Common attack vector | **Impossible.** No install script mechanism exists. |
| Undeclared capabilities | No enforcement | **Compile error.** Capabilities are statically verified. |
| Capability escalation in patch | Undetected | **Hard error.** Patch updates cannot add capabilities. |
| Version mutation | Possible on some registries | **Detected.** Content hashes verified at build time. |
| Typosquatting | Common | **Mitigated.** Registry rejects names too similar to popular packages. |
| Dependency confusion | Internal vs public name collision | **Mitigated.** Organization scopes (`@org/`) isolate internal packages. |
| Compromised maintainer account | Ongoing problem | **Mitigated.** Transparency log makes all publishes auditable. Scoped tokens limit blast radius. |

---

## 9. Versioning

### 9.1 Compiler-Enforced Semver

Forge's type system provides a complete, machine-readable public API surface for every package. The compiler uses this to enforce semantic versioning. On publish, the compiler:

1. Extracts the **public API signature** — every exported type, function, model, keyword, and their full type signatures.
2. Compares it against the **previous version's** API signature.
3. Classifies every difference.
4. Computes the **minimum allowed version bump**.

### 9.2 Change Classification

| Change | Classification | Minimum Bump |
|---|---|---|
| New exported function/type | Addition | Minor |
| New optional field on exported type | Addition | Minor |
| New required field on exported type | Breaking | Major |
| Removed export | Breaking | Major |
| Changed function signature | Breaking | Major |
| Renamed export | Breaking (removal + addition) | Major |
| Changed keyword syntax | Breaking | Major |
| Internal-only change (no API diff) | Patch | Patch |
| New capability declared | Capability change | Minor (but triggers user approval) |
| Removed capability | Capability reduction | Patch |

### 9.3 The Floor Rule

**The compiler computes the minimum version bump. The author can bump higher, never lower.**

This means:

- If you made an internal refactor only (patch-level change), you can release it as `2.0.0` if you want to signal a major milestone. The compiler allows bumping higher.
- If you removed an export (breaking change), you **cannot** release it as a patch. The compiler enforces the floor.

```bash
forge publish

# API diff since 1.2.3:
#   - removed: export fn legacy_parse(raw: string) -> Config
#   + added:   export fn parse(raw: string, opts?: ParseOpts) -> Config
#
# Minimum version: 2.0.0 (breaking change: export removed)
#
# Version [2.0.0]: _
```

The author enters the version. If they try to enter `1.2.4`:

```
ERROR[E0480]: version 1.2.4 is below the minimum allowed version 2.0.0

  Breaking changes detected:
    - removed: export fn legacy_parse(raw: string) -> Config

  The minimum version for a breaking change is a major bump.
  Minimum allowed: 2.0.0
```

If the author enters `2.0.0` or `3.0.0` — both are accepted.

### 9.4 Behavioral Changes

The compiler can detect API surface changes but cannot detect behavioral changes (e.g., a sort function changing from stable to unstable sort). The publish flow asks the author:

```
# No public API changes detected.
# Minimum version: 1.2.4 (patch)
#
# Does this release contain behavioral changes to existing functions? (y/n): y
# Describe the behavioral change:
> sort() is now unstable sort for performance. Use stable_sort() for order preservation.
#
# Behavioral changes bump to at least minor: 1.3.0
# Version [1.3.0]: _
```

### 9.5 Version Trustworthiness

Because versions are compiler-enforced:

- A **patch** bump guarantees no public API changes. Guaranteed. Not a convention — a compiler check.
- A **minor** bump guarantees only additions (or declared behavioral changes). No removals, no signature changes.
- A **major** bump means something was removed or changed.

This makes version numbers meaningful signal rather than human opinion.

---

## 10. Quality Signals

Quality is a continuous, computed signal — not a binary badge and not a namespace. Every package in the registry has automatically computed quality metrics that are surfaced in search results and `forge info` output.

### 10.1 Computed Signals

| Signal | How It's Computed |
|---|---|
| **Tests** | Does the package have tests? Do they pass on the registry's CI? |
| **Type completeness** | Are all public exports fully typed? (Always true in Forge, but doc comments are checked.) |
| **Documentation** | Does every public export have a doc comment? Is there a README? |
| **Maintenance** | Last publish date. Commit activity on source repo. Issue response time. |
| **Dependency health** | Are all dependencies well-maintained? Any known vulnerabilities in the tree? |
| **Capability minimalism** | Does the package declare only the capabilities it needs? Fewer = better. |
| **Adoption** | Download count. Number of packages that depend on this one. |
| **API stability** | Ratio of major bumps to total releases. Fewer breaking changes = more stable. |

### 10.2 Quality Score

These signals are combined into a single 0-10 quality score, surfaced in search results:

```
forge search graphql

  graphql v3.1.0                     ████████░░ 8.2/10
    "Full GraphQL server and client for Forge"
    ✓ tests  ✓ documented  ✓ maintained  ✓ stable API
    capabilities: [network, native]
    downloads: 12.4k | dependents: 89

  graphql-lite v0.2.0                ████░░░░░░ 4.1/10
    "Minimal GraphQL parser"
    ✓ typed  ✗ no tests  ✗ sparse docs  ⚠ unmaintained (8 months)
    capabilities: []
    downloads: 340 | dependents: 3
```

### 10.3 Not a Namespace

Quality signals are metadata, not identity. A package's name and import path never change based on quality. If a package's quality drops (tests start failing, maintainer goes inactive), the signal updates but no consumer needs to change their code. This avoids the problem of namespace-based verification where degradation would break import paths.

---

## 11. Toolchain Commands

### 11.1 Package Management

```bash
# Add a dependency
forge add graphql                    # latest compatible version
forge add graphql@3.1.0             # specific version
forge add graphql@^3.0.0            # version range
forge add @acme/internal-auth        # organization-scoped package

# Add from Git (see Section 15)
forge add git:https://github.com/alice/forge-graphql.git
forge add git:https://github.com/alice/forge-graphql.git#v3.1.0
forge add git:https://github.com/alice/forge-graphql.git#main

# Remove a dependency
forge remove graphql

# Update dependencies
forge update                         # update all to latest compatible
forge update graphql                 # update specific package
forge update graphql@4.0.0          # update to specific version

# List dependencies
forge deps                           # show dependency tree
forge deps --flat                    # flat list
forge deps --outdated                # show available updates
```

### 11.2 Dependency Inspection

```bash
# Package info
forge info graphql                   # full metadata, quality signals, capabilities
forge info graphql --context         # show typed API surface (Forge context)
forge info graphql --versions        # list all published versions
forge info graphql --changelog       # show changelog between versions

# Dependency analysis
forge deps explain http-client       # why is this in my project? full chain.
forge deps tree                      # full dependency tree with versions
forge deps size                      # size contribution of each dependency
forge deps capabilities              # all capabilities in the dependency tree
```

### 11.3 `forge why`

Explains why a transitive dependency is in the project:

```bash
forge why http-client

  http-client v1.0.0 is in your project because:

    your code → graphql v3.1.0 → http-client v1.0.0

  It contributes:
    2 functions linked (of 24 exported)
    14KB to binary size
    capabilities: [network] (already approved via graphql)

  If removed: graphql v3.1.0 would fail to compile
```

### 11.4 Cache Management

```bash
forge cache status                   # cache size breakdown by tier
forge cache gc                       # evict source archives, keep compilation artifacts
forge cache gc --aggressive          # evict everything not used by current project
forge cache clear                    # wipe entire cache
forge cache prefetch                 # download all deps for offline work
```

### 11.5 Security

```bash
forge audit                          # check all deps for known vulnerabilities
forge audit --verify-log             # verify lockfile hashes against transparency log
forge allow <package> <capability>   # approve a capability escalation
```

### 11.6 Publishing

```bash
forge publish                        # publish current package to registry
forge publish --dry-run              # show what would be published (API diff, version)
forge auth login                     # authenticate with registry
forge auth token create              # create scoped publish token
forge auth token list                # list active tokens
forge auth token revoke <id>         # revoke a token
```

---

## 12. forge.toml Dependency Syntax

Dependencies are declared in the project's `forge.toml`:

### 12.1 Basic Dependencies

```toml
[dependencies]
"@std/http" = "0.1.0"               # exact version
"@std/sql" = "0.1.0"
"graphql" = "^3.1.0"                 # compatible updates (>=3.1.0, <4.0.0)
"http-client" = "~1.2.0"            # patch updates only (>=1.2.0, <1.3.0)
```

### 12.2 Git Dependencies

```toml
[dependencies]
"my-internal-lib" = { git = "https://github.com/acme/my-lib.git" }
"my-internal-lib" = { git = "https://github.com/acme/my-lib.git", tag = "v1.0.0" }
"my-internal-lib" = { git = "https://github.com/acme/my-lib.git", branch = "main" }
"my-internal-lib" = { git = "https://github.com/acme/my-lib.git", rev = "a3f2b1c" }
```

### 12.3 Path Dependencies (Local Development)

```toml
[dependencies]
"my-local-lib" = { path = "../my-lib" }
```

Path dependencies are resolved at build time. They are not published to the registry. If you publish a package with path dependencies, the compiler emits an error.

### 12.4 Dev Dependencies

```toml
[dev-dependencies]
"@std/test" = ">=0.1.0"
"test-fixtures" = "^1.0.0"
```

Dev dependencies are only resolved for `forge test` and `forge bench`. They are not included in the published package's dependency tree.

### 12.5 Capability Approvals

Approved capabilities are stored in `forge.toml` so they're version-controlled with the project:

```toml
[capabilities.approved]
"graphql" = ["network", "native"]
"@std/http" = ["network", "native"]
```

When `forge add` introduces a package with capabilities, and the user approves, the approval is recorded here. Subsequent `forge build` checks approvals against this list.

---

## 13. Lockfile

### 13.1 Purpose

`forge.lock` records the exact resolved dependency graph: specific versions, content hashes, and artifact hashes. It guarantees reproducible builds. The lockfile is committed to version control.

### 13.2 Format

```toml
# forge.lock — auto-generated by forge. Do not edit manually.

[metadata]
forge_version = "0.2.0"
resolved_at = "2026-03-14T10:30:00Z"

[[package]]
name = "graphql"
version = "3.1.0"
source = "registry"
hash = "sha256:a3f2b1c4e8d9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5"
artifact_hash = "sha256:7e91d4af3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c7d6e"
capabilities = ["network", "native"]
dependencies = ["http-client@1.0.0"]

[[package]]
name = "http-client"
version = "1.0.0"
source = "registry"
hash = "sha256:1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b"
artifact_hash = "sha256:2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c"
capabilities = ["network", "native"]
dependencies = []

[[package]]
name = "@std/http"
version = "0.1.0"
source = "std"
hash = "sha256:..."
artifact_hash = "sha256:..."
capabilities = ["network", "native"]
dependencies = []
```

### 13.3 Build Verification

On every `forge build`:

1. Read `forge.lock`.
2. For each dependency, verify the cached artifact's hash matches `artifact_hash`.
3. If any hash mismatches, fail with `E0463` (content hash mismatch).
4. If a dependency is missing from the cache, fetch it and verify before proceeding.

### 13.4 Reproducible Builds

Given the same `forge.lock`, `forge.toml`, source code, and Forge compiler version, `forge build` produces a byte-identical binary. The lockfile captures everything needed for reproducibility.

---

## 14. Publishing

### 14.1 Publish Flow

```bash
forge publish
```

The publish command:

1. **Authenticates** with the registry using the stored token.
2. **Runs tests.** `forge test` must pass. If tests fail, publish is rejected.
3. **Extracts the public API signature** from the package source.
4. **Fetches the previous version's API signature** from the registry.
5. **Computes the API diff** and classifies changes.
6. **Computes the minimum version bump** based on the diff.
7. **Prompts the author for a version number** (must be ≥ minimum).
8. **Prompts for behavioral change declaration** if no API changes detected.
9. **Prompts for a changelog message** (required for major bumps).
10. **Generates the Forge context** (`context.fg`) — the machine-readable API surface.
11. **Computes the content hash** of the source tree.
12. **Compiles pre-compiled artifacts** (bitcode and/or static libs) for declared targets.
13. **Uploads** metadata, hashes, context, and artifacts to the registry.
14. **Registry records** the publish in the transparency log.

### 14.2 First Publish

The first version of a new package can be any version. Convention is `0.1.0` for initial development and `1.0.0` for the first stable release. There is no API diff on first publish.

### 14.3 Dry Run

```bash
forge publish --dry-run

# Package: graphql
# Current published version: 3.0.2
#
# API diff:
#   + added: export fn parse_schema(raw: string) -> Schema
#   + added: export type Schema = { types: List<TypeDef>, queries: List<QueryDef> }
#   (no removals, no changes)
#
# Minimum version: 3.1.0 (minor — additions only)
#
# Quality checks:
#   ✓ tests pass (42 tests, 0 failures)
#   ✓ all exports documented
#   ✓ capabilities unchanged
#   ✓ context.fg generated (12 exports)
#
# Ready to publish. Run `forge publish` to proceed.
```

### 14.4 Yanking

An author can yank a version, which marks it as "do not use for new installs" but does not delete it. Existing lockfiles referencing a yanked version continue to work. New `forge add` or `forge update` will not select a yanked version.

```bash
forge yank graphql@3.1.0 --reason "critical bug in schema parser"
```

Yanked versions are visible in the registry with a warning. They are never truly deleted (immutability guarantee).

---

## 15. Git-Based Dependencies

For packages not published to the registry — private packages, forks, pre-release testing — Forge supports Git-based dependencies.

### 15.1 Syntax

```toml
[dependencies]
# Latest commit on default branch
"my-lib" = { git = "https://github.com/acme/my-lib.git" }

# Specific tag
"my-lib" = { git = "https://github.com/acme/my-lib.git", tag = "v1.0.0" }

# Specific branch
"my-lib" = { git = "https://github.com/acme/my-lib.git", branch = "main" }

# Specific commit
"my-lib" = { git = "https://github.com/acme/my-lib.git", rev = "a3f2b1c4" }

# SSH URLs (for private repos)
"my-lib" = { git = "git@github.com:acme/my-lib.git", tag = "v1.0.0" }
```

### 15.2 Resolution

Git dependencies are resolved at `forge add` or `forge update` time:

1. Clone/fetch the repository to a local cache (`~/.forge/cache/git/`).
2. Checkout the specified ref (tag, branch, or commit).
3. Verify that `package.toml` exists in the repo root.
4. Compute the content hash of the source tree.
5. Record the resolved commit hash in `forge.lock`.

Subsequent `forge build` uses the locked commit hash. The build is reproducible as long as the commit exists in the remote repository.

### 15.3 Security Considerations for Git Dependencies

Git dependencies bypass the registry's transparency log and pre-compiled artifact pipeline. They are inherently higher-risk:

- **No transparency log verification.** The registry cannot audit publishes that never go through it.
- **No pre-compiled artifacts.** Native code must be compiled from source, requiring the appropriate toolchain.
- **Branch refs are mutable.** A `branch = "main"` dependency can change between resolves. The lockfile pins the commit hash, but `forge update` will pick up new commits.

The compiler warns when a project uses Git dependencies:

```
WARNING[W0040]: project uses Git-based dependencies

  The following dependencies are not from the registry and
  bypass transparency log verification:

    my-lib (git: github.com/acme/my-lib @ a3f2b1c4)

  Consider publishing to the registry for supply chain security.
```

Capability enforcement still applies to Git dependencies. The compiler reads `package.toml` from the Git source and enforces capabilities identically to registry packages.

---

## 16. Forge Context Integration

### 16.1 What Is Forge Context?

Every package ships a `context.fg` file — a machine-readable description of its complete public API surface. This is the same format generated by `forge context` for project-level documentation. It includes:

- All exported types with full type signatures
- All exported functions with parameter types and return types
- All exported keywords with their syntax patterns and config schemas
- All capability requirements
- Doc comments for every export

### 16.2 Registry-Queryable Context

The registry stores `context.fg` for every published version. It is queryable via the API without downloading the full package:

```bash
forge info graphql --context

# graphql v3.1.0 — Forge Context
#
# Keywords:
#   graphql { ... }        — defines a GraphQL schema block
#
# Types:
#   Schema = { types: List<TypeDef>, queries: List<QueryDef> }
#   TypeDef = { name: string, fields: List<FieldDef> }
#   ...
#
# Functions:
#   export fn parse_schema(raw: string) -> Schema
#   export fn execute(schema: Schema, query: string) -> Result<json, GraphQLError>
#   ...
#
# Capabilities: [network, native]
```

### 16.3 Use in Development

The Forge context system enables:

- **Package evaluation without installation.** Read the full typed API of any package from the registry before adding it to your project.
- **LSP integration.** The language server can provide completions and hover info for package exports using only the cached context, without compiling the full package.
- **`forge context` includes dependencies.** When you generate context for your project, it includes a summary of dependency APIs so an LLM has full context.

---

## 17. Error Catalog

All package-related errors use the E0450-E0499 range.

| Code | Error | Description |
|---|---|---|
| E0450 | `dependency_not_found` | Package name not found in registry or Git URL |
| E0451 | `version_not_found` | Requested version does not exist |
| E0452 | `version_range_unsatisfiable` | No version satisfies the declared range |
| E0453 | `dependency_conflict` | Two packages require incompatible versions of the same dependency |
| E0454 | `circular_dependency` | Dependency graph contains a cycle |
| E0460 | `undeclared_capability` | Package code uses a capability not declared in package.toml |
| E0461 | `capability_violation` | Package code exceeds declared capabilities |
| E0462 | `capability_escalation` | Patch/minor update introduces new capabilities |
| E0463 | `content_hash_mismatch` | Cached content doesn't match lockfile hash |
| E0464 | `artifact_hash_mismatch` | Pre-compiled artifact doesn't match expected hash |
| E0465 | `lockfile_stale` | forge.lock doesn't match forge.toml (deps added/removed) |
| E0470 | `duplicate_version` | Cannot have multiple versions of the same package |
| E0480 | `version_below_minimum` | Publish version is below compiler-computed minimum |
| E0481 | `publish_tests_failed` | Cannot publish: tests do not pass |
| E0482 | `publish_auth_failed` | Registry authentication failed |
| E0483 | `publish_name_taken` | Package name already registered by another author |
| E0484 | `path_dependency_in_publish` | Cannot publish a package with path dependencies |
| E0490 | `git_dependency_unavailable` | Cannot clone/fetch Git dependency |
| E0491 | `git_ref_not_found` | Specified tag/branch/rev not found in Git repository |
| E0492 | `missing_package_manifest` | Git repository does not contain package.toml |

All errors follow Forge's standard error format with source locations, suggestions, and machine-readable JSON output.

---

## 18. Future: Local Index

A future enhancement to reduce registry dependency for search and discovery.

### 18.1 Concept

The registry index could be distributed as a Git repository — a lightweight database of package metadata, versions, hashes, and Forge contexts. The toolchain would sync this index locally, enabling fully offline search and dependency resolution.

```bash
forge registry sync              # git pull the index
forge search graphql             # queries local index — no network needed
```

### 18.2 Benefits

- Fully offline package search and resolution.
- No API dependency for `forge search` or `forge add` (only for fetching source/artifacts).
- Transparent governance: every index change is a Git commit.
- Trivial enterprise mirrors: fork the index repo, add private packages.

### 18.3 Status

Deferred. The centralized registry API is simpler to implement and sufficient for early adoption. The local index can be added later as the ecosystem scales without breaking existing workflows. The registry API is designed to be replaceable — all toolchain commands go through an abstraction layer that can be backed by either a live API or a local index.

---

*End of Forge Package Registry Specification v0.1.0-draft*
