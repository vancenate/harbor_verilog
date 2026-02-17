// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top #(parameter
  DATA_WIDTH = 32
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

  solution_core #(.DATA_WIDTH(DATA_WIDTH)) core_inst (
    .clk(clk),
    .resetn(resetn),
    .din(din),
    .dout(dout)
  );

  solution_assertions #(.DATA_WIDTH(DATA_WIDTH)) assertions_inst (.*);

endmodule
