//-----------------------------------------------------------------
//                         RISC-V Top
//                            V0.6
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------
module tcm_mem
(
    // Inputs
     input wire            clk_i
    ,input wire            rst_i
    ,input wire            mem_i_rd_i //
    ,input wire            mem_i_flush_i //
    ,input wire            mem_i_invalidate_i //
    ,input wire   [ 31:0]  mem_i_pc_i //
    ,input wire   [ 31:0]  mem_d_addr_i //
    ,input wire   [ 31:0]  mem_d_data_wr_i //
    ,input wire            mem_d_rd_i //
    ,input wire   [  3:0]  mem_d_wr_i //
    ,input wire            mem_d_cacheable_i //
    ,input wire   [ 10:0]  mem_d_req_tag_i //
    ,input wire            mem_d_invalidate_i //
    ,input wire            mem_d_writeback_i //
    ,input wire            mem_d_flush_i                               //
    ,input wire            axi_awvalid_i //
    ,input wire   [ 31:0]  axi_awaddr_i //
    ,input wire   [  3:0]  axi_awid_i //
    ,input wire   [  7:0]  axi_awlen_i //
    ,input wire   [  1:0]  axi_awburst_i //
    ,input wire            axi_wvalid_i //
    ,input wire   [ 31:0]  axi_wdata_i //
    ,input wire   [  3:0]  axi_wstrb_i //
    ,input wire            axi_wlast_i //
    ,input wire            axi_bready_i //
    ,input wire            axi_arvalid_i //
    ,input wire   [ 31:0]  axi_araddr_i //
    ,input wire   [  3:0]  axi_arid_i //
    ,input wire   [  7:0]  axi_arlen_i //
    ,input wire   [  1:0]  axi_arburst_i //
    ,input wire            axi_rready_i                                //

    // Outputs
    ,output wire         mem_i_accept_o //
    ,output wire         mem_i_valid_o                                      //
    ,output wire         mem_i_error_o//
    ,output wire[ 31:0]  mem_i_inst_o//
    ,output wire[ 31:0]  mem_d_data_rd_o//
    ,output wire         mem_d_accept_o//
    ,output wire         mem_d_ack_o//
    ,output wire         mem_d_error_o//
    ,output wire[ 10:0]  mem_d_resp_tag_o//

    ,output wire         axi_awready_o//
    ,output wire         axi_wready_o//
    ,output wire         axi_bvalid_o//
    ,output wire[  1:0]  axi_bresp_o//
    ,output wire[  3:0]  axi_bid_o
    ,output wire         axi_arready_o//
    ,output wire         axi_rvalid_o//
    ,output wire[ 31:0]  axi_rdata_o//
    ,output wire[  1:0]  axi_rresp_o//
    ,output wire[  3:0]  axi_rid_o//
    ,output wire         axi_rlast_o//
);



//-------------------------------------------------------------
// AXI -> PMEM Interface
//-------------------------------------------------------------
wire          ext_accept_w;                                     //
wire          ext_ack_w;//
wire [ 31:0]  ext_read_data_w;//
wire [  3:0]  ext_wr_w;//
wire          ext_rd_w;//
wire [  7:0]  ext_len_w;//
wire [ 31:0]  ext_addr_w;//
wire [ 31:0]  ext_write_data_w;//
wire [31:0]   mem_i_inst; //

