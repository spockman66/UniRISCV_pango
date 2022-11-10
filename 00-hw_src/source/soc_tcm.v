module soc_tcm(
    // Inputs
     input           osc_in
    ,input           rst_i
    ,input           rst_cpu_i
    ,input           dbg_txd_i
    ,input           uart_rx_i

    // Outputs
    ,output          dbg_rxd_o
    ,output          uart_tx_o  
    ,output          led_0_o
    ,output          led_1_o
    ,output          led_2_o
    ,output          led_3_o
);

parameter CLK_FREQ         = 50000000       ;
parameter BAUDRATE         = 1000000        ;
parameter UART_SPEED       = 1000000        ;
parameter C_SCK_RATIO      = 5          ;

wire           rst_i_r;/* synthesis syn_keep=1 */
wire           interrupt_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  enable_w;/* synthesis syn_keep=1 */
wire           rst_cpu_w;/* synthesis syn_keep=1 */

wire           axi_cfg_wvalid_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_cfg_rdata_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_cfg_wstrb_w;/* synthesis syn_keep=1 */
wire           axi_cfg_bready_w;/* synthesis syn_keep=1 */
wire           axi_cfg_awready_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_cfg_wdata_w;/* synthesis syn_keep=1 */
wire           axi_cfg_wready_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_cfg_araddr_w;/* synthesis syn_keep=1 */
wire           axi_cfg_rvalid_w;/* synthesis syn_keep=1 */
wire           axi_cfg_bvalid_w;/* synthesis syn_keep=1 */
wire           axi_cfg_arvalid_w;/* synthesis syn_keep=1 */
wire           axi_cfg_rready_w;/* synthesis syn_keep=1 */
wire           axi_cfg_awvalid_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_cfg_awaddr_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_cfg_rresp_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_cfg_bresp_w;/* synthesis syn_keep=1 */
wire           axi_cfg_arready_w;/* synthesis syn_keep=1 */

wire  [ 31:0]  axi_t_araddr_w;/* synthesis syn_keep=1 */
wire           axi_t_wlast_w;/* synthesis syn_keep=1 */
wire           axi_t_arvalid_w;/* synthesis syn_keep=1 */
wire           axi_t_arready_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_t_rid_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_t_awburst_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_t_wstrb_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_t_wdata_w;/* synthesis syn_keep=1 */
wire           axi_t_rlast_w;/* synthesis syn_keep=1 */
wire           axi_t_rready_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_t_awaddr_w;/* synthesis syn_keep=1 */
wire           axi_t_rvalid_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_t_awid_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_t_arburst_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_t_bresp_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_t_arid_w;/* synthesis syn_keep=1 */
wire           axi_t_awready_w;/* synthesis syn_keep=1 */
wire  [  7:0]  axi_t_arlen_w;/* synthesis syn_keep=1 */
wire           axi_t_wvalid_w;/* synthesis syn_keep=1 */
wire  [  1:0]  axi_t_rresp_w;/* synthesis syn_keep=1 */
wire  [  3:0]  axi_t_bid_w;/* synthesis syn_keep=1 */
wire  [  7:0]  axi_t_awlen_w;/* synthesis syn_keep=1 */
wire           axi_t_bready_w;/* synthesis syn_keep=1 */
wire           axi_t_bvalid_w;/* synthesis syn_keep=1 */
wire           axi_t_awvalid_w;/* synthesis syn_keep=1 */
wire  [ 31:0]  axi_t_rdata_w;/* synthesis syn_keep=1 */
wire           axi_t_wready_w;                              /* synthesis syn_keep=1 */

// wire pll_lock;
// reg pll_lock_r1, pll_lock_r2;
// reg rst_cpu_reg;

// assign rst_i_r = ~pll_lock_r4;

// assign rst_i_r = ~pll_lock_r1;
// assign rst_cpu_w = rst_cpu_reg;

assign clk_i_1 = osc_in;

assign rst_i_r = ~rst_i;
assign rst_cpu_w = ~rst_cpu_i;


assign led_0_o = rst_i;
assign led_1_o = rst_cpu_i;
assign led_2_o = uart_rx_i;
assign led_3_o = uart_tx_o;


// pll_v1 u_clk_1 (
//   .clkin1(osc_in),        // input
//   .pll_lock(pll_lock),    // output
//   .clkout0(clk_i_1)       // output
// );


// pll_v1 u_clk_2 (
//   .clkin1(osc_in),        // input
//   .pll_lock(),    // output
//   .clkout0(clk_i_2)       // output
// );

