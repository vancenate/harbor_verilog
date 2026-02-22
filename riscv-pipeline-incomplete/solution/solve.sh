#!/bin/bash
# Oracle solution for execute-stage-only task.
# Workspace is pre-populated with pipeline.v, IF_ID.v, wb.v, opcode.vh; copy only execute.v.
SOL_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SOL_DIR"/execute.v /workspace/
echo "Copied reference execute.v to /workspace"
