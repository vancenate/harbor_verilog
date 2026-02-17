#!/bin/bash

# Formal verification test script for router circuit
set -e

echo "=== Starting formal verification for router circuit ==="

# Check if solution_core.sv exists in workspace
if [ ! -f /workspace/solution_core.sv ]; then
    echo "ERROR: solution_core.sv not found in /workspace"
    echo "The AI agent must create a file named 'solution_core.sv' in the /workspace directory"
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

echo "Found solution_core.sv in /workspace"

# Copy solution_core.sv to tests directory (solution_top.sv and solution_assertions.sv are already in tests/)
cp /workspace/solution_core.sv /tests/solution_core.sv

# Save a copy for inspection in logs
cp /workspace/solution_core.sv /logs/verifier/solution_core.sv

# Run SymbiYosys formal verification
cd /tests
echo "Running SymbiYosys formal verification..."

# Run sby and capture output (set +e so we write reward even when sby fails)
set +e
sby -f solution_formal.sby > /logs/verifier/sby_output.log 2>&1
SBY_EXIT_CODE=$?
set -e

# Display the output
cat /logs/verifier/sby_output.log

# Check if verification passed
if [ $SBY_EXIT_CODE -eq 0 ]; then
    # Check for PASS in the output
    if grep -q "PASS" /logs/verifier/sby_output.log; then
        echo ""
        echo "=========================================="
        echo "=== FORMAL VERIFICATION PASSED ==="
        echo "=========================================="
        echo "All assertions verified successfully!"
        echo ""
        
        # Count how many assertions were checked
        ASSERT_COUNT=$(grep -c "Checking assertions" /logs/verifier/sby_output.log || echo "0")
        if [ "$ASSERT_COUNT" != "0" ]; then
            echo "Total assertions verified: $ASSERT_COUNT"
        fi
        
        echo 1 > /logs/verifier/reward.txt
    else
        echo "=== FORMAL VERIFICATION FAILED ==="
        echo "SymbiYosys completed but did not report PASS"
        echo 0 > /logs/verifier/reward.txt
    fi
else
    echo ""
    echo "=========================================="
    echo "=== FORMAL VERIFICATION FAILED ==="
    echo "=========================================="
    echo "SymbiYosys exited with code $SBY_EXIT_CODE"
    echo ""
    
    # Extract failed assertion names from the output
    echo "Looking for failed assertions..."
    if grep -q "Assert failed" /logs/verifier/sby_output.log; then
        echo ""
        echo "FAILED ASSERTIONS:"
        grep "Assert failed\|Assertion.*failed\|BMC failed" /logs/verifier/sby_output.log | head -20
    fi
    
    # Look for assertion names in the trace
    if grep -E "a_[a-z0-9_]+" /logs/verifier/sby_output.log > /dev/null; then
        echo ""
        echo "Assertion details found in trace:"
        grep -E "a_[a-z0-9_]+" /logs/verifier/sby_output.log | head -10
    fi
    
    # Check for counterexample
    if [ -d /tests/solution_formal ]; then
        echo ""
        echo "Counterexample trace available in solution_formal directory:"
        ls -la /tests/solution_formal/
        
        # Try to extract counterexample values if available
        if [ -f /tests/solution_formal/engine_0/trace.vcd ]; then
            echo ""
            echo "VCD trace file created: solution_formal/engine_0/trace.vcd"
            echo "This shows the input values that caused the assertion failure"
            # Copy trace files to logs for debugging
            cp /tests/solution_formal/engine_0/trace.vcd /logs/verifier/trace.vcd
            echo "Copied trace.vcd to /logs/verifier/trace.vcd"
        fi
        
        # Copy other trace files if they exist
        if [ -f /tests/solution_formal/engine_0/trace_tb.v ]; then
            cp /tests/solution_formal/engine_0/trace_tb.v /logs/verifier/trace_tb.v
            echo "Copied trace_tb.v to /logs/verifier/trace_tb.v"
        fi
        if [ -f /tests/solution_formal/engine_0/trace.smtc ]; then
            cp /tests/solution_formal/engine_0/trace.smtc /logs/verifier/trace.smtc
            echo "Copied trace.smtc to /logs/verifier/trace.smtc"
        fi
        
        # Look for witness file with counterexample
        if [ -f /tests/solution_formal/engine_0/trace*.smtc ]; then
            echo ""
            echo "SMT counterexample:"
            cat /tests/solution_formal/engine_0/trace*.smtc 2>/dev/null | head -50
        fi
    fi
    
    echo ""
    echo 0 > /logs/verifier/reward.txt
fi
