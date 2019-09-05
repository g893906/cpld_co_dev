module T_FF(
	input i_clk,
	input i_rst_n,
	output o_q
);
wire d;
D_FF u_DFF(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_d(d),
	.o_q(o_q)
);

not u_not(d,o_q);
endmodule
