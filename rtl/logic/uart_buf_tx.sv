`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc
// Engineer: Arthur Brown
// 
// Create Date: 07/27/2016 03:53:30 PM
// Design Name: 
// Module Name: uart_buf_con
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  
// Modified by:
// Jan Jurek
//////////////////////////////////////////////////////////////////////////////////


module uart_buf_tx(
    input logic            clk,
    input logic rst,
   // input      [ 2:0] bcount,
    input logic     [31:0] tbuf,
    input logic            start,
    input  logic          tready,
    output logic           ready,
    output logic        tstart,
    output logic [ 7:0] tbus
    );
    reg [2:0] sel=0;
    reg [31:0] pbuf=0;
    reg running=0;

    logic [7:0] tbus_nxt =0;
    logic tstart_nxt;
    always_ff @(posedge clk) begin
        if(rst)begin
            tbus <= 'b0;
            tstart <= 'b0;
        end else begin
            tbus <= tbus_nxt;
            tstart <= tstart_nxt;
        end
    end

    always_comb begin
        if (tready == 1'b1) begin
            if (running == 1'b1) begin
                if (sel == 4'd1) begin
                    running = 1'b0;
                    sel = 5;
                end else begin
                    sel = sel - 1'b1;
                    tstart_nxt = 1'b1;
                    running = 1'b1;
                end
            end else begin
                    pbuf = tbuf;
                    tstart_nxt = start;
                    running = start;
                    sel = 5;
            end
        end else
        tstart_nxt = 1'b0;
    end

    assign ready = ~running;
    always_comb begin
        case (sel)
        3'd1: tbus_nxt = pbuf[31:24];
        3'd2: tbus_nxt = pbuf[23:16];
        3'd3: tbus_nxt = pbuf[15:8];
        3'd4: tbus_nxt = pbuf[7:0];
        3'd5: tbus_nxt = pbuf[7:0];
        default: tbus_nxt = 8'd0;
        endcase
    end
endmodule
