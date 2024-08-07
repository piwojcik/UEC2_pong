# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name vga_project

# Top module name                               -- EDIT
set top_module top_vga_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/vga_pkg.sv
    ../rtl/vga_timing.sv
    ../rtl/draw_bg.sv
    ../rtl/vga_if.sv
    ../rtl/delay.sv
    ../rtl/mouse/draw_mouse.sv
    ../rtl/rect/draw_rect.sv
    ../rtl/rect/draw_rect_ctl.sv
    ../rtl/rect/image_rom.sv
    ../rtl/char/draw_rect_char.sv
    ../rtl/char/font_rom.sv
    ../rtl/char/char_rom_16x16.sv
    ../rtl/top_vga.sv
    ../rtl/uart/uart_test.sv
    ../rtl/uart/UART_monitor.sv
    ../rtl/uart/disp_hex_mux.sv
    ../rtl/uart/top_uart.sv
    ../rtl/uproc/decode.sv 
    ../rtl/uproc/top_micro.sv 
    ../rtl/uproc/disp_hex_mux16b.sv
    rtl/top_vga_basys3.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    rtl/clk_wiz_0_clk_wiz.v
    ../rtl/uart/uart.v
    ../rtl/uart/mod_m_counter.v
    ../rtl/uart/uart_rx.v
    ../rtl/uart/uart_tx.v
    ../rtl/uart/fifo.v
    ../rtl/uart/flag_buf.v
    ../rtl/uart/debounce.v
    ../rtl/uproc/adder.v \
                ../rtl/uproc/alu.v \
                ../rtl/uproc/branch_ctl.v \
                ../rtl/uproc/control_unit.v \
                ../rtl/uproc/flopenr.v \
                ../rtl/uproc/imem.v \
                ../rtl/uproc/flopr.v \
                ../rtl/uproc/micro.v \
                ../rtl/uproc/mux2.v \
                ../rtl/uproc/regfile.v 
    
    
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
   ../rtl/mouse/MouseCtl.vhd
   ../rtl/mouse/Ps2Interface.vhd 
   ../rtl/mouse/MouseDisplay.vhd 
}

# Specify files for a memory initialization     -- EDIT
set mem_files {
    ../rtl/rect/image_rom.data
    ../rtl/uproc/imem.data
}
