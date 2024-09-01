/**
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * Ball controller
 */

`timescale 1 ns / 1 ps

module ball_controller (
    input  logic clk,
    input  logic rst,
    input  logic timing_tick,
    input  logic [9:0] y_pad_left,
    input  logic [9:0] y_pad_right,
    input  logic [1:0] state,
    output logic [9:0] y_ball,
    output logic [10:0] x_ball
);

  import vga_pkg::*;

  logic [3:0] hor_ball_velocity;  
  logic [3:0] ver_ball_velocity;  
  logic [3:0] hor_ball_velocity_nxt;  
  logic [3:0] ver_ball_velocity_nxt;  
  logic [3:0] random_velocity;  

  logic [9:0] y_ball_nxt;
  logic [10:0] x_ball_nxt;

  logic down = 1'b0;
  logic right = 1'b0;
  logic down_nxt = 1'b0, right_nxt = 1'b0;

  always_ff @(posedge clk) begin
    if (rst || (state != PLAY)) begin
      y_ball <= (VER_PIXELS - BALL_SIZE - 1) / 2;
      x_ball <= (HOR_PIXELS - BALL_SIZE - 1) / 2;
      down <= 1'b0;
      right <= 1'b0;
      hor_ball_velocity <= 3;
      ver_ball_velocity <= 3; 
    end else begin
      x_ball <= x_ball_nxt;
      y_ball <= y_ball_nxt;
      down <= down_nxt;
      right <= right_nxt;
      ver_ball_velocity <= ver_ball_velocity_nxt;
      hor_ball_velocity <= hor_ball_velocity_nxt;
    end
  end

  always_comb begin
    down_nxt = down;
    right_nxt = right;

   random_velocity = ((y_pad_left + y_pad_right) % 5 ) + 4;

    ver_ball_velocity_nxt = ver_ball_velocity;
    hor_ball_velocity_nxt = hor_ball_velocity;

    if (timing_tick) begin
      // Odbicie od górnej i dolnej ściany
      if (down) begin
        y_ball_nxt = y_ball + ver_ball_velocity;
        if (y_ball >= VER_PIXELS - BALL_SIZE - ver_ball_velocity) begin
          down_nxt = 1'b0;
          ver_ball_velocity_nxt = random_velocity;
        end
      end else begin
        y_ball_nxt = y_ball - ver_ball_velocity;
        if (y_ball <= TOP_BORDER + ver_ball_velocity ) begin
          down_nxt = 1'b1;
          ver_ball_velocity_nxt = random_velocity;
        end
      end

      // Odbicie prawo-lewo
      if (right) begin
        x_ball_nxt = x_ball + hor_ball_velocity;
        if ((x_ball + BALL_SIZE >= X_PAD_RIGHT) && (x_ball + BALL_SIZE <= X_PAD_RIGHT + PAD_WIDTH) &&
            (y_ball + BALL_SIZE >= y_pad_right) &&
            (y_ball <= y_pad_right + PAD_HEIGHT)) begin
          right_nxt = 1'b0;
          hor_ball_velocity_nxt = random_velocity;
        end
      end else begin
        x_ball_nxt = x_ball - hor_ball_velocity;
        if ((x_ball <= X_PAD_LEFT + BALL_SIZE) && (x_ball >= X_PAD_LEFT) &&
            (y_ball + BALL_SIZE >= y_pad_left) &&
            (y_ball <= y_pad_left + PAD_HEIGHT)) begin
          right_nxt = 1'b1;
          hor_ball_velocity_nxt = random_velocity;
        end
      end

      // Sprawdzenie czy piłka opuściła ekran po lewej lub prawej stronie
      if ((x_ball <= 8) || (x_ball >= HOR_PIXELS - BALL_SIZE - 8)) begin
        x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
        y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
        hor_ball_velocity_nxt = 3;
        ver_ball_velocity_nxt = 3;
      end

    end else begin
      y_ball_nxt = y_ball;
      x_ball_nxt = x_ball;
    end
  end

endmodule