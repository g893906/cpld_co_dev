module adc(clock,reset,enable,sdat_in,adc_clk,cs_n,data_ready,data_out);  
//I/O������
input		clock;          	//ϵͳʱ��
input 		reset;          	//��λ���ߵ�ƽ��Ч
input		enable;				//ת��ʹ��
input 		sdat_in;			//TLC549������������
output 		adc_clk;			//TLC549 I/Oʱ��
output 		cs_n;				//TLC549 Ƭѡ����
output 		data_ready;			//ָʾ���µ��������
output[7:0]	data_out;			//ADת���������
//I/O�Ĵ���
reg 		adc_clk_r;
reg 		cs_n_r;
reg 		data_ready_r;
reg[7:0]	data_out_r;			//ADת���������
reg			sdat_in_r;			//�����������
//�ڲ��Ĵ���
reg[7:0]q;						//��λ�Ĵ��������ڽ��ջ�������
reg[2:0]adc_state;     			//״̬��ADC
reg[2:0]adc_next_state;
reg[5:0]bit_count;       		//��λ������
reg 	bit_count_rst;			//ADCʱ�Ӽ�����ȫ�ܿ���
reg  	div_clk;
reg[CLK_DIV_BITS-1:0] clk_count;//ʱ�ӷ�Ƶ������

reg buf1,buf2;
//�ڲ��ź�
wire ready_done;				//cs_n����(����1.4us)��ı�־
wire rec_done;					//���ݶ�ȡ��ϵı�־
wire conv_done;					//����ת����ϵı�־

//��ʱ������

parameter CLK_DIV_VALUE = 31;   //ADCʱ�Ӽ�����(����404nS)����ֵ
parameter CLK_DIV_BITS  = 5; 	//ADCʱ�Ӽ�����λ��

//״̬��M1״̬������
parameter   idle      		= 3'b000,
			adc_ready   	= 3'b001,
			adc_receive		= 3'b011,
			adc_conversion  = 3'b010,
			adc_data_load   = 3'b110;
			
//**********************************************************
//I/O�Ĵ������
assign adc_clk = adc_clk_r;
assign cs_n = cs_n_r;
assign data_out = data_out_r;
assign data_ready = data_ready_r;

//ͬ�����������ź�
always @(posedge clock)
begin
    sdat_in_r <= sdat_in;
end

//**********************************************************
//ʱ�ӷ�Ƶ������
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
//״̬��ADC
always @(posedge clock)
begin 
    if (reset == 1'b1) 
		adc_state <= idle;
    else 
		adc_state <= adc_next_state;
end

//ADC״̬��ת���߼�
always @(adc_state or ready_done or rec_done or conv_done or enable)
begin 
	cs_n_r <= 1'b0;
	bit_count_rst <= 1'b0;
	data_ready_r <= 1'b0;
	case (adc_state)
	    idle:                 					//��ʼ״̬
	    begin
			cs_n_r <= 1'b1;
			bit_count_rst <= 1'b1;				//��λ��λ������
	        if (enable == 1'b1)
				adc_next_state <= adc_ready;
	        else
				adc_next_state <= idle;
	    end
	      
	    adc_ready:  							//׼������
	    begin
			if(ready_done == 1'b1)
	       	 	adc_next_state <= adc_receive;
			else 
				adc_next_state <= adc_ready;
	    end
	
	    adc_receive:  							//��������
	    begin
			if(rec_done == 1'b1)
	       	 	adc_next_state <= adc_conversion;				
			else 
				adc_next_state <= adc_receive;
	    end

		adc_conversion:							//ת��ǰ�Ĳ���������
		begin
			cs_n_r <= 1'b1;
			if(conv_done == 1'b1)
	       	 	adc_next_state <= adc_data_load;
			else 
				adc_next_state <= adc_conversion;
		end 
		
		adc_data_load:
		begin
			data_ready_r <= 1'b1;				//���������־
			adc_next_state <= idle;
		end
	
	    default : adc_next_state <= idle;
    endcase
end

//**********************************************************
//λ��λ������
always @(posedge clock)
begin
    if (reset == 1'b1)
		bit_count <= 6'd0;  
    else if (bit_count_rst == 1'b1) 
		bit_count <= 6'd0; 
	else if (div_clk == 1'b1)
    	bit_count <= bit_count + 1'b1;
end

assign ready_done = (bit_count == 6'd4);		//׼����ȡ����	
assign rec_done = (bit_count == 6'd19);			//�����������
assign conv_done = (bit_count == 6'd63);		//ADCת�����

//�ڽ���λ������4��20��8��adc clk
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

//��ȡ����
always @(posedge clock)
begin
	if(buf1 && ~buf2)							//ADCʱ��������
		q <= {q[6:0],sdat_in_r};
	else if(data_ready_r == 1'b1)				//�����ȡ������
		data_out_r <= q;
end

endmodule