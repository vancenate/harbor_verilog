module testbench();

    //Local Parameters
    localparam      IMEMSIZE = 4096;
    localparam      DMEMSIZE = 4096;

    // PC counter and checker
    reg     [31: 0] next_pc;
    reg     [ 7: 0] count;

    reg             clk;
    reg             reset;
    reg             stall;
    wire            exception;
    wire    [31: 0] inst_mem_read_data;
    wire            inst_mem_is_valid;
    wire            dmem_write_valid;
    wire            dmem_read_valid;
    wire    [31: 0] dmem_read_data_temp;

assign dmem_write_valid    = 1'b1;
assign dmem_read_valid     = 1'b1;
assign inst_mem_is_valid   = 1'b1;

initial
begin
     $monitor("time: %t ,result =%d",$time,pipe.regs[15]);
end

initial
begin
    $dumpfile("pipeline.vcd");
    $dumpvars(0,pipe);
end

// Debug: run with +debug to print each cycle (PC, instruction, operands, result, a4/a5)
wire debug = $test$plusargs("debug");
integer cycle_count;
initial cycle_count = 0;
always @(posedge clk) begin
    if (debug && reset && !stall) begin
        cycle_count = cycle_count + 1;
        $display("--- cycle %0d --- pc=%x inst=%x rdata1=%d rdata2=%d result=%d wb_dest=%d wb_mem_to_reg=%b regs[a4]=%d regs[a5]=%d",
            cycle_count, pipe.inst_fetch_pc, pipe.instruction,
            pipe.reg_rdata1, pipe.reg_rdata2, pipe.result,
            pipe.wb_dest_reg_sel, pipe.wb_mem_to_reg,
            pipe.regs[14], pipe.regs[15]);
    end
end

initial
begin

    clk            <= 1'b1;
    reset          <= 1'b0;
    stall          <= 1'b1;

    repeat (10) @(posedge clk);
    reset          <= 1'b1;

    repeat (10) @(posedge clk);
    stall           <= 1'b0;

end

always #10 clk      <= ~clk;

// check timeout if the PC do not change anymore
always @(posedge clk or negedge reset)
begin
    if (!reset)
    begin
        next_pc     <= 32'h0;
        count       <= 8'h0;
        pipe.regs[2] <= 32'h00000fff;
    end
    else
    begin
        next_pc     <= pipe.inst_fetch_pc;

        if (next_pc == pipe.inst_fetch_pc)
            count   <= count + 1;
        else
            count   <= 8'h0;
        if (count > 100)
        begin
            $display("FAIL: Executing timeout");
            #10 $finish(1);
        end
    end
end

// Program done when exception is raised; result must be in regs[15]. Override with -DEXPECTED_RESULT=n.
`ifdef EXPECTED_RESULT
localparam EXPECTED_RESULT = 32'd`EXPECTED_RESULT;
`else
localparam EXPECTED_RESULT = 32'd102;
`endif

// Check result one cycle after exception so ADD's writeback has committed (nonblocking reg update).
reg exception_prev;
always @(posedge clk) exception_prev <= exception;
always @(posedge clk)
begin
    if (exception_prev)
    begin
        if (pipe.regs[15] == EXPECTED_RESULT)
        begin
            $display("PASS");
            #10 $finish(0);
        end
        else
        begin
            $display("FAIL: result in regs[15] = %d, expected %d", pipe.regs[15], EXPECTED_RESULT);
            #10 $finish(1);
        end
    end
end

///////////////////////////////////////////////////////////
/////// Instantiate Data memory
///////////////////////////////////////////////////////////
    memory # (
        .SIZE(DMEMSIZE),
        .FILE("imem_dmem/dmem.hex")
    ) dmem (
        .clk   (clk),
        .read_ready(pipe.dmem_read_ready),
        .write_ready(pipe.dmem_write_ready),
        .read_data (dmem_read_data_temp),
        .read_address (pipe.dmem_read_address[31:2]),
        .write_address (pipe.dmem_write_address[31:2]),
        .write_data (pipe.dmem_write_data),
        .write_byte (pipe.dmem_write_byte)
    );

///////////////////////////////////////////////////////////
/////// Instantiate Instruction memory
///////////////////////////////////////////////////////////

    memory # (
        .SIZE(IMEMSIZE),
        .FILE("imem_dmem/imem.hex")
    ) inst_mem (
        .clk   (clk),
        .read_ready(1'b1),
        .write_ready(1'b0),
        .read_data (inst_mem_read_data),
        .read_address (pipe.inst_mem_address[31:2]),
        .write_address (30'h0),
        .write_data (32'h0),
        .write_byte (4'h0)
    );

///////////////////////////////////////////////////////////
/////// Instantiate Pipeline Module
//////////////////////////////////////////////////////////

pipe pipe(
    .clk        (clk),
    .reset     (reset),
    .stall      (stall),
    .exception  (exception),
    .inst_mem_read_data (inst_mem_read_data),
    .inst_mem_is_valid (inst_mem_is_valid),
    .dmem_read_data_temp(dmem_read_data_temp),
    .dmem_write_valid(dmem_write_valid),
    .dmem_read_valid(dmem_read_valid)
);

//check memory range
always @(posedge clk)
begin
    if (pipe.inst_mem_is_ready && pipe.inst_mem_address[31:$clog2(IMEMSIZE)] != 'd0)
    begin
        $display("FAIL: IMEM address %x out of range", pipe.inst_mem_address);
        #10 $finish(1);
    end
    if (pipe.dmem_write_ready  && pipe.dmem_write_address[31:$clog2(DMEMSIZE)] != 'd0)
    begin
        $display("FAIL: DMEM address %x out of range", pipe.dmem_write_address);
        #10 $finish(1);
    end
end

endmodule
