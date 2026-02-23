#!/bin/bash
# Verifier for 3-stage RISC-V pipeline task.
# Requires all five design files in /workspace/: pipeline.v, IF_ID.v, execute.v, wb.v, opcode.vh. Missing any = fail.
# Runs addition, load_use, sort, negative, fibonacci, shifting, xor; ALL must PASS for reward 1.

set -e

echo "=== 3-stage RISC-V pipeline verifier ==="

# Require all five design files (verifier fails if any are missing)
REQUIRED_FILES="pipeline.v IF_ID.v execute.v wb.v opcode.vh"
missing=""
for f in $REQUIRED_FILES; do
    if [ ! -f "/workspace/$f" ]; then
        missing="$missing $f"
    fi
done
if [ -n "$missing" ]; then
    echo "ERROR: Required file(s) missing in /workspace/:$missing"
    echo "Provide all five design files; do not delete or omit any."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Copy design files into tests
mkdir -p /logs/verifier/vcd
mkdir -p /logs/verifier/workspace
for f in pipeline.v IF_ID.v execute.v wb.v opcode.vh; do
    if [ -f "/workspace/$f" ]; then
        cp "/workspace/$f" /tests/
        cp "/workspace/$f" /logs/verifier/workspace/ 2>/dev/null || true
    fi
done

cd /tests
IMEM_DMEM="/tests/imem_dmem"
SUITES="/tests/suites"
mkdir -p "$IMEM_DMEM"

RUN_LOG="/logs/verifier/run.log"

# Per-test simulation timeout (seconds). Prevents one test from hanging the verifier.
TEST_TIMEOUT="${TEST_TIMEOUT:-120}"

run_one() {
    local name="$1"
    local expected="$2"
    local marker="$3"
    cp "$SUITES/$name/imem.hex" "$IMEM_DMEM/imem.hex"
    cp "$SUITES/$name/dmem.hex" "$IMEM_DMEM/dmem.hex"
    if ! iverilog -DEXPECTED_RESULT="$expected" -f filelist.txt -o riscv_output 2>&1 | tee /logs/verifier/compile.log; then
        echo "${marker} FAILED (compile error)" >> "$RUN_LOG"
        return 1
    fi
    set +e
    local vvp_out vvp_exit
    if command -v timeout >/dev/null 2>&1; then
        vvp_out=$(timeout "$TEST_TIMEOUT" vvp riscv_output 2>&1)
        vvp_exit=$?
        if [ $vvp_exit -eq 124 ]; then
            vvp_out="FAIL: Simulation timed out after ${TEST_TIMEOUT}s
$vvp_out"
        fi
    else
        vvp_out=$(vvp riscv_output 2>&1)
        vvp_exit=$?
    fi
    set -e
    [ -f /tests/pipeline.vcd ] && cp /tests/pipeline.vcd "/logs/verifier/vcd/${name}.vcd"
    rm -f riscv_output pipeline.vcd
    local result_line
    if [ $vvp_exit -eq 0 ] && echo "$vvp_out" | grep -q "^PASS"; then
        result_line="${marker} PASSED"
    else
        result_line="${marker} FAILED (exit $vvp_exit)"
    fi
    {
        echo "========== $name test (expected $expected) =========="
        echo "$vvp_out"
        echo "$result_line"
        echo ""
    } >> "$RUN_LOG"
    # Also print to stdout so verifier log shows full details of each run
    echo "========== $name test (expected $expected) =========="
    echo "$vvp_out"
    echo "$result_line"
    echo ""
    if [ $vvp_exit -eq 0 ] && echo "$vvp_out" | grep -q "^PASS"; then
        return 0
    else
        return 1
    fi
}

: > "$RUN_LOG"

# Run both tests so the log always has results for both
echo "--- Running addition test (expected 102) ---"
run_one addition 102 "ADDITION TEST" || true

echo "--- Running load_use test (expected 102, exposes load-use hazard) ---"
run_one load_use 102 "LOAD_USE TEST" || true

echo "--- Running sort test (expected 3) ---"
run_one sort 3 "SORT TEST" || true

echo "--- Running negative test (expected 4294967250) ---"
run_one negative 4294967250 "NEGATIVE TEST" || true

echo "--- Running fibonacci test (expected 5) ---"
run_one fibonacci 5 "FIBONACCI TEST" || true

echo "--- Running shifting test (expected 400) ---"
run_one shifting 400 "SHIFTING TEST" || true

echo "--- Running xor test (expected 5) ---"
run_one xor 5 "XOR TEST" || true

# Pass only if all tests show PASSED (searchable in run.log)
if grep -q "ADDITION TEST PASSED" "$RUN_LOG" && grep -q "LOAD_USE TEST PASSED" "$RUN_LOG" && grep -q "SORT TEST PASSED" "$RUN_LOG" && grep -q "NEGATIVE TEST PASSED" "$RUN_LOG" && grep -q "FIBONACCI TEST PASSED" "$RUN_LOG" && grep -q "SHIFTING TEST PASSED" "$RUN_LOG" && grep -q "XOR TEST PASSED" "$RUN_LOG"; then
    echo "PASS: Pipeline completed all tests successfully."
    echo 1 > /logs/verifier/reward.txt
    exit 0
else
    echo "FAIL: One or more tests did not pass. See run.log for each test output."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi
