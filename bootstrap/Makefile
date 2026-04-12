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
.PHONY: build build-O0 test run selfhost clean help install-hooks regress score update-seed verify-seed seed-sigs

DIAG := bash scripts/diagnose.sh

help:
	@echo "Bootstrap compiler — common targets:"
	@echo ""
	@echo "  make build         Build the bootstrap compiler (default)."
	@echo "  make build-O0      Build at -O0 for lldb debugging (build/bs2_O0)."
	@echo "  make test          Run regression suite + self-host fixed-point check."
	@echo "  make run FILE=x.fg Compile and run a Forge program."
	@echo "  make selfhost      Verify bs2 and bs3 emit byte-identical IR."
	@echo "  make regress       Run regression suite only (faster than 'test')."
	@echo "  make update-seed   Rebuild seed/seed.ll from current source."
	@echo "  make verify-seed   Verify bootstrap chain (no auto-cycle on failure)."
	@echo "  make seed-sigs     Compare function signatures between seed and source."
	@echo "  make clean         Remove all build artifacts."
	@echo "  make install-hooks Install the pre-commit hook."
	@echo ""
	@echo "Anything not listed: bash scripts/diagnose.sh --help"

# Build the bootstrap compiler. Produces build/bs2.
build:
	@$(DIAG) --build-bs2

# Build at -O0 for lldb debugging. Produces build/bs2_O0.
build-O0:
	@$(DIAG) --build-O0

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
