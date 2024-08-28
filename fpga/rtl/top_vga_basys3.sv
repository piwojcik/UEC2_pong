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
    input wire JC1,
    output wire JC2,
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
wire locked;
wire pclk;
wire pclk_mirror;
logic [10:0] x_ball;
logic [9:0] y_ball;

logic timing_tick;
logic up, down;
logic [9:0] y_player1;
logic [9:0] y_player2;

logic [3:0] player1_score, player2_score;


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
    .y_player1,
    .y_player2,
    .timing_tick,
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .x_ball(x_ball),
    .y_ball(y_ball),
    .player1_score,
    .player2_score

);
keyboard_top u_keyboard_top (
    .clk(clk65mhz),
    .rst(btnC),
    .PS2Data,
    .PS2Clk,
    .sw(sw[0]),
    .btnU,
    .btnD,
    .up,
    .down
);

top_logic u_top_logic (
    .clk(clk65mhz),
    .rst(btnC),
    .timing_tick,
    .up,
    .down,
    .sw(sw[2:1]),
    .btnU,
    .btnD,
    .rx(JC1),
    .tx(JC2),
    .y_player1,
    .y_player2,
    .x_ball(x_ball),
    .y_ball(y_ball),
    .player1_score,
    .player2_score
);
endmodule
