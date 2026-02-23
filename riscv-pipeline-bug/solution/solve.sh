#!/bin/bash
# Oracle solution: fix the pipeline bug by replacing buggy IF_ID.v with corrected version.
# The only change is in the decode-stage forwarding: forward load results from WB (wb_read_data when wb_mem_to_reg).
SOL_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SOL_DIR"/IF_ID.v /workspace/
echo "Copied reference IF_ID.v to /workspace"
