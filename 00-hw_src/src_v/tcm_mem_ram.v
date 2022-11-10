//-----------------------------------------------------------------
//                         biRISC-V CPU
//                            V0.6.0
//-----------------------------------------------------------------

module tcm_mem_ram
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [ 13:0]  addr0_i
    ,input  [ 31:0]  data0_i
    ,input  [  3:0]  wr0_i
    ,input  [ 13:0]  addr1_i

    // Outputs
    ,output [ 31:0]  data0_o
    ,output [ 31:0]  data1_o
);

//-----------------------------------------------------------------
// Dual Port RAM 64KB
// Mode: Read First
//-----------------------------------------------------------------
/* verilator lint_off MULTIDRIVEN */
reg [31:0]   ram [8191:0] /*verilator public*/;
// reg [63:0]   ram [8191:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

initial begin
    $readmemh("D:/DOING/00-GRAD/02-proj/07-FPGA_contest/UniRISCV_221108/ubriscvOnPango/source/uart_tx_test_bin.txt", ram);
end

reg [31:0] ram_read0_q;
reg [31:0] ram_read1_q;

// wire [12:0] ram_addr_0;
// assign ram_addr_0 = addr0_i[12:0];
// // wire ram_sel;
// // assign ram_sel = addr0_i[0];
// wire [12:0] ram_addr_1;
// assign ram_addr_1 = addr1_i[12:0];

// Synchronous write
always @ (posedge clk_i)
begin
    if (wr0_i[0])
        ram[addr0_i][7:0] <= data0_i[7:0];
    if (wr0_i[1])
        ram[addr0_i][15:8] <= data0_i[15:8];
    if (wr0_i[2])
        ram[addr0_i][23:16] <= data0_i[23:16];
    if (wr0_i[3])
        ram[addr0_i][31:24] <= data0_i[31:24];

    ram_read0_q <= ram[addr0_i];
    ram_read1_q <= ram[addr1_i];
end

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;

endmodule
