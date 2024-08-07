/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk, Jan Jurek
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);

/**
 * Local variables and signals
 */


/**
 * Signals assignments
 */
vga_intf vgatop_bus();

assign vs = vgatop_bus.vsync;
assign hs = vgatop_bus.hsync;
assign {r,g,b} = vgatop_bus.rgb;


/**
 * Submodules instances
 */

 vga_intf vgat_bus();

vga_timing u_vga_timing (
    .clk,
    .rst,
     .vgat_out (vgat_bus)
);
vga_intf bg_bus();


draw_bg u_draw_bg (
    .clk,
    .rst,
     .bg_in (vgat_bus),
     .bg_out (vgatop_bus)
);




endmodule
