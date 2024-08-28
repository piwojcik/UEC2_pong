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
    logic [2:0] sel=0;
    logic [31:0] rxbuf_nxt=0;
    logic running=0;
    logic done;
    
    always_ff @(posedge clk) begin
        if(rst)begin
            rxbuf <= 'b0;
        end else begin
            if(done) begin
                rxbuf <= rxbuf_nxt;
            end
        end
    end

    always_comb begin
        done = '0;
        if(start)begin
            if (running == 1'b1) begin
                if (sel == 4'd1) begin
                    running = 1'b0;
                    sel = 4;
                    done = 1;
                end else begin
                    sel = sel - 1'b1;
                    running = 1'b1;
                end
            end else begin
                    running = start;
                    sel = 4;
                    rxbuf_nxt = 32'b0;
            end
        end 
    end
    


    always_comb begin
        if(start) begin
            case (sel)
                3'd1: rxbuf_nxt[31:24] = rxbus;
                3'd2: rxbuf_nxt[23:16] = rxbus;
                3'd3: rxbuf_nxt[15:8] = rxbus;
                3'd4: rxbuf_nxt[7:0] = rxbus;
                3'd5: rxbuf_nxt[7:0] = rxbus;
                default: rxbuf_nxt = 32'd0;
            endcase
        end
    end
endmodule

