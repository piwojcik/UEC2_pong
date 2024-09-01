/**
 * Copyright (C) 2023  AGH University of Science and Technologyy
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * Draw state
 */

 `timescale 1 ns / 1 ps

 module draw_state (
     input logic clk,
     input logic rst,
     input logic [1:0] state,
     input logic [3:0] player1_score,
     input logic [3:0] player2_score,
 
     vga_intf.in game_in,
     vga_intf.out game_out 
 );
 import vga_pkg::*;
 
 // Obliczanie pozycji tekstow
 localparam TITLE_X_POS = (HOR_PIXELS / 2) - ((CHAR_WIDTH * SCALE * 11) / 2);
 localparam TITLE_Y_POS = (VER_PIXELS / 2) - (CHAR_HEIGHT * SCALE / 2);

 localparam OVER_X_POS = (HOR_PIXELS / 2) - (CHAR_WIDTH * SCALE * 9 / 2);
 localparam OVER_Y_POS = (VER_PIXELS / 2) - (CHAR_HEIGHT * SCALE / 2);

 localparam WINNER_X_POS = (HOR_PIXELS / 2) - (CHAR_WIDTH * SCALE2 * 13 / 2);
 localparam WINNER_Y_POS = OVER_Y_POS + CHAR_HEIGHT * SCALE + 20;

 localparam AUTHORS_X_POS = HOR_PIXELS - (HOR_PIXELS / 4) - ((CHAR_WIDTH * SCALE2 * 10) / 2);
 localparam AUTHORS_Y_POS = VER_PIXELS - 50 -(CHAR_HEIGHT * SCALE2 / 2);;

 localparam AGH_X_POS = (HOR_PIXELS / 2) - ((CHAR_WIDTH * SCALE2 * 7) / 2);
 localparam AGH_Y_POS = (VER_PIXELS / 2) - (CHAR_HEIGHT * SCALE2 / 2) - 150;

 
 logic [3:0] char_line, char_line_nxt;
 logic [6:0] char_code;
 logic [10:0] rom_addr;
 logic [7:0] char_line_pixels;
 logic [11:0] rgb_nxt;
 wire [10:0] title_on;
 wire [10:0] agh_on;
 wire [10:0] over_on;
 wire [10:0] winner_on;
 wire [6:0] winner;
 wire [10:0] authors_on;

 font_rom font_inst (
     .clk(clk),
     .addr(rom_addr),
     .char_line_pixels(char_line_pixels)
 );
 
 //Miejsce wyswietlenia tekstu
 assign title_on = ((game_in.hcount >= TITLE_X_POS) && (game_in.hcount < TITLE_X_POS + CHAR_WIDTH * SCALE * 11) &&
                 (game_in.vcount >= TITLE_Y_POS) && (game_in.vcount < TITLE_Y_POS + CHAR_HEIGHT * SCALE));
                 
 assign over_on = ((game_in.hcount >= OVER_X_POS) && (game_in.hcount < OVER_X_POS + CHAR_WIDTH * SCALE * 9) &&
                 (game_in.vcount >= OVER_Y_POS) && (game_in.vcount < OVER_Y_POS + CHAR_HEIGHT * SCALE));
 
 assign winner_on = ((game_in.hcount >= WINNER_X_POS) && (game_in.hcount < WINNER_X_POS + CHAR_WIDTH * SCALE2 * 13) &&
                 (game_in.vcount >= WINNER_Y_POS) && (game_in.vcount < WINNER_Y_POS + CHAR_HEIGHT * SCALE2));
 
 assign winner = (player1_score > player2_score) ? 7'h31 : 7'h32;

 assign authors_on = ((game_in.hcount >= AUTHORS_X_POS) && (game_in.hcount < AUTHORS_X_POS + CHAR_WIDTH * SCALE2  * 10) &&
                    (game_in.vcount >= AUTHORS_Y_POS) && (game_in.vcount < AUTHORS_Y_POS + CHAR_HEIGHT * SCALE2 ));

 assign agh_on = ((game_in.hcount >= AGH_X_POS) && (game_in.hcount < AGH_X_POS + CHAR_WIDTH * SCALE2 * 7) &&
                    (game_in.vcount >= AGH_Y_POS) && (game_in.vcount < AGH_Y_POS + CHAR_HEIGHT * SCALE2));
 
  // Generacja adresu ROM na podstawie pozycji pixela
 always_comb begin
    char_line_nxt = char_line;
     if (state == MENU_START) begin
         if(title_on) begin    
             char_line_nxt = (game_in.vcount - TITLE_Y_POS) / SCALE;
             case ((game_in.hcount - TITLE_X_POS) / (CHAR_WIDTH * SCALE))
                 0: char_code = 7'h50; // code for 'P'
                 1: char_code = 7'h69; // code for 'I'
                 2: char_code = 7'h78; // code for 'X'
                 3: char_code = 7'h65; // code for 'E'
                 4: char_code = 7'h6C; // code for 'L'
                 5: char_code = 7'h50; // code for 'P'
                 6: char_code = 7'h61; // code for 'A'
                 7: char_code = 7'h64; // code for 'D'
                 8: char_code = 7'h64; // code for 'D'
                 9: char_code = 7'h6C; // code for 'L'
                 10: char_code = 7'h65; // code for 'E'
                 default: char_code = 7'b0;
             endcase
         end else if (authors_on) begin 
            char_line_nxt = (game_in.vcount - AUTHORS_Y_POS) /  SCALE2 ;
            case ((game_in.hcount - AUTHORS_X_POS) / (CHAR_WIDTH *  SCALE2 ))
                0: char_code = 7'h42; // code for 'B'
                1: char_code = 7'h79; // code for 'y'
                2: char_code = 7'h00; // code for ' '
                3: char_code = 7'h50; // code for 'P'
                4: char_code = 7'h57; // code for 'W'
                5: char_code = 7'h00; // code for ' '
                6: char_code = 7'h26; // code for '&'
                7: char_code = 7'h00; // code for ' '
                8: char_code = 7'h4A; // code for 'J'
                9: char_code = 7'h4A; // code for 'J'
                default: char_code = 7'b0;
            endcase
         end else if (agh_on) begin 
            char_line_nxt = (game_in.vcount - AGH_Y_POS) / SCALE2;
            case ((game_in.hcount - AGH_X_POS) / (CHAR_WIDTH * SCALE2))
                0: char_code = 7'h4D; // code for 'M'
                1: char_code = 7'h54; // code for 'T'
                2: char_code = 7'h4D; // code for 'M'
                3: char_code = 7'h00; // code for ' '
                4: char_code = 7'h41; // code for 'A'
                5: char_code = 7'h47; // code for 'G'
                6: char_code = 7'h48; // code for 'H'
                default: char_code = 7'b0;
            endcase
         end else begin
             char_code = 7'b0;
         end 
     end else if(state == GAME_OVER) begin
         if(over_on)begin
            char_line_nxt = (game_in.vcount - OVER_Y_POS) / SCALE;
             case ((game_in.hcount - OVER_X_POS) / (CHAR_WIDTH * SCALE))
                 0: char_code = 7'h47; // code for 'G'
                 1: char_code = 7'h41; // code for 'A'
                 2: char_code = 7'h4D; // code for 'M'
                 3: char_code = 7'h45; // code for 'E'
                 4: char_code = 7'h00; // code for ' '
                 5: char_code = 7'h4F; // code for 'O'
                 6: char_code = 7'h56; // code for 'V'
                 7: char_code = 7'h45; // code for 'E'
                 8: char_code = 7'h52; // code for 'R'
                 default: char_code = 7'b0;
             endcase
         end else if(winner_on)begin
            char_line_nxt = (game_in.vcount - WINNER_Y_POS) / SCALE2;
             case ((game_in.hcount - WINNER_X_POS) / (CHAR_WIDTH * SCALE2))
                 0: char_code = 7'h50; // code for 'P'
                 1: char_code = 7'h4c; // code for 'L'
                 2: char_code = 7'h41; // code for 'A'
                 3: char_code = 7'h59; // code for 'Y'
                 4: char_code = 7'h45; // code for 'E'
                 5: char_code = 7'h52; // code for 'R'
                 6: char_code = 7'h00; // code for ' '
                 7: char_code = winner; // code for '1/2'
                 8: char_code = 7'h00; // code for ' '
                 9: char_code = 7'h57; // code for 'W'
                 10: char_code = 7'h49; // code for 'I'
                 11: char_code = 7'h4E; // code for 'N'
                 12: char_code = 7'h53; // code for 'S'
                 default: char_code = 7'b0;
             endcase
         end else begin
             char_code = 7'b0;
             char_line_nxt = 4'b0;
         end
     end else begin
         char_code = 7'b0;
         char_line_nxt = 4'b0;
     end
     rom_addr = {char_code, char_line};
 end
 
 always_ff @(posedge clk) begin
     if (rst) begin
         game_out.rgb <= 12'h0_0_0;
         char_line <= 4'b0;
     end else begin
         game_out.rgb <= rgb_nxt;
         char_line <= char_line_nxt;
     end 
 end
 
 
 // RGB MUX
 always_comb begin
     if (game_in.vblnk || game_in.hblnk) begin           
         rgb_nxt = 12'h0_0_0;                   
     end else if (state == MENU_START) begin 
         if(title_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - TITLE_X_POS) / SCALE) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'hF_0_F; 
             end else begin       
                rgb_nxt = game_in.rgb;
            end 
         end else if (authors_on) begin 
            if(char_line_pixels[7 - ((game_in.hcount - AUTHORS_X_POS) / SCALE2) % CHAR_WIDTH]) begin
                rgb_nxt = 12'h0_F_0;       
            end else begin
                rgb_nxt = game_in.rgb;
            end 
         end else if (agh_on) begin 
            if(char_line_pixels[7 - ((game_in.hcount - AGH_X_POS)/ SCALE2) % CHAR_WIDTH]) begin
                rgb_nxt = 12'h0_F_0; 
            end else begin
                rgb_nxt = game_in.rgb;
            end 
        end else begin
             rgb_nxt = game_in.rgb;
         end
     end else if (state == GAME_OVER) begin 
         if(over_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - OVER_X_POS) / SCALE) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'hF_0_F;  
             end else begin
                 rgb_nxt = game_in.rgb;
             end 
         end else if(winner_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - WINNER_X_POS) / SCALE2) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'h0_F_0;     
             end else begin
                 rgb_nxt = game_in.rgb;
             end 
         end else begin
             rgb_nxt = game_in.rgb;
         end
     end
     else begin
         rgb_nxt = game_in.rgb;
     end
 end
 
 delay #(
     .WIDTH (22),
     .CLK_DEL (2)
 ) u_delay_count (
         .clk,
         .rst,
         .din({game_in.vcount, game_in.hcount}),
         .dout({game_out.vcount, game_out.hcount}) 
     );
 
 delay #(
     .WIDTH (4),
     .CLK_DEL (2)
     ) u_delay_control (
         .clk,
         .rst,
         .din({game_in.vsync, game_in.vblnk, game_in.hsync, game_in.hblnk}),
         .dout({game_out.vsync, game_out.vblnk, game_out.hsync, game_out.hblnk}) 
 );
 endmodule