// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top #(parameter
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

  solution_core #(.DATA_WIDTH(DATA_WIDTH)) core_inst (
    .din(din),
    .din_en(din_en),
    .addr(addr),
    .dout0(dout0),
    .dout1(dout1),
    .dout2(dout2),
    .dout3(dout3)
  );

  solution_assertions #(.DATA_WIDTH(DATA_WIDTH)) assertions_inst (.*);

endmodule
