`include "para_def.v"
module testHarness
(
    input clk,
    input rst,
    input ckey1,
    output  pulse,
    output  push_reg_b0,
    output [3:0] carry_counter

    );

wire [3:0] push_reg;
assign push_reg_b0=push_reg[0];
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

push_sw u1_push_det (
  .i_clk(clk),
  .i_rstn(rst),
  .push_button(ckey1),
  .o_push_reg(push_reg)
);

endmodule
