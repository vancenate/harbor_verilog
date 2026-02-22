# 3-Stage RISC-V Pipeline

Implement a 3-stage RISC-V (RV32I) pipeline that runs programs against a fixed testbench. Stages: Fetch/Decode, Execute, Writeback. Handle data hazards (RAW via forwarding and/or stalls; load-use must stall or forward) and control hazards (branches/jumps).

**Implement in `/workspace/`.** Name your top-level file `pipeline.v` and provide a module named `pipe` (Verilog). You may add other `.v`/`.vh` files (e.g. for stages or opcodes); the verifier copies all into the test environment. The testbench expects the exact interface below; internal signal names must match so the harness can connect memory and detect completion.

**Verilog only — no SystemVerilog.** The verifier compiles with plain Verilog (Icarus Verilog). Do not use SystemVerilog-only constructs.

## Module: `pipe`

- **Ports (do not change):**

| Port | Direction | Width |
|------|------------|--------|
| clk | input | 1 |
| reset | input | 1 |
| stall | input | 1 |
| exception | output | 1 |
| inst_mem_is_valid | input | 1 |
| inst_mem_read_data | input | 32 |
| dmem_read_data_temp | input | 32 |
| dmem_write_valid | input | 1 |
| dmem_read_valid | input | 1 |

- **Parameter:** `RESET = 32'h0000_0000` (reset PC).
- **Required internal names** (the testbench connects to these; declare and drive them as needed):
  - `inst_mem_address` [31:0], `inst_mem_is_ready`;
  - `dmem_read_address` [31:0], `dmem_write_address` [31:0], `dmem_write_data` [31:0], `dmem_write_byte` [3:0], `dmem_read_ready`, `dmem_write_ready`;
  - `inst_fetch_pc` [31:0];
  - `regs` — register file `reg [31:0] regs [31:1]` (x0 is always 0; testbench sets `regs[2]` and observes `regs[15]`).

## ISA (support at least these)

- **U:** LUI  
- **J:** JAL  
- **I:** JALR  
- **B:** BEQ, BNE, BLT, BGE, BLTU, BGEU  
- **Load:** LB, LH, LW, LBU, LHU  
- **Store:** SB, SH, SW  
- **ARITHI:** ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI  
- **ARITHR:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND  

(Opcode/func3/func7 encodings follow RV32I; inst[30] distinguishes SUB vs ADD and SRA vs SRL.)

## Memory and control

- **I-mem:** Word-aligned; address `inst_mem_address[31:2]`; data on `inst_mem_read_data`; drive `inst_mem_is_ready` when requesting. The testbench drives `inst_mem_is_valid` when the data on `inst_mem_read_data` is valid for the current `inst_mem_address`. **You must advance the fetch address (the value driving `inst_mem_address`) every clock when not stalled** (or to the branch/jump target when a control transfer is taken). Do not gate updating this address on `inst_mem_is_valid`—otherwise the pipeline will not fetch subsequent instructions.
- **D-mem:** Word-aligned; read address `dmem_read_address[31:2]`, `dmem_read_ready` when loading; write address/data/byte-enable `dmem_write_*`, `dmem_write_ready` when storing. Read data arrives on `dmem_read_data_temp`. Testbench memory supports same-cycle read-after-write.
- **Reset:** Active-low. When `reset` is 0, the core is in reset: set PC to RESET and clear all architectural state. When `reset` is 1, the core runs. When `stall` is 1, do not change architectural state.
- **Exception:** Assert `exception` for illegal instruction or misaligned fetch (e.g. `inst_mem_address[1:0] != 0`). When asserted, the testbench ends the run and reports pass/fail.

Correctness is checked by running the provided test programs; the simulation must complete without timeout or address error and report PASS.
