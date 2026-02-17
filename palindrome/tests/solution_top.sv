// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

  solution_core #(.DATA_WIDTH(DATA_WIDTH)) core_inst (
    .din(din),
    .dout(dout)
  );

  solution_assertions #(.DATA_WIDTH(DATA_WIDTH)) assertions_inst (.*);

endmodule
