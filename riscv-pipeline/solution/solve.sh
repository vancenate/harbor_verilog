#!/bin/bash
# Oracle solution for 3-stage RISC-V pipeline task.
# Copies the reference pipeline (and included .v/.vh) into /workspace so the
# verifier can run tests against it (e.g. to confirm the harness passes).
SOL_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SOL_DIR"/pipeline.v "$SOL_DIR"/IF_ID.v "$SOL_DIR"/execute.v "$SOL_DIR"/wb.v "$SOL_DIR"/opcode.vh /workspace/
echo "Copied reference pipeline (pipeline.v, IF_ID.v, execute.v, wb.v, opcode.vh) to /workspace"
