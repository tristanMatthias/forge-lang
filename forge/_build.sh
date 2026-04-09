#!/bin/bash
cd "$(dirname "$0")"
LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 cargo build --release
