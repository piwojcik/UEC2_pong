/**
 * MTM UEC2
 * Author: Piotr Wojcik, Jan Jurek
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
     input  logic btnU,
     input  logic btnD,
     input  logic [1:1] sw,
     output  logic [10:0] x_ball,
     output  logic [9:0] y_ball,

     output logic [9:0] y_player1,
     output logic [9:0] y_player2,
     output logic [3:0] player1_score,
     output logic [3:0] player2_score
 );

ball_controller u_ball_controller(
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(y_player2), 
    .y_pad_left(y_player1),
    .y_ball(y_ball),
    .x_ball(x_ball)
);

player_pad_controller u_player_pad_controller (
    .clk,
    .rst,
    .timing_tick,
    .up_in(up),
    .down_in(down),
    .y_pad(y_player1)
);
score_controller  u_score_controller(
    .clk,
    .rst,
    .timing_tick,
    .x_ball,
    .player1_score,
    .player2_score
  );

  player2_pad_controller u_player2_pad_controller (
    .clk,
    .rst,
    .timing_tick,
    .y_pad_uart(),
    .sw,
    .btnU,
    .btnD,
    .y_pad(y_player2)
);
 endmodule