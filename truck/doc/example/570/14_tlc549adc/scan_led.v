module scan_led(clk_1k,d,dig,seg);		//模块名scan_led
input clk_1k;							//输入时钟
input[31:0] d;							//输入要显示的数据
output[7:0]	dig;						//数码管选择输出引脚
output[7:0] seg;						//数码管段输出引脚

reg[7:0] seg_r;							//定义数码管输出寄存器
reg[7:0] dig_r;							//定义数码管选择输出寄存器
reg[3:0] disp_dat;						//定义显示数据寄存器
reg[2:0]count;							//定义计数寄存器

assign dig = dig_r;						//输出数码管选择
assign seg = seg_r;						//输出数码管译码结果	

always @(posedge clk_1k)   				//定义上升沿触发进程
begin
	count <= count + 1'b1;
end

always @(posedge clk_1k)   						
begin
	case(count)							//选择扫描显示数据
		3'd0:disp_dat = d[31:28];		//第一个数码管
		3'd1:disp_dat = d[27:24];		//第二个数码管
		3'd2:disp_dat = d[23:20];		//第三个数码管
		3'd3:disp_dat = d[19:16];		//第四个数码管
		3'd4:disp_dat = d[15:12];		//第五个数码管
		3'd5:disp_dat = d[11:8];		//第六个数码管
		3'd6:disp_dat = d[7:4];			//第七个数码管
		3'd7:disp_dat = d[3:0];			//第八个数码管
	endcase
	case(count)							//选择数码管显示位
		3'd0:dig_r = 8'b01111111;		//选择第一个数码管显示
		3'd1:dig_r = 8'b10111111;		//选择第二个数码管显示
		3'd2:dig_r = 8'b11011111;		//选择第三个数码管显示
		3'd3:dig_r = 8'b11101111;		//选择第四个数码管显示
		3'd4:dig_r = 8'b11110111;		//选择第五个数码管显示
		3'd5:dig_r = 8'b11111011;		//选择第六个数码管显示
		3'd6:dig_r = 8'b11111101;		//选择第七个数码管显示
		3'd7:dig_r = 8'b11111110;		//选择第八个数码管显示
	endcase	
end

always @(disp_dat)
begin
	case(disp_dat)						//七段译码
		4'h0:seg_r = 8'hc0;				//显示0
		4'h1:seg_r = 8'hf9;				//显示1
		4'h2:seg_r = 8'ha4;				//显示2
		4'h3:seg_r = 8'hb0;				//显示3
		4'h4:seg_r = 8'h99;				//显示4
		4'h5:seg_r = 8'h92;				//显示5
		4'h6:seg_r = 8'h82;				//显示6
		4'h7:seg_r = 8'hf8;				//显示7
		4'h8:seg_r = 8'h80;				//显示8
		4'h9:seg_r = 8'h90;				//显示9
		4'ha:seg_r = 8'h88;				//显示a
		4'hb:seg_r = 8'h83;				//显示b
		4'hc:seg_r = 8'hc6;				//显示c
		4'hd:seg_r = 8'ha1;				//显示d
		4'he:seg_r = 8'h86;				//显示e
		4'hf:seg_r = 8'h8e;				//显示f
	endcase
end
endmodule