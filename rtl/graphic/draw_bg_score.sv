/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 * 
 * Modified by: Jan Jurek
 */


`timescale 1 ns / 1 ps

module draw_bg_score (
    input  logic clk,
    input  logic rst,
    input  logic [10:0] vcount_in,
    input  logic        vsync_in,
    input  logic        vblnk_in,
    input  logic [10:0] hcount_in,
    input  logic        hsync_in,
    input  logic        hblnk_in,
    
    input  logic [3:0] player1_score,
    input  logic [3:0] player2_score,
    input  logic [7:0] char_pixel,
    output  logic [6:0] char_code,
    output  logic [3:0] char_line,
    vga_intf.out bg_out
     
);

import vga_pkg::*;


/**
 * Local variables and signals
 */
localparam WIDTH = 8; 
localparam HEIGHT = 16; 
localparam STARTY = 16;
localparam STARTX = 512;

logic [2:0] i, i_nxt =0;
logic [11:0] rgb_nxt;
logic [10:0] temp_var;

/**
 * Internal logic
 */
assign temp_var = vcount_in + 4; // offset lini przerywanej
always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        bg_out.rgb    <= '0;
        i <= 0;
        char_code <= '0;
        char_line <= '0;
    end else begin
        bg_out.rgb   <= rgb_nxt;
        i <= i_nxt;
        char_line <= {vcount_in[3:0] - STARTY };
         if (hcount_in >= 512) begin
            char_code <= 'h30 + player2_score;
        end else begin
            char_code <= 'h30 + player1_score; 
        end
    end
end

delay #(
    .WIDTH (22),
    .CLK_DEL (2)
) u_delay_count (
        .clk,
        .rst,
        .din({vcount_in, hcount_in}),
        .dout({bg_out.vcount, bg_out.hcount}) 
    );

delay #(
    .WIDTH (4),
    .CLK_DEL (2)
    ) u_delay_control (
        .clk,
        .rst,
        .din({vsync_in, vblnk_in, hsync_in, hblnk_in}),
        .dout({bg_out.vsync, bg_out.vblnk, bg_out.hsync, bg_out.hblnk}) 
);

always_comb begin : bg_comb_blk
    if (vblnk_in || hblnk_in) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                   // - make it it black.
        i_nxt = 0;
    end else begin                              // Active region:
        if (bg_out.vcount >= STARTY & bg_out.vcount <= (STARTY + HEIGHT)- 1) begin  //draw score              
            if ((bg_out.hcount >= (STARTX - 32) & bg_out.hcount <= ((STARTX - 32) + WIDTH) - 1) || ((bg_out.hcount >= (STARTX + 32 - WIDTH) & bg_out.hcount <= ((STARTX + 32)) - 1))) begin                   
                if (char_pixel[7-i] == '1 ) begin                
                    rgb_nxt = 12'hF_F_F;                   
                end else begin
                    rgb_nxt = 12'h8_8_8;;
                end
                if(bg_out.hcount == STARTX) begin
                    i_nxt = 0;
                end else begin
                    i_nxt = i + 1;
                end                 
            end else begin   
                rgb_nxt = 12'h8_8_8;; 
                i_nxt = 0;             
            end
        end else if(bg_out.vcount == TOP_BORDER || bg_out.vcount == TOP_BORDER + 1) begin
            rgb_nxt = 12'hF_F_F;                // - fill with white.
            i_nxt = 0;
        end else if(bg_out.vcount == BOTTOM_BORDER - 1 || bg_out.vcount == BOTTOM_BORDER - 2) begin
            rgb_nxt = 12'hF_F_F;                // - fill with white.
            i_nxt = 0;
        end  else if(bg_out.vcount > TOP_BORDER) begin
            if (bg_out.hcount >= 511 & bg_out.hcount <= 513) begin // middle line
                if (temp_var[5] == 0) begin
                    rgb_nxt = 12'h0_7_0;
                    i_nxt = 0;
                end else begin   
                    rgb_nxt = 12'h8_8_8;; 
                    i_nxt = 0;             
                end
            end else begin   
                rgb_nxt = 12'h8_8_8;; 
                i_nxt = 0;             
            end
        end else begin                                   
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
            i_nxt = 0;
        end
    end
end

endmodule
