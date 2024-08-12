/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Vga timing controller.
 */

 `timescale 1 ns / 1 ps

 module vga_timing (
     input  logic clk,
     input  logic rst,
     output logic [10:0] vcount,
     output logic vsync,
     output logic vblnk,
     output logic [10:0] hcount,
     output logic hsync,
     output logic hblnk // interfejs powoduje warning
 );
 
 import vga_pkg::*;
 
 
 /**
  * Local variables and signals
  */
 
 logic [10:0] vcount_nxt;
 logic vsync_nxt;
 logic vblnk_nxt;
 logic [10:0] hcount_nxt;
 logic hsync_nxt;
 logic hblnk_nxt;
 
 
 // Add your signals and variables here.
 
 
 /**
  * Internal logic
  */
 always_ff @(posedge clk) begin
     if(rst == 1) begin
         vcount <= '0;
         hcount <= '0;
         vsync <= '0;
         vblnk <= '0;
         hsync <= '0;
         hblnk <= '0;
     end
     else begin
         vcount <= vcount_nxt;
         hcount <= hcount_nxt;
         vsync <= vsync_nxt;
         vblnk <= vblnk_nxt;
         hsync <= hsync_nxt;
         hblnk <= hblnk_nxt;
     end
 
 
 
 end
 
 
 always_comb begin
     if(rst == 1) begin
         vcount_nxt = '0;
         hcount_nxt = '0;
         vsync_nxt = '0;
         vblnk_nxt = '0;
         hsync_nxt = '0;
         hblnk_nxt = '0;
     end else begin

         if(hcount > (HBLKSTART - 2) & hcount != (HTOTAL - 1)) begin
             hblnk_nxt = '1;
         end
         else begin
             hblnk_nxt = '0;
         end 
 
         if(hcount > (HSYNCSTART - 2) & hcount < (HSYNCSTART + HSYNCTIME - 1)) begin
             hsync_nxt = '1;
         end
         else begin
             hsync_nxt = '0;    
         end

         if (hcount == (HTOTAL - 1)) begin
            hcount_nxt = '0;

            if(vcount > (VBLKSTART - 2) & vcount != (VTOTAL - 1)) begin
                vblnk_nxt = '1;
            end
            else begin
                vblnk_nxt = '0;
            end 

            if(vcount > (VSYNCSTART - 2) & vcount < (VSYNCSTART + VSYNCTIME - 1)) begin
                vsync_nxt = '1;
            end
            else begin
                vsync_nxt = '0;    
            end

            if (vcount == (VTOTAL - 1)) begin
                vcount_nxt = '0;
            end else begin
                vcount_nxt = vcount + 1;
            end
         end else begin
            hcount_nxt = hcount + 1;
            vcount_nxt = vcount;
            vblnk_nxt = vblnk;
            vsync_nxt = vsync;
        end
     end
 end
 
 endmodule
 