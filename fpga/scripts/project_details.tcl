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
    ../rtl/common/vga_pkg.sv
    ../rtl/common/delay.sv
    ../rtl/graphic/vga_timing.sv
    ../rtl/graphic/draw_bg_score.sv
    ../rtl/graphic/vga_if.sv
    ../rtl/graphic/top_vga.sv
    ../rtl/graphic/font_rom.sv
    ../rtl/graphic/draw_ball_pads.sv
    ../rtl/graphic/draw_state.sv
    ../rtl/logic/ball_controller.sv
    ../rtl/logic/player_pad_controller.sv
    ../rtl/logic/player2_pad_controller.sv
    ../rtl/logic/top_logic.sv
    ../rtl/logic/score_controller.sv
    ../rtl/logic/player2_mux.sv
    ../rtl/logic/player2_pad_controller.sv
    ../rtl/uart/uart_buf_rx.sv
    ../rtl/uart/uart_buf_tx.sv
    ../rtl/uart/uart.sv
    ../rtl/keyboard/keyboard_top.sv
    ../rtl/keyboard/input_mux.sv
    ../rtl/top_pong.sv
    rtl/top_vga_basys3.sv
}

# Specify Verilog design files location         -- EDIT
 set verilog_files {
    rtl/clk_wiz_0_clk_wiz.v 
    ../rtl/keyboard/bin2ascii.v
    ../rtl/keyboard/debouncer.v
    ../rtl/keyboard/PS2Receiver.v
    ../rtl/uart/uart_tx.v
    ../rtl/uart/uart_rx.v
    ../rtl/uart/mod_m_counter.v
 }

# Specify VHDL design files location            -- EDIT
# set vhdl_files {
#    path/to/file.vhd
# }

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }
