#!/bin/bash
# Run one or all suite tests. Usage: ./run_tests.sh [addition] [sort] [negative] [fibonacci] [shifting] [xor]
# Run from riscv-pipeline-incomplete/tests/

set -e
TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$TESTS_DIR"

SUITES_DIR="$TESTS_DIR/suites"
IMEM_DMEM="$TESTS_DIR/imem_dmem"

if [ ! -d "$SUITES_DIR" ] || [ ! -d "$IMEM_DMEM" ]; then
    echo "ERROR: suites/ or imem_dmem/ not found. Run from riscv-pipeline-incomplete/tests/"
    exit 1
fi
# For local runs, copy design files from environment/starter and solution if not present (Harbor copies from /workspace)
if [ ! -f "$TESTS_DIR/pipeline.v" ]; then
    STARTER="$TESTS_DIR/../environment/starter"
    SOLUTION="$TESTS_DIR/../solution"
    if [ -f "$STARTER/pipeline.v" ] && [ -f "$SOLUTION/execute.v" ]; then
        cp "$STARTER/pipeline.v" "$STARTER/IF_ID.v" "$STARTER/wb.v" "$STARTER/opcode.vh" "$TESTS_DIR/"
        cp "$SOLUTION/execute.v" "$TESTS_DIR/"
    else
        echo "ERROR: pipeline.v not found. Copy pipeline RTL into tests/ or run from repo with environment/starter and solution/."
        exit 1
    fi
fi

run_one() {
    local name="$1"
    local suite="$SUITES_DIR/$name"
    if [ ! -d "$suite" ]; then
        echo "FAIL: $name (suite not found)"
        return 1
    fi
    cp "$suite/imem.hex" "$IMEM_DMEM/imem.hex"
    cp "$suite/dmem.hex" "$IMEM_DMEM/dmem.hex"
    local expected
    expected=$(tr -d '\r\n' < "$suite/expected.txt")
    if ! iverilog -DEXPECTED_RESULT="$expected" -f filelist.txt -o riscv_output 2>&1; then
        echo "FAIL: $name (compile error)"
        rm -f riscv_output
        return 1
    fi
    local out
    out=$(vvp riscv_output 2>&1) || true
    echo "$out" | tail -5
    rm -f riscv_output pipeline.vcd
    if echo "$out" | grep -q "^PASS"; then
        echo "PASS: $name"
        return 0
    else
        echo "FAIL: $name"
        return 1
    fi
}

if [ $# -eq 0 ]; then
    failed=0
    for name in addition sort negative fibonacci shifting xor; do
        run_one "$name" || failed=$((failed + 1))
    done
    [ $failed -eq 0 ] && exit 0 || exit 1
fi

failed=0
for name in "$@"; do
    run_one "$name" || failed=$((failed + 1))
done
[ $failed -eq 0 ] && exit 0 || exit 1
