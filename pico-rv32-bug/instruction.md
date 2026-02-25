## PicoRV32 Bug Hunt

This task gives you a single-file Verilog implementation of the PicoRV32 core, `picorv32.v`, wired up to a simple testbench and a precompiled firmware image. Your goal is to identify and fix a bug in `picorv32.v` so that the design runs the firmware to completion and the simulation passes.

### What is provided

- `picorv32.v` — a self-contained implementation of a 32-bit RISC-V (RV32I) core with optional extensions. It exposes a simple memory interface and includes optional PCPI / AXI / Wishbone wrappers inside the same file. This is the file you must fix; the starter copy may contain a bug; the copy in `solution/` is the golden reference.
- `testbench.v` — instantiates `picorv32_wrapper` and an `axi4_memory` model, then loads a prebuilt firmware image and runs the core until it traps. It is provided in `/workspace/` **for reference only**: read it to understand how the core is driven and how pass/fail is determined. **Do not modify `testbench.v`.** The verifier runs tests using its own copy of the testbench; your workspace copy is not used during verification.
- `firmware/firmware.hex` — the program image the testbench loads into memory via `$readmemh("firmware/firmware.hex", mem.memory);`. It is provided in `/workspace/firmware/` **for reference only** so you have the full picture of what the core is executing; **do not modify it.** The verifier uses its own copy of this file when running tests.

The environment copies starter `picorv32.v`, `testbench.v`, and `firmware/` into `/workspace/` before each run.

### Your objective

Edit `/workspace/picorv32.v` to fix the bug so that:

- The design builds with Icarus Verilog using the provided `filelist.txt`.
- Running the simulation with the provided testbench and firmware terminates normally (no TIMEOUT).
- The testbench prints `ALL TESTS PASSED.` before exiting.

The verifier runs the same compile-and-simulate flow and checks for this PASS condition. Any compile error, TIMEOUT, or missing `ALL TESTS PASSED.` in the output is treated as a failure.

