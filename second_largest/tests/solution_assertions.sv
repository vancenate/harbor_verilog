// Formal verification assertions for the second-largest value tracker
// Must use same DATA_WIDTH as solution.sv (passed via instantiation).

module solution_assertions #(parameter DATA_WIDTH = 32) (
    input wire clk,
    input wire resetn,
    input wire [DATA_WIDTH-1:0] din,
    input wire [DATA_WIDTH-1:0] dout
);
    logic past_valid;
    initial past_valid = 1'b0;
    always @(posedge clk) past_valid <= 1'b1;

    initial assume(!resetn);
    always @(posedge clk) if (past_valid) assume(resetn); // deassert forever after first edge


    logic [DATA_WIDTH-1:0] largest, second_largest;

    always @(posedge clk) begin
        if(~resetn) begin
            largest <= '0;
            second_largest <= '0;
        end else if ((din > largest && din > second_largest)) begin
            largest <= din;
            second_largest <= largest;
        end else if (din > second_largest) begin
            second_largest <= din;
        end
    end

    // dout should always equal second_largest unless in reset
    always @(posedge clk) begin
        if (past_valid && resetn) begin
            a_dout_is_second_largest: assert(dout == second_largest);
        end
    end


endmodule
