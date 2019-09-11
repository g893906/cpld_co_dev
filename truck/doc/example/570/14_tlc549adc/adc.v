module adc(clock,reset,enable,sdat_in,adc_clk,cs_n,data_ready,data_out);  
//I/O口声明
input		clock;          	//系统时钟
input 		reset;          	//复位，高电平有效
input		enable;				//转换使能
input 		sdat_in;			//TLC549串行数据输入
output 		adc_clk;			//TLC549 I/O时钟
output 		cs_n;				//TLC549 片选控制
output 		data_ready;			//指示有新的数据输出
output[7:0]	data_out;			//AD转换数据输出
//I/O寄存器
reg 		adc_clk_r;
reg 		cs_n_r;
reg 		data_ready_r;
reg[7:0]	data_out_r;			//AD转换数据输出
reg			sdat_in_r;			//数据输出锁存
//内部寄存器
reg[7:0]q;						//移位寄存器，用于接收或发送数据
reg[2:0]adc_state;     			//状态机ADC
reg[2:0]adc_next_state;
reg[5:0]bit_count;       		//移位计数器
reg 	bit_count_rst;			//ADC时钟计数器全能控制
reg  	div_clk;
reg[CLK_DIV_BITS-1:0] clk_count;//时钟分频计数器

reg buf1,buf2;
//内部信号
wire ready_done;				//cs_n拉低(大于1.4us)后的标志
wire rec_done;					//数据读取完毕的标志
wire conv_done;					//数据转换完毕的标志

//计时器参数

parameter CLK_DIV_VALUE = 31;   //ADC时钟计数器(大于404nS)计数值
parameter CLK_DIV_BITS  = 5; 	//ADC时钟计数器位宽

//状态机M1状态参数表
parameter   idle      		= 3'b000,
			adc_ready   	= 3'b001,
			adc_receive		= 3'b011,
			adc_conversion  = 3'b010,
			adc_data_load   = 3'b110;
			
//**********************************************************
//I/O寄存器输出
assign adc_clk = adc_clk_r;
assign cs_n = cs_n_r;
assign data_out = data_out_r;
assign data_ready = data_ready_r;

//同步输入数据信号
always @(posedge clock)
begin
    sdat_in_r <= sdat_in;
end

//**********************************************************
//时钟分频计数器
always @(posedge clock)
begin
	if (reset == 1'b1)           
		clk_count <= 5'd0;
	else
	begin
		if (clk_count < CLK_DIV_VALUE)
 	    begin
 	    	clk_count <= clk_count + 1'b1;
 	    	div_clk <= 1'b0;
 	    end
 	    else
 	    begin
 	    	clk_count <= 5'd0;
 	    	div_clk <= 1'b1;
 	    end
 	end
end

//**********************************************************
//状态机ADC
always @(posedge clock)
begin 
    if (reset == 1'b1) 
		adc_state <= idle;
    else 
		adc_state <= adc_next_state;
end

//ADC状态机转换逻辑
always @(adc_state or ready_done or rec_done or conv_done or enable)
begin 
	cs_n_r <= 1'b0;
	bit_count_rst <= 1'b0;
	data_ready_r <= 1'b0;
	case (adc_state)
	    idle:                 					//初始状态
	    begin
			cs_n_r <= 1'b1;
			bit_count_rst <= 1'b1;				//复位移位计数器
	        if (enable == 1'b1)
				adc_next_state <= adc_ready;
	        else
				adc_next_state <= idle;
	    end
	      
	    adc_ready:  							//准备接收
	    begin
			if(ready_done == 1'b1)
	       	 	adc_next_state <= adc_receive;
			else 
				adc_next_state <= adc_ready;
	    end
	
	    adc_receive:  							//接收数据
	    begin
			if(rec_done == 1'b1)
	       	 	adc_next_state <= adc_conversion;				
			else 
				adc_next_state <= adc_receive;
	    end

		adc_conversion:							//转换前的采样的数据
		begin
			cs_n_r <= 1'b1;
			if(conv_done == 1'b1)
	       	 	adc_next_state <= adc_data_load;
			else 
				adc_next_state <= adc_conversion;
		end 
		
		adc_data_load:
		begin
			data_ready_r <= 1'b1;				//数据输出标志
			adc_next_state <= idle;
		end
	
	    default : adc_next_state <= idle;
    endcase
end

//**********************************************************
//位移位计数器
always @(posedge clock)
begin
    if (reset == 1'b1)
		bit_count <= 6'd0;  
    else if (bit_count_rst == 1'b1) 
		bit_count <= 6'd0; 
	else if (div_clk == 1'b1)
    	bit_count <= bit_count + 1'b1;
end

assign ready_done = (bit_count == 6'd4);		//准备读取数据	
assign rec_done = (bit_count == 6'd19);			//接收数据完毕
assign conv_done = (bit_count == 6'd63);		//ADC转换完毕

//在接收位计数器4－20间8个adc clk
always @(bit_count)
begin
	if ((bit_count < 6'd20) && (bit_count >= 6'd4))
		adc_clk_r <= ~bit_count[0];
	else
		adc_clk_r <= 1'b0;
end

always @(posedge clock)
begin
	buf1 <= adc_clk_r;
	buf2 <= buf1;
end

//读取数据
always @(posedge clock)
begin
	if(buf1 && ~buf2)							//ADC时钟上升沿
		q <= {q[6:0],sdat_in_r};
	else if(data_ready_r == 1'b1)				//输出读取的数据
		data_out_r <= q;
end

endmodule