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

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		lvl<=0;
	end
	else if (pulse_in)
		lvl<=!lvl;
end
bitsync(
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
		pre_dout<=lvl_dsync
end
assign pulse_out=lvl_dsync ^ pre_dout;
