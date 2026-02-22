#!/bin/bash
# Verifier for 3-stage RISC-V pipeline task.
# Expects agent to provide /workspace/pipeline.v (module pipe) and optional other .v/.vh.
# Runs simulation with addition test; PASS + exit 0 => reward 1.

set -e

echo "=== 3-stage RISC-V pipeline verifier ==="

# Require pipeline entry point
if [ ! -f /workspace/pipeline.v ]; then
    echo "ERROR: /workspace/pipeline.v not found. Provide a top-level module named 'pipe' in pipeline.v."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Copy pipeline and any included sources into tests (do not overwrite tb or memory)
cp /workspace/pipeline.v /tests/pipeline.v
for f in /workspace/*.v /workspace/*.vh; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in
        tb_pipeline.v|memory.v) ;;
        *) cp "$f" /tests/ ;;
    esac
done

# Save copy for logs (single file + full workspace for debugging)
mkdir -p /logs/verifier
cp /workspace/pipeline.v /logs/verifier/pipeline.v
mkdir -p /logs/verifier/workspace
cp -r /workspace/. /logs/verifier/workspace/

cd /tests

# Compile
if ! iverilog -f filelist.txt -o riscv_output 2>&1 | tee /logs/verifier/compile.log; then
    echo "FAIL: Compilation failed"
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Run (addition test: imem_dmem/imem.hex and dmem.hex are used by tb)
set +e
vvp riscv_output 2>&1 | tee /logs/verifier/run.log
VVP_EXIT=$?
set -e

# Save VCD to verifier logs for debugging (gtkwave pipeline.vcd, etc.)
[ -f /tests/pipeline.vcd ] && cp /tests/pipeline.vcd /logs/verifier/pipeline.vcd

if [ $VVP_EXIT -eq 0 ] && grep -q "^PASS" /logs/verifier/run.log; then
    echo "PASS: Pipeline completed the test successfully."
    echo 1 > /logs/verifier/reward.txt
    exit 0
fi

echo "FAIL: Simulation did not report PASS (exit code $VVP_EXIT)"
echo 0 > /logs/verifier/reward.txt
exit 1
