`timescale 1 ns / 1 ps

module ball_controller (
     input  logic clk,
     input  logic rst,
     input  logic timing_tick,
     output logic [9:0] y_pad_left,
     output logic [9:0] y_pad_right,
     output  logic [9:0] y_ball,
     output  logic [9:0] x_ball,

     output  logic miss_left,
     output  logic miss_right
 );

 import vga_pkg::*;

 localparam X_PAD_R = 979; 
 localparam X_PAD_L = 30;
 localparam BALL_SIZE = 15;
 localparam HOR_PIXELS = 1024;
 localparam VER_PIXELS = 768;

 localparam BALL_VELOCITY_POS = 2; // w dół/prawo
 localparam BALL_VELOCITY_NEG = -2; // w górę/lewo

 logic [9:0] y_ball_nxt;
 logic [9:0] x_ball_nxt;
 logic [2:0] y_delta;
 logic [2:0] x_delta;
 logic [2:0] y_delta_nxt;
 logic [2:0] x_delta_nxt;

 always_ff @(posedge clk) begin
     if (rst) begin
         x_ball <= (HOR_PIXELS - BALL_SIZE) / 2;
         y_ball <= (VER_PIXELS - BALL_SIZE) / 2;
         x_delta <= BALL_VELOCITY_POS;
         y_delta <= BALL_VELOCITY_POS;
     end else begin
         x_ball <= x_ball_nxt;
         y_ball <= y_ball_nxt;
         x_delta <= x_delta_nxt;
         y_delta <= y_delta_nxt;
     end
 end

 always_comb begin
     if (timing_tick) begin
         miss_left = 1'b0;
         miss_right = 1'b0;
         x_delta_nxt = x_delta;
         x_delta_nxt = x_delta;
         y_pad_left=((VER_PIXELS-72)/2);
         y_pad_right=((VER_PIXELS-72)/2);

         // Odbicie od górnej i dolnej ściany
         if (y_ball <= 8) begin
             y_delta_nxt = BALL_VELOCITY_POS;
         end else if (y_ball >= (VER_PIXELS - BALL_SIZE - 8)) begin
             y_delta_nxt = BALL_VELOCITY_NEG;
         end else begin
             y_delta_nxt = y_delta;
         end

         // Odbicie od lewego pada
         if ((x_ball <= X_PAD_L + BALL_SIZE) && 
             (y_ball + BALL_SIZE >= y_pad_left) && 
             (y_ball <= y_pad_left + 145)) begin
             x_delta_nxt = BALL_VELOCITY_POS;
         end 
         // Odbicie od prawego pada
         else if ((x_ball + BALL_SIZE >= X_PAD_R) && 
             (y_ball + BALL_SIZE >= y_pad_right) && 
             (y_ball <= y_pad_right + 145)) begin
             x_delta_nxt = BALL_VELOCITY_NEG;
         end else begin
             x_delta_nxt = x_delta;
         end

         // Aktualizacja pozycji piłki
         x_ball_nxt = x_ball + x_delta;
         y_ball_nxt = y_ball + y_delta;

         // Sprawdzenie czy piłka opuściła ekran po lewej stronie
         if (x_ball <= 8) begin
             miss_left = 1'b1;
             x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
             y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
             x_delta_nxt = BALL_VELOCITY_POS;
         end
         // Sprawdzenie czy piłka opuściła ekran po prawej stronie
         if (x_ball >= HOR_PIXELS - BALL_SIZE - 8) begin
             miss_right = 1'b1;
             x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
             y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
             x_delta_nxt = BALL_VELOCITY_NEG;
         end
     end
 end

endmodule
