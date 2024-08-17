`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 
// Engineer: Arthur Brown
// 
// Create Date: 07/27/2016 02:04:01 PM
// Design Name: Basys3 Keyboard Demo
// Module Name: top
// Project Name: Keyboard
// Target Devices: Basys3
// Tool Versions: 2016.X
// Description: 
//     Receives input from USB-HID in the form of a PS/2, displays keyboard key presses and releases over USB-UART.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//     Known issue, when multiple buttons are pressed and one is released, the scan code of the one still held down is ometimes re-sent.
// https://github.com/Digilent/Basys-3-Keyboard
//
// Modified by:
// 2024  AGH University of Science and Technology
// MTM UEC2
// Jan Jurek
//////////////////////////////////////////////////////////////////////////////////


module keyboard_top(
    input  logic       clk,
    input  logic       rst,
    input  logic       PS2Data,
    input  logic       PS2Clk,
    input  logic [0:0] sw,
    input  logic       btnU,
    input  logic       btnD,
    output logic       up,
    output logic       down,
);
    wire        flag;
    reg         cn=0;
    reg         start=0;
    reg  [15:0] keycodev=0;
    wire [15:0] keycode;
    
    PS2Receiver uut (
        .clk,
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    
    always@(keycode or keycodev)
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= keycode != keycodev;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
        end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1) begin
            start <= 1'b1;
            keycodev <= keycode;
        end else
            start <= 1'b0;
            
    input_mux u_input_mux(
    .clk,
    .rst,
    .keycode(keycodev),
    .ready(start),
    .sw,
    .btnU,
    .btnD,
    .up,
    .down
    );
endmodule
