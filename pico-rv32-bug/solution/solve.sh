#!/bin/bash
# Oracle solution for pico-rv32-bug task.
# Copies the golden PicoRV32 core into /workspace so the verifier passes.

set -e

SOL_DIR="$(cd "$(dirname "$0")" && pwd)"

cp "$SOL_DIR"/picorv32.v /workspace/

echo "Copied golden picorv32.v to /workspace"

