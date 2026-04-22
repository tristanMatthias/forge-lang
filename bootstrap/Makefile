# Bootstrap compiler — friendly Makefile.
#
# The bootstrap is FULLY SELF-HOSTED. No Rust compiler needed.
# It builds from a checked-in LLVM IR seed (seed/seed.ll).
#
# Pipeline:
#   seed/seed.ll → llc + cc → seed binary → compiles src/ → bs2
#   bs2 → compiles src/ → bs3 (must match bs2 = fixed point)
#
# Quick reference:
#   make              build the bootstrap compiler
#   make test         run the full safety net (regression + fixed point)
#   make run FILE=x   compile and run a Forge program
#   make update-seed  rebuild seed IR from current source (after dogfooding)
#   make clean        remove all build artifacts
#   make help         show this list

.DEFAULT_GOAL := build
.PHONY: build build-O0 build-debug test run selfhost clean help install-hooks regress score update-seed seed-patch verify-seed seed-sigs next work epic

DIAG := NO_AUTOCYCLE=1 bash scripts/diagnose.sh

help:
	@echo "Bootstrap compiler — common targets:"
	@echo ""
	@echo "  make build         Build the bootstrap compiler (default)."
	@echo "  make build-O0      Build at -O0 for lldb debugging (build/bs2_O0)."
	@echo "  make test          Run regression suite + self-host fixed-point check."
	@echo "  make run FILE=x.fg Compile and run a Forge program."
	@echo "  make selfhost      Verify bs2 and bs3 emit byte-identical IR."
	@echo "  make regress       Run regression suite only (faster than 'test')."
	@echo "  make update-seed   Rebuild seed/seed.ll from current source (with verify)."
	@echo "  make seed-patch    Incremental seed update with per-function diff report."
	@echo "  make verify-seed   Verify bootstrap chain (no auto-cycle on failure)."
	@echo "  make seed-sigs     Compare function signatures between seed and source."
	@echo "  make clean         Remove all build artifacts."
	@echo "  make install-hooks Install the pre-commit hook."
	@echo ""
	@echo "Workflow:"
	@echo "  make next              Show next work item (highest priority open ticket)."
	@echo "  make work TICKET=x EPIC=y  Work a ticket using the 9-step inner formula."
	@echo "  make epic EPIC=x       Show epic status and open items."
	@echo ""
	@echo "Anything not listed: bash scripts/diagnose.sh --help"

# Lint: catch common bootstrap mistakes before building.
# Runs automatically before every build. Does NOT block — warnings only.
lint:
	@# Check for ValueType.Int in Stmt constructors outside parsers.
	@# This catches the bug where pipeline stages (desugar, resolver, mono)
	@# discard parser-resolved ValueType fields by writing ValueType.Int.
	@HITS=$$(grep -rn 'ValueType\.Int' src/ --include='*.fg' \
		| grep -E '\.(Let|Mut|Const|Function|ExternFn)\(' \
		| grep -v 'parser\.' | grep -v '// '); \
	if [ -n "$$HITS" ]; then \
		echo "\033[1;33m[lint]\033[0m ValueType.Int in Stmt constructors (may discard resolved types):"; \
		echo "$$HITS" | head -10; \
		echo ""; \
	fi
	@# Remind about pipeline tracing when typeck/codegen changed.
	@if git diff --name-only HEAD 2>/dev/null | grep -qE 'typeck/|codegen/|desugar/|resolve/|mono\.fg'; then \
		echo "\033[1;33m[lint]\033[0m Pipeline stage modified. If tests fail, trace values through:"; \
		echo "       parse → desugar → resolve_names → typecheck → monomorphize → codegen"; \
		echo "       Use 'check' before 'compile' to isolate typeck vs codegen."; \
		echo ""; \
	fi

# Build the bootstrap compiler. Produces build/bs2.
build: lint
	@$(DIAG) --build-bs2

# Build at -O0 for lldb debugging. Produces build/bs2_O0.
build-O0:
	@$(DIAG) --build-O0

# Build with --debug-null for null argument detection. Produces build/bs2_debug.
build-debug:
	@$(DIAG) --build-debug

# Full safety net: regression suite + fixed-point invariant.
test:
	@$(DIAG) --regress
	@$(DIAG) --check-fixedpoint

# Just the regression suite — faster, useful while iterating.
regress:
	@$(DIAG) --regress

# Just the fixed-point check.
selfhost:
	@$(DIAG) --check-fixedpoint

# Compile and run a single Forge file with the bootstrap compiler.
run:
ifndef FILE
	@echo "usage: make run FILE=path/to/program.fg" >&2
	@exit 1
endif
	@$(DIAG) --run $(FILE)

# Update the seed IR from the current self-hosted compiler.
# Run this after dogfooding new syntax into bootstrap source.
# The auto-cycle in --build-bs2 handles most seed updates automatically,
# but this target does a VERIFIED update with fixed-point check.
update-seed:
	@$(DIAG) --build-bs2
	@$(DIAG) --check-fixedpoint
	@cp src/main.fg.ll seed/seed.ll
	@# Prepend provenance comment (commit hash, timestamp, source hash)
	@COMMIT=$$(git rev-parse --short HEAD); \
	 TIMESTAMP=$$(date -u +%Y-%m-%dT%H:%M:%SZ); \
	 SRC_HASH=$$(find src/ -name '*.fg' -exec shasum -a 256 {} + | shasum -a 256 | cut -d' ' -f1); \
	 { printf '; seed built from commit %s at %s\n; source hash: %s\n' "$$COMMIT" "$$TIMESTAMP" "$$SRC_HASH"; cat seed/seed.ll; } > seed/seed.ll.tmp && \
	 mv seed/seed.ll.tmp seed/seed.ll
	@rm -f build/seed build/seed.o
	@echo "seed/seed.ll updated ($$(wc -l < seed/seed.ll | tr -d ' ') lines)"
	@echo "build/seed invalidated — next 'make build' rebuilds from new seed"
	@rm -rf build
	@$(DIAG) --build-bs2
	@echo "clean rebuild from new seed: OK"

