# Router Circuit SystemVerilog Interview Question

Build a router circuit which forwards data from the input (din) to one of four outputs (dout0, dout1, dout2, or dout3), specified by the address input (addr).

## Requirements

The address is a two bit value whose decimal representation determines which output value to use. Append to dout the decimal representation of addr to get the output signal name dout{address decimal value}. For example, if addr=b11 then the decimal representation of addr is 3, so the output signal name is dout3.

The input has an enable signal (din_en), which allows the input to be forwarded to an output when enabled. If an output is not currently being driven to, then it should be set to 0.

## Input and Output Signals

- **din** [DATA_WIDTH-1:0] - Input data
- **din_en** - Enable signal for din. Forwards data from input to an output if 1, does not forward data otherwise
- **addr** [1:0] - Two bit destination address. For example addr = b11 = 3 indicates din should be forwarded to output value 3 (dout3)
- **dout0** [DATA_WIDTH-1:0] - Output 0. Corresponds to addr = b00
- **dout1** [DATA_WIDTH-1:0] - Output 1. Corresponds to addr = b01
- **dout2** [DATA_WIDTH-1:0] - Output 2. Corresponds to addr = b10
- **dout3** [DATA_WIDTH-1:0] - Output 3. Corresponds to addr = b11

## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify the `solution_core` module signature below
- Only add your routing logic inside the `solution_core` module

```systemverilog
module solution_core #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  input  din_en,
  input  [1:0] addr,
  output logic [DATA_WIDTH-1:0] dout0,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);

  // Add your routing logic here

endmodule
```

Formal verification will prove your implementation is correct.