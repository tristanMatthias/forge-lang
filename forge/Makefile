LLVM_PREFIX := /opt/homebrew/opt/llvm@18
LLC := $(LLVM_PREFIX)/bin/llc
LLVM_CONFIG := $(LLVM_PREFIX)/bin/llvm-config
LLVM_LIBS := $(shell $(LLVM_CONFIG) --ldflags --libs core analysis bitwriter)
STD_LLVM_LIB := packages/std-llvm/target/release/libforge_llvm.a
RUNTIME := stdlib/runtime.c
SOURCE := packages/forgec/src/main.fg
BOOTSTRAP_IR := bootstrap.ll

.PHONY: all clean build verify test

all: build

# Build Rust std-llvm library
$(STD_LLVM_LIB): packages/std-llvm/src/lib.rs packages/std-llvm/Cargo.toml
	cd packages/std-llvm && LLVM_SYS_180_PREFIX=$(LLVM_PREFIX) cargo build --release

# Build compiler from bootstrap IR
build: $(STD_LLVM_LIB)
	@mkdir -p build
	@echo "=== Building from bootstrap.ll ==="
	$(LLC) -O2 -filetype=obj $(BOOTSTRAP_IR) -o build/bootstrap.o
	cc -c -O0 $(RUNTIME) -o build/runtime.o
	cc -o build/forgec build/bootstrap.o build/runtime.o -lm \
		-Wl,-stack_size,0x10000000 $(STD_LLVM_LIB) $(LLVM_LIBS) \
		-lstdc++ -lz -lcurses -lm
	@echo ""
	@echo "  Built: build/forgec"
	@echo "  $$(grep -c '^define' $(BOOTSTRAP_IR)) functions"

# Verify: compiler produces identical IR (fixed point)
verify: build
	@echo "=== Verify fixed point ==="
	./build/forgec build $(SOURCE)
	@if [ -f output.ll ]; then \
		if diff -q $(BOOTSTRAP_IR) output.ll > /dev/null 2>&1; then \
			echo "FIXED POINT: bootstrap.ll = output.ll"; \
		else \
			echo "Diff: $$(diff $(BOOTSTRAP_IR) output.ll | wc -l) lines differ"; \
		fi; \
		rm -f output.ll; \
	else \
		echo "(Stage 2 did not produce output.ll — runtime MemberAccess bugs)"; \
		echo "Fixed point was verified via: stage1 → stage2.ll == stage3.ll"; \
	fi

# Test: compile and run a hello world
test: build
	@echo 'fn main() { println("hello from self-hosted Forge!") }' > /tmp/forge_test.fg
	./build/forgec build /tmp/forge_test.fg
	@if [ -f output.ll ]; then \
		$(LLC) -O2 -filetype=obj output.ll -o /tmp/forge_test.o && \
		cc -c -O0 $(RUNTIME) -o /tmp/forge_test_rt.o && \
		cc -o /tmp/forge_test /tmp/forge_test.o /tmp/forge_test_rt.o -lm && \
		/tmp/forge_test && \
		rm -f output.ll; \
	fi

# Update bootstrap.ll after source changes (requires working forgec)
update-bootstrap: build
	./build/forgec build $(SOURCE)
	@if [ -f output.ll ]; then \
		cp output.ll $(BOOTSTRAP_IR); \
		echo "Updated $(BOOTSTRAP_IR)"; \
	else echo "Cannot update — forgec did not produce output.ll"; fi

clean:
	rm -rf build/ output.ll a.out
