Create a Verilog testbench that verifies the RISC-V core in `picorv32.v`. Use it to find and fix any functional bugs in the design.

Design and evaluation:
- The core is a PicoRV32-style RISC-V CPU implementing RV32IMC with interrupts enabled (compressed, multiply/divide, and IRQ behavior should follow the RISC-V spec).
- Evaluation instantiates the AXI wrapper `picorv32_axi` with compressed instructions and the M extension enabled (`COMPRESSED_ISA`, `ENABLE_MUL`, `ENABLE_DIV`, `ENABLE_IRQ`, and `ENABLE_TRACE` are turned on).
- Your solution is considered correct when the design passes a hidden testbench and firmware; that test will print `ALL TESTS PASSED.` on success.

How to run your own tests:
- Instantiate `picorv32_axi` with the same parameters (COMPRESSED_ISA, ENABLE_MUL, ENABLE_DIV, ENABLE_IRQ, ENABLE_TRACE) so your tests match evaluation.
- Write a testbench (for example `my_testbench.v`) that instantiates the core and a memory model, loads a program into memory, and checks for correct behavior.
- You can simulate with Icarus Verilog, for example:
  - `iverilog -g2012 -o sim.vvp my_testbench.v picorv32.v`
  - `vvp -N sim.vvp`