# Incremental seed update: compile with bs2, report per-function diff, copy.
# Faster than 'update-seed' — skips the verification rebuild.
seed-patch:
	@$(DIAG) --seed-patch

# Verify bootstrap chain integrity (no auto-cycle on failure).
# Builds seed → bs2 → verifies bs2 self-compiles → verifies bs3 self-compiles.
verify-seed:
	@$(DIAG) --verify-seed

# Compare function signatures between seed IR and source .fg files.
# Reports parameter count mismatches, new functions, and removed functions.
seed-sigs:
	@$(DIAG) --seed-sigs

# Install the pre-commit hook (idempotent).
install-hooks:
	@ln -sf ../../bootstrap/scripts/pre-commit ../.git/hooks/pre-commit
	@echo "installed: .git/hooks/pre-commit -> bootstrap/scripts/pre-commit"

# Remove all build artifacts. Source and seed are preserved.
clean:
	@rm -rf build
	@rm -f src/*.fg.ll
	@echo "cleaned: build/ and src/*.fg.ll"

# Assemble the canonical grammar from feature fragments.
grammar:
	@echo "# Forge Bootstrap Grammar" > GRAMMAR.md
	@echo "" >> GRAMMAR.md
	@echo "Assembled from \`src/features/*/grammar.md\`." >> GRAMMAR.md
	@echo "" >> GRAMMAR.md
	@for f in src/features/*/grammar.md; do echo "---" >> GRAMMAR.md; echo "" >> GRAMMAR.md; cat "$$f" >> GRAMMAR.md; echo "" >> GRAMMAR.md; done
	@echo "assembled GRAMMAR.md ($$(wc -l < GRAMMAR.md | tr -d ' ') lines)"

# ── Workflow commands ──

# Show the next ticket to work on (highest priority open item in current epic).
next:
	@echo "=== Next work item ==="
	@bd ready -n 5 2>/dev/null || echo "Run 'bd prime' for setup"

# Work a ticket using the inner formula process (9 steps).
# Usage: make work TICKET=<id> EPIC=<epic-id>
work:
ifndef TICKET
	@echo "usage: make work TICKET=<bead-id> EPIC=<epic-id>" >&2
	@echo "  Runs the ticket-inner formula (implement → check → cleanup → break → polish)" >&2
	@echo "" >&2
	@echo "Current epic children:" >&2
	@bd show $(EPIC) 2>/dev/null | grep "↑.*○" || echo "  (no EPIC specified or no open items)"
	@exit 1
endif
	@echo "=== Working ticket $(TICKET) under epic $(EPIC) ==="
	@echo "Formula: ticket-inner (9 steps)"
	@echo ""
	@bd formula show ticket-inner 2>/dev/null
	@echo ""
	@echo "Starting..."
	@bd update $(TICKET) --claim 2>/dev/null

# Run the full epic workflow (outer formula).
# Usage: make epic EPIC=<epic-id>
epic:
ifndef EPIC
	@echo "usage: make epic EPIC=<epic-id>" >&2
	@echo "  Runs the epic-outer formula (select → work all tickets → review → close)" >&2
	@echo "" >&2
	@echo "Available epics:" >&2
	@bd list --type epic 2>/dev/null || echo "  (none found)"
	@exit 1
endif
	@echo "=== Working epic $(EPIC) ==="
	@echo "Formula: epic-outer (4 steps)"
	@echo ""
	@bd show $(EPIC) 2>/dev/null
	@echo ""
	@echo "Open items:"
	@bd show $(EPIC) 2>/dev/null | grep "↑.*○"
	@echo ""
	@echo "Run 'make work TICKET=<id> EPIC=$(EPIC)' for each ticket."

# Automated work loop: pick next ticket from current epic, or switch epics.
# Usage: make loop EPIC=<id>
# If all tickets in EPIC are done, shows next epic to switch to.
loop:
ifndef EPIC
	@echo "usage: make loop EPIC=<epic-id>" >&2
	@echo "" >&2
	@echo "Available epics:" >&2
	@bd list --type epic --status open 2>/dev/null
	@exit 1
endif
	@NEXT=$$(bd show $(EPIC) 2>/dev/null | grep "↑.*○" | head -1 | grep -o 'forge-crafting-intepreters-[a-z0-9]*' | sed 's/forge-crafting-intepreters-//'); \
	if [ -z "$$NEXT" ]; then \
		echo "=== Epic $(EPIC) complete! ==="; \
		echo ""; \
		echo "Next epics to work on:"; \
		bd list --type epic --status open 2>/dev/null | grep -v "$(EPIC)"; \
	else \
		echo "=== Working ticket $$NEXT in epic $(EPIC) ==="; \
		bd update $$NEXT --claim 2>/dev/null; \
		bd mol pour ticket-inner --var ticket_id=$$NEXT --var epic_id=$(EPIC) 2>/dev/null; \
		echo ""; \
		bd show $$NEXT 2>/dev/null; \
	fi
