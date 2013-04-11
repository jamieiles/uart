/*
 * Hacky baud rate generator to divide a 50MHz clock into a 115200 baud
 * rx/tx pair where the rx clcken oversamples by 16x.
 */
module baud_rate_gen(clk_50m, rxclk_en, txclk_en);

input clk_50m;
output rxclk_en, txclk_en;

parameter RX_ACC_MAX = 50000000 / (115200 * 16);
parameter TX_ACC_MAX = 50000000 / 115200;

wire clk_50m, rxclk_en, txclk_en;

reg [4:0] rx_acc = 0;
reg [15:0] tx_acc = 0;
wire [15:0] foo = RX_ACC_MAX;

assign rxclk_en = (rx_acc == 5'd0);
assign txclk_en = (tx_acc == 9'd0);

always @(posedge clk_50m) begin
	if (rx_acc == RX_ACC_MAX)
		rx_acc <= 0;
	else
		rx_acc <= rx_acc + 5'b1;
end

always @(posedge clk_50m) begin
	if (tx_acc == TX_ACC_MAX)
		tx_acc <= 0;
	else
		tx_acc <= tx_acc + 9'b1;
end

endmodule
