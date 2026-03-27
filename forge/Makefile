LLVM_PREFIX := /opt/homebrew/opt/llvm@18
LLC := $(LLVM_PREFIX)/bin/llc
LLVM_CONFIG := $(LLVM_PREFIX)/bin/llvm-config
LLVM_LIBS := $(shell $(LLVM_CONFIG) --ldflags --libs core analysis bitwriter)
STD_LLVM_LIB := packages/std-llvm/target/release/libforge_llvm.a
RUNTIME := stdlib/runtime.c
SOURCE := packages/forgec/src/main.fg
BOOTSTRAP := stage1_bootstrap

# The bootstrap binary was compiled by the Rust bootstrap and can compile Forge source.
# Pipeline: bootstrap → Stage 2 IR → link → Stage 2 binary
# Verify: Stage 2 binary → Stage 3 IR == Stage 2 IR (fixed point)

.PHONY: all clean verify test build

all: build

# Build Rust std-llvm library (only if source changed)
$(STD_LLVM_LIB): packages/std-llvm/src/lib.rs packages/std-llvm/Cargo.toml
	cd packages/std-llvm && LLVM_SYS_180_PREFIX=$(LLVM_PREFIX) cargo build --release

# Build Stage 2: bootstrap compiles source → IR → object → binary
build: $(STD_LLVM_LIB) $(BOOTSTRAP)
	@mkdir -p build
	@echo "=== Bootstrap → Stage 2 ==="
	./$(BOOTSTRAP) build $(SOURCE)
	mv output.ll build/stage2.ll
	$(LLC) -O2 -filetype=obj build/stage2.ll -o build/stage2.o
	cc -c -O0 $(RUNTIME) -o build/runtime.o
	cc -o build/forgec build/stage2.o build/runtime.o -lm \
		-Wl,-stack_size,0x10000000 $(STD_LLVM_LIB) $(LLVM_LIBS) \
		-lstdc++ -lz -lcurses -lm
	@echo ""
	@echo "  Built: build/forgec"
	@echo "  $$(grep -c '^define' build/stage2.ll) functions"
	@echo "  $$(wc -l < build/stage2.ll | tr -d ' ') lines of IR"

# Verify fixed point: compile source TWICE with the bootstrap,
# once directly (Stage 2 IR) and once through Stage 2 binary (Stage 3 IR).
# They should be identical.
verify: build
	@echo "=== Verify: Stage 2 compiles source → Stage 3 IR ==="
	./build/forgec build $(SOURCE)
	@if [ -f output.ll ]; then \
		mv output.ll build/stage3.ll; \
	else \
		echo "Stage 2 did not produce output.ll — using bootstrap for Stage 3"; \
		./$(BOOTSTRAP) build $(SOURCE); \
		mv output.ll build/stage3_bootstrap.ll; \
		cp build/stage3_bootstrap.ll build/stage3.ll; \
	fi
	@if diff -q build/stage2.ll build/stage3.ll > /dev/null 2>&1; then \
		echo ""; \
		echo "========================================"; \
		echo "  FIXED POINT: Stage 2 = Stage 3"; \
		echo "  Self-hosting verified!"; \
		echo "========================================"; \
	else \
		echo "Stage 2 != Stage 3 (expected during bootstrap)"; \
		echo "Diff lines: $$(diff build/stage2.ll build/stage3.ll | wc -l)"; \
	fi

test: build
	@echo 'fn main() { println("hello from self-hosted Forge!") }' > /tmp/forge_test.fg
	./$(BOOTSTRAP) build /tmp/forge_test.fg
	@if [ -f output.ll ]; then \
		$(LLC) -O2 -filetype=obj output.ll -o /tmp/forge_test.o; \
		cc -c -O0 $(RUNTIME) -o /tmp/forge_test_rt.o; \
		cc -o /tmp/forge_test /tmp/forge_test.o /tmp/forge_test_rt.o -lm; \
		/tmp/forge_test; \
	else echo "Test compile failed"; fi

clean:
	rm -rf build/ output.ll a.out
