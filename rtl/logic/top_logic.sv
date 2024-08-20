/**
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * Top logic with FSM
 */

 `timescale 1 ns / 1 ps

 module top_logic (
     input  logic clk,
     input  logic rst,
     input  logic timing_tick,
     input  logic up,
     input  logic down,
     output  logic [10:0] x_ball,
     output  logic [9:0] y_ball,
    //  input  logic up_2,
    //  input  logic down_2,

     output logic [9:0] y_player_1
    //  output logic [9:0] y_player_2,
 );

 wire [10:0] x_ball_n;
 wire [10:0] y_ball_n;

ball_controller u_ball_controller(
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(), //y_player_2
    .y_pad_left(y_player_1),
    .y_ball(y_ball),
    .x_ball(x_ball)
);

player_pad_controller u_player_pad_controller (
    .clk,
    .rst,
    .timing_tick,
    .up_in(up),
    .down_in(down),
    .y_pad(y_player_1)
);
 endmodule