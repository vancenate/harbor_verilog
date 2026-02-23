FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Only what this task's verifier uses: iverilog (includes vvp) for RTL simulation.
# test.sh runs: iverilog -f filelist.txt -o riscv_output && vvp riscv_output
RUN apt-get update && apt-get install -y --no-install-recommends \
    iverilog \
    && rm -rf /var/lib/apt/lists/*

# Pre-populate workspace with all design files except execute.v.
# Build context is environment/ so starter/ is environment/starter/.
# Also copy to /starter so they can be copied to /workspace if it is mounted empty.
COPY starter/pipeline.v starter/IF_ID.v starter/wb.v starter/opcode.vh /workspace/
COPY starter/pipeline.v starter/IF_ID.v starter/wb.v starter/opcode.vh /starter/

WORKDIR /workspace
