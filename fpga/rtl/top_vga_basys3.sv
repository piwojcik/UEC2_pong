/**
 * MTM UEC2
 * Author: Piotr Wojcik, Jan Jurek
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    input  wire [2:0] sw,
    input  wire btnU,
    input  wire btnD,
    input  wire PS2Clk,
    input  wire PS2Data,
    input  wire [0:0] JC,
    output wire [0:0] JB,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1
);


/**
 * Local variables and signals
 */

wire clk_in, clk_fb, clk_ss, clk_out;
wire clk65mhz;
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

clk_wiz_0_clk_wiz clk_gen
    (
     // Clock out ports
     .clk65mhz,
     // Status and control signals
     .locked(),
    // Clock in ports
     .clk(clk)         
    );

/**
 *  Project functional top module
 */
top_pong u_top_pong(
    .clk(clk65mhz),
    .rst(btnC),
    .sw(sw),
    .btnU(btnU),
    .btnD(btnD),
    .PS2Clk(PS2Clk),
    .PS2Data(PS2Data),
    .tx(JB[0]),
    .rx(JC[0]),
    .Vsync(Vsync),
    .Hsync(Hsync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
    );

endmodule
