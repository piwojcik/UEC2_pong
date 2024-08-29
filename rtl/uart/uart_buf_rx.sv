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


module uart_buf_rx(
    input logic            clk,
    input logic            rst,
    input logic             start,
    input  logic [ 7:0] rxbus,
    output logic [31:0] rxbuf  
    //output logic            done
    );
    //signals
    logic [2:0] sel, sel_nxt=0;
    logic [31:0] rxbuf_temp,rxbuf_temp_nxt=0;
    logic running=0, running_nxt=0;
   // logic done; 
    always_ff @(posedge clk) begin
        if(rst)begin
            rxbuf <= 'b0;
            sel <= 'b0;
            running <= 'b0;
            rxbuf_temp <= 'b0;
        end else begin
            if(!running) begin
                rxbuf <= rxbuf_temp;
              end
            rxbuf_temp <= rxbuf_temp_nxt;
            sel <= sel_nxt;
            running <= running_nxt;
        end
    end
    

    always_comb begin
        running_nxt = running;
        sel_nxt = sel;
        if(start)begin
            if (running == 1'b1) begin
                if (sel == 4'd1) begin
                    running_nxt = 1'b0;
                    sel_nxt = 5;
                     //done = 1;
                end else begin
                    sel_nxt = sel - 1'b1;
                    running_nxt = 1'b1;
                end
            end else begin
                running_nxt = start;
                sel_nxt = 5;
            end
        end else if (sel == 4'd1) begin
            running_nxt = 1'b0;
            sel_nxt = 5;
            // done = 1;
        end 
    end
    


    always_comb begin
        rxbuf_temp_nxt = rxbuf_temp;
        if(start) begin
            case (sel)
                3'd1: rxbuf_temp_nxt[31:24] = rxbus;
                3'd2: rxbuf_temp_nxt[31:24] = rxbus;
                3'd3: rxbuf_temp_nxt[23:16] = rxbus;
                3'd4: rxbuf_temp_nxt[15:8] = rxbus;
                3'd5: rxbuf_temp_nxt[7:0] = rxbus;
                default: rxbuf_temp_nxt = 32'd0;
            endcase
        end
    end
endmodule

