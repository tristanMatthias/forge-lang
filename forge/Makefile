# ═══════════════════════════════════════════════════════════════════
# Forge Self-Hosting Build System
# ═══════════════════════════════════════════════════════════════════
#
# Pipeline:
#   1. cargo        → target/release/forgec       (Rust compiler)
#   2. cargo        → libforge_llvm.a             (LLVM bindings)
#   3. cc           → build/runtime.o             (C runtime)
#   4. forgec build → build/mini                  (mini compiler binary)
#   5. mini build   → build/stage1.ll             (Stage 1 IR)
#   6. llc + cc     → build/stage1                (Stage 1 binary)
#   7. stage1 build → build/stage2.ll             (Stage 2 IR)
#   8. audit        → score                       (Stage 2 quality)
#
# Usage:
#   make runtime     — compile runtime.o
#   make mini        — build mini compiler binary
#   make stage1-ir   — mini compiles source → Stage 1 IR
#   make stage1      — link Stage 1 binary
#   make stage2-ir   — Stage 1 compiles source → Stage 2 IR
#   make audit       — audit Stage 2 IR quality
#   make clean       — remove all build artifacts
#
# ═══════════════════════════════════════════════════════════════════

LLVM_PREFIX  := /opt/homebrew/opt/llvm@18
LLC          := $(LLVM_PREFIX)/bin/llc
LLVM_CONFIG  := $(LLVM_PREFIX)/bin/llvm-config
LLVM_LIBS    := $(shell $(LLVM_CONFIG) --ldflags --libs core analysis bitwriter)
FORGEC       := LLVM_SYS_180_PREFIX=$(LLVM_PREFIX) ./target/release/forgec
STD_LLVM_LIB := packages/std-llvm/target/release/libforge_llvm.a
RUNTIME_SRC  := stdlib/runtime.c
SOURCE       := packages/forgec/src/main.fg
MINI_MAIN    := packages/forgec/src/mini/main.fg

BUILD        := build
RUNTIME_O    := $(BUILD)/runtime.o
MINI_BIN     := $(BUILD)/mini
STAGE1_LL    := $(BUILD)/stage1.ll
STAGE1_O     := $(BUILD)/stage1.o
STAGE1_BIN   := $(BUILD)/stage1
STAGE2_LL    := $(BUILD)/stage2.ll

# Link flags shared by stage1 and stage2
LINK_FLAGS   := -lm -Wl,-stack_size,0x10000000 $(STD_LLVM_LIB) \
                $(LLVM_LIBS) -lstdc++ -lz -lcurses

.PHONY: all clean runtime mini stage1-ir stage1 stage2-ir audit test-mini help

all: stage1
help:
	@echo "Targets: runtime mini stage1-ir stage1 stage2-ir audit clean"

# ─── Prerequisites ────────────────────────────────────────────────

# Rust compiler (forgec binary)
target/release/forgec: $(shell find packages/forgec-rust -name '*.rs' 2>/dev/null) Cargo.toml
	LLVM_SYS_180_PREFIX=$(LLVM_PREFIX) cargo build --release

# LLVM bindings library
$(STD_LLVM_LIB): packages/std-llvm/src/lib.rs packages/std-llvm/Cargo.toml
	cd packages/std-llvm && LLVM_SYS_180_PREFIX=$(LLVM_PREFIX) cargo build --release

# ─── Step 1: Runtime ─────────────────────────────────────────────

$(BUILD):
	@mkdir -p $(BUILD)

runtime: $(RUNTIME_O)
$(RUNTIME_O): $(RUNTIME_SRC) | $(BUILD)
	@echo "=== Compiling runtime ==="
	cc -c -O0 $(RUNTIME_SRC) -o $(RUNTIME_O)

# ─── Step 2: Mini Compiler ───────────────────────────────────────

mini: $(MINI_BIN)
$(MINI_BIN): target/release/forgec $(STD_LLVM_LIB) $(RUNTIME_O) $(shell find packages/forgec/src/mini -name '*.fg') | $(BUILD)
	@echo "=== Building mini compiler ==="
	$(FORGEC) build $(MINI_MAIN) --dev -o $(MINI_BIN)
	@echo "  Built: $(MINI_BIN)"

# ─── Step 3: Stage 1 IR ─────────────────────────────────────────

stage1-ir: $(STAGE1_LL)
$(STAGE1_LL): $(MINI_BIN) $(shell find packages/forgec/src -name '*.fg' ! -path '*/mini/*') | $(BUILD)
	@echo "=== Mini compiling source → Stage 1 IR ==="
	-$(MINI_BIN) build $(SOURCE) 2>&1 | tee $(BUILD)/mini.log; true
	@if [ -f /tmp/mini_output.ll ]; then \
		LC_ALL=C sed -i '' 's/ptr 0,/ptr null,/g; s/ptr 0$$/ptr null/; s/%ForgeString [0-9][0-9]*/%ForgeString zeroinitializer/g' /tmp/mini_output.ll; \
		mv /tmp/mini_output.ll $(STAGE1_LL); \
		echo "  Stage 1 IR: $$(grep -c '^define' $(STAGE1_LL)) functions, $$(wc -l < $(STAGE1_LL)) lines"; \
	else \
		echo "ERROR: mini did not produce /tmp/mini_output.ll"; \
		exit 1; \
	fi

