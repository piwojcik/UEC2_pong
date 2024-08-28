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
     input logic [9:0] y_player2_logic,
     input logic [9:0] y_player2_uart,
     input logic [10:0] x_ball_uart,
     input logic [9:0] y_ball_uart,
     input logic sw,

     output logic [9:0] y_player2_mux,
     output  logic [10:0] x_ball_mux,
     output  logic [9:0] y_ball_mux


 );
 
 /**
  * Local variables and signals
  */
 
  import vga_pkg::*;
  logic [9:0] y_player2_nxt;
  logic [10:0] x_ball_nxt;
  logic [9:0] y_ball_nxt;

 /**
  * Internal logic
  */
 always_ff @(posedge clk) begin 
    if (rst) begin
        x_ball_mux <= (HOR_PIXELS-BALLSIZE)/2;
        y_ball_mux <= (VER_PIXELS-BALLSIZE)/2;
        y_player2_mux <= (VER_PIXELS-PAD_HEIGHT)/2;
    end else begin
        x_ball_mux <= x_ball_nxt;
        y_ball_mux <= y_ball_nxt;
        y_player2_mux <= y_player2_nxt;
    end
 end
 
 always_comb begin
    y_player2_nxt = y_player2_mux;
    x_ball_nxt = x_ball_mux;
    y_ball_nxt = y_ball_mux;
    if(sw == 1) begin    // uzycie uart
        y_player2_nxt = y_player2_uart;
        x_ball_nxt = x_ball_uart;
        y_ball_nxt = y_ball_uart;
    end else begin  //uzycie przyciskow na basys3
        y_player2_nxt = y_player2_logic;
        x_ball_nxt = x_ball_logic;
        y_ball_nxt = y_ball_logic;
    end
end
 

 endmodule
 