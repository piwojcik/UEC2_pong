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
    output logic       tx
);
    // wire        tready; // sygnaly do uart
    // wire        ready;
    // wire        tstart;
    // reg         CLK50MHZ=0;
    // wire [31:0] tbuf;
    // wire [ 7:0] tbus;
    // reg  [ 2:0] bcount=0;
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
            // bcount <= 3'd0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= keycode != keycodev;
            // bcount <= 3'd5;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
            // bcount <= 3'd2;
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

    // zostawiam do testow
    // bin2ascii #(
    //     .NBYTES(2)
    // ) conv (
    //     .I(keycodev),
    //     .O(tbuf)
    // );

    // uart_buf_con tx_con (
    //     .clk    (clk),
    //     .bcount (bcount),
    //     .tbuf   (keycodev),  
    //     .start  (start ), 
    //     .ready  (ready ), 
    //     .tstart (tstart),
    //     .tready (tready),
    //     .tbus   (tbus  )
    // );
    
    // uart_tx get_tx (
    //     .clk    (clk),
    //     .start  (tstart),
    //     .tbus   (tbus),
    //     .tx     (tx),
    //     .ready  (tready)
    // );
endmodule
