// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

  solution_core #(.DIV_LOG2(DIV_LOG2), .OUT_WIDTH(OUT_WIDTH), .IN_WIDTH(IN_WIDTH)) core_inst (
    .din(din),
    .dout(dout)
  );

  solution_assertions #(.DIV_LOG2(DIV_LOG2), .OUT_WIDTH(OUT_WIDTH), .IN_WIDTH(IN_WIDTH)) assertions_inst (.*);

endmodule
