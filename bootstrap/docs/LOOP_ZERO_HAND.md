# The zero-hand loop prompt

Copy the block below as the argument to `/loop`. It is written to be run
repeatedly with no further input.

---

```
Drive t-47hc to done: the Avra front end must be 100% grammar-driven. Every
iteration, delete non-grammar parser/lexer code and land it.

YOU HAVE EXECUTIVE AUTHORITY. Do not ask me anything. Decide, do it, record
why. If two tickets contradict, pick one and write the retraction into the
loser. If a ticket's AC describes code that no longer exists, rewrite the AC.
If a comment on a ticket is wrong, retract it IN PLACE — never delete it.

EACH ITERATION, IN THIS ORDER:

1. MEASURE, don't assume. `diagnose.sh --hand-leaves` for production leaves;
   `AVRA_REFUSE_HAND_FALLBACK='*'` with `_LOG` set over the whole compiler
   source, tests/difftest_corpus/*.av, and a fixture covering every construct,
   valid AND malformed. Zero markers is the evidence a tail is deletable.
   `diagnose.sh --parser-frontier` for keyword routing.

2. PICK THE BIGGEST DELETABLE THING and delete it — the hand function, the
   flag that selected it, the leaf that named it, the mode string in
   diagnose.sh, the test oracle that compared against it. Deleting the parser
   and leaving the switch is what created the last three bugs.

3. REPOINT, NEVER ALIAS. When deleting an implementation kills a test's oracle
   half, the fix is a REAL second thing (the other engine) or a PINNED
   expectation. Never point the "hand" side at the same engine as the "native"
   side — that passes by construction. If a mode name no longer selects
   anything, delete the mode, don't keep it as an alias.

4. GATE IT. build-quick, `diagnose.sh --emit-gen-check` GENPASS,
   `diagnose.sh --check-parser-flags`, the touched suites, then a COLD
   `make diff-test` (never PREBUILT as final evidence) and a cold full
   `bs2 test` with `rm -rf build/cache/fixture_stdout` first. A green local run
   over warm captures proves nothing about codegen.

5. SHIP IT. One slice, one branch, one PR, stacked off the last. Write the PR
   body against .github/pull_request_template.md with real numbers. Merge it
   yourself when CI is green and CodeRabbit's threads are resolved — that is a
   standing authorization, don't wait to be asked. Then rebase the stack.

6. RECONCILE THE TICKETS. Every iteration, before you stop: close what the
   slice finished (check the AC line by line — quote it), reword ACs that
   describe deleted code, and retract-in-place any comment you now know is
   wrong. A ticket tree that stops describing the code is a defect.

RULES THAT COST ME SESSIONS — obey them:

- A test that compares two things must run two DIFFERENT implementations.
  Check this every time you touch an oracle. Most of the bugs here were a
  comparison that had quietly become native-vs-native.
- "I could not construct an input where X diverges" is a statement about the
  oracles you had, not about X. Say so in the comment, and revisit when the
  oracle set changes.
- Never `git checkout --`, `reset --hard`, `stash drop`, or `clean`. Fix
  forward.
- The executor is PRODUCTION for the type family. A fix to emit is not a fix
  until you check the executor has the mirror of it, and vice versa.
- On ENOSPC: `make clean` from bootstrap/, then retry. Never ask me to clean up.
- A local diff-test divergence with green CI means your BASE is stale — rebase
  onto integration and re-fetch the pinned seed before believing it.
- A shard is named after the FIRST file in its batch, not the failing one.
  Open the log.

STOP CONDITION: `--hand-leaves` reports 0 production leaves, the hand-fallback
probe fires zero times in every routing configuration, no `parse_*_hand`
remains reachable, and every t-47hc ticket is either closed or has an AC that
matches the code. Until then there is always a next slice — find it and ship it.
```

---

## Why it is shaped this way

**Step 2 exists because of a real failure mode.** Deleting a parser and
leaving the switch that selected it is what produced the last three bugs in
this program: `AVRA_NO_STATIC_FALLBACK`, `AVRA_PARSER_DECL_FLIP` (t-bw9s), and
`AVRA_PARSER_EXPR_STATIC` (t-47hc.4.1). Each looked harmless — the default
still routed correctly — and each left a setting that *appeared* to select an
oracle while selecting nothing.

**Step 3 is the one that actually needs the instruction.** When you delete an
implementation, every test comparing against it needs a new second side. The
tempting move is to alias the dead mode onto the surviving one; the result is
hundreds of assertions that pass by construction. Repointing the recovery
corpus from `hand-vs-emit` to `emit-vs-exec` immediately surfaced ten real
divergences, one of which was a live bug.

**Step 6 is not bookkeeping.** Two tickets in this tree carried a comment
recommending closure on a criterion the project had not adopted, followed by a
retraction. The retraction is what makes the history usable. Overwriting the
wrong comment would have hidden the reasoning error.
