#!/usr/bin/env bash
# t-myz7 frontier: which malformed decl keywords still fall back to @hand(decl_hand)?
# A keyword GRADUATES when its malformed form no longer needs the leaf.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

probe() { # name, source
  printf '%s\n' "$2" > /tmp/avra_frontier.av
  out=$(AVRA_REFUSE_HAND_LEAF=decl_hand ./build/bs2 check /tmp/avra_frontier.av 2>&1 | sed 's/.\[[0-9;]*m//g')
  if printf '%s' "$out" | grep -q "is refused"; then printf '%-12s REFUSES\n' "$1"
  else printf '%-12s native\n' "$1"; fi
}

probe mod       'mod {'
probe use       'use @std.{'
probe const     'const X ='
probe trait     'trait T {'
probe shape     'shape S = {'
probe enum      'enum E {'
probe select    'select { x }'
probe spec      'spec "s" { given }'
probe fn        'fn foo('
probe type      'type Foo = {'
probe impl      'impl Foo {'
probe component 'component acct_sr { balance: int = 100 }'
probe let       'let = 5'
