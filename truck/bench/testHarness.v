// -------------------------- testHarness.v -----------------------
`include "timescale.v"
`include "para_def.v"
module testHarness ();

reg rst;
reg clk; 
wire pulse;
wire [3:0] carry_counter;
wire [`CNT_LEN-1:0] push_reg;
reg push_sw;
reg i_req_0;
reg i_req_1;
wire    gnt_0;
wire    gnt_1;

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

push_sw u1_push_det (
  .i_clk(clk),
  .i_rstn(~rst),
  .push_button(push_sw),
  .o_push_reg(push_reg)
);

grant_fsm u1_grant_fsm (
  .i_clk(clk),
  .i_rstn(~rst),
  .i_req_0(i_req_0),
  .i_req_1(i_req_1),
  .o_gnt_0(gnt_0),
  .o_gnt_1(gnt_1)
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
  push_sw <= 1'b1;
  i_req_0<=1'b0;
  i_req_1<=1'b0;
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

task push_sim;
begin
    push_sw<=1'b0;
#10000;
    push_sw<=1'b1;
#1000;
    push_sw<=1'b1;
#10;
    push_sw<=1'b0;
#100;
    push_sw<=1'b1;
#100;
    push_sw<=1'b0;
#10000;
    push_sw<=1'b1;
end
endtask

task grant_fsm;
begin
#10000;
    i_req_0<=1'b1;
#1000;
    i_req_1<=1'b1;
#1000;
    i_req_0<=1'b0;
#1000;
    i_req_1<=1'b0;
end
endtask
endmodule
