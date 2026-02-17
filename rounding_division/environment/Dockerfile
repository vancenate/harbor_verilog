FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    yosys \
    python3 \
    python3-pip \
    z3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# SymbiYosys requires click (per https://symbiyosys.readthedocs.io/en/latest/install.html)
RUN pip3 install --break-system-packages click

# Install SymbiYosys from GitHub
RUN git clone https://github.com/YosysHQ/sby.git /tmp/sby && \
    cd /tmp/sby && \
    make install && \
    cd / && \
    rm -rf /tmp/sby

WORKDIR /workspace
