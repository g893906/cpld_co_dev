//--------------------------------------------------------------------------------------------------
//拨码开关1控制正反转，2控制启停


//-------------------------------------------------------------------------------------------------



module step_moto (StepDrive, clk, Dir, StepEnable, rst);

     

     input clk; 

     input Dir; 

     input StepEnable; 

     input rst; 

   

     output[3:0] StepDrive; 

     

     reg[3:0] StepDrive;

     reg[2:0] state; 

     reg[31:0] StepCounter = 32'b0; 

     parameter[31:0] StepLockOut = 32'd200000;             //250HZ

     reg InternalStepEnable; 



     always @(posedge clk or negedge rst)

     begin 

         if ( !rst)    

         begin 

             StepDrive      <= 4'b0;

             state    <= 3'b0;

             StepCounter <= 32'b0;

            end



         else  

         begin

             if (StepEnable == 1'b1)    InternalStepEnable <= 1'b1 ; 

             

             StepCounter <= StepCounter + 31'b1 ; 

             if (StepCounter >= StepLockOut)

             begin

                 StepCounter <= 32'b0 ; 

             

                 if (InternalStepEnable == 1'b1)

                 begin

                     InternalStepEnable <= StepEnable ; 

                     if (Dir == 1'b1)           state <= state + 3'b001 ; 

                     else if (Dir == 1'b0)       state <= state - 3'b001 ; 

                     case (state)

                         3'b000 :    StepDrive <= 4'b0001 ; 

                         3'b001 :    StepDrive <= 4'b0011 ; 

                         3'b010 :    StepDrive <= 4'b0010 ; 

                         3'b011 :    StepDrive <= 4'b0110 ; 

                         3'b100 :    StepDrive <= 4'b0100 ; 

                         3'b101 :    StepDrive <= 4'b1100 ; 

                         3'b110 :    StepDrive <= 4'b1000 ; 

                         3'b111 :    StepDrive <= 4'b1001 ;  

                     endcase 

                 end 

             end 

         end     

     end

endmodule
