#!/bin/bash
# Verifier for pico-rv32-bug task.
# Expects /workspace/picorv32.v to contain the (possibly buggy) core.
# Compiles with the provided testbench and firmware image; PASS iff
# simulation prints "ALL TESTS PASSED." and exits cleanly.

set -e

echo "=== PicoRV32 bug verifier ==="

if [ ! -f /workspace/picorv32.v ]; then
    echo "ERROR: /workspace/picorv32.v not found. Provide picorv32.v in the workspace."
    mkdir -p /logs/verifier
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

mkdir -p /logs/verifier
mkdir -p /logs/verifier/vcd
mkdir -p /logs/verifier/workspace

# Save a copy of the workspace core for inspection.
cp /workspace/picorv32.v /logs/verifier/workspace/ 2>/dev/null || true

cd /tests

# Copy design into tests directory (testbench.v and firmware are already here).
cp /workspace/picorv32.v /tests/picorv32.v

RUN_LOG="/logs/verifier/run.log"
: > "$RUN_LOG"

echo "--- Building and running PicoRV32 testbench ---"
# Match pico-rv32/Makefile: -DCOMPRESSED_ISA (firmware uses RVC), and vvp -N
if ! iverilog -DCOMPRESSED_ISA -f filelist.txt -o picorv32_output 2>&1 | tee /logs/verifier/compile.log; then
    echo "BUILD FAILED" >> "$RUN_LOG"
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

set +e
vvp_out=$(vvp -N picorv32_output 2>&1)
vvp_exit=$?
set -e

{
    echo "========== PicoRV32 testbench output =========="
    echo "$vvp_out"
} | tee "$RUN_LOG"

if echo "$vvp_out" | grep -q "testbench.vcd"; then
    [ -f testbench.vcd ] && cp testbench.vcd /logs/verifier/vcd/testbench.vcd || true
fi

rm -f picorv32_output testbench.vcd

if [ $vvp_exit -eq 0 ] && echo "$vvp_out" | grep -q "ALL TESTS PASSED."; then
    echo "PASS: PicoRV32 firmware completed successfully."
    echo 1 > /logs/verifier/reward.txt
    exit 0
else
    echo "FAIL: Simulation did not report ALL TESTS PASSED."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

