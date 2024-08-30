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

  localparam X_PAD_R = 979;
  localparam X_PAD_L = 30;
  localparam BALL_SIZE = 15;

  logic [2:0] hor_ball_velocity;  // pozioma prędkość piłki
  logic [2:0] ver_ball_velocity;  // pionowa prędkość piłki
  logic [2:0] hor_ball_velocity_nxt;  // pozioma prędkość piłki
  logic [2:0] ver_ball_velocity_nxt;  // pionowa prędkość piłki
  logic [2:0] random_velocity;    // losowa prędkość piłki

  logic [9:0] y_ball_nxt;
  logic [10:0] x_ball_nxt;

  logic down = 1'b0;
  logic right = 1'b0;
  logic down_nxt = 1'b0, right_nxt = 1'b0;

  // Generator licznika pseudo-losowego
  logic [1:0] rand_counter; 

  always_ff @(posedge clk) begin
    if (rst || (state != play)) begin
      y_ball <= (VER_PIXELS - BALL_SIZE - 1) / 2;
      x_ball <= (HOR_PIXELS - BALL_SIZE - 1) / 2;
      down <= 1'b0;
      right <= 1'b0;
      hor_ball_velocity <= 3;  // Inicjalna prędkość pozioma
      ver_ball_velocity <= 3;  // Inicjalna prędkość pionowa
      rand_counter <= 4'b0;
    end else begin
      x_ball <= x_ball_nxt;
      y_ball <= y_ball_nxt;
      down <= down_nxt;
      right <= right_nxt;
      ver_ball_velocity <= ver_ball_velocity_nxt;
      ver_ball_velocity <= ver_ball_velocity_nxt;
      // hor_ball_velocity <= random_velocity; // Losowanie nowej prędkości przy odbiciu
      // ver_ball_velocity <= random_velocity; // Losowanie nowej prędkości przy odbiciu
      rand_counter <= rand_counter + 1;  // Prosty licznik do generowania losowości
    end
  end

  logic gen;

  always_comb begin
    down_nxt = down;
    right_nxt = right;

    case (rand_counter[1:0])  // Wybór losowej wartości w zakresie 3 do 6
      2'b00: random_velocity = 3;
      2'b01: random_velocity = 4;
      2'b10: random_velocity = 5;
      2'b11: random_velocity = 6;
      default: random_velocity = 3;  // Domyślna wartość
    endcase

    // hor_ball_velocity = random_velocity; // Losowanie nowej prędkości przy odbiciu
    // ver_ball_velocity = random_velocity; // Losowanie nowej prędkości przy odbiciu
    ver_ball_velocity_nxt = ver_ball_velocity;
    
    if (timing_tick) begin
      // Odbicie od górnej i dolnej ściany
      if (down) begin
        y_ball_nxt = y_ball + ver_ball_velocity;
        if (y_ball >= VER_PIXELS - BALL_SIZE) begin
          down_nxt = 1'b0;
          ver_ball_velocity_nxt = random_velocity;
        end
      end else begin
        y_ball_nxt = y_ball - ver_ball_velocity;
        if (y_ball <= 10) begin
          down_nxt = 1'b1;
          ver_ball_velocity_nxt = random_velocity;
        end
      end

      // Odbicie prawo-lewo
      if (right) begin
        x_ball_nxt = x_ball + hor_ball_velocity;
        if ((x_ball + BALL_SIZE >= X_PAD_R) &&
            (y_ball + BALL_SIZE >= y_pad_right) &&
            (y_ball <= y_pad_right + 145)) begin
          right_nxt = 1'b0;
          hor_ball_velocity_nxt = random_velocity;
        end
      end else begin
        x_ball_nxt = x_ball - hor_ball_velocity;
        if ((x_ball <= X_PAD_L + BALL_SIZE) &&
            (y_ball + BALL_SIZE >= y_pad_left) &&
            (y_ball <= y_pad_left + 145)) begin
          right_nxt = 1'b1;
          hor_ball_velocity_nxt = random_velocity;
        end
      end

      // Sprawdzenie czy piłka opuściła ekran po lewej stronie
      if (x_ball <= 8) begin
        x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
        y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
        hor_ball_velocity_nxt = random_velocity;
        ver_ball_velocity_nxt = random_velocity;
      end

      // Sprawdzenie czy piłka opuściła ekran po prawej stronie
      if (x_ball >= HOR_PIXELS - BALL_SIZE - 8) begin
        x_ball_nxt = (HOR_PIXELS - BALL_SIZE) / 2;
        y_ball_nxt = (VER_PIXELS - BALL_SIZE) / 2;
        hor_ball_velocity_nxt = random_velocity;
        ver_ball_velocity_nxt = random_velocity;
      end

    end else begin
      y_ball_nxt = y_ball;
      x_ball_nxt = x_ball;
      hor_ball_velocity_nxt = hor_ball_velocity;
      ver_ball_velocity_nxt = ver_ball_velocity;
    end
  end

endmodule
