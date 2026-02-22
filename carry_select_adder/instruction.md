# SystemVerilog Interview Question

Use the solutions to questions 22 & 24 (Full Adder and Ripple Carry Adder, respectively) to implement a 24-bit Carry Select Adder (CSA). CSAs commonly employ two Ripple Carry Adders (RCAs) which compute a + b + cin, where cin = 0 in one computation, and cin = 1 in the other. The final result is obtained by selecting the correct partial sum, based on the cout bit of the previous stage.

Fig. 1 below shows a 4-bit CSA. This module can be replicated in order to build larger bitwidth high speed adders, for instance, a 24-bit CSA.

In this question, implement a 24-bit Carry Select Adder (CSA) using multiple parallel RCAs and multiplexers. The CSA module takes two unsigned integers a and b, and produces an output word sum, corresponding to a + b operation. The number of RCA stages in the CSA can be chosen by the designer, e.g., 3 stages of 8-bit RCAs, 4 stages of 6-bit RCAs, etc. Bonus: Can you design a parametric number of stage 24-bit CSA? Test your design with various number of RCA stages.

## Input and Output Signals

a - First operand input word
b - Second operand input word
result - Output word corresponding to a plus b operation (25-bit word since both a and b are 24-bit)

## Provided Files

The files `full_adder.sv` and `rca.sv` are provided in the tests directory and will be available when verification runs. **You must ensure these files exist in your workspace** — create them with the implementations below if they are not present. Implement `solution_core.sv` that includes and uses them.

### full_adder.sv

```systemverilog
module full_adder (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);

    assign {cout, sum} = a + b + cin;

endmodule
```

### rca.sv

```systemverilog
module rca #(parameter
    DATA_WIDTH=10
) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input cin,
    output logic [DATA_WIDTH-0:0] sum,
    output logic [DATA_WIDTH-1:0] cout_int
);

    genvar i;
    generate
        for(i = 0; i < DATA_WIDTH; i = i + 1) begin
            if(i == 0) begin
                full_adder f(
                  .a(a[i]),
                  .b(b[i]),
                  .cin(cin),
                  .sum(sum[i]),
                  .cout(cout_int[i])
                );
            end
            else begin
                full_adder f(
                  .a(a[i]),
                  .b(b[i]),
                  .cin(cout_int[i-1]),
                  .sum(sum[i]),
                  .cout(cout_int[i])
                );
            end
        end
    endgenerate

    assign sum[DATA_WIDTH] = cout_int[DATA_WIDTH-1];

endmodule
```

## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify the `solution_core` module signature below
- Only add your logic inside the `solution_core` module
- Use `include "full_adder.sv"` and `include "rca.sv"` to include the provided modules

```systemverilog
module solution_core (
    input [23:0] a,
    input [23:0] b,
    output logic [24:0] result
);

endmodule
```

Formal verification will prove your implementation is correct.
