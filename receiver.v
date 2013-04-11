module receiver(rx, rdy, rdy_clr, clk_50m, clken, data);

input rx, clk_50m, clken, rdy_clr;
output rdy;
output [7:0] data;

wire rx, clk_50m, clken, rdy_clr;
reg rdy = 0;
reg [7:0] data = 8'b0;
reg [7:0] scratch = 8'b0;

parameter RX_STATE_START	= 2'b00;
parameter RX_STATE_DATA		= 2'b01;
parameter RX_STATE_STOP		= 2'b10;

reg [1:0] state = RX_STATE_START;
reg [3:0] sample = 0;
reg [3:0] bitpos = 0;

always @(posedge clk_50m) begin
	if (rdy_clr)
		rdy <= 0;

	if (clken) begin
		case (state)
		RX_STATE_START: begin
			/*
			* Start counting from the first low sample, once we've
			* sampled a full bit, start collecting data bits.
			*/
			if (!rx || sample != 0)
				sample <= sample + 4'b1;

			if (sample == 15) begin
				state <= RX_STATE_DATA;
				bitpos <= 0;
				sample <= 0;
				scratch <= 0;
			end
		end
		RX_STATE_DATA: begin
			sample <= sample + 4'b1;
			if (sample == 4'h8) begin
				scratch[bitpos] <= rx;
				bitpos <= bitpos + 4'b1;
			end
			if (bitpos == 8 && sample == 15)
				state <= RX_STATE_STOP;
		end
		RX_STATE_STOP: begin
			/*
			 * Our baud clock may not be running at exactly the
			 * same rate as the transmitter.  If we thing that
			 * we're at least half way into the stop bit, allow
			 * transition into handling the next start bit.
			 */
			if (sample == 15 || (sample >= 8 && !rx)) begin
				state = RX_STATE_START;
				data <= scratch;
				rdy <= 1'b1;
				sample <= 0;
			end else begin
				sample <= sample + 4'b1;
			end
		end
		endcase
	end
end

endmodule