// pll_v1 u_clk_3 (
//   .clkin1(osc_in),        // input
//   .pll_lock(),    // output
//   .clkout0(clk_i_3)       // output
// );

// always @(posedge clk_i_1 or negedge pll_lock) begin
//     if(pll_lock) begin
//         pll_lock_r1 <= 1'b1;
//     end
//     else begin
//         pll_lock_r1 <= 1'b0;
//     end
// end

// reg [5:0] cnt = 6'd0;
// always @(posedge clk_i_1) begin
//     if(cnt == 'd30)
//         cnt <= 'd0;
//     else if(pll_lock_r1)
//         cnt <= cnt + 1'b1;
// end

// always @(posedge clk_i_1 or negedge pll_lock_r1) begin
//     if(~pll_lock_r1)
//         rst_cpu_reg <= 1'b1;
//     else if (rst_cpu_reg & cnt == 'd30)
//         rst_cpu_reg <= 1'b0;
// end


core_soc
#(
     .CLK_FREQ(CLK_FREQ)
    ,.BAUDRATE(BAUDRATE)
    ,.C_SCK_RATIO(C_SCK_RATIO)
)
u_soc
(
    // Inputs
     .clk_i(clk_i_1)
    ,.rst_i(rst_i_r)
    ,.inport_awvalid_i(axi_cfg_awvalid_w)
    ,.inport_awaddr_i(axi_cfg_awaddr_w)
    ,.inport_wvalid_i(axi_cfg_wvalid_w)
    ,.inport_wdata_i(axi_cfg_wdata_w)
    ,.inport_wstrb_i(axi_cfg_wstrb_w)
    ,.inport_bready_i(axi_cfg_bready_w)
    ,.inport_arvalid_i(axi_cfg_arvalid_w)
    ,.inport_araddr_i(axi_cfg_araddr_w)
    ,.inport_rready_i(axi_cfg_rready_w)
    
    ,.spi_miso_i(1'b0)
    ,.uart_rx_i(uart_rx_i)
    ,.gpio_input_i(32'b0)
    ,.ext1_cfg_awready_i(1'b0)
    ,.ext1_cfg_wready_i(1'b0)
    ,.ext1_cfg_bvalid_i(1'b0)
    ,.ext1_cfg_bresp_i(2'b0)
    ,.ext1_cfg_arready_i(1'b0)
    ,.ext1_cfg_rvalid_i(1'b0)
    ,.ext1_cfg_rdata_i(32'b0)
    ,.ext1_cfg_rresp_i(2'b0)
    ,.ext1_irq_i(1'b0)

    ,.ext2_cfg_awready_i(1'b0)
    ,.ext2_cfg_wready_i(1'b0)
    ,.ext2_cfg_bvalid_i(1'b0)
    ,.ext2_cfg_bresp_i(2'b0)
    ,.ext2_cfg_arready_i(1'b0)
    ,.ext2_cfg_rvalid_i(1'b0)
    ,.ext2_cfg_rdata_i(32'b0)
    ,.ext2_cfg_rresp_i(2'b0)
    ,.ext2_irq_i(1'b0)

    ,.ext3_cfg_awready_i(1'b0)
    ,.ext3_cfg_wready_i(1'b0)
    ,.ext3_cfg_bvalid_i(1'b0)
    ,.ext3_cfg_bresp_i(2'b0)
    ,.ext3_cfg_arready_i(1'b0)
    ,.ext3_cfg_rvalid_i(1'b0)
    ,.ext3_cfg_rdata_i(32'b0)
    ,.ext3_cfg_rresp_i(2'b0)
    ,.ext3_irq_i(1'b0)

    // Outputs
    ,.intr_o(interrupt_w)
    ,.inport_awready_o(axi_cfg_awready_w)
    ,.inport_wready_o(axi_cfg_wready_w)
    ,.inport_bvalid_o(axi_cfg_bvalid_w)
    ,.inport_bresp_o(axi_cfg_bresp_w)
    ,.inport_arready_o(axi_cfg_arready_w)
    ,.inport_rvalid_o(axi_cfg_rvalid_w)
    ,.inport_rdata_o(axi_cfg_rdata_w)
    ,.inport_rresp_o(axi_cfg_rresp_w)

    ,.spi_clk_o()
    ,.spi_mosi_o()
    ,.spi_cs_o()
    ,.uart_tx_o(uart_tx_o)
    ,.gpio_output_o()
    ,.gpio_output_enable_o()
    ,.ext1_cfg_awvalid_o()
    ,.ext1_cfg_awaddr_o()
    ,.ext1_cfg_wvalid_o()
    ,.ext1_cfg_wdata_o()
    ,.ext1_cfg_wstrb_o()
    ,.ext1_cfg_bready_o()
    ,.ext1_cfg_arvalid_o()
    ,.ext1_cfg_araddr_o()
    ,.ext1_cfg_rready_o()

    ,.ext2_cfg_awvalid_o()
    ,.ext2_cfg_awaddr_o()
    ,.ext2_cfg_wvalid_o()
    ,.ext2_cfg_wdata_o()
    ,.ext2_cfg_wstrb_o()
    ,.ext2_cfg_bready_o()
    ,.ext2_cfg_arvalid_o()
    ,.ext2_cfg_araddr_o()
    ,.ext2_cfg_rready_o()

    ,.ext3_cfg_awvalid_o()
    ,.ext3_cfg_awaddr_o()
    ,.ext3_cfg_wvalid_o()
    ,.ext3_cfg_wdata_o()
    ,.ext3_cfg_wstrb_o()
    ,.ext3_cfg_bready_o()
    ,.ext3_cfg_arvalid_o()
    ,.ext3_cfg_araddr_o()
    ,.ext3_cfg_rready_o()
);

dbg_bridge
#(
     .CLK_FREQ(CLK_FREQ)
    ,.UART_SPEED(UART_SPEED)
)
u_dbg
(
    // Inputs
     .clk_i(clk_i_1)
    ,.rst_i(rst_i_r)
    ,.uart_rxd_i(1'b1)
    ,.mem_awready_i(axi_t_awready_w)
    ,.mem_wready_i(axi_t_wready_w)
    ,.mem_bvalid_i(axi_t_bvalid_w)
    ,.mem_bresp_i(axi_t_bresp_w)
    ,.mem_bid_i(axi_t_bid_w)
    ,.mem_arready_i(axi_t_arready_w)
    ,.mem_rvalid_i(axi_t_rvalid_w)
    ,.mem_rdata_i(axi_t_rdata_w)
    ,.mem_rresp_i(axi_t_rresp_w)
    ,.mem_rid_i(axi_t_rid_w)
    ,.mem_rlast_i(axi_t_rlast_w)

    // Outputs
    ,.uart_txd_o(dbg_rxd_o)
    ,.mem_awvalid_o(axi_t_awvalid_w)
    ,.mem_awaddr_o(axi_t_awaddr_w)
    ,.mem_awid_o(axi_t_awid_w)
    ,.mem_awlen_o(axi_t_awlen_w)
    ,.mem_awburst_o(axi_t_awburst_w)
    ,.mem_wvalid_o(axi_t_wvalid_w)
    ,.mem_wdata_o(axi_t_wdata_w)
    ,.mem_wstrb_o(axi_t_wstrb_w)
    ,.mem_wlast_o(axi_t_wlast_w)
    ,.mem_bready_o(axi_t_bready_w)
    ,.mem_arvalid_o(axi_t_arvalid_w)
    ,.mem_araddr_o(axi_t_araddr_w)
    ,.mem_arid_o(axi_t_arid_w)
    ,.mem_arlen_o(axi_t_arlen_w)
    ,.mem_arburst_o(axi_t_arburst_w)
    ,.mem_rready_o(axi_t_rready_w)
    ,.gpio_outputs_o(enable_w)
);

// assign axi_t_awvalid_w  = 1'b0;
// assign axi_t_awaddr_w   = 32'b0;
// assign axi_t_awid_w     = 4'b0;
// assign axi_t_awlen_w    = 8'b0;
// assign axi_t_awburst_w  = 2'b0;
// assign axi_t_wvalid_w   = 1'b0;
// assign axi_t_wdata_w    = 32'b0;
// assign axi_t_wstrb_w    = 4'b0;
// assign axi_t_wlast_w    = 1'b0;
// assign axi_t_bready_w   = 1'b0;
// assign axi_t_arvalid_w  = 1'b0;
// assign axi_t_araddr_w   = 32'b0;
// assign axi_t_arid_w     = 4'b0;
// assign axi_t_arlen_w    = 8'b0;
// assign axi_t_arburst_w  = 2'b0;
// assign axi_t_rready_w   = 1'b0;

riscv_tcm_top
#(
    .BOOT_VECTOR(32'h00000000),
    .CORE_ID(0),
    .TCM_MEM_BASE(32'h00000000)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff) // h8fffffff
) riscv_tcm_top (
    .clk_i(clk_i_1),                 // input         
    .rst_i(rst_i_r),                 // input         
    .rst_cpu_i(rst_cpu_w),             // input         
    .axi_i_awready_i(axi_cfg_awready_w),       // input         
    .axi_i_wready_i(axi_cfg_wready_w),        // input         
    .axi_i_bvalid_i(axi_cfg_bvalid_w),        // input         
    .axi_i_bresp_i(axi_cfg_bresp_w),         // input  [  1:0]
    .axi_i_arready_i(axi_cfg_arready_w),       // input         
    .axi_i_rvalid_i(axi_cfg_rvalid_w),        // input         
    .axi_i_rdata_i(axi_cfg_rdata_w),         // input  [ 31:0]
    .axi_i_rresp_i(axi_cfg_rresp_w),         // input  [  1:0]
    .axi_t_awvalid_i(axi_t_awvalid_w),       // input         
    .axi_t_awaddr_i(axi_t_awaddr_w),        // input  [ 31:0]
    .axi_t_awid_i(axi_t_awid_w),          // input  [  3:0]
    .axi_t_awlen_i(axi_t_awlen_w),         // input  [  7:0]
    .axi_t_awburst_i(axi_t_awburst_w),       // input  [  1:0]
    .axi_t_wvalid_i(axi_t_wvalid_w),        // input         
    .axi_t_wdata_i(axi_t_wdata_w),         // input  [ 31:0]
    .axi_t_wstrb_i(axi_t_wstrb_w),         // input  [  3:0]
    .axi_t_wlast_i(axi_t_wlast_w),         // input         
    .axi_t_bready_i(axi_t_bready_w),        // input         
    .axi_t_arvalid_i(axi_t_arvalid_w),       // input         
    .axi_t_araddr_i(axi_t_araddr_w),        // input  [ 31:0]
    .axi_t_arid_i(axi_t_arid_w),          // input  [  3:0]
    .axi_t_arlen_i(axi_t_arlen_w),         // input  [  7:0]
    .axi_t_arburst_i(axi_t_arburst_w),       // input  [  1:0]
    .axi_t_rready_i(axi_t_rready_w),        // input         
    .intr_i(interrupt_w),                // input

    .axi_i_awvalid_o(axi_cfg_awvalid_w),       // output        
    .axi_i_awaddr_o(axi_cfg_awaddr_w),        // output [ 31:0]
    .axi_i_wvalid_o(axi_cfg_wvalid_w),        // output        
    .axi_i_wdata_o(axi_cfg_wdata_w),         // output [ 31:0]
    .axi_i_wstrb_o(axi_cfg_wstrb_w),         // output [  3:0]
    .axi_i_bready_o(axi_cfg_bready_w),        // output        
    .axi_i_arvalid_o(axi_cfg_arvalid_w),       // output        
    .axi_i_araddr_o(axi_cfg_araddr_w),        // output [ 31:0]
    .axi_i_rready_o(axi_cfg_rready_w),        // output        
    .axi_t_awready_o(axi_t_awready_w),       // output        
    .axi_t_wready_o(axi_t_wready_w),        // output        
    .axi_t_bvalid_o(axi_t_bvalid_w),        // output        
    .axi_t_bresp_o(axi_t_bresp_w),         // output [  1:0]
    .axi_t_bid_o(axi_t_bid_w),           // output [  3:0]
    .axi_t_arready_o(axi_t_arready_w),       // output        
    .axi_t_rvalid_o(axi_t_rvalid_w),        // output        
    .axi_t_rdata_o(axi_t_rdata_w),         // output [ 31:0]
    .axi_t_rresp_o(axi_t_rresp_w),         // output [  1:0]
    .axi_t_rid_o(axi_t_rid_w),           // output [  3:0]
    .axi_t_rlast_o(axi_t_rlast_w)          // output        
);

// `define DBG_BIT_RELEASE_RESET 0
// `define DBG_BIT_ENABLE_DEBUG  1
// `define DBG_BIT_CAPTURE_HI    2
// `define DBG_BIT_CAPTURE_LO    3
// `define DBG_BIT_DEBUG_WRITE   4
// `define DBG_BIT_BOOTADDR      5

// reg [31:0] reset_vector_q;

// always @ (posedge clk_i )
// if (rst_i_r)
//     reset_vector_q <= 32'h80000000;
// else if (enable_w[`DBG_BIT_CAPTURE_HI] && enable_w[`DBG_BIT_BOOTADDR])
//     reset_vector_q <= {enable_w[31:16], reset_vector_q[15:0]};
// else if (enable_w[`DBG_BIT_CAPTURE_LO] && enable_w[`DBG_BIT_BOOTADDR])
//     reset_vector_q <= {reset_vector_q[31:16], enable_w[31:16]};

// assign reset_vector_w  = reset_vector_q;


// // DDR to AXI4
// HMIC_H_0 mem_controller (
//   .pll_refclk_in(pll_refclk_in),        // input
//   .top_rst_n(top_rst_n),                // input
//   .ddrc_rst(ddrc_rst),                  // input
//   .csysreq_ddrc(csysreq_ddrc),          // input
//   .csysack_ddrc(csysack_ddrc),          // output
//   .cactive_ddrc(cactive_ddrc),          // output
//   .pll_lock(pll_lock),                  // output
//   .pll_aclk_0(pll_aclk_0),              // output
//   .pll_aclk_1(pll_aclk_1),              // output
//   .pll_aclk_2(pll_aclk_2),              // output
//   .ddrphy_rst_done(ddrphy_rst_done),    // output
//   .ddrc_init_done(ddrc_init_done),      // output
//   .pad_loop_in(pad_loop_in),            // input
//   .pad_loop_in_h(pad_loop_in_h),        // input
//   .pad_rstn_ch0(pad_rstn_ch0),          // output
//   .pad_ddr_clk_w(pad_ddr_clk_w),        // output
//   .pad_ddr_clkn_w(pad_ddr_clkn_w),      // output
//   .pad_csn_ch0(pad_csn_ch0),            // output
//   .pad_addr_ch0(pad_addr_ch0),          // output [15:0]
//   .pad_dq_ch0(pad_dq_ch0),              // inout [15:0]
//   .pad_dqs_ch0(pad_dqs_ch0),            // inout [1:0]
//   .pad_dqsn_ch0(pad_dqsn_ch0),          // inout [1:0]
//   .pad_dm_rdqs_ch0(pad_dm_rdqs_ch0),    // output [1:0]
//   .pad_cke_ch0(pad_cke_ch0),            // output
//   .pad_odt_ch0(pad_odt_ch0),            // output
//   .pad_rasn_ch0(pad_rasn_ch0),          // output
//   .pad_casn_ch0(pad_casn_ch0),          // output
//   .pad_wen_ch0(pad_wen_ch0),            // output
//   .pad_ba_ch0(pad_ba_ch0),              // output [2:0]
//   .pad_loop_out(pad_loop_out),          // output
//   .pad_loop_out_h(pad_loop_out_h),      // output
//   .areset_0(areset_0),                  // input
//   .aclk_0(aclk_0),                      // input
//   .awid_0(awid_0),                      // input [7:0]
//   .awaddr_0(awaddr_0),                  // input [31:0]
//   .awlen_0(awlen_0),                    // input [7:0]
//   .awsize_0(awsize_0),                  // input [2:0]
//   .awburst_0(awburst_0),                // input [1:0]
//   .awlock_0(awlock_0),                  // input
//   .awvalid_0(awvalid_0),                // input
//   .awready_0(awready_0),                // output
//   .awurgent_0(awurgent_0),              // input
//   .awpoison_0(awpoison_0),              // input
//   .wdata_0(wdata_0),                    // input [127:0]
//   .wstrb_0(wstrb_0),                    // input [15:0]
//   .wlast_0(wlast_0),                    // input
//   .wvalid_0(wvalid_0),                  // input
//   .wready_0(wready_0),                  // output
//   .bid_0(bid_0),                        // output [7:0]
//   .bresp_0(bresp_0),                    // output [1:0]
//   .bvalid_0(bvalid_0),                  // output
//   .bready_0(bready_0),                  // input
//   .arid_0(arid_0),                      // input [7:0]
//   .araddr_0(araddr_0),                  // input [31:0]
//   .arlen_0(arlen_0),                    // input [7:0]
//   .arsize_0(arsize_0),                  // input [2:0]
//   .arburst_0(arburst_0),                // input [1:0]
//   .arlock_0(arlock_0),                  // input
//   .arvalid_0(arvalid_0),                // input
//   .arready_0(arready_0),                // output
//   .arpoison_0(arpoison_0),              // input
//   .rid_0(rid_0),                        // output [7:0]
//   .rdata_0(rdata_0),                    // output [127:0]
//   .rresp_0(rresp_0),                    // output [1:0]
//   .rlast_0(rlast_0),                    // output
//   .rvalid_0(rvalid_0),                  // output
//   .rready_0(rready_0),                  // input
//   .arurgent_0(arurgent_0),              // input
//   .csysreq_0(csysreq_0),                // input
//   .csysack_0(csysack_0),                // output
//   .cactive_0(cactive_0)                 // output
// );
endmodule