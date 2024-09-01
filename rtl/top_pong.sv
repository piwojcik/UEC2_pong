/**
 * MTM UEC2
 * Author: Piotr Wojcik, Jan Jurek
 *
 * Description:
 * The project pong top module.
 */

 `timescale 1 ns / 1 ps

 module top_pong (
     input  wire clk,
     input  wire rst,
     input  wire [2:0] sw,
     input  wire btnU,
     input  wire btnD,
     input  wire PS2Clk,
     input  wire PS2Data,
     input  wire rx,
     output wire tx,
     output wire Vsync,
     output wire Hsync,
     output wire [3:0] vgaRed,
     output wire [3:0] vgaGreen,
     output wire [3:0] vgaBlue
 );

 /**
 * Local variables and signals
 */

 logic [10:0] x_ball;
 logic [9:0] y_ball;
 
 logic timing_tick;

 logic up, down;
 logic [9:0] y_player1;
 logic [9:0] y_player2;
 logic [1:0] state;
 logic [3:0] player1_score, player2_score;

 /**
 * Submodules instances
 */

 top_vga u_top_vga (
    .clk,
    .rst,
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
    .player2_score,
    .state(state)

);
keyboard_top u_keyboard_top (
    .clk,
    .rst,
    .PS2Data,
    .PS2Clk,
    .sw(sw[0]),
    .btnU,
    .btnD,
    .up,
    .down
);

top_logic u_top_logic (
    .clk,
    .rst,
    .timing_tick,
    .up,
    .down,
    .sw(sw[2:1]),
    .btnU,
    .btnD,
    .rx,
    .tx,
    .y_player1,
    .y_player2,
    .x_ball(x_ball),
    .y_ball(y_ball),
    .player1_score,
    .player2_score,
    .state(state)
);

 endmodule