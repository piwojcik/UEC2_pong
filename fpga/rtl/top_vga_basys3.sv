/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    inout  wire PS2Clk,
    inout  wire PS2Data,
    // input  wire loopback_enable,
    // output wire [2:1] JA,
    input  wire RsRx,
    output wire RsTx,
    input  wire btnU,
    input  wire btnC, //rst?
    input  wire btnL,
    input  wire [5:0] sw,

    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    output wire [6:0] seg,
    output wire [3:0] an
);


/**
 * Local variables and signals
 */

wire clk_in, clk_fb, clk_ss, clk_out;
wire locked;
wire pclk;
wire clk100mhz;
wire pclk_mirror;

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)
logic [7:0] safe_start = 0;
// For details on synthesis attributes used above, see AMD Xilinx UG 901:
// https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes


/**
 * Signals assignments
 */

assign JA1 = pclk_mirror;


/**
 * FPGA submodules placement
 */

// Mirror pclk on a pin for use by the testbench;
// not functionally required for this design to work.

ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


/**
 *  Project functional top module
 */
clk_wiz_0_clk_wiz clk_gen
    (
     // Clock out ports
     .clk100MHz(clk100mhz),
     .clk40MHz(pclk),
     // Status and control signals
     .locked(),
    // Clock in ports
     .clk(clk)         
    );
top_vga u_top_vga (
    .clk(pclk),
    .clk100mhz(clk100mhz),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync)
);
wire [7:0] inputInstr;
wire  rx_done_tick;
top_uart u_top_uart(
    .clk(clk100mhz),
    // .loopback_enable,
    // .rx_monitor (JA1), pod UART monitor
    // .tx_monitor (JA[1]),

    .rst(btnC),
    .RsRx,
    .RsTx,
    .btnU,
    .out(inputInstr),
    .rx_done_tick,
    .seg (),
    .an ()
);
top_micro u_top_micro(
    .clk(clk100mhz),

    .rst(btnC),
    .inputInstr,
    .rx_done_tick,
    .sw,
    .btnL, 
    .btnU,
    .seg,
    .an
);


endmodule
