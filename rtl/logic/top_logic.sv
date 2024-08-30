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
     input  logic [2:1] sw,
     input logic rx,
     output logic tx,
     output  logic [10:0] x_ball,
     output  logic [9:0] y_ball,

     output logic [9:0] y_player1,
     output logic [9:0] y_player2,
     output logic [3:0] player1_score,
     output logic [3:0] player2_score
 );
//signals
 logic [9:0] y_player2_uart, y_player1_logic, y_player2_logic ,y_ball_uart, y_ball_logic;
 logic [10:0] x_ball_uart, x_ball_logic;

 logic [31:0] rx_buft;

ball_controller u_ball_controller(
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(y_player2), 
    .y_pad_left(y_player1),
    .y_ball(y_ball_logic),
    .x_ball(x_ball_logic)
);

player_pad_controller u_player_pad_controller (
    .clk,
    .rst,
    .timing_tick,
    .up_in(up),
    .down_in(down),
    .y_pad(y_player1_logic)
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
    .y_pad_uart(y_player2_uart),
    .sw(sw[1]),
    .btnU,
    .btnD,
    .y_pad(y_player2_logic)
);

 uart uart_unit (
    .clk,
    .reset(rst),
    .rx,
    .tbuf({1'b1, y_player1_logic, y_ball_logic, x_ball_logic}),
    .timing_tick,
    .tx,
    .rx_buf(rx_buft)
    );

 player2_mux u_player2_mux(
        .clk,
        .rst,
        .x_ball_logic,
        .y_ball_logic,
        .y_player1_logic,
        .y_player2_logic,
        .y_player2_uart,
        .x_ball_uart,
        .y_ball_uart,
        .sw(sw),
        .y_player1_mux(y_player1),
        .y_player2_mux(y_player2),
        .x_ball_mux(x_ball),
        .y_ball_mux(y_ball)  
    );

 assign y_player2_uart = rx_buft[30:21];
 assign y_ball_uart = rx_buft[20:11];
 assign x_ball_uart = rx_buft[10:0];
 endmodule