Please fix the bug(s) in `picorv32.v` that are causing the testbench to fail. Run the testbench to see the failure, then debug and fix it.

**How to run the tests:** Build with `iverilog -DCOMPRESSED_ISA -o sim.vvp testbench.v picorv32.v`, then run with `vvp -N sim.vvp`. The test passes when the simulation output contains `ALL TESTS PASSED.`
