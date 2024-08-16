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
     input  logic [9:0] y_pad_right,
     input  logic [9:0] y_pad_left,

     inout  logic [9:0] y_ball,
     inout  logic [9:0] x_ball,

     output  logic miss,
 );

 import vga_pkg::*;

 localparam X_PAD_R = 979; 
 localparam X_PAD_L = 30;

 // Ustawienie piłki na środku ekranu
localparam [9:0] x_ball_center = (HOR_PIXELS - BALL_SIZE) / 2;
localparam [9:0] y_ball_center = (VER_PIXELS - BALL_SIZE) / 2;

localparam BALL_VELOCITY_POS = 2; // w dol/prawo
localparam BALL_VELOCITY_NEG = -2; // gora/lewo

logic [9:0] y_ball_nxt;
logic [9:0] x_ball_nxt;
logic [1:0] y_delta;
logic [1:0] x_delta;
logic [1:0] y_delta_nxt;
logic [1:0] x_delta_nxt;

assign x_ball_nxt = x_ball + x_delta;
assign y_ball_nxt = y_ball + y_delta;

always_ff @(posedge clk)begin
    if(rst)begin
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

always_comb @(posedge clk) begin
    miss_left = 1b'0;
    miss_right = 1b'0;
    x_delta_nxt = x_delta;
    y_delta_nxt = y_delta;

    if(y_ball == 8) // odbicie od gornej sciany
        y_delta_nxt = BALL_VELOCITY_POS;
    else if(y_ball == 761) //odbicie od dolnej sciany
        y_delta_nxt = BALL_VELOCITY_NEG;

    if((x_ball == x_pad_left + 15+7)&&(y_ball >= y_pad_left)&&(y_ball <= y_pad_left-145))  //odbicie od lewego pada
        x_delta_nxt = BALL_VELOCITY_POS;
    else if ((x_ball + 7 == x_pad_right)&&(y_ball >= y_pad_right)&&(y_ball <= y_pad_right-145))  //odbicie od prawego pada
        x_delta_nxt = BALL_VELOCITY_NEG;

    if(x_ball == 8) // lewy gracz spudlowal
        miss_left = 1'b1;

    if(x_ball > x_pad_right) // prawy gracz spudlowal
        miss_right = 1'b1;

end

 endmodule