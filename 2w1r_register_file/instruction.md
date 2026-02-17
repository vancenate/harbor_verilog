# SystemVerilog Interview Question

Implement a programmable bitwidth, 32-word 2-read 1-write (2R1W) register file (RF).

The RF has 32 entries, each of which being a DATA_WIDTH-bit binary word.  The input word din is written to one of the entries of the RF by using the write address port wad1 and asserting signal wen1.  Entries are read from the RF by selecting the addresses and asserting the ren1 and/or ren2 signals.  The RF must support up to three operations per clock cycle, that is, two reads and one write;  no operations (NOP), one, and two operations must be also supported.

The default value of both dout1 and dout2 is zero.  If, at the rising edge of the clock, one of the read-enable ports is deasserted, then it is expected that its respective data-output port produces the default value (zero).  If one tries to read from an address that has never been written to, then dout1 and/or dout2 produce zero.

RF's output port collision = 1 when at least two out of three input addresses are equal, and collision = 0 otherwise.  That is, the RF must flag when one tries to write to and read from the same address (wad1 = rad1 or wad1 = rad2), or attempts to read from the same address using both read ports (rad1 or wad1 = rad2).


## Input and Output Signals
din - Input data port
wad1 - Write input address 1
rad1 - Read input address 1
rad2 - Read input address 2
wen1 - Write-enable signal 1
ren1 - Read-enable input signal 1
ren2 - Read-enable input signal 2
clk - Clock signal
resetn - Synchronous, active-low, reset signal
dout1 - Output data port 1
dout2 - Output data port 2
collision - Indicates collisions among read & write addresses

## Output signals during reset
dout1 - 0
dout2 - 0
collision - 0


## Solution Structure

**Implement your solution in `/workspace/solution_core.sv` only.**

- Do NOT modify the `solution_core` module signature below
- Only add your routing logic inside the `solution_core` module

```systemverilog
module solution_core #(parameter 
    DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    input [4:0] wad1,
    input [4:0] rad1, rad2,
    input wen1, ren1, ren2,
    input clk,
    input resetn,
    output logic [DATA_WIDTH-1:0] dout1, dout2,
    output logic collision
);

//Add your logic here

endmodule
```

Formal verification will prove your implementation is correct.