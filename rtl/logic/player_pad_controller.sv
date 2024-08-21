/**
 * MTM UEC2
 * Author: Jan Jurek
 *
 * Description:
 * Player pad controller
 */

 `timescale 1 ns / 1 ps

 module player_pad_controller (
     input  logic clk,
     input  logic rst,
     input logic timing_tick,
     input logic up_in,
     input logic down_in,
     input logic [1:0] state,
     output  logic [9:0] y_pad
 );

 import vga_pkg::*;

//zmienne padów
 //logic [9:0] y_pad_right = 312;

 //logic [9:0] y_pad_left = 312;
 localparam PAD_HEIGHT = 145;  
 logic [9:0] y_pad_t, y_pad_b;
 assign y_pad_t = y_pad;                             // pad pozycja gory
 assign y_pad_b = y_pad_t + PAD_HEIGHT - 1;          // pad pozycja dolu
logic [9:0] y_pad_next = 312;
localparam PAD_VELOCITY = 3;                         // predkosc pada
logic up, down;

always_ff @(posedge clk)begin
    if(rst)begin
        y_pad <= 312;
    end else begin
        y_pad <= y_pad_next;
    end
end

always_ff @(posedge clk) begin
    if(rst)begin
        up <= '0;
        down <= '0;
    end else begin
        up <= up_in;
        down <= down_in;
    end
end

always_comb begin
    y_pad_next = y_pad;     
    if(state & play) begin    
        if(timing_tick)
            if(down & (y_pad_b < (VER_PIXELS - 1 - PAD_VELOCITY)))
                y_pad_next = y_pad + PAD_VELOCITY;  // ruch do dolu
            else if(up & (y_pad_t > (1 + PAD_VELOCITY)))
                y_pad_next = y_pad - PAD_VELOCITY;  // ruch do gory
    end else if ((state & game_over)||(state & menu_start)) begin
        y_pad_next = (VER_PIXELS -72)/2;
    end
    else begin
        y_pad_next = (VER_PIXELS -72)/2;
    end
end

 endmodule