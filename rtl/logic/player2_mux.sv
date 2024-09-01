 /**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * 
 */
`timescale 1 ns / 1 ps

 module player2_mux(
     input  logic clk,
     input  logic rst,
     input  logic [10:0] x_ball_logic,
     input  logic [9:0] y_ball_logic,
     input logic [9:0] y_player1_logic,
     input logic [9:0] y_player2_logic,
     input logic [9:0] y_player2_uart,
     input logic [10:0] x_ball_uart,
     input logic [9:0] y_ball_uart,
     input logic [2:1] sw,

     output logic [9:0] y_player1_mux,
     output logic [9:0] y_player2_mux,
     output  logic [10:0] x_ball_mux,
     output  logic [9:0] y_ball_mux


 );
 
 /**
  * Local variables and signals
  */
 
  import vga_pkg::*;
  logic [9:0] y_player2_nxt, y_player1_nxt;
  logic [10:0] x_ball_nxt;
  logic [9:0] y_ball_nxt;

 /**
  * Internal logic
  */
 always_ff @(posedge clk) begin 
    if (rst) begin
        x_ball_mux <= (HOR_PIXELS-BALL_SIZE)/2;
        y_ball_mux <= (VER_PIXELS-BALL_SIZE)/2;
        y_player2_mux <= (VER_PIXELS-PAD_HEIGHT)/2;
        y_player1_mux <= (VER_PIXELS-PAD_HEIGHT)/2;
    end else begin
        x_ball_mux <= x_ball_nxt;
        y_ball_mux <= y_ball_nxt;
        y_player2_mux <= y_player2_nxt;
        y_player1_mux <= y_player1_nxt;
    end
 end
 
 always_comb begin
    y_player1_nxt = y_player1_mux;
    y_player2_nxt = y_player2_mux;
    x_ball_nxt = x_ball_mux;
    y_ball_nxt = y_ball_mux;
    if(sw[2]) begin    //dla gracza2 po uart
        y_player1_nxt = y_player2_uart;
        y_player2_nxt = y_player1_logic;
        x_ball_nxt = x_ball_uart;
        y_ball_nxt = y_ball_uart;
    end else if(sw[1]) begin  //tryb jednej plytki
        y_player1_nxt = y_player1_logic;
        y_player2_nxt = y_player2_logic;
        x_ball_nxt = x_ball_logic;
        y_ball_nxt = y_ball_logic;
    end else begin //dla gracza1 przez uart
        y_player1_nxt = y_player1_logic;
        y_player2_nxt = y_player2_uart;
        x_ball_nxt = x_ball_logic;
        y_ball_nxt = y_ball_logic;
    end
end
 

 endmodule
 