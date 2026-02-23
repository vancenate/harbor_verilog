FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Only what this task's verifier uses: iverilog (includes vvp) for RTL simulation.
# test.sh runs: iverilog -f filelist.txt -o riscv_output && vvp riscv_output
RUN apt-get update && apt-get install -y --no-install-recommends \
    iverilog \
    && rm -rf /var/lib/apt/lists/*

# Pre-populate workspace with opcode.vh (RV32I opcode/func3 definitions). Build context is environment/ so starter/ is environment/starter/.
COPY starter/opcode.vh /workspace/
COPY starter/opcode.vh /starter/

# Testbench and memory model (reference only; verifier uses its own copy with test-specific imem/dmem).
COPY reference/tb_pipeline.v reference/memory.v /reference/

WORKDIR /workspace