tcm_mem_pmem
u_conv
(
    // Inputs
    .clk_i(clk_i),
    .rst_i(rst_i),
    .axi_awvalid_i(axi_awvalid_i),
    .axi_awaddr_i(axi_awaddr_i),
    .axi_awid_i(axi_awid_i),
    .axi_awlen_i(axi_awlen_i),
    .axi_awburst_i(axi_awburst_i),
    .axi_wvalid_i(axi_wvalid_i),
    .axi_wdata_i(axi_wdata_i),
    .axi_wstrb_i(axi_wstrb_i),
    .axi_wlast_i(axi_wlast_i),
    .axi_bready_i(axi_bready_i),
    .axi_arvalid_i(axi_arvalid_i),
    .axi_araddr_i(axi_araddr_i),
    .axi_arid_i(axi_arid_i),
    .axi_arlen_i(axi_arlen_i),
    .axi_arburst_i(axi_arburst_i),
    .axi_rready_i(axi_rready_i),
    .ram_accept_i(ext_accept_w),
    .ram_ack_i(ext_ack_w),
    .ram_error_i(1'b0),
    .ram_read_data_i(ext_read_data_w),

    // Outputs
    .axi_awready_o(axi_awready_o),
    .axi_wready_o(axi_wready_o),
    .axi_bvalid_o(axi_bvalid_o),
    .axi_bresp_o(axi_bresp_o),
    .axi_bid_o(axi_bid_o),
    .axi_arready_o(axi_arready_o),
    .axi_rvalid_o(axi_rvalid_o),
    .axi_rdata_o(axi_rdata_o),
    .axi_rresp_o(axi_rresp_o),
    .axi_rid_o(axi_rid_o),
    .axi_rlast_o(axi_rlast_o),
    .ram_wr_o(ext_wr_w),
    .ram_rd_o(ext_rd_w),
    .ram_len_o(ext_len_w),
    .ram_addr_o(ext_addr_w),
    .ram_write_data_o(ext_write_data_w)
);

//-------------------------------------------------------------
// Dual Port RAM
//-------------------------------------------------------------

// Mux access to the 2nd port between external access and CPU data access
wire [13:0] muxed_addr_w = ext_accept_w ? ext_addr_w[15:2] : mem_d_addr_i[15:2];
wire [31:0] muxed_data_w = ext_accept_w ? ext_write_data_w : mem_d_data_wr_i;
wire [3:0]  muxed_wr_w   = ext_accept_w ? ext_wr_w         : mem_d_wr_i;
wire [31:0] data_r_w;



assign mem_i_inst_o = mem_i_inst;



// tcm_mem_ram
// u_ram
// (
//      .clk_i(clk_i)
//     ,.rst_i(rst_i)

//     // External access / Data access
//     ,.addr0_i(muxed_addr_w)
//     ,.data0_i(muxed_data_w)

//     ,.wr0_i(muxed_wr_w)

//     // Instruction fetch
//     ,.addr1_i(mem_i_pc_i[15:2])

//     // Outputs
//     ,.data0_o(data_r_w)
//     ,.data1_o(mem_i_inst_o)
// );

assign ext_read_data_w = data_r_w;

//-------------------------------------------------------------
// Instruction Fetch
//-------------------------------------------------------------
reg        mem_i_valid_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    mem_i_valid_q <= 1'b0;
else
    mem_i_valid_q <= mem_i_rd_i;

assign mem_i_accept_o  = 1'b1;
assign mem_i_valid_o   = mem_i_valid_q;
assign mem_i_error_o   = 1'b0;

//-------------------------------------------------------------
// Data Access / Incoming external access
//-------------------------------------------------------------
reg        mem_d_accept_q;
reg [10:0] mem_d_tag_q;
reg        mem_d_ack_q;
reg        ext_ack_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    mem_d_accept_q <= 1'b1;
// External request, do not accept internal requests in next cycle
else if (ext_rd_w || ext_wr_w != 4'b0)
    mem_d_accept_q <= 1'b0;
else
    mem_d_accept_q <= 1'b1;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    mem_d_ack_q    <= 1'b0;
    mem_d_tag_q    <= 11'b0;
end
else if ((mem_d_rd_i || mem_d_wr_i != 4'b0 || mem_d_flush_i || mem_d_invalidate_i || mem_d_writeback_i) && mem_d_accept_o)
begin
    mem_d_ack_q    <= 1'b1;
    mem_d_tag_q    <= mem_d_req_tag_i;
end
else
    mem_d_ack_q    <= 1'b0;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    ext_ack_q <= 1'b0;
// External request accepted
else if ((ext_rd_w || ext_wr_w != 4'b0) && ext_accept_w)
    ext_ack_q <= 1'b1;
else
    ext_ack_q <= 1'b0;

assign mem_d_ack_o          = mem_d_ack_q;
assign mem_d_resp_tag_o     = mem_d_tag_q;
assign mem_d_data_rd_o      = data_r_w;
assign mem_d_error_o        = 1'b0;

assign mem_d_accept_o       = mem_d_accept_q;
assign ext_accept_w         = !mem_d_accept_q;
assign ext_ack_w            = ext_ack_q;

BRAM u_ram (

  .a_addr(muxed_addr_w),          // input [13:0]
  .a_wr_data(muxed_data_w),    // input [31:0]
  .a_rd_data(data_r_w),    // output [31:0]
  .a_wr_en(|muxed_wr_w),        // input
  .a_wr_byte_en(muxed_wr_w),

  .a_clk(clk_i),            // input
  .a_rst(rst_i),            // input

  // Instruction fetch
  .b_addr(mem_i_pc_i[15:2]),          // input [13:0]
  .b_wr_data(32'h0000_0000),    // input [31:0]
  .b_rd_data(mem_i_inst),    // output [31:0]
  .b_wr_en(1'b0),        // input
  .b_wr_byte_en(4'b0),

  .b_clk(clk_i),            // input
  .b_rst(rst_i)             // input
);



endmodule
