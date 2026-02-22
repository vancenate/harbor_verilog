FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Only what this task's verifier uses: iverilog (includes vvp) for RTL simulation.
# test.sh runs: iverilog -f filelist.txt -o riscv_output && vvp riscv_output
RUN apt-get update && apt-get install -y --no-install-recommends \
    iverilog \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
