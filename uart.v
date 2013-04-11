`include "receiver.v"
`include "transmitter.v"
`include "baudgen.v"

module uart(din, wr_en, clk_50m, tx, tx_busy, rx, rdy, rdy_clr, dout);

input [7:0] din;
input wr_en, clk_50m, rx, rdy_clr;
output tx, tx_busy, rdy;
output [7:0] dout;

wire [7:0] din;
wire clk_50m, tx, tx_busy, rx, rdy_clr;

wire rxclk_en, txclk_en;

baud_rate_gen uart_baud(.clk_50m(clk_50m),
			.rxclk_en(rxclk_en),
			.txclk_en(txclk_en));
transmitter uart_tx(.din(din),
		    .wr_en(wr_en),
		    .clk_50m(clk_50m),
		    .clken(txclk_en),
		    .tx(tx),
		    .tx_busy(tx_busy));
receiver uart_rx(.rx(rx),
		 .rdy(rdy),
		 .rdy_clr(rdy_clr),
		 .clk_50m(clk_50m),
		 .clken(rxclk_en),
		 .data(dout));

endmodule
