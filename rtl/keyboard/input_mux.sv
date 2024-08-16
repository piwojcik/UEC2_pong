 /**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Jurek
 *
 * Description:
 * Decode keyboard.
 */
 `timescale 1 ns / 1 ps

 module input_mux(
     input  logic clk,
     input  logic rst,
     input  logic [15:0] keycode,
     input  logic ready,
     output logic up,
     output logic down
 );
 
 /**
  * Local variables and signals
  */
 
 logic up_nxt = 0;
 logic down_nxt = 0;
 /**
  * Internal logic
  */
 always_ff @(posedge clk) begin 
    if (rst) begin
        up <= '0;
        down <= '0;
    end else begin
        up <= up_nxt;
        down <= down_nxt;
    end
 end
 
 always_comb begin 
   if(ready) begin
        up_nxt = up_nxt;
        down_nxt = down_nxt;
        if(keycode[7:0] == 'h75 ) begin
            up_nxt = 1;
        end
        if(keycode[7:0] == 'h72 ) begin
            down_nxt = 1;
        end
        if(keycode == 'hf075 ) begin
            up_nxt = 0;
        end
        if(keycode == 'hf072 ) begin
            down_nxt = 0;
        end
   end
 end
 
 endmodule
 