FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Icarus Verilog and RISC-V GCC toolchain (for building test binaries from C).
RUN apt-get update && apt-get install -y --no-install-recommends \
    iverilog \
    gcc-riscv64-unknown-elf \
    binutils-riscv64-unknown-elf \
    && rm -rf /var/lib/apt/lists/*

# Pre-populate workspace with starter PicoRV32 core only (read-only reference).
# Build context is environment/, so starter/ is environment/starter/.
COPY starter/picorv32.v /workspace/
COPY starter/picorv32.v /starter/
COPY makehex.py /workspace/

WORKDIR /workspace

