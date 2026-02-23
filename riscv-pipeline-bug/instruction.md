# 3-Stage RISC-V Pipeline — Find and Fix the Bug

The pipeline in `/workspace/` has **one bug**. Fix it so **all tests pass**.

**Verilog only.** The verifier uses Icarus Verilog. Do not use SystemVerilog-only constructs.

## Test program (instruction memory)

| Addr | Instruction   |
|------|---------------|
| 0    | addi a4, x0, 0 |
| 4    | addi a5, x0, 0 |
| 8    | addi a3, x0, 0 |
| c    | lw   a4, 0(a3) |
| 10   | lw   a5, 4(a3) |
| 14   | add  a5, a4, a5|
| 18   | illegal (end)  |

## Data memory (initial)

- Word at address 0: **100**
- Word at address 4: **2**

## Expected result

When the program completes (exception raised), **`regs[15]`** must equal **102**.

A waveform (**`waveform.png`**) may be provided for reference. 

## What you can change

Edit only the existing design files in `/workspace/`: **`pipeline.v`**, **`IF_ID.v`**, **`execute.v`**, **`wb.v`**, **`opcode.vh`**. Use all five files—do not delete or omit any. Only modify the code to fix the bug. Do not create any new design files. The testbench and test programs are fixed. The verifier requires all five files to be present; if any are missing, the run fails.
