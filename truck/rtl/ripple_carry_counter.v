module ripple_carry_counter(
	input i_clk,
	input i_rst_n,
	output [3:0] o_q
);

T_FF	tff0 (
	.i_clk( i_clk ),
	.i_rst_n( i_rst_n ),
	.o_q( o_q[0] )
);

T_FF	tff1(
	.i_clk(o_q[0]),
	.i_rst_n(i_rst_n),
	.o_q(o_q[1])
);

T_FF	tff2(
	.i_clk(o_q[1]),
	.i_rst_n(i_rst_n),
	.o_q(o_q[2])
);

T_FF	tff3(
	.i_clk(o_q[2]),
	.i_rst_n(i_rst_n),
	.o_q(o_q[3])
);

endmodule
