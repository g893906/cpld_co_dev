module scan_led(clk_1k,d,dig,seg);		//ģ����scan_led
input clk_1k;							//����ʱ��
input[31:0] d;							//����Ҫ��ʾ������
output[7:0]	dig;						//�����ѡ���������
output[7:0] seg;						//����ܶ��������

reg[7:0] seg_r;							//�������������Ĵ���
reg[7:0] dig_r;							//���������ѡ������Ĵ���
reg[3:0] disp_dat;						//������ʾ���ݼĴ���
reg[2:0]count;							//��������Ĵ���

assign dig = dig_r;						//��������ѡ��
assign seg = seg_r;						//��������������	

always @(posedge clk_1k)   				//���������ش�������
begin
	count <= count + 1'b1;
end

always @(posedge clk_1k)   						
begin
	case(count)							//ѡ��ɨ����ʾ����
		3'd0:disp_dat = d[31:28];		//��һ�������
		3'd1:disp_dat = d[27:24];		//�ڶ��������
		3'd2:disp_dat = d[23:20];		//�����������
		3'd3:disp_dat = d[19:16];		//���ĸ������
		3'd4:disp_dat = d[15:12];		//����������
		3'd5:disp_dat = d[11:8];		//�����������
		3'd6:disp_dat = d[7:4];			//���߸������
		3'd7:disp_dat = d[3:0];			//�ڰ˸������
	endcase
	case(count)							//ѡ���������ʾλ
		3'd0:dig_r = 8'b01111111;		//ѡ���һ���������ʾ
		3'd1:dig_r = 8'b10111111;		//ѡ��ڶ����������ʾ
		3'd2:dig_r = 8'b11011111;		//ѡ��������������ʾ
		3'd3:dig_r = 8'b11101111;		//ѡ����ĸ��������ʾ
		3'd4:dig_r = 8'b11110111;		//ѡ�������������ʾ
		3'd5:dig_r = 8'b11111011;		//ѡ��������������ʾ
		3'd6:dig_r = 8'b11111101;		//ѡ����߸��������ʾ
		3'd7:dig_r = 8'b11111110;		//ѡ��ڰ˸��������ʾ
	endcase	
end

always @(disp_dat)
begin
	case(disp_dat)						//�߶�����
		4'h0:seg_r = 8'hc0;				//��ʾ0
		4'h1:seg_r = 8'hf9;				//��ʾ1
		4'h2:seg_r = 8'ha4;				//��ʾ2
		4'h3:seg_r = 8'hb0;				//��ʾ3
		4'h4:seg_r = 8'h99;				//��ʾ4
		4'h5:seg_r = 8'h92;				//��ʾ5
		4'h6:seg_r = 8'h82;				//��ʾ6
		4'h7:seg_r = 8'hf8;				//��ʾ7
		4'h8:seg_r = 8'h80;				//��ʾ8
		4'h9:seg_r = 8'h90;				//��ʾ9
		4'ha:seg_r = 8'h88;				//��ʾa
		4'hb:seg_r = 8'h83;				//��ʾb
		4'hc:seg_r = 8'hc6;				//��ʾc
		4'hd:seg_r = 8'ha1;				//��ʾd
		4'he:seg_r = 8'h86;				//��ʾe
		4'hf:seg_r = 8'h8e;				//��ʾf
	endcase
end
endmodule