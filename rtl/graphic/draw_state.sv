/**
 * Copyright (C) 2023  AGH University of Science and Technologyy
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * Draw rectangle.
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
 
 //Parametry tekstu
 localparam CHAR_WIDTH = 8;
 localparam CHAR_HEIGHT = 16;
 localparam SCALE = 8; // skalowanie liter
 localparam SCALE2 = 2; // skalowanie - mniejsza czcionka
 
 // Obliczanie pozycji "MENU"
 localparam MENU_X_POS = (HOR_PIXELS / 2) - ((CHAR_WIDTH * SCALE * 4) / 2);
 localparam MENU_Y_POS = (VER_PIXELS / 2) - (CHAR_HEIGHT * SCALE / 2);
 // Obliczanie pozycji "GAME OVER"
 localparam OVER_X_POS = (HOR_PIXELS / 2) - (CHAR_WIDTH * SCALE * 9 / 2);
 localparam OVER_Y_POS = (VER_PIXELS / 2) - (CHAR_HEIGHT * SCALE / 2);
 // Obliczanie pozycji "PLAYER X WINS"
 localparam WINNER_X_POS = (HOR_PIXELS / 2) - (CHAR_WIDTH * SCALE2 * 13 / 2);
 localparam WINNER_Y_POS = OVER_Y_POS + CHAR_HEIGHT * SCALE + 20;
 
 
 logic [3:0] char_line;
 logic [6:0] char_code;
 logic [10:0] rom_addr;
 logic [7:0] char_line_pixels;
 logic [11:0] rgb_nxt;
 wire [10:0] menu_on;
 wire [10:0] over_on;
 wire [10:0] winner_on;
 wire [10:0] winner;
 
 
 // Deklaracja podmodulu
 font_rom font_inst (
     .clk(clk),
     .addr(rom_addr),
     .char_line_pixels(char_line_pixels)
 );
 
 //Miejsce wyswietlenia tekstu
 assign menu_on = ((game_in.hcount >= MENU_X_POS) && (game_in.hcount < MENU_X_POS + CHAR_WIDTH * SCALE * 4) &&
                 (game_in.vcount >= MENU_Y_POS) && (game_in.vcount < MENU_Y_POS + CHAR_HEIGHT * SCALE));
                 
 assign over_on = ((game_in.hcount >= OVER_X_POS) && (game_in.hcount < OVER_X_POS + CHAR_WIDTH * SCALE * 9) &&
                 (game_in.vcount >= OVER_Y_POS) && (game_in.vcount < OVER_Y_POS + CHAR_HEIGHT * SCALE));
 
 assign winner_on = ((game_in.hcount >= WINNER_X_POS) && (game_in.hcount < WINNER_X_POS + CHAR_WIDTH * SCALE * 13) &&
                 (game_in.vcount >= WINNER_Y_POS) && (game_in.vcount < WINNER_Y_POS + CHAR_HEIGHT * SCALE2));
 // Ktory gracz wygral
 assign winner = (player1_score > player2_score) ? 7'h31 : 7'h32;
 
  // Generacja adresu ROM na podstawie pozycji pixela
 always_comb begin
     if (state == menu_start) begin
         if(menu_on) begin    
             char_line = (game_in.vcount - MENU_Y_POS) / SCALE;
             case ((game_in.hcount - MENU_X_POS) / (CHAR_WIDTH * SCALE))
                 0: char_code = 7'h4D; // ASCII code for 'M'
                 1: char_code = 7'h45; // ASCII code for 'E'
                 2: char_code = 7'h4E; // ASCII code for 'N'
                 3: char_code = 7'h55; // ASCII code for 'U'
                 default: char_code = 7'b0;
             endcase
         end else begin
             char_code = 7'b0;
         end 
     end else if(state == game_over) begin
         if(over_on)begin
             char_line = (game_in.vcount - OVER_Y_POS) / SCALE;
             case ((game_in.hcount - OVER_X_POS) / (CHAR_WIDTH * SCALE))
                 0: char_code = 7'h47; // ASCII code for 'G'
                 1: char_code = 7'h41; // ASCII code for 'A'
                 2: char_code = 7'h4D; // ASCII code for 'M'
                 3: char_code = 7'h45; // ASCII code for 'E'
                 4: char_code = 7'h00; // ASCII code for ' '
                 5: char_code = 7'h4F; // ASCII code for 'O'
                 6: char_code = 7'h56; // ASCII code for 'V'
                 7: char_code = 7'h45; // ASCII code for 'E'
                 8: char_code = 7'h52; // ASCII code for 'R'
                 default: char_code = 7'b0;
             endcase
         end else if(winner_on)begin
             char_line = (game_in.vcount - WINNER_Y_POS) / SCALE2;
             case ((game_in.hcount - WINNER_X_POS) / (CHAR_WIDTH * SCALE2))
                 0: char_code = 7'h50; // ASCII code for 'P'
                 1: char_code = 7'h4c; // ASCII code for 'L'
                 2: char_code = 7'h41; // ASCII code for 'A'
                 3: char_code = 7'h59; // ASCII code for 'Y'
                 4: char_code = 7'h45; // ASCII code for 'E'
                 5: char_code = 7'h52; // ASCII code for 'R'
                 6: char_code = 7'h00; // ASCII code for ' '
                 7: char_code = winner; // ASCII code for '1/2'
                 8: char_code = 7'h00; // ASCII code for ' '
                 9: char_code = 7'h57; // ASCII code for 'W'
                 10: char_code = 7'h49; // ASCII code for 'I'
                 11: char_code = 7'h4E; // ASCII code for 'N'
                 12: char_code = 7'h53; // ASCII code for 'S'
                 default: char_code = 7'b0;
             endcase
         end else begin
             char_code = 7'b0;
         end
     end else begin
         char_code = 7'b0;
     end
     rom_addr = {char_code, char_line};
 end
 
 always_ff @(posedge clk) begin
     if (rst) begin
         game_out.rgb <= 12'h0_0_0;
     end else begin
         game_out.rgb <= rgb_nxt;
     end 
 end
 
 
 // RGB MUX
 always_comb begin
     if (game_in.vblnk || game_in.hblnk) begin             // Blanking region:
         rgb_nxt = 12'h0_0_0;                    // - make it it black.
     end else if (state == menu_start) begin 
         if(menu_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - MENU_X_POS) / SCALE) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'hF_0_F;         // - fioletowy napis MENU
             end else begin
                 rgb_nxt = game_in.rgb;
             end 
         end else begin
             rgb_nxt = game_in.rgb;
         end
     end else if (state == game_over) begin 
         if(over_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - OVER_X_POS) / SCALE) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'hF_0_F;      // - fioletowy napis GAME OVER
             end else begin
                 rgb_nxt = game_in.rgb;
             end 
         end else if(winner_on) begin
             if(char_line_pixels[7 - ((game_in.hcount - WINNER_X_POS) / SCALE2) % CHAR_WIDTH]) begin
                 rgb_nxt = 12'h0_F_0;       // - zielony napis PLAYER x WINS
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