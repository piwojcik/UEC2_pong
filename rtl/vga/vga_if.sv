/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Jurek
 *
 * Description:
 * interface for vga

 */

 interface vga_intf;
    logic  [10:0]vcount, hcount;

    logic   vsync, vblnk, hsync, hblnk;

    logic  [11:0] rgb;

    modport in (input vcount, hcount, vsync, vblnk, hsync, hblnk ,rgb);
    modport out (output vcount, hcount, vsync, vblnk, hsync, hblnk, rgb);
 endinterface
 