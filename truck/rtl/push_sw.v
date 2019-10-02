`include "para_def.v"

module  push_sw(
  input i_clk,
  input i_rstn,
  input push_button,
  output  reg [`CNT_LEN-1:0] o_push_reg
);

reg   [`PIPE_LEN-1:0] pushPipe;
reg   push_flag;



always  @(posedge i_clk) begin
  if (~i_rstn) begin
    pushPipe <= {`PIPE_LEN{1'b1}};
    push_flag <= 1'b0;
    o_push_reg <= {`CNT_LEN{1'b0}};
  end

  else if(push_button && push_flag==1'b0)  pushPipe <= {`PIPE_LEN{1'b1}};

  else if(push_button && push_flag==1'b1 )  begin
    push_flag <= 1'b0;
    pushPipe  <= {`PIPE_LEN{1'b1}};
    o_push_reg <= o_push_reg + 1;
  end

  else if( (~push_button) && (push_flag!=1'b1) ) begin
    pushPipe <= pushPipe-1;//{pushPipe[`PIPE_LEN-2:0], push_button};
    if(|pushPipe[`PIPE_LEN-1:0] == 0 && push_flag!=1'b1) begin
      push_flag <= 1'b1;
    end
  end

  else pushPipe <= {`PIPE_LEN{1'b1}};

end

endmodule
