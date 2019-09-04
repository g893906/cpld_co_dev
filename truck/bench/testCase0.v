// ---------------------------------- testcase0.v ----------------------------
`include "timescale.v"

module testCase0();


initial
begin
  $write("\n\n");
  testHarness.reset;
  #1000;


  $write("Finished all tests\n");
  $stop;	

end

endmodule

