#!/usr/bin/env bash
# t-47hc.5 component sweep: which `component` forms still need @hand(decl_hand)?
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
probe() {
  printf '%s\n' "$2" > /tmp/avra_comp_probe.av
  out=$(AVRA_REFUSE_HAND_LEAF=decl_hand ./build/bs2 check /tmp/avra_comp_probe.av 2>&1 | sed 's/.\[[0-9;]*m//g')
  if printf '%s' "$out" | grep -q "is refused"; then printf '%-34s REFUSES\n' "$1"
  else printf '%-34s native\n' "$1"; fi
}
probe 'def-brace'          'component C { }'
probe 'def-field'          'component C { let x: int = 1 }'
probe 'def-implements'     'trait T { fn t(self) -> int }
component C implements T { }'
probe 'def-config'         'component C { config { k: int = 1 } }'
probe 'def-children'       'component C { children { s: int } }'
probe 'legacy-paren'       'component C(a: int) { }'
probe 'legacy-paren-cfg'   'component C(a: int) { config { k: int = 1 } }'
probe 'inst-kw'            'component C { }
component C i { }'
probe 'inst-bare'          'component C { }
C i { }'
probe 'err-no-name'        'component'
probe 'err-no-brace'       'component C'
probe 'err-implements-inst' 'trait T { fn t(self) -> int }
component C implements T i { }'
