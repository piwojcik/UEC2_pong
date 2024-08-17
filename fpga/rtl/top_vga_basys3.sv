/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2024  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk, Jan Jurek
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    input  wire [0:0] sw,
    input  wire btnU,
    input  wire btnD,
    inout  wire PS2Clk,
    inout  wire PS2Data,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    output wire [1:0] led, // TODO usunac ledy
    output wire       tx
);


/**
 * Local variables and signals
 */

wire clk_in, clk_fb, clk_ss, clk_out;
wire locked;
wire pclk;
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
    .C(clk65mhz),
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
     .clk65MHz(clk65mhz),
     // Status and control signals
     .locked(),
    // Clock in ports
     .clk(clk)         
    );

top_vga u_top_vga (
    .clk(clk65mhz),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync)
);
keyboard_top u_keyboard_top (
    .clk(clk100mhz),
    .rst(btnC),
    .PS2Data,
    .PS2Clk,
    .sw,
    .btnU,
    .btnD,
    .up(led[0]),
    .down(led[1]),
    .tx
);

endmodule
