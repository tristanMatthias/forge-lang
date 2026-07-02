---
name: cleanup-epic-children
description: For a given bd epic, create 3 mandatory cleanup sub-tickets (perf / DRY / red-team) under every existing child. Use when the user wants every phase of an epic to ship with the same aggressive quality bar — no lazy "ship and forget" — or asks to add cleanup tickets across an epic's children.
---

# Cleanup Tickets for Epic Children

This skill enforces a consistent post-implementation cleanup contract across every phase of a multi-phase epic. For each child of the supplied epic, it creates three sub-tickets describing mandatory passes:

- **`<child>.cleanupA`** — aggressive performance review
- **`<child>.cleanupB`** — DRY + use language features
- **`<child>.cleanupC`** — red-team review + edge cases

Each sub-ticket carries the full description of what counts as "done" for that pass. The point is to make laziness impossible: closing a phase without the cleanup tickets being explicitly addressed is visibly incomplete.

## When to invoke

- The user has just created an epic with multiple child tickets and wants the same quality bar applied to every phase.
- The user asks to "add cleanup tickets across this epic" or "make sure every child has a cleanup pass."
- Mid-epic, when an early phase shipped but its successors haven't grown the same cleanup contract.

## Inputs

The user supplies (or you infer from context) **one bd epic ID**. The format follows whatever bd uses in this repo (typically `<project-slug>-<short-id>`).

## Workflow

### Step 1 — Verify the epic exists and list its children

```bash
bd --sandbox show <epic-id>
```

Confirm the epic has child tickets. Closed children are skipped automatically (they already shipped without the cleanup contract — file a retro-cleanup ticket separately if you want to revisit).

### Step 2 — Run the bulk-create script

The `scripts/create_cleanup_tickets.sh` script walks the epic's open children and creates 3 sub-tickets per child, reading the cleanup-pass descriptions directly from this skill's `cleanup_pass_*.md` files. No template-copying needed — just point it at the epic ID.

```bash
.claude/skills/cleanup-epic-children/scripts/create_cleanup_tickets.sh <epic-id>
```

The script:
- Calls `bd --sandbox show` to discover OPEN children of the epic.
- For each child, calls `bd --sandbox create` three times with `--parent=<child-id>` and the appropriate cleanup-pass description as the body.
- Names each new ticket `<short-id>.cleanup{A,B,C}: <pass-name>`.
- Adds a blocking dep so each cleanup ticket depends on its parent phase being done — without this, cleanup tickets appear in `bd ready` immediately, ahead of the implementation they're meant to review.
- Prints `✓ <new-id> (blocked-by <child-id>)` per success or `✗ FAILED` with bd's output for failures.

### Step 3 — Verify the tree

```bash
bd --sandbox show <epic-id>
```

Confirm count: epic should now have its original children + 3 × N cleanup sub-tickets.

## What the cleanup passes mandate

Each sub-ticket's description is detailed and demanding (see `cleanup_pass_1.md`, `cleanup_pass_2.md`, `cleanup_pass_3.md` in this skill's directory). The high-level shape:

| Pass | Focus | Key bar |
|---|---|---|
| **A — perf** | Algorithmic complexity, allocations, fast-paths, mature compiler techniques | "Optimal, not just good." Measure before/after; file deferred wins. |
| **B — DRY + language features** | Duplication, abstraction opportunities, proper use of components/traits/generics, redundant types | "If two sites share 80% logic, share 80%." File cross-cutting refactors. |
| **C — red-team** | Smells, hacks, edge cases, recursion limits, error message quality, integration | "Happy path is 10% of code, 90% of bugs." File any smell not fixed. |

## Anti-patterns this skill exists to prevent

- Phases that "ship" without measurable perf review.
- Cumulative duplication across phases ("I'll DRY this later").
- Edge-case bugs lurking because reviews only checked the happy path.
- Cleanup tickets being filed as P3+ and silently never picked up.

By making each cleanup a P1 sub-ticket explicitly blocking the parent phase from closing, the work *cannot* be skipped without visible deferral.

## Files in this skill

- `SKILL.md` — this file
- `cleanup_pass_1.md` — perf-pass description (used as ticket body)
- `cleanup_pass_2.md` — DRY-pass description
- `cleanup_pass_3.md` — red-team-pass description
- `scripts/create_cleanup_tickets.sh` — the bulk-creation script

## Concrete example

A multi-phase epic with 12 open child phases (e.g. `myproject-abc`), each implementing one phase of a larger architectural change. Invoking the skill:

- Each open child gains 3 P1 cleanup sub-tickets (cleanupA / cleanupB / cleanupC).
- 36 new tickets total, all parented to the right child.
- The epic ticket can no longer close until every child + every cleanup is done.

The skill was extracted from a real session where a compiler's metaprogramming epic needed consistent post-implementation rigor across all phases. The approach generalizes to any multi-phase epic where quality must not degrade across phases.

## Anti-patterns to avoid when invoking

- **Don't run on an epic with closed children** without filing regret-tickets first. The closed children shipped without the cleanup; adding sub-tickets retroactively would just clutter unless you intend to retro-cleanup them.
- **Don't run twice on the same epic** without checking — the script doesn't dedupe. Closing duplicates after the fact is annoying.
- **Don't skip Step 4** — verify the tree. The bd dolt sync can occasionally drop tickets if it hits a network blip.
