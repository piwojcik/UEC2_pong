/**
 * MTM UEC2
 * Author: Jan Jurek
 *
 * Description:
 * score counter
 */
`timescale 1 ns / 1 ps

 module score_controller (
    input  logic clk,
    input  logic rst,
    input  logic timing_tick,
    input  logic [10:0] x_ball,
    input  logic [1:0] state,
    output  logic [3:0] player1_score,
    output  logic [3:0] player2_score
 );

 import vga_pkg::*;

 logic [3:0] player1_score_nxt;
 logic [3:0] player2_score_nxt;
 logic player1_scored = '0, player2_scored = '0;
 logic player1_scored_nxt = '0, player2_scored_nxt = '0;

 always_ff @(posedge clk)begin
    if(rst || (state == MENU_START))begin
        player1_score <= '0;
        player2_score <= '0;
        player1_scored <= '0;
        player2_scored <= '0;
    end else begin
        player1_score <= player1_score_nxt;
        player2_score <= player2_score_nxt;
        player1_scored <= player1_scored_nxt;
        player2_scored <= player2_scored_nxt;
    end
 end

 always_comb begin
 // liczenie punktow
    player1_score_nxt = player1_score;
    player2_score_nxt = player2_score;
    player2_scored_nxt = player2_scored;
    player1_scored_nxt = player1_scored;
    
    if(timing_tick) begin
        if(x_ball + BALL_SIZE <= X_PAD_LEFT)begin
            player2_scored_nxt = 1; 
        end else if(x_ball + BALL_SIZE > X_PAD_RIGHT + PAD_WIDTH)begin
            player1_scored_nxt = 1;
        
        end else if(player1_scored & player1_score < 9)begin // zabezpieczenie aby naliczyc tylko 1 punkt i max 9 punktow
            player1_score_nxt = player1_score + 1;
            player1_scored_nxt = '0;
        end else if(player2_scored & player2_score < 9)begin
            player2_score_nxt = player2_score + 1;
            player2_scored_nxt = '0;
        end
    end
 end
 endmodule
