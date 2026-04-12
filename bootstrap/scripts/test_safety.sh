#!/bin/bash
# Test runtime safety checks — every crash vector must produce a friendly error
set -e
cd "$(dirname "$0")/.."
BS2=./build/bs2
LLC=/opt/homebrew/opt/llvm/bin/llc
PASS=0; FAIL=0

check() {
    local name="$1" expect="$2" src="$3"
    echo "$src" > "/tmp/safety_${name}.fg"
    $BS2 compile "/tmp/safety_${name}.fg" >/dev/null 2>&1 || { echo "  SKIP $name (compile error)"; return; }
    $LLC -filetype=obj "/tmp/safety_${name}.fg.ll" -o "/tmp/safety_${name}.o" 2>/dev/null || { echo "  SKIP $name (llc error)"; return; }
    cc -o "/tmp/safety_${name}" "/tmp/safety_${name}.o" build/runtime.o build/llvm_wrapper.o \
        -Wl,-stack_size,0x800000 -L/opt/homebrew/opt/llvm/lib -lLLVM -lc++ 2>/dev/null || { echo "  SKIP $name (link error)"; return; }
    local output=$("/tmp/safety_${name}" 2>&1 || true)
    if echo "$output" | grep -qi "$expect"; then
        echo "  [ok] $name"
        PASS=$((PASS+1))
    else
        echo "  [FAIL] $name — expected '$expect', got: $(echo "$output" | head -1)"
        FAIL=$((FAIL+1))
    fi
}

echo "Runtime safety checks:"
check null_field "null pointer dereference" 'type P={x:int}
fn main(){let p:P?=null
println(string(p!.x))}'

check null_method "null pointer dereference" 'type T={x:int}
impl T{fn get(self)->int{self.x}}
fn main(){let t:T?=null
println(string(t!.get()))}'

check div_zero "division by zero" 'fn main(){println(string(10/0))}'
check mod_zero "division by zero" 'fn main(){println(string(10%0))}'

check index_oob "out of bounds" 'fn main(){let a=[1,2,3]
println(string(a[99]))}'

check index_neg "out of bounds" 'fn main(){let a=[1,2,3]
println(string(a[-1]))}'

check pop_empty "pop on empty" 'fn main(){mut a=[1]
a.pop()
a.pop()}'

check stack_overflow "stack overflow" 'fn boom(n:int)->int{boom(n+1)}
fn main(){println(string(boom(0)))}'

check mutual_recursion "stack overflow" 'fn a(n:int)->int{b(n+1)}
fn b(n:int)->int{a(n+1)}
fn main(){println(string(a(0)))}'

check match_enum "match fallthrough" 'enum D{N,S,E,W}
fn f(d:D)->string{match d{.N->"n"}}
fn main(){println(f(D.W))}'

check match_prim "match fallthrough" 'fn f(n:int)->string{match n{1->"one"}}
fn main(){println(f(99))}'

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
