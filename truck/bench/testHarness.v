// -------------------------- testHarness.v -----------------------
`include "timescale.v"

module testHarness ();

reg rst;
reg clk; 
wire pulse;
wire [3:0] carry_counter;

initial begin
$dumpfile("wave.vcd");
$dumpvars(0, testHarness); 
end

pulse	u1_pulse(
  .i_clk(clk),
  .i_rst_n(~rst),
  .o_pulse(pulse)
  );

ripple_carry_counter u1_carry_counter (
	.i_clk(pulse),
	.i_rst_n(~rst),
	.o_q(carry_counter)
);

// ******************************  Clock section  ******************************
//approx 48MHz clock
`define CLK_HALF_PERIOD 10
always begin
  #`CLK_HALF_PERIOD clk <= 1'b0;
  #`CLK_HALF_PERIOD clk <= 1'b1;
end


// ******************************  reset  ****************************** 
task reset;
begin
  rst <= 1'b1;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  rst <= 1'b0;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
end
endtask

endmodule
