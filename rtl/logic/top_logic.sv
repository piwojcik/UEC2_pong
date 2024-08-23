/**
 * MTM UEC2
 * Author: Piotr Wojcik
 *
 * Description:
 * Top logic with FSM
 */

 `timescale 1 ns / 1 ps

 module top_logic (
     input  logic clk,
     input  logic rst,
     input  logic timing_tick,
     input  logic up,
     input  logic down,
     output  logic [10:0] x_ball,
     output  logic [9:0] y_ball,
     output logic still_graphic,
    //  input  logic up_2,
    //  input  logic down_2,

     output logic [9:0] y_player_1,
    //  output logic [9:0] y_player_2,
     output logic [3:0] player1_score,
     output logic [3:0] player2_score
 );

 //signals
 wire [10:0] x_ball_n;
 wire [10:0] y_ball_n;
 logic [1:0] state, state_nxt;

 //submodules

ball_controller u_ball_controller(
    .clk,
    .rst,
    .timing_tick,
    .y_pad_right(), //y_player_2
    .y_pad_left(y_player_1),
    .y_ball(y_ball),
    .x_ball(x_ball),
    .still_graphic
);

player_pad_controller u_player_pad_controller (
    .clk,
    .rst,
    .timing_tick,
    .up_in(up),
    .down_in(down),
    .y_pad(y_player_1),
    .still_graphic
);

score_controller  u_score_controller(
    .clk,
    .rst,
    .timing_tick,
    .x_ball,
    .state,
    .player1_score,
    .player2_score
  );


// logic [2:0] score_1 = 0;
// logic [2:0] score_2 = 0;

// localparam menu_start = 2'b00;
// localparam play = 2'b01;
// localparam game_over = 2'b10;
import vga_pkg::*;

always_ff @(posedge clk) begin
    if(rst) begin
        state <= menu_start;
    end else begin
        state <= state_nxt;
    end
end

always_comb begin
    // Domyślnie przypisanie obecnego stanu do następnego
    state_nxt = state;
    case(state)
        menu_start: begin
            still_graphic = 1'b1;
            if(up) begin
                state_nxt = play;
            end
        end
        play: begin
            still_graphic = 1'b0;
            if((player1_score >= 5) || (player2_score >= 5)) begin
                state_nxt = game_over;
            end
        end
        game_over: begin
            still_graphic = 1'b1;
            if(down) begin         
                state_nxt = menu_start;
            end
        end
        default: begin
            still_graphic = 1'b1;
            state_nxt = menu_start; // Bezpieczne ustawienie domyślnego stanu
        end
    endcase
end

 endmodule