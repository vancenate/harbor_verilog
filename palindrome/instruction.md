# SystemVerilog Interview Question

Given an input (din), output (dout) a 1 if its binary representation is a palindrome and a 0 otherwise.

A palindrome binary representation means that the binary representation has the same sequence of bits whether you read it from left to right or right to left. Leading 0s are considered part of the input binary representation.

## Input and Output Signals

din - Input value
dout - 1 if the binary representation is a palindrome, 0 otherwise

## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify `solution_top.sv` (it is provided and contains the top-level module and assertions)
- Do NOT modify the `solution_core` module signature below
- Only add your routing logic inside the `solution_core` module

```systemverilog
module solution_core #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

  // Add your logic here

endmodule
```

Formal verification will prove your implementation is correct.