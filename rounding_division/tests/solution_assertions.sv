// Formal verification assertions for the rounding division module
// Expected: divide by 2^DIV_LOG2, round 0.5+ up, saturate on overflow.

module solution_assertions #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  input logic [OUT_WIDTH-1:0] dout
);

  logic [OUT_WIDTH:0] expected_temp;
  logic [OUT_WIDTH-1:0] expected_dout;

  // quotient = din / 2^DIV_LOG2; round up if remainder >= 2^(DIV_LOG2-1) (i.e. din[DIV_LOG2-1])
  assign expected_temp = din[IN_WIDTH-1:DIV_LOG2] + din[DIV_LOG2-1];
  assign expected_dout = expected_temp[OUT_WIDTH] ? din[IN_WIDTH-1:DIV_LOG2] : expected_temp[OUT_WIDTH-1:0];

  always @(*) begin
    a_dout_rounded: assert(dout == expected_dout);
  end

endmodule
