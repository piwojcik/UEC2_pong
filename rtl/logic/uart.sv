//Listing 8.4
module uart
    #( // Default setting:
       // 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
       parameter DBIT = 8,     // # data bits
                 SB_TICK = 16, // # ticks for stop bits, 16/24/32
                               // for 1/1.5/2 stop bits
                 DVSR = 163,   // baud rate divisor
                               // DVSR = 50M/(16*baud rate)
                 DVSR_BIT = 8, // # bits of DVSR
                 FIFO_W = 2    // # addr bits of FIFO
                               // # words in FIFO=2^FIFO_W
    )
    (
     input logic clk, reset,
     input logic rx,
     input logic [31:0] tbuf,
     input logic timing_tick,
     output logic tx,
     output logic [31:0] rx_buf
    );
 
    // signal declaration
    wire tick, rx_done_tick;
    logic tstart, tready;
   logic timing_tick_delay;
  //  wire [31:0] tbuf;
    wire [ 7:0] tbus;
    wire [ 7:0] rxbus;
    //body
    //delay aby wczytac nowe pozycje
    delay #(
    .WIDTH (1),
    .CLK_DEL (4) //TODO doprecyzowac 
) u_delay_count (
    .clk(clk),
    .rst(reset),
    .din(timing_tick),
    .dout(timing_tick_delay) 
);

    mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
       (.clk(clk), .reset(reset), .q(), .max_tick(tick));
 
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
       (.clk(clk), .reset(reset), .rx(rx), .s_tick(tick),
        .rx_done_tick(rx_done_tick), .dout(rxbus));

   uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
         (.clk(clk), .reset(reset), .tx_start(tstart),
         .s_tick(tick), .din(tbus),
         .tx_ready(tready), .tx(tx));

        uart_buf_rx rx_con (
            .clk    (clk   ),
            .rst (reset),
            .rxbuf   (rx_buf  ),  
            .start  (rx_done_tick ),
            .rxbus   (rxbus  )
        );

        uart_buf_tx tx_con (
            .clk    (clk   ),
            .rst    (reset),
            .tbuf   (tbuf  ),  
            .start  (timing_tick_delay ), 
            .ready  (ready ), 
            .tstart (tstart),
            .tready (tready),
            .tbus   (tbus  )
        );
 
 endmodule