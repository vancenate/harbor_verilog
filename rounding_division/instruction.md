# SystemVerilog Interview Question

Divide an input number by a power of two and round the result to the nearest integer. The power of two is calculated using 2^DIV_LOG2 where DIV_LOG2 is a module parameter. Remainders of 0.5 or greater should be rounded up to the nearest integer. If the output were to overflow, then the result should be saturated instead.

## Input and Output Signals

din - Input number
dout - Rounded result

## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify the `solution_core` module signature below
- Only add your logic inside the `solution_core` module

```systemverilog
module solution_core #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

endmodule
```

Formal verification will prove your implementation is correct.
