//*******************************************************//
//                  ����������Ƶģ��                     //
//*******************************************************//
//���ܣ�������ʱ��clock����F_DIV����Ƶ�����clk_out��
//����F_DIVΪ��Ƶϵ������Ƶϵ����ΧΪ1~2^n (n=F_DIV_WIDTH)
//��Ҫ�ı��Ƶϵ�����ı����F_DIV��F_DIV_WIDTH����Ӧ��Χ���ɡ�
//����Ƶϵ��Ϊż���������ʱ��ռ�ձ�Ϊ50%��
//����Ƶϵ��Ϊ�����������ʱ��ռ�ձ�ȡ��������ʱ��ռ�ձȺͷ�
//Ƶϵ����������Ϊ50%ʱ�����Ҳ��50%����
//--------------------------------------------------------
//��������Ƶ:������Ƶ��ʱ��ͼ������ʾ��
//               1     2     3     4     5    6
//clock       |--|__|--|__|--|__|--|__|--|__|--|__|
//clk_p_r     |_____|-----------|_____|-----------| 
//clk_n_r     ---|_____|-----------|_____|---------
//clk_out     |________|--------|________|--------|

module  int_div(clock,clk_out);

//I/O������
input	clock;					//����ʱ��
output	clk_out;				//���ʱ��

//�ڲ��Ĵ���
reg	clk_p_r;					//���������ʱ��
reg clk_n_r;					//�½������ʱ��
reg[F_DIV_WIDTH - 1:0] count_p;	//���������������
reg[F_DIV_WIDTH - 1:0] count_n;	//�½������������

//����--��Ƶϵ��
parameter F_DIV = 48000000;		//��Ƶϵ��<<<<-----�޸�����
parameter F_DIV_WIDTH = 32; 	//��Ƶ���������

wire full_div_p;				//�����ؼ�������־
wire half_div_p;				//�����ؼ���������־
wire full_div_n;				//�½��ؼ�������־
wire half_div_n;				//�½��ؼ���������־

//�жϼ�����־λ��λ���
assign full_div_p = (count_p < F_DIV - 1);
assign half_div_p = (count_p < (F_DIV>>1) - 1);
assign full_div_n = (count_n < F_DIV - 1);
assign half_div_n = (count_n < (F_DIV>>1) - 1);

//ʱ�����
assign	clk_out = (F_DIV == 1) ? 
				clock : (F_DIV[0] ? (clk_p_r & clk_n_r) : clk_p_r);

//�������������
always @(posedge clock)
begin
	if(full_div_p)
	begin
		count_p <= count_p + 1'b1;
		if(half_div_p)
			clk_p_r <= 1'b0;
		else
			clk_p_r <= 1'b1;
	end
	else
	begin
		count_p <= 0;
		clk_p_r <= 1'b0;
	end
end

//�½����������
always @(negedge clock)
begin
	if(full_div_n)
	begin
		count_n <= count_n + 1'b1;
		if(half_div_n)
			clk_n_r <= 1'b0;
		else
			clk_n_r <= 1'b1;
	end
	else
	begin
		count_n <= 0;
		clk_n_r <= 1'b0;
	end
end

endmodule
