module	D_FF(
	input	i_clk,
	input	i_rst_n,
	input	i_d,
	output	o_q
);

reg o_q;

always @(negedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n)
		o_q <= 1'b0;
	else
		o_q <= i_d;
end
endmodule
