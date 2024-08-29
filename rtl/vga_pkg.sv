/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;

// Add VGA timing parameters here and refer to them in other modules.
localparam HTOTAL = 1344;
localparam VTOTAL = 806;
localparam HBLKSTART = 1024;
localparam VBLKSTART = 768;
localparam HSYNCSTART = 1048;
localparam HSYNCTIME= 136;
localparam VSYNCSTART = 771;
localparam VSYNCTIME= 6;

localparam menu_start = 2'b00;
localparam play = 2'b01;
localparam game_over = 2'b10;

endpackage
