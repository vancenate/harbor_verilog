// Formal verification assertions for the palindrome module
// Must use same DATA_WIDTH as solution_core.sv (passed via instantiation).

module solution_assertions #(parameter DATA_WIDTH = 32) (
  input [DATA_WIDTH-1:0] din,
  input logic dout
);
    int i;
    logic is_palindrome;

    always @* begin
        is_palindrome = 1;
        for (i = 0; i < DATA_WIDTH/2; i++) begin
            is_palindrome = (din[i] == din[DATA_WIDTH-1-i]) && is_palindrome;
        end
    end

    always @(*) begin
        a_dout_is_palindrome: assert(dout == is_palindrome);
    end

endmodule
