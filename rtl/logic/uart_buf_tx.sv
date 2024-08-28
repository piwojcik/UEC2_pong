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
    logic [2:0] sel=0, sel_nxt=0;
    logic [31:0] pbuf=0, pbuf_nxt=0;
    logic running=0, running_nxt=0;

    logic [7:0] tbus_nxt =0;
    logic tstart_nxt;
    always_ff @(posedge clk) begin
        if(rst)begin
            tbus <= 'b0;
            tstart <= 'b0;
            sel <= 'b0;
            running <= 'b0;
            pbuf <= 'b0;
        end else begin
            tbus <= tbus_nxt;
            tstart <= tstart_nxt;
            sel <= sel_nxt;
            running <= running_nxt;
            pbuf <= pbuf_nxt;
        end
    end

    always_comb begin
        sel_nxt = sel;
        tstart_nxt = tstart;
        running_nxt = running;
        pbuf_nxt = pbuf;
        if (tready == 1'b1) begin
            if (running == 1'b1) begin
                if(tstart == 0) begin
                    if (sel == 4'd1) begin
                       running_nxt = 1'b0;
                        sel_nxt = 5;
                    end else begin
                        sel_nxt = sel - 1'b1;
                        tstart_nxt = 1'b1;
                        running_nxt = 1'b1;
                    end
                end
            end else begin
                    pbuf_nxt = tbuf;
                    tstart_nxt = start;
                    running_nxt = start;
                    sel_nxt = 5;
            end
        end else
        tstart_nxt = 1'b0;
    end

    assign ready = ~running;
    always_comb begin
        case (sel)
        3'd1: tbus_nxt = pbuf[31:24];
        3'd2: tbus_nxt = pbuf[31:24];
        3'd3: tbus_nxt = pbuf[23:16];
        3'd4: tbus_nxt = pbuf[15:8];
        3'd5: tbus_nxt = pbuf[7:0];
        default: tbus_nxt = 8'd0;
        endcase
    end
endmodule
