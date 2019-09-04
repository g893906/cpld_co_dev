module  dly_n(clk,rst,d,q);
input     clk;
input     rst;
input     d;
output    q;

parameter n=3;
reg [n-1:0] dly_q;
assign  q=dly_q[n-1];

always  @(posedge clk)
begin
  if(rst==1'b1)
    dly_q <=  0;
  else
    dly_q <=  {dly_q[n-2:0],d};
end

endmodule
