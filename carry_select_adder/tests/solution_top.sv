// Top-level module - DO NOT MODIFY
// This structure is shared across all Verilog problems.

module solution_top (
  input [23:0] a,
  input [23:0] b,
  output logic [24:0] result
);

  solution_core core_inst (
    .a(a),
    .b(b),
    .result(result)
  );

  solution_assertions assertions_inst (.*);

endmodule
