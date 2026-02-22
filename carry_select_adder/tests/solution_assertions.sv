// Formal verification assertions for the 24-bit Carry Select Adder
// Expected: result == a + b (unsigned)

module solution_assertions (
  input [23:0] a,
  input [23:0] b,
  input logic [24:0] result
);

  always @(*) begin
    a_result_sum: assert(result == (a + b));
  end

endmodule
