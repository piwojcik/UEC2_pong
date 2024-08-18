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
    input  logic [9:0] y_player_pad,
    output logic timing_tick,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);

/**
 * Local variables and signals
 */
// VGA signals from timing
 wire [10:0] vcount_tim, hcount_tim;
 wire vsync_tim, hsync_tim;
 wire vblnk_tim, hblnk_tim;

wire [7:0] char_pixel;
wire [3:0] char_line;
wire [6:0] char_code;
// wire [9:0] x_ball;
wire [9:0] y_pad_right;
// wire [9:0] y_ball;
wire [9:0] y_pad_left;
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
    .timing_tick,
    .vcount (vcount_tim),
    .vsync  (vsync_tim),
    .vblnk  (vblnk_tim),
    .hcount (hcount_tim),
    .hsync  (hsync_tim),
    .hblnk  (hblnk_tim)
);
vga_intf bg_bus();

draw_bg u_draw_bg (
    .clk,
    .rst,
    .vcount_in (vcount_tim),
    .vsync_in  (vsync_tim),
    .vblnk_in  (vblnk_tim),
    .hcount_in (hcount_tim),
    .hsync_in  (hsync_tim),
    .hblnk_in  (hblnk_tim),
    .bg_out (bg_bus)
);

vga_intf draw_score_bus();

draw_score u_draw_score (
    .clk,
    .rst,
    .rect_in (bg_bus),
    .rect_out (draw_score_bus),
    .char_pixel(char_pixel),

    .char_code,
    .char_line(char_line)
    );

font_rom u_font_rom(
    .clk,
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixel)
);

draw_ball_pads u_draw_ball_pads (
    .clk,
    .rst,
    .y_ball(y_ball),
    .x_ball(x_ball),
    .y_pad_left(y_pad_left),
    .y_pad_right(y_pad_right),
    .game_field_in(draw_score_bus),
    .game_field_out(vgatop_bus)
);

ball_controller u_ball_controller(
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(y_pad_right),
    .y_pad_left(y_pad_left),
    .y_ball(y_ball),
    .x_ball(x_ball)
);


endmodule
