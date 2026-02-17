// Formal verification assertions for the router module
// Must use same DATA_WIDTH as solution.sv (passed via instantiation).

module solution_assertions #(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] din,
    input wire din_en,
    input wire [1:0] addr,
    input wire [DATA_WIDTH-1:0] dout0,
    input wire [DATA_WIDTH-1:0] dout1,
    input wire [DATA_WIDTH-1:0] dout2,
    input wire [DATA_WIDTH-1:0] dout3
);
    localparam ZERO = {DATA_WIDTH{1'b0}};

    // Property 1: When din_en is disabled, all outputs must be 0
    always @(*) begin
        if (!din_en) begin
            a_disabled_dout0_zero: assert(dout0 == ZERO);
            a_disabled_dout1_zero: assert(dout1 == ZERO);
            a_disabled_dout2_zero: assert(dout2 == ZERO);
            a_disabled_dout3_zero: assert(dout3 == ZERO);
        end
    end

    // Property 2: When enabled with addr=00, only dout0 should equal din
    always @(*) begin
        if (din_en && addr == 2'b00) begin
            a_addr00_dout0_equals_din: assert(dout0 == din);
            a_addr00_dout1_is_zero: assert(dout1 == ZERO);
            a_addr00_dout2_is_zero: assert(dout2 == ZERO);
            a_addr00_dout3_is_zero: assert(dout3 == ZERO);
        end
    end

    // Property 3: When enabled with addr=01, only dout1 should equal din
    always @(*) begin
        if (din_en && addr == 2'b01) begin
            a_addr01_dout0_is_zero: assert(dout0 == ZERO);
            a_addr01_dout1_equals_din: assert(dout1 == din);
            a_addr01_dout2_is_zero: assert(dout2 == ZERO);
            a_addr01_dout3_is_zero: assert(dout3 == ZERO);
        end
    end

    // Property 4: When enabled with addr=10, only dout2 should equal din
    always @(*) begin
        if (din_en && addr == 2'b10) begin
            a_addr10_dout0_is_zero: assert(dout0 == ZERO);
            a_addr10_dout1_is_zero: assert(dout1 == ZERO);
            a_addr10_dout2_equals_din: assert(dout2 == din);
            a_addr10_dout3_is_zero: assert(dout3 == ZERO);
        end
    end

    // Property 5: When enabled with addr=11, only dout3 should equal din
    always @(*) begin
        if (din_en && addr == 2'b11) begin
            a_addr11_dout0_is_zero: assert(dout0 == ZERO);
            a_addr11_dout1_is_zero: assert(dout1 == ZERO);
            a_addr11_dout2_is_zero: assert(dout2 == ZERO);
            a_addr11_dout3_equals_din: assert(dout3 == din);
        end
    end

    // Property 6: At most one output can be non-zero at any time
    always @(*) begin
        a_only_one_output_active: assert($countones({dout0 != ZERO, dout1 != ZERO, dout2 != ZERO, dout3 != ZERO}) <= 1);
    end

    // Property 7: Sum of all outputs equals din when enabled, 0 when disabled
    always @(*) begin
        if (din_en) begin
            a_enabled_output_equals_din: assert((dout0 | dout1 | dout2 | dout3) == din);
        end else begin
            a_disabled_all_outputs_zero: assert((dout0 | dout1 | dout2 | dout3) == ZERO);
        end
    end

endmodule
