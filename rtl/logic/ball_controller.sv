`timescale 1 ns / 1 ps

module ball_controller (
     input  logic clk,
     input  logic rst,
     input  logic timing_tick,
     input logic [9:0] y_pad_left,
     output logic [9:0] y_pad_right,
     output  logic [10:0] y_ball,
     output  logic [10:0] x_ball

    //  output  logic miss_left,
    //  output  logic miss_right
 );

 import vga_pkg::*;

 localparam X_PAD_R = 979; 
 localparam X_PAD_L = 30;
 localparam BALL_SIZE = 15;

//  localparam BALL_VELOCITY_POS = 2; // w dół/prawo
//  localparam BALL_VELOCITY_NEG = -2; // w górę/lewo
 localparam BALL_VELOCITY = 2; // w górę/lewo



 logic [10:0] y_ball_nxt;
 logic [10:0] x_ball_nxt;

//  logic signed [2:0] y_delta;
//  logic signed [2:0] x_delta;
//  logic signed [2:0] y_delta_nxt;
//  logic signed [2:0] x_delta_nxt;
 logic down = 1'b0;
 logic right = 1'b0;


 always_ff @(posedge clk)begin
    if(rst)begin
        y_ball <= (VER_PIXELS - BALL_SIZE-1) / 2;
        x_ball <= (HOR_PIXELS - BALL_SIZE-1) / 2;
        // y_delta <= BALL_VELOCITY_NEG;
        // x_delta <= BALL_VELOCITY_NEG;
    end else begin
        x_ball <= x_ball_nxt;
        y_ball <= y_ball_nxt;
        // y_delta <= y_delta_nxt;
        // x_delta <= x_delta_nxt;
    end
 end

 always_comb begin
 // y_pad_left=((VER_PIXELS-72)/2);
 y_pad_right=((VER_PIXELS-72)/2);
    if(timing_tick)begin


 // Odbicie od górnej i dolnej ściany
      if(down)begin
        y_ball_nxt = y_ball + BALL_VELOCITY;
        if(y_ball >= VER_PIXELS - BALL_SIZE)begin
            down = 1'b0;
        end
    end else begin
        y_ball_nxt = y_ball - BALL_VELOCITY;
        if(y_ball <= 5) begin
            down = 1'b1;
      end
    end
// Odbicie prawo lewo
    if(right)begin
        x_ball_nxt = x_ball + BALL_VELOCITY;
        if((x_ball + BALL_SIZE >= X_PAD_R) && 
              (y_ball + BALL_SIZE >= y_pad_right) && 
              (y_ball <= y_pad_right + 145))begin
            right = 1'b0;
        end
      end
      else begin
        x_ball_nxt = x_ball - BALL_VELOCITY;
        if ((x_ball <= X_PAD_L + BALL_SIZE) && 
        (y_ball + BALL_SIZE >= y_pad_left) && 
        (y_ball <= y_pad_left + 145)) begin
            right = 1'b1;
      end
    end

         // Sprawdzenie czy piłka opuściła ekran po lewej stronie
         if (x_ball <= 8) begin
            //  miss_left = 1'b1;
             x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
             y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
            //  x_ball_nxt = x_ball + BALL_VELOCITY;
         end
         // Sprawdzenie czy piłka opuściła ekran po prawej stronie
         if (x_ball >= HOR_PIXELS - BALL_SIZE - 8) begin
            //  miss_right = 1'b1;
             x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
             y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
            //  x_ball_nxt = x_ball - BALL_VELOCITY;
         end
    end else begin
    y_ball_nxt = y_ball;
    x_ball_nxt = x_ball;  
    // x_delta_nxt = x_delta;
    // y_delta_nxt = y_delta;  

    end
 end

endmodule
