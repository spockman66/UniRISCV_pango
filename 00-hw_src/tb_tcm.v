`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/07 22:50:21
// Design Name: 
// Module Name: soc_tcm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_tcm;

    reg clk_i;
    reg rst_i;
    reg rst_cpu_i;
    // wire dbg_txd_i;
    // wire uart_rx_i;

    wire dbg_rxd_o;
    wire uart_tx_o;
    wire led_0_o;
    wire led_1_o;
    wire led_2_o;
    wire led_3_o;

    soc_tcm soc_tsm_inst (
        // Inputs
         .osc_in(clk_i)
        ,.rst_i(rst_i)
        ,.rst_cpu_i(rst_cpu_i)
        ,.dbg_txd_i(1'b1)
        ,.uart_rx_i(1'b1)

        // Outputs
        ,.dbg_rxd_o(dbg_rxd_o)
        ,.uart_tx_o(uart_tx_o)
        ,.led_0_o(led_0_o)
        ,.led_1_o(led_1_o)
        ,.led_2_o(led_2_o)
        ,.led_3_o(led_3_o)
    );

    wire GRS_N;

    GTP_GRS GRS_INST (
    
    .GRS_N(1'b1)
    
    );

    initial begin
        clk_i = 1'b1;
    end

    always #10 begin
        clk_i = ~clk_i;
    end

    initial begin
        rst_i = 1'b1;
        rst_cpu_i = 1'b1;
        #2000
        rst_i = 1'b0;
        #2000
        rst_cpu_i = 1'b0;

        #2000
        rst_i = 1'b1;
        rst_cpu_i = 1'b1;
    end

endmodule
