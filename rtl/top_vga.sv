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
wire [7:0] char_pixel;
wire [3:0] char_line;
wire [6:0] char_code;
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
     .bg_out (bg_bus)
);

vga_intf draw_score_bus();

draw_score u_draw_score (
    .clk,
    .rst,
    .rect_in (bg_bus),
    .rect_out (vgatop_bus),
    .char_pixel(char_pixel),

    .char_code,
    .char_line(char_line)
    );

font_rom u_font_rom(
    .clk,
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixel)
);


endmodule
