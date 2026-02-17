// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top #(parameter
  DATA_WIDTH = 16
) (
  input  clk,
  input  resetn,
  input  [DATA_WIDTH-1:0] din,
  input  [4:0] wad1,
  input  [4:0] rad1, rad2,
  input  wen1, ren1, ren2,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic collision
);

  solution_core #(.DATA_WIDTH(DATA_WIDTH)) core_inst (
    .din(din),
    .wad1(wad1),
    .rad1(rad1),
    .rad2(rad2),
    .wen1(wen1),
    .ren1(ren1),
    .ren2(ren2),
    .clk(clk),
    .resetn(resetn),
    .dout1(dout1),
    .dout2(dout2),
    .collision(collision)
  );

  solution_assertions #(.DATA_WIDTH(DATA_WIDTH)) assertions_inst (.*);

endmodule
