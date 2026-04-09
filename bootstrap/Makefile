# Bootstrap compiler — friendly Makefile.
#
# This is the everyday entry point. All targets just call into
# scripts/diagnose.sh under the hood — `bash scripts/diagnose.sh --help`
# is the full menu when you need anything not listed here.
#
# Quick reference:
#   make            build the bootstrap compiler
#   make test       run the full safety net (regression + self-host check)
#   make run FILE=x.fg
#                   compile and run a Forge program
#   make selfhost   verify bs2 and bs3 emit byte-identical IR
#   make clean      remove all build artifacts
#   make help       show this list
#
# The bs1 / bs2 / bs3 generations are an implementation detail you
# don't need to think about. `make` builds whatever you need; `make
# test` checks everything.

.DEFAULT_GOAL := build
.PHONY: build test run selfhost clean help install-hooks regress score

DIAG := bash scripts/diagnose.sh

help:
	@echo "Bootstrap compiler — common targets:"
	@echo ""
	@echo "  make build         Build the bootstrap compiler (default)."
	@echo "  make test          Run regression suite + self-host fixed-point check."
	@echo "  make run FILE=x.fg Compile and run a Forge program."
	@echo "  make selfhost      Verify bs2 and bs3 emit byte-identical IR."
	@echo "  make regress       Run regression suite only (faster than 'test')."
	@echo "  make score         Score the current bootstrap IR."
	@echo "  make clean         Remove all build artifacts."
	@echo "  make install-hooks Install the pre-commit hook."
	@echo ""
	@echo "Anything not listed: bash scripts/diagnose.sh --help"

# Build the bootstrap compiler. Produces build/bs2 — that's the
# binary you actually use to compile Forge programs.
build:
	@$(DIAG) --build-bs2

# Full safety net: regression suite (which also cross-checks stage1
# vs bs2) plus the bs2 ↔ bs3 fixed-point invariant.
test:
	@$(DIAG) --regress
	@$(DIAG) --check-fixedpoint

# Just the regression suite — faster, useful while iterating.
regress:
	@$(DIAG) --regress

# Just the fixed-point check.
selfhost:
	@$(DIAG) --check-fixedpoint

# Score the most recently emitted bootstrap IR. Fails non-zero if
# any wide-store-into-narrow-malloc bugs are present.
score:
	@$(DIAG) --score

# Compile and run a single Forge file with the bootstrap compiler.
# Usage: make run FILE=examples/hello.fg
run:
ifndef FILE
	@echo "usage: make run FILE=path/to/program.fg" >&2
	@exit 1
endif
	@$(DIAG) --run $(FILE)

# Install the pre-commit hook (idempotent).
install-hooks:
	@ln -sf ../../bootstrap/scripts/pre-commit ../.git/hooks/pre-commit
	@echo "installed: .git/hooks/pre-commit -> bootstrap/scripts/pre-commit"

# Remove all build artifacts. Source files and captured regression
# tests are preserved.
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
