module  grant_fsm(
  input     i_clk,
  input     i_rstn,
  input     i_req_0,
  input     i_req_1,
  output    o_gnt_0,
  output    o_gnt_1
);

// output ports type
reg     o_gnt_0;
reg     o_gnt_1;

// Internal Constants
parameter   SIZE = 3;
parameter   IDLE = 3'b001;
parameter   GNT0 = 3'b010;
parameter   GNT1 = 3'b100;

// Internal Variables
reg [SIZE-1:0]  state;
reg [SIZE-1:0]  next_state;

// Code start here
always  @(state or i_req_0 or i_req_1)
begin: FSM_COMBO
    next_state = 3'b000;
    case(state)
        IDLE: if( i_req_0 == 1'b1 ) begin
                next_state = GNT0;
              end
              else if( i_req_1 == 1'b1 ) begin
                    next_state = GNT1;
              end
              else  next_state = IDLE;

        GNT0: if( i_req_0 == 1'b1 ) begin
                next_state = GNT0;
              end
              else begin
                next_state = IDLE;
              end

        GNT1: if( i_req_1 == 1'b1 ) begin
                next_state = GNT1;
              end
              else begin
                next_state = IDLE;
              end

        default: next_state = IDLE;
    endcase
end

// Seq Logic
always @(posedge i_clk)
begin: SEQ_LOGIC
    if( ~i_rstn )
        state <= IDLE;
    else
        state <= next_state;
end

// Output Logic
always @(posedge i_clk)
begin: OUTPUT_LOGIC
    if( ~i_rstn )   begin
        o_gnt_0 <= 1'b0;
        o_gnt_1 <= 1'b0;
    end
    else begin
        case(state)
            IDLE:begin
                    o_gnt_0   <=  1'b0;
                    o_gnt_1   <=  1'b0;
                 end
            GNT0:begin
                    o_gnt_0   <=  1'b1;
                    o_gnt_1   <=  1'b0;
                 end
            GNT1:begin
                    o_gnt_0   <=  1'b0;
                    o_gnt_1   <=  1'b1;
                 end
            default: begin
                    o_gnt_0   <=  1'b0;
                    o_gnt_1   <=  1'b0;
                 end
        endcase
    end
end

endmodule
