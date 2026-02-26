FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Icarus Verilog (iverilog + vvp) for RTL simulation.
RUN apt-get update && apt-get install -y --no-install-recommends \
    iverilog \
    && rm -rf /var/lib/apt/lists/*

# Pre-populate workspace with starter PicoRV32 core, testbench, and firmware (read-only reference).
# Build context is environment/, so starter/ is environment/starter/.
# Also copy to /starter so it can be restored into /workspace if needed.
COPY starter/picorv32.v starter/testbench.v /workspace/
COPY starter/picorv32.v starter/testbench.v /starter/
COPY starter/firmware /workspace/firmware
COPY starter/firmware /starter/firmware

WORKDIR /workspace

