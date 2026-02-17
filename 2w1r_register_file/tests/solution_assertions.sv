// Formal verification assertions for 2R1W register file (golden model + implementation check)
// Must use same DATA_WIDTH as solution_core.sv (passed via instantiation).

module solution_assertions #(parameter DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    input [4:0] wad1,
    input [4:0] rad1, rad2,
    input wen1, ren1, ren2,
    input clk,
    input resetn,
    input logic [DATA_WIDTH-1:0] dout1, dout2,
    input logic collision
);
    logic past_valid;
    initial past_valid = 1'b0;
    always @(posedge clk) past_valid <= 1'b1;

    initial assume(!resetn);
    always @(posedge clk) if (past_valid) assume(resetn); // deassert forever after first edge

    reg [DATA_WIDTH-1:0] mem [31:0];
    logic [DATA_WIDTH-1:0] dout1_model, dout2_model;
    logic collision_model;

    integer i;
    always_ff @(posedge clk) begin
        if (!resetn) begin
            // If reset mode, all entries are set to zero
            for (i = 0; i < 32; i = i + 1) mem[i] = 0;
            dout1_model <= 0;
            dout2_model <= 0;
            collision_model <= 1'b0;
        end else begin
            if (!wen1 & !ren1 & !ren2) begin  // NOP
                dout1_model <= 0;
                dout2_model <= 0;
                collision_model <= 1'b0;
            end else if (!wen1 & !ren1 & ren2) begin  // Read 2
                dout1_model <= 0;
                dout2_model <= mem[rad2];
                collision_model <= 1'b0;
            end else if (!wen1 & ren1 & !ren2) begin  // Read 1
                dout1_model <= mem[rad1];
                dout2_model <= 0;
                collision_model <= 1'b0;
            end else if (!wen1 & ren1 & ren2) begin  // Read 1 & Read 2
                if (rad1 == rad2) begin
                    dout1_model <= 0;
                    dout2_model <= 0;
                    collision_model <= 1'b1;
                end else begin
                    dout1_model <= mem[rad1];
                    dout2_model <= mem[rad2];
                    collision_model <= 1'b0;
                end
            end else if (wen1 & !ren1 & !ren2) begin  // Write, no reads
                mem[wad1] <= din;
                dout1_model <= 0;
                dout2_model <= 0;
                collision_model <= 1'b0;
            end else begin  // Allowed, but need to check for address collision
                if (wad1 == rad1 && ren1) begin
                    dout1_model <= 0;
                    dout2_model <= 0;
                    collision_model <= 1'b1;
                end else if (wad1 == rad2 && ren2) begin
                    dout1_model <= 0;
                    dout2_model <= 0;
                    collision_model <= 1'b1;
                end else if (rad1 == rad2 && ren1 && ren2) begin
                    mem[wad1] <= din;
                    dout1_model <= 0;
                    dout2_model <= 0;
                    collision_model <= 1'b1;
                end else begin
                    mem[wad1] <= din;
                    if (!ren1 & ren2) begin
                        dout1_model <= 0;
                        dout2_model <= mem[rad2];
                    end else if (ren1 & !ren2) begin
                        dout1_model <= mem[rad1];
                        dout2_model <= 0;
                    end else begin
                        dout1_model <= mem[rad1];
                        dout2_model <= mem[rad2];
                    end
                    collision_model <= 1'b0;
                end
            end
        end
    end

    // Implementation must match golden reference model
    always @(posedge clk) begin
        if (past_valid && resetn) begin
            a_dout1_matches_model: assert(dout1 == dout1_model);
            a_dout2_matches_model: assert(dout2 == dout2_model);
            a_collision_matches_model: assert(collision == collision_model);
        end
    end


endmodule
