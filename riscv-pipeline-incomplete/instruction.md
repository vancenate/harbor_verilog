# 3-Stage RISC-V Pipeline — Execute Stage

Complete the 3-stage RISC-V (RV32I) pipeline by implementing **only the Execute stage**. The Fetch/Decode stage (IF_ID), Writeback stage (wb), top-level pipeline (pipe), and opcode definitions are already provided in your workspace. You must add **`execute.v`** in `/workspace/` so that the pipeline compiles and runs correctly against the fixed testbench.

**Verilog only — no SystemVerilog.** The verifier compiles with plain Verilog (Icarus Verilog). Do not use SystemVerilog-only constructs.

## What you have in `/workspace/`

Your workspace is pre-populated with the design files below (only `execute.v` is missing). If `/workspace/` is empty when you start, copy the starter files from the image: `cp /starter/*.v /starter/*.vh /workspace/`, then create `execute.v`.

- **`pipeline.v`** — Top-level module `pipe`; includes `IF_ID.v`, `execute.v`, and `wb.v`. Do not change this file.
- **`IF_ID.v`** — Fetch/Decode stage (instruction fetch, decode, register read, forwarding into decode). Do not change.
- **`wb.v`** — Writeback stage (memory read formatting, register write, PC update, branch stalls). Do not change.
- **`opcode.vh`** — Opcode and `func3`/`func7` definitions (`LUI`, `JAL`, `JALR`, `BRANCH`, `LOAD`, `STORE`, `ARITHI`, `ARITHR`, and `BEQ`/`BNE`/`BLT`/`BGE`/`BLTU`/`BGEU`, `ADD`/`SUB`, `SLL`, `SLT`/`SLTU`, `XOR`, `SR`/`SRA`, `OR`, `AND`, load/store encodings). Use this; do not change.

You **must create** `/workspace/execute.v` with a module named **`execute`** that matches the instantiation in `pipeline.v`:

```verilog
execute execute(
    .clk   (clk),
    .reset (reset)
);
```

The execute module has no ports other than `clk` and `reset`. It communicates with the rest of the pipeline by driving and reading **hierarchical references** to the parent `pipe` module (e.g. `pipe.reg_rdata1`, `pipe.result`, `pipe.fetch_pc`). The existing design uses this style; your execute stage must use the same signal names and directions so the pipeline and testbench connect correctly.

## What the Execute stage must do

1. **ALU operands**  
   - Drive `pipe.alu_operand1` and `pipe.alu_operand2`.  
   - Operand1 comes from the register file output (`pipe.reg_rdata1`).  
   - Operand2 is either the decoded immediate (`pipe.execute_immediate`) or `pipe.reg_rdata2`, depending on `pipe.immediate_sel` (use immediate for I-type ALU, JALR, LOAD; use reg for R-type and stores).

2. **Comparisons for branches**  
   - Compute signed and unsigned subtracts for branch conditions:  
     - `pipe.result_subs[32:0]` = signed subtraction (for BEQ, BNE, BLT, BGE).  
     - `pipe.result_subu[32:0]` = unsigned subtraction (for BLTU, BGEU).  
   - Use the sign/zero of these results to decide branch taken and to drive `pipe.next_pc` and `pipe.branch_taken`.

3. **Next PC and branch resolution**  
   - Drive `pipe.next_pc` and `pipe.branch_taken`.  
   - Default: `pipe.next_pc = pipe.fetch_pc + 4`, `pipe.branch_taken = 0`.  
   - JAL: `pipe.next_pc = pipe.pc + pipe.execute_immediate`, `pipe.branch_taken = 1`.  
   - JALR: `pipe.next_pc = pipe.alu_operand1 + pipe.execute_immediate`, `pipe.branch_taken = 1`.  
   - BRANCH: set `pipe.next_pc` to either `pipe.pc + pipe.execute_immediate` (taken) or `pipe.fetch_pc + 4` (not taken), and set `pipe.branch_taken` accordingly, using `pipe.alu_operation` (BEQ/BNE/BLT/BGE/BLTU/BGEU) and the comparison results above.  
   - Drive `pipe.branch_stall` (e.g. from `pipe.wb_branch_nxt || pipe.wb_branch`) so the rest of the pipeline can stall when a branch is in flight.

