/**
 * Copyright (C) 2023  AGH University of Science and Technologyy
 * MTM UEC2
 * Author: Jan Jurek
 *
 * Description:
 * Draw rectangle.
 */


 `timescale 1 ns / 1 ps

 module draw_score (
     input  logic clk,
     input  logic rst,
    //  input  logic player1_score,
    //  input  logic player2_score,

     input  logic [7:0] char_pixel,
     output  logic [6:0] char_code,
     output  logic [3:0] char_line,
     vga_intf.in rect_in,
     vga_intf.out rect_out
 );
 
import vga_pkg::*;
 
 
 /**
  * Local variables and signals
  */

  localparam WIDTH = 8; // zaczyna od 1 dla 0 nie wyswietla
  localparam HEIGHT = 16; // zaczyna od 1 dla 0 nie wyswietla
  localparam STARTY = 32;
  localparam STARTX = 512;

logic [2:0] i, i_nxt =0;
logic [11:0] rgb_nxt;

 /**
  * Internal logic
  */

 
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
        rect_out.rgb    <= '0;
        i <= 0;
        char_code <= '0;
        char_line <= '0;
     end else begin
        rect_out.rgb    <= rgb_nxt;
        i <= i_nxt;
        char_line <= {rect_in.vcount[3:0] - STARTY };
         if (rect_in.hcount >= 512) begin
            char_code <= 'h30 + 1;
        end else begin
            char_code <= 'h30 + 2; // tu powinno byc jak podepniemy: char_code <= 'h30 + player1_score;
        end
     end
 end

delay #(
    .WIDTH (22),
    .CLK_DEL (2)
) u_delay_count (
        .clk,
        .rst,
        .din({rect_in.vcount, rect_in.hcount}),
        .dout({rect_out.vcount, rect_out.hcount}) 
    );

delay #(
    .WIDTH (4),
    .CLK_DEL (2)
    ) u_delay_control (
        .clk,
        .rst,
        .din({rect_in.vsync, rect_in.vblnk, rect_in.hsync, rect_in.hblnk}),
        .dout({rect_out.vsync, rect_out.vblnk, rect_out.hsync, rect_out.hblnk}) 
);

 always_comb begin : rect_comb_blk
    if (rect_in.vblnk || rect_in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
        i_nxt = 0;
    end else begin
        if (rect_out.vcount >= STARTY & rect_out.vcount <= (STARTY + HEIGHT)- 1) begin                
            if ((rect_out.hcount >= (STARTX - 32) & rect_out.hcount <= ((STARTX - 32) + WIDTH) - 1) || ((rect_out.hcount >= (STARTX + 30) & rect_out.hcount <= ((STARTX + 30) + WIDTH) - 1))) begin                   
                if (char_pixel[7-i] == '1 ) begin                
                    rgb_nxt = 12'hF_F_F;                   
                end else begin
                    rgb_nxt = rect_in.rgb;
                end

                if(rect_out.hcount == STARTX) begin
                     i_nxt = 0;
                end else begin
                    i_nxt =i + 1;
                end  

            end else begin   
            rgb_nxt = rect_in.rgb; 
            i_nxt = 0;             
            end    
        
        end else begin   
            rgb_nxt = rect_in.rgb;
            i_nxt = 0;
        end                                          
    end 
end

 
 endmodule
 