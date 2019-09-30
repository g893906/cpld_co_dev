module testHarness
(
    input clk,
    input rst,
    output  pulse,
    output [3:0] carry_counter

    );

pulse	u1_pulse(
  .i_clk(clk),
  .i_rst_n(rst),
  .o_pulse(pulse)
  );

ripple_carry_counter u1_carry_counter (
	.i_clk(pulse),
	.i_rst_n(rst),
	.o_q(carry_counter)
);

endmodule
