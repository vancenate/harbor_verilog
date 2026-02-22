#!/bin/bash
# Verifier for 3-stage RISC-V pipeline task.
# Expects agent to provide /workspace/pipeline.v (module pipe) and optional other .v/.vh.
# Runs addition, sort, negative, fibonacci, shifting, then xor; ALL must PASS for reward 1.

set -e

echo "=== 3-stage RISC-V pipeline verifier ==="

# Require pipeline entry point and execute stage
if [ ! -f /workspace/pipeline.v ]; then
    echo "ERROR: /workspace/pipeline.v not found."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi
if [ ! -f /workspace/execute.v ]; then
    echo "ERROR: /workspace/execute.v not found. Implement the execute stage in execute.v."
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

# Save copy for logs
mkdir -p /logs/verifier/vcd
mkdir -p /logs/verifier/workspace
cp /workspace/execute.v /logs/verifier/workspace/execute.v

cd /tests
IMEM_DMEM="/tests/imem_dmem"
SUITES="/tests/suites"

RUN_LOG="/logs/verifier/run.log"

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
    local vvp_out
    vvp_out=$(vvp riscv_output 2>&1)
    local vvp_exit=$?
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
if grep -q "ADDITION TEST PASSED" "$RUN_LOG" && grep -q "SORT TEST PASSED" "$RUN_LOG" && grep -q "NEGATIVE TEST PASSED" "$RUN_LOG" && grep -q "FIBONACCI TEST PASSED" "$RUN_LOG" && grep -q "SHIFTING TEST PASSED" "$RUN_LOG" && grep -q "XOR TEST PASSED" "$RUN_LOG"; then
    echo "PASS: Pipeline completed all tests successfully."
    echo 1 > /logs/verifier/reward.txt
    exit 0
else
    echo "FAIL: One or more tests did not pass. See run.log for each test output."
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi
