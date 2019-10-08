// ---------------------------------- testcase0.v ----------------------------
`include "timescale.v"

module testCase0();


initial
begin
  $write("\n\n");
  testHarness.reset;
  testHarness.push_sim;
  testHarness.grant_fsm;
  #10000;
  $write("Finished all tests\n");
  $stop;	

end

endmodule

