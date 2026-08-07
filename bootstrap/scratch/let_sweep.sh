#!/usr/bin/env bash
# t-47hc.5 let sweep: which binding forms still need @hand(decl_hand)?
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
probe() {
  printf '%s\n' "$2" > /tmp/avra_let_probe.av
  out=$(AVRA_REFUSE_HAND_LEAF=decl_hand ./build/bs2 check /tmp/avra_let_probe.av 2>&1 | sed 's/.\[[0-9;]*m//g')
  if printf '%s' "$out" | grep -q "is refused"; then printf '%-28s REFUSES\n' "$1"
  else printf '%-28s native\n' "$1"; fi
}
probe 'let-ok'          'fn f() { let x = 1 }'
probe 'let-typed'       'fn f() { let x: int = 1 }'
probe 'let-mut'         'fn f() { let mut x = 1 }'
probe 'let-else'        'fn f(o: int?) -> int { let v = o else { return 0 }
 v }'
probe 'letdes'          'fn f(t: (int, int)) { let (a, b) = t }'
probe 'mut-decl'        'fn f() { mut x = 1 }'
probe 'const-decl'      'const X = 1'
probe 'err-no-name'     'let = 5'
probe 'err-no-eq'       'fn f() { let x }'
probe 'err-no-init'     'fn f() { let x = }'
probe 'err-bad-type'    'fn f() { let x: = 1 }'
probe 'err-des-noclose' 'fn f(t: (int,int)) { let (a b) = t }'
probe 'lambda-tail'     'fn f() { let a = (1) -> }'
probe 'let-lambda'      'fn f() { let g = (x: int) -> x + 1 }'