4. **Memory address for loads/stores**  
   - Drive `pipe.write_address` = `pipe.alu_operand1 + pipe.execute_immediate` (effective address for loads and stores). The writeback stage and top level use this for dmem address and store data; the load path uses the same address.

5. **ALU result**  
   - Drive `pipe.result` for the current instruction:  
     - LUI: `pipe.execute_immediate`.  
     - JAL/JALR: return address `pipe.pc + 4`.  
     - Stores: pass through store data in `pipe.alu_operand2` (so `pipe.result = pipe.alu_operand2` for store).  
     - ARITHI/ARITHR: implement ADD, SUB (using `pipe.arithsubtype`), SLL, SLT, SLTU, XOR, SRL, SRA (using `pipe.arithsubtype`), OR, AND per RV32I.  
   - Use `pipe.alu_operation` and `pipe.arithsubtype` (inst[30] for SUB vs ADD and SRA vs SRL).

6. **PC register for execute**  
   - Update `pipe.fetch_pc` on the clock when not in reset and when not stalled (`!pipe.stall_read`): on branch stall use `pipe.fetch_pc + 4`, else use `pipe.next_pc`.

7. **Pass values to Writeback**  
   - On the same clock edge, when not in reset and when not stalled, latch into the writeback stage:  
     - `pipe.wb_result`, `pipe.wb_mem_write`, `pipe.wb_alu_to_reg`, `pipe.wb_dest_reg_sel`, `pipe.wb_branch`, `pipe.wb_branch_nxt`, `pipe.wb_mem_to_reg`, `pipe.wb_read_address` (from load address low bits, e.g. `pipe.dmem_read_address[1:0]` or equivalent), and `pipe.wb_alu_operation`.  
   - Suppress store on branch (e.g. `pipe.wb_mem_write = pipe.mem_write && !pipe.branch_stall`).  
   - Set `pipe.wb_alu_to_reg` so that the writeback stage and register file know when to write back (e.g. for ALU, LUI, JAL/JALR, or load).

## Pipeline and testbench interface (for reference)

- The top-level module is **`pipe`** in **`pipeline.v`** with parameter **`RESET = 32'h0000_0000`**.  
- Ports (do not change): `clk`, `reset`, `stall`, `exception`, `inst_mem_is_valid`, `inst_mem_read_data`, `dmem_read_data_temp`, `dmem_write_valid`, `dmem_read_valid`.  
- Required internal names the testbench uses: `inst_mem_address`, `inst_mem_is_ready`, `dmem_read_address`, `dmem_write_address`, `dmem_write_data`, `dmem_write_byte`, `dmem_read_ready`, `dmem_write_ready`, `inst_fetch_pc`, and register file `regs` (`reg [31:0] regs [31:1]`; x0 is always 0; testbench uses `regs[2]` and observes `regs[15]`).  
- I-mem: word-aligned; advance the address each clock when not stalled (or to branch/jump target when taken). Do not gate the fetch address on `inst_mem_is_valid`.  
- D-mem: word-aligned; read/write and byte-enables as in the provided design.  
- Reset: active-low; when `reset` is 0, clear state; when `stall` is 1, do not change architectural state.  
- Assert `exception` for illegal instruction or misaligned fetch; the testbench ends the run on exception.

## ISA (support at least these)

- **U:** LUI  
- **J:** JAL  
- **I:** JALR  
- **B:** BEQ, BNE, BLT, BGE, BLTU, BGEU  
- **Load:** LB, LH, LW, LBU, LHU  
- **Store:** SB, SH, SW  
- **ARITHI:** ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI  
- **ARITHR:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND  

Opcode/func3/func7 follow RV32I; `inst[30]` distinguishes SUB vs ADD and SRA vs SRL. All of these are already decoded in IF_ID and exposed via `pipe.*`; your execute stage only needs to use them and drive the correct `pipe.result`, `pipe.next_pc`, and writeback inputs.

Correctness is checked by running the provided test programs; the simulation must complete without timeout or address error and report **PASS**.
