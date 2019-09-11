/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   读取按键信号实验
********************************************************************/


module key_led(key,led);//
input[6:1]key;
output[6:1]led;
reg[6:1]led_r;
reg[6:1]buffer;
assign led=led_r;

always@(key)
begin
	buffer=key;
	case(buffer)
		6'b111110:led_r=6'b111110;//如果按下的是key1,那么点亮LED1
		6'b111101:led_r=6'b111100;//如果按下的是key2,那么点亮LED1-LED2
		6'b111011:led_r=6'b111000;//key3
		6'b110111:led_r=6'b110000;//key4
	   6'b101111:led_r=6'b100000;//key5
	   6'b011111:led_r=6'b000000;//key6
	    
		default:led_r=6'b111111;
	endcase
end
endmodule