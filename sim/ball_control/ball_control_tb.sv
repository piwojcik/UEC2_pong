/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for top_vga.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

 `timescale 1 ns / 1 ps

 module ball_control_tb;
 
 
 /**
  *  Local parameters
  */
 
 localparam CLK_PERIOD = 15.384615384615;     // ok 65 MHz 
 // localparam CLK_PERIOD100MHZ = 10; //100 MHz
 /**
  * Local variables and signals
  */
 
 logic clk, rst;
 wire vs, hs;
 logic timing_tick, up = 0;
 logic down;
 wire [3:0] r, g, b;
 wire [9:0] x_ball, y_ball, y_pad_right, y_pad_left;
 /**
  * Clock generation
  */
 
 initial begin
     clk = 1'b0;
     forever #(CLK_PERIOD/2) clk = ~clk;
 end
 
 // initial begin
 //     clk100mhz = 1'b0;
 //     forever #(CLK_PERIOD100MHZ/2) clk100mhz = ~clk100mhz;
 // end
 
 /**
  * Submodules instances
  */
 
 top_vga dut (
     .clk(clk),
     .rst(rst),
     .timing_tick,
     .x_ball(x_ball),
     .y_ball(y_ball),
     .vs(vs),
     .hs(hs),
     .r(r),
     .g(g),
     .b(b)
 );
 
 tiff_writer #(
     .XDIM(16'd1344),
     .YDIM(16'd806),
     .FILE_DIR("../../results")
 ) u_tiff_writer (
     .clk(clk),
     .r({r,r}), // fabricate an 8-bit value
     .g({g,g}), // fabricate an 8-bit value
     .b({b,b}), // fabricate an 8-bit value
     .go(vs)
 );
 ball_controller u_ball_controller_tb (
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(y_pad_right),
    .y_pad_left(y_pad_left),
    .y_ball(y_ball),
    .x_ball(x_ball)
 );
 
 /**
  * Main test
  */
 
 initial begin
     rst = 1'b0;
     down = 1'b1;
     # 30 rst = 1'b1;
     # 30 rst = 1'b0;
 
     $display("If simulation ends before the testbench");
     $display("completes, use the menu option to run all.");
     $display("Prepare to wait a long time...");
 
     wait (vs == 1'b0);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     @(negedge vs) $display("Info: negedge VS at %t",$time);
     // End the simulation.
     $display("Simulation is over, check the waveforms.");
     $finish;
 end
 
 endmodule