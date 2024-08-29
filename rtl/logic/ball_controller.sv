`timescale 1 ns / 1 ps

module ball_controller (
    input  logic clk,
    input  logic rst,
    input  logic timing_tick,
    input  logic [9:0] y_pad_left,
    input  logic [1:0] state,
    input  logic [9:0] y_pad_right,
    output  logic [9:0] y_ball,
    output  logic [10:0] x_ball
  );

  import vga_pkg::*;

  localparam X_PAD_R = 979;
  localparam X_PAD_L = 30;
  localparam BALL_SIZE = 15;
  localparam HOR_BALL_VELOCITY = 2; // w górę/lewo
  localparam VER_BALL_VELOCITY = 2; // w górę/lewo

  logic [10:0] y_ball_nxt;
  logic [10:0] x_ball_nxt;
  logic [2:0] hor_ball_velocity;
  logic [2:0] ver_ball_velocity;
  logic [2:0] hor_ball_velocity_nxt;
  logic [2:0] ver_ball_velocity_nxt;


  logic down = 1'b0;
  logic right = 1'b0;
  logic down_nxt = 1'b0, right_nxt = 1'b0;

  always_ff @(posedge clk)begin
    if(rst || (state != play))begin
      y_ball <= (VER_PIXELS - BALL_SIZE-1) / 2;
      x_ball <= (HOR_PIXELS - BALL_SIZE-1) / 2;
      down <= '0;
      right <= '0;
      hor_ball_velocity <= 4;
      ver_ball_velocity <= 4;
    end 
    else begin
      x_ball <= x_ball_nxt;
      y_ball <= y_ball_nxt;
      down <= down_nxt;
      right <= right_nxt;
      hor_ball_velocity <= hor_ball_velocity_nxt;
      ver_ball_velocity <= ver_ball_velocity_nxt;
    end
  end

  always_comb begin

 // y_pad_right=((VER_PIXELS-72)/2);
  down_nxt = down;
  right_nxt = right;
  if(timing_tick)begin
// Odbicie od gornej i dolnej sciany
    if(down)begin
      y_ball_nxt = y_ball + ver_ball_velocity;
      if(y_ball >= VER_PIXELS - BALL_SIZE)begin
        down_nxt = 1'b0;
      end
    end else begin
        y_ball_nxt = y_ball - ver_ball_velocity;
        if(y_ball <= 10) begin
          down_nxt = 1'b1;
        end
    end
// Odbicie prawo lewo
    if(right)begin
      x_ball_nxt = x_ball + hor_ball_velocity;
      if((x_ball + BALL_SIZE >= X_PAD_R) &&
          (y_ball + BALL_SIZE >= y_pad_right) &&
          (y_ball <= y_pad_right + 145))begin
        right_nxt = 1'b0;
      end
    end
    else begin
      x_ball_nxt = x_ball - hor_ball_velocity;
      if ((x_ball <= X_PAD_L + BALL_SIZE) &&
          (y_ball + BALL_SIZE >= y_pad_left) &&
          (y_ball <= y_pad_left + 145)) begin
        right_nxt = 1'b1;
      end
    end

    // Sprawdzenie czy piłka opuściła ekran po lewej stronie
    if (x_ball <= 8) begin
      x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
      y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
    end
    // Sprawdzenie czy piłka opuściła ekran po prawej stronie
    if (x_ball >= HOR_PIXELS - BALL_SIZE - 8) begin
      x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
      y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
    end
    end else begin
      y_ball_nxt = y_ball;
      x_ball_nxt = x_ball;
      hor_ball_velocity_nxt = hor_ball_velocity;
      ver_ball_velocity_nxt = ver_ball_velocity; 
    end
  end

endmodule
