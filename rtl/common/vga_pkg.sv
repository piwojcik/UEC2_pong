/**
 * Description:
 * Package with project related constants.
 *  Authors: Jan Jurek, Piotr Wojcik
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

//Parametry padow i pilki
localparam TOP_BORDER = 32;
localparam BOTTOM_BORDER = 768;
localparam PAD_HEIGHT = 100; 
localparam PAD_WIDTH = 15;
localparam X_PAD_RIGHT = 979;
localparam X_PAD_LEFT = 30;
localparam PAD_VELOCITY = 9;                    
localparam BALL_SIZE = 15;

//Kodowanie stanow
localparam MENU_START = 2'b00;
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b10;

 //Parametry tekstu
localparam CHAR_WIDTH = 8;
localparam CHAR_HEIGHT = 16;
localparam SCALE = 8; 
localparam SCALE2 = 2;

endpackage
