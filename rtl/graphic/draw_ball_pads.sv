`timescale 1 ns / 1 ps

module draw_ball_pads(
    input logic clk,
    input logic rst,
    // inout logic [9:0] y_ball; 
    // inout logic [9:0] x_ball;
    // inout logic [9:0] y_pad_left;
    //inout logic [9:0] y_pad_right;
    vga_intf.in game_field_in,
    vga_intf.out game_field_out 
);
localparam BALL_SIZE = 15;
import vga_pkg::*;

// Ustawienie piłki na środku ekranu -przeniesc do ball_controller
localparam [9:0] x_ball_center = (HOR_PIXELS - BALL_SIZE) / 2;
localparam [9:0] y_ball_center = (VER_PIXELS - BALL_SIZE) / 2;

logic [9:0] y_ball = y_ball_center; 
logic [9:0] x_ball = x_ball_center;

// Granice prostokąta otaczającego koło
logic [9:0] x_ball_left, x_ball_right, y_ball_top, y_ball_bottom; 
logic [3:0] rom_addr, rom_col;
logic [15:0] rom_data;
wire rom_bit;
wire sq_ball_on, ball_on;

// Definicja danych ROM dla koła
always_comb begin
    case(rom_addr)
        4'b0000: rom_data = 16'b0000000000000000; //  
        4'b0001: rom_data = 16'b0000001110000000; //     
        4'b0010: rom_data = 16'b0000011111000000; //  
        4'b0011: rom_data = 16'b0000111111100000; // 
        4'b0100: rom_data = 16'b0001111111110000; // 
        4'b0101: rom_data = 16'b0011111111111000; // 
        4'b0110: rom_data = 16'b0111111111111100; // 
        4'b0111: rom_data = 16'b1111111111111110; //   
        4'b1000: rom_data = 16'b1111111111111110; //     
        4'b1001: rom_data = 16'b1111111111111110; //  
        4'b1010: rom_data = 16'b0111111111111100; // 
        4'b1011: rom_data = 16'b0011111111111000; // 
        4'b1100: rom_data = 16'b0001111111110000; // 
        4'b1101: rom_data = 16'b0000111111100000; // 
        4'b1110: rom_data = 16'b0000011111000000; //  
        4'b1111: rom_data = 16'b0000001110000000; //   
    endcase
end 

// Granice prostokąta otaczającego koło
assign x_ball_left = x_ball;
assign y_ball_top = y_ball;
assign x_ball_right = x_ball_left + BALL_SIZE;
assign y_ball_bottom = y_ball_top + BALL_SIZE;

// Piksel w granicach prostokąta
assign sq_ball_on = (x_ball_left <= game_field_in.hcount) && (game_field_in.hcount <= x_ball_right) &&
                    (y_ball_top <= game_field_in.vcount) && (game_field_in.vcount <= y_ball_bottom);

// Adresowanie ROM dla piksela
assign rom_addr = game_field_in.vcount[3:0] - y_ball_top[3:0];   // 4-bitowy adres
assign rom_col = game_field_in.hcount[3:0] - x_ball_left[3:0];    // 4-bitowy indeks kolumny
assign rom_bit = rom_data[rom_col];         // 1-bitowy sygnał danych ROM

// Piksel wewnątrz koła
assign ball_on = sq_ball_on & rom_bit;      // granice prostokąta AND bit danych ROM

//Rysowanie padów
logic [9:0] x_pad_right = 979; 
logic [9:0] y_pad_right = 312;

logic [9:0] x_pad_left = 30;
logic [9:0] y_pad_left = 312;
localparam PAD_HIGHT = 145; 
localparam PAD_WIDTH = 15;   

// wire pad_on;
assign pads_on = ((game_field_in.hcount >= x_pad_right) && (game_field_in.hcount <= x_pad_right + PAD_WIDTH)
                  && (game_field_in.vcount >= y_pad_right) && (game_field_in.vcount <= y_pad_right + PAD_HIGHT))
                  || ((game_field_in.hcount >= x_pad_left) && (game_field_in.hcount <= x_pad_left + PAD_WIDTH)
                  && (game_field_in.vcount >= y_pad_left) && (game_field_in.vcount <= y_pad_left + PAD_HIGHT));


delay #(
    .WIDTH (22),
    .CLK_DEL (2)
) u_delay_count (
        .clk,
        .rst,
        .din({game_field_in.vcount, game_field_in.hcount}),
        .dout({game_field_out.vcount, game_field_out.hcount}) 
    );

delay #(
    .WIDTH (4),
    .CLK_DEL (2)
    ) u_delay_control (
        .clk,
        .rst,
        .din({game_field_in.vsync, game_field_in.vblnk, game_field_in.hsync, game_field_in.hblnk}),
        .dout({game_field_out.vsync, game_field_out.vblnk, game_field_out.hsync, game_field_out.hblnk}) 
);

logic [11:0] rgb_nxt;
logic [11:0] ball_rgb = 12'hF_F_F;

always_comb begin
   if(game_field_in.vblnk || game_field_in.hblnk) begin
      rgb_nxt = 12'h0_0_0;
   end else if(ball_on || pads_on ) begin 
      rgb_nxt = ball_rgb;
   end else begin
      rgb_nxt = game_field_in.rgb;
   end
end

always_ff @(posedge clk) begin
   if(rst) begin
      game_field_out.rgb <= 12'h0_0_0;
   end else begin
      game_field_out.rgb <= rgb_nxt;
   end 
end



endmodule
