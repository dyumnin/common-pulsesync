/* Assumption that the source does not change until the pulse is latched at
* the destination. */
module pulsesync (
	input wire pulse_in,
	input wire sclk,
	input wire srst_n,
	input wire dclk,
	input wire drst_n,
	output wire pulse_out
);
reg lvl,pre_dout;
always @(posedge sclk or negedge srst_n)
begin
	if(!srst_n)begin
		lvl<=0;
	end
	else if (pulse_in)
		lvl<=!lvl;
end
bitsync BS(
	.clk(dclk),
	.rst_n(drst_n),
	.din(lvl),
	.dout(lvl_dsync)
);
always @(posedge dclk or negedge drst_n)
begin
	if(!drst_n)
		pre_dout<=1'b0;
	else
		pre_dout<=lvl_dsync;
end
assign pulse_out=lvl_dsync ^ pre_dout;
endmodule
