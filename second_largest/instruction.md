# SystemVerilog Interview Question

Given a clocked sequence of unsigned values, output the second-largest value seen so far in the sequence. If only one value is seen, then the output (dout) should equal 0. Note that repeated values are treated as separate candidates for being the second largest value.

When the reset-low signal (resetn) goes low, all previous values seen in the input sequence should no longer be considered for the calculation of the second largest value, and the output dout should restart from 0 on the next cycle.

## Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input data sequence
dout - Second-largest value seen so far

## Output signals during reset
dout - 0 when resetn is active


## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify `solution_top.sv` (it is provided and contains the top-level module and assertions)
- Do NOT modify the `solution_core` module signature below
- Only add your routing logic inside the `solution_core` module

```systemverilog
module solution_core #(parameter
  DATA_WIDTH = 32
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

//Add your logic here

endmodule
```

Formal verification will prove your implementation is correct.