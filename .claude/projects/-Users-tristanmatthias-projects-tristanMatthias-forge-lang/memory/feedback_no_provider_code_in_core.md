---
name: No provider-specific code in core
description: NEVER put @std provider-specific code (cli, term, http, model, etc.) in compiler core or features
type: feedback
---

The compiler core/ and features/ must NEVER contain code that references specific providers or @std libraries.

**Why:** The compiler is a generic infrastructure. Provider behavior is expressed through the template/expansion system. Hardcoding provider names (like `decl.component == "cli"`) or provider-specific expansion functions (like `expand_cli_component()`) in core violates the architecture. The user explicitly corrected this.

**How to apply:** When implementing a new provider like @std/cli, ALL provider-specific logic must live in the provider's own files (provider.fg template, native lib.rs). If the generic template system can't express what's needed, extend the generic system (e.g., add new ComponentTemplateItem variants, new template substitution features) — never add special cases for specific providers.
