`timescale 1 ns / 1 ns


module spidac(clk, Reset, dac_sclk, DAC_nCS, dac_din);
   input            clk;
   input            Reset;
   output           dac_sclk;
   output           DAC_nCS;
   output           dac_din;
   
   reg [11:0]       shift_reg;
   parameter [11:0] DAC_HIGH = 12'b111111111100;
   parameter [11:0] DAC_LOW =  12'b111111111100;
   reg              loadH;
   
   reg [3:0]        state;
   
   parameter [3:0]  IDLE = 4'b0010;
   parameter [3:0]  LOAD = 4'b0110;
   parameter [3:0]  CSDAC = 4'b0000;
   parameter [3:0]  TxD0 = 4'b0001;
   parameter [3:0]  TxD1 = 4'b0101;
   parameter [3:0]  TXD2 = 4'b0100;
   parameter [3:0]  shift = 4'b1000;
   parameter [3:0]  spiend1 = 4'b1100;
   parameter [3:0]  spiend2 = 4'b1010;
   
   reg              wait_on;
   reg [2:0]        wait_cnt;
   
   reg              clkdiv2;
   reg              clkdiv4;
   
   reg [3:0]        bit_cnt;
   
   
   always @(posedge clk or negedge Reset)
      if (Reset == 1'b0)
         clkdiv2 <= 1'b0;
      else 
         clkdiv2 <= (~clkdiv2);
   
   
   always @(posedge clkdiv2 or negedge Reset)
      if (Reset == 1'b0)
         clkdiv4 <= 1'b0;
      else 
         clkdiv4 <= (~clkdiv4);
   
   
   always @(negedge Reset or posedge clkdiv4)
   begin: xhdl0
      integer          i;
      if (Reset == 1'b0)
      begin
         bit_cnt <= 4'b0000;
         state <= IDLE;
         loadH <= 1'b1;
         wait_on <= 1'b0;
      end
      else 
         case (state)
            IDLE :
               state <= LOAD;
            LOAD :
               begin
                  state <= CSDAC;
                  bit_cnt <= 4'b0000;
                  if (loadH == 1'b1)
                     shift_reg <= DAC_HIGH;
                  else
                     shift_reg <= DAC_LOW;
               end
            CSDAC :
               state <= TxD0;
            TxD0 :
               begin
                  state <= TxD1;
                  bit_cnt <= bit_cnt + 1;
               end
            TxD1 :
               state <= shift;
            shift :
               begin
                  state <= TXD2;
                  for (i = 11; i >= 1; i = i - 1)
                     shift_reg[i] <= shift_reg[i - 1];
                  shift_reg[0] <= 1'b0;
               end
            TXD2 :
               if (bit_cnt == 4'b1100)
                  state <= spiend1;
               else
                  state <= TxD0;
            spiend1 :
               begin
                  state <= spiend2;
                  wait_on <= 1'b1;
               end
            spiend2 :
               if (wait_cnt == 3'b111)
               begin
                  state <= LOAD;
                  wait_on <= 1'b0;
                  loadH <= (~loadH);
               end
            default :
               state <= IDLE;
         endcase
   end
   
   
   always @(negedge Reset or negedge clkdiv4)
      if (Reset == 1'b0)
         wait_cnt <= 3'b000;
      else 
      begin
         if (wait_on == 1'b1)
            wait_cnt <= wait_cnt + 1;
         else
            wait_cnt <= 3'b000;
      end
   
   assign dac_din = shift_reg[11];
   assign dac_sclk = state[0];
   assign DAC_nCS = state[1];
   
endmodule