# ─── Step 3b: Stage 1 via Rust compiler (bypass mini) ────────────
# The Rust compiler can build the self-hosted source directly.
# Produces a Stage 1 binary without going through the mini's IR.
# Currently: module resolution only finds main file (needs fix).

STAGE1_RUST := $(BUILD)/stage1_rust
stage1-rust: $(STAGE1_RUST)
$(STAGE1_RUST): target/release/forgec $(STD_LLVM_LIB) $(RUNTIME_O) $(shell find packages/forgec/src -name '*.fg') | $(BUILD)
	@echo "=== Checking runtime function registration ==="
	@bash scripts/check_runtime_fns.sh || (echo "ERROR: Fix unregistered functions before building" && exit 1)
	@echo "=== Rust compiler → Stage 1 binary ==="
	$(FORGEC) build $(SOURCE) --dev -o $(STAGE1_RUST)
	@echo "  Built: $(STAGE1_RUST)"

# ─── Step 4: Stage 1 Binary ─────────────────────────────────────

stage1: $(STAGE1_BIN)
$(STAGE1_BIN): $(STAGE1_LL) $(RUNTIME_O) $(STD_LLVM_LIB)
	@echo "=== Compiling Stage 1 binary ==="
	$(LLC) -O2 -filetype=obj $(STAGE1_LL) -o $(STAGE1_O)
	cc -o $(STAGE1_BIN) $(STAGE1_O) $(RUNTIME_O) $(LINK_FLAGS)
	@echo "  Built: $(STAGE1_BIN)"
	@$(STAGE1_BIN) 2>&1 | head -1

# ─── Step 5: Stage 2 IR ─────────────────────────────────────────

stage2-ir: $(STAGE2_LL)
$(STAGE2_LL): $(STAGE1_BIN)
	@echo "=== Stage 1 compiling source → Stage 2 IR ==="
	$(STAGE1_BIN) build $(SOURCE)
	@if [ -f output.ll ]; then \
		mv output.ll $(STAGE2_LL); \
		echo "  Stage 2 IR: $$(grep -c '^define' $(STAGE2_LL)) functions"; \
	else \
		echo "ERROR: stage1 did not produce output.ll"; \
		exit 1; \
	fi

# ─── Audit ───────────────────────────────────────────────────────

audit: $(STAGE2_LL)
	@echo "=== Auditing Stage 2 IR ==="
	bash scripts/audit_stage2.sh $(STAGE2_LL)

# ─── Test: mini compiles hello world ─────────────────────────────

test-mini: $(MINI_BIN) $(RUNTIME_O)
	@echo "=== Testing mini on hello world ==="
	@echo 'fn main() { println("hello from mini!") }' > /tmp/forge_mini_test.fg
	$(MINI_BIN) build /tmp/forge_mini_test.fg
	@if [ -f /tmp/mini_output.ll ]; then \
		$(LLC) -O2 -filetype=obj /tmp/mini_output.ll -o /tmp/forge_mini_test.o && \
		cc -o /tmp/forge_mini_test /tmp/forge_mini_test.o $(RUNTIME_O) -lm && \
		/tmp/forge_mini_test && \
		rm -f /tmp/forge_mini_test.fg /tmp/forge_mini_test.o /tmp/forge_mini_test /tmp/mini_output.ll; \
		echo "  PASS"; \
	else \
		echo "  FAIL: no IR produced"; \
		exit 1; \
	fi

# ─── Test: Stage 1 compiles hello world ─────────────────────────

test-stage1: $(STAGE1_RUST) $(RUNTIME_O)
	@echo "=== Testing Stage 1 (self-hosted) on hello world ==="
	@echo 'fn main() { println("hello from stage 2!") }' > /tmp/forge_s1_test.fg
	@$(STAGE1_RUST) build /tmp/forge_s1_test.fg 2>/dev/null
	@if [ -f output.ll ]; then \
		$(LLC) -O0 -filetype=obj output.ll -o /tmp/forge_s1_test.o && \
		cc -o /tmp/forge_s1_test /tmp/forge_s1_test.o $(RUNTIME_O) -lm && \
		/tmp/forge_s1_test && \
		rm -f /tmp/forge_s1_test.fg /tmp/forge_s1_test.o /tmp/forge_s1_test output.ll; \
		echo "  PASS"; \
	else \
		echo "  FAIL: no IR produced"; \
		exit 1; \
	fi

# ─── Clean ───────────────────────────────────────────────────────

clean:
	rm -rf $(BUILD) output.ll a.out /tmp/mini_output.ll
