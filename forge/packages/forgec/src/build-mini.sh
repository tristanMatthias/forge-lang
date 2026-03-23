#!/bin/bash
# Regenerate mini.fg from split files
cd "$(dirname "$0")"
{
  cat mini/types.fg
  echo ""
  cat mini/lexer.fg
  echo ""
  cat mini/state.fg
  echo ""
  cat mini/registry.fg
  echo ""
  cat mini/packages.fg
  echo ""
  cat mini/parser.fg
  echo ""
  cat mini/codegen.fg
  echo ""
  # main.fg without mod declarations
  grep -v "^mod " mini/main.fg
} > mini.fg
echo "Generated mini.fg: $(wc -l < mini.fg) lines"
