module pulse
(
	input i_clk,
	input i_rst_n,
	output o_pulse
);
reg	r_pulse;
assign	o_pulse = r_pulse;

always @(posedge i_clk) begin
	if(~i_rst_n)
		r_pulse <= 1'b0;
	else begin
		r_pulse <= ~r_pulse;
	end
end

endmodule

