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
     vga_intf.out vgat_out
 );
 
 import vga_pkg::*;
 
 
 /**
  * Local variables and signals
  */
 localparam HTOTAL = 1056;
 localparam VTOTAL = 628;
 localparam HBLKSTART = 800;
 localparam VBLKSTART = 600;
 localparam HSYNCSTART = 840;
 localparam HSYNCTIME= 128;
 localparam VSYNCSTART = 601;
 localparam VSYNCTIME= 4;
 
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
         vgat_out.vcount <= '0;
         vgat_out.hcount <= '0;
         vgat_out.vsync <= '0;
         vgat_out.vblnk <= '0;
         vgat_out.hsync <= '0;
         vgat_out.hblnk <= '0;
     end
     else begin
         vgat_out.vcount <= vcount_nxt;
         vgat_out.hcount <= hcount_nxt;
         vgat_out.vsync <= vsync_nxt;
         vgat_out.vblnk <= vblnk_nxt;
         vgat_out.hsync <= hsync_nxt;
         vgat_out.hblnk <= hblnk_nxt;
 
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

         if(vgat_out.hcount > (HBLKSTART - 2) & vgat_out.hcount != (HTOTAL - 1)) begin
             hblnk_nxt = '1;
         end
         else begin
             hblnk_nxt = '0;
         end 
 
         if(vgat_out.hcount > (HSYNCSTART - 2) & vgat_out.hcount < (HSYNCSTART + HSYNCTIME - 1)) begin
             hsync_nxt = '1;
         end
         else begin
             hsync_nxt = '0;    
         end

         if (vgat_out.hcount == (HTOTAL - 1)) begin
            hcount_nxt = '0;

            if(vgat_out.vcount > (VBLKSTART - 2) & vgat_out.vcount != (VTOTAL - 1)) begin
                vblnk_nxt = '1;
            end
            else begin
                vblnk_nxt = '0;
            end 

            if(vgat_out.vcount > (VSYNCSTART - 2) & vgat_out.vcount < (VSYNCSTART + VSYNCTIME - 1)) begin
                vsync_nxt = '1;
            end
            else begin
                vsync_nxt = '0;    
            end

            if (vgat_out.vcount == (VTOTAL - 1)) begin
                vcount_nxt = '0;
            end else begin
                vcount_nxt = vgat_out.vcount + 1;
            end
         end else begin
            hcount_nxt = vgat_out.hcount + 1;
            vcount_nxt = vgat_out.vcount;
            vblnk_nxt = vgat_out.vblnk;
            vsync_nxt = vgat_out.vsync;
        end
     end
 end
 
 
 
 
 // Add your code here.
 
 
 endmodule
 