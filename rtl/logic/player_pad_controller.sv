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
     input  logic timing_tick,
     input  logic up_in,
     input  logic down_in,
     input  logic [1:0] state,
     output  logic [9:0] y_pad
 );

 import vga_pkg::*;

 //zmienne pada

 logic [9:0] y_pad_t, y_pad_b;
 logic [9:0] y_pad_next = 312;
 logic up, down;

 assign y_pad_t = y_pad;                          
 assign y_pad_b = y_pad_t + PAD_HEIGHT - 1;         

 always_ff @(posedge clk)begin
    if(rst || (state != PLAY ))begin
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
    if(timing_tick)begin
        if(down & (y_pad_b < (VER_PIXELS - 1 - PAD_VELOCITY)))
            y_pad_next = y_pad + PAD_VELOCITY;  // ruch do dolu
        else if(up & (y_pad_t > (PAD_VELOCITY + TOP_BORDER)))
            y_pad_next = y_pad - PAD_VELOCITY;  // ruch do gory
    end
 end

 endmodule