//*******************************************************//
//                  任意整数分频模块                     //
//*******************************************************//
//功能：对输入时钟clock进行F_DIV倍分频后输出clk_out。
//其中F_DIV为分频系数，分频系数范围为1~2^n (n=F_DIV_WIDTH)
//若要改变分频系数，改变参数F_DIV或F_DIV_WIDTH到相应范围即可。
//若分频系数为偶数，则输出时钟占空比为50%；
//若分频系数为奇数，则输出时钟占空比取决于输入时钟占空比和分
//频系数（当输入为50%时，输出也是50%）。
//--------------------------------------------------------
//奇数倍分频:三倍分频的时序图如下所示。
//               1     2     3     4     5    6
//clock       |--|__|--|__|--|__|--|__|--|__|--|__|
//clk_p_r     |_____|-----------|_____|-----------| 
//clk_n_r     ---|_____|-----------|_____|---------
//clk_out     |________|--------|________|--------|

module  int_div(clock,clk_out);

//I/O口声明
input	clock;					//输入时钟
output	clk_out;				//输出时钟

//内部寄存器
reg	clk_p_r;					//上升沿输出时钟
reg clk_n_r;					//下降沿输出时钟
reg[F_DIV_WIDTH - 1:0] count_p;	//上升沿脉冲计数器
reg[F_DIV_WIDTH - 1:0] count_n;	//下降沿脉冲计数器

//参数--分频系数
parameter F_DIV = 48000000;		//分频系数<<<<-----修改这里
parameter F_DIV_WIDTH = 32; 	//分频计数器宽度

wire full_div_p;				//上升沿计数满标志
wire half_div_p;				//上升沿计数半满标志
wire full_div_n;				//下降沿计数满标志
wire half_div_n;				//下降沿计数半满标志

//判断计数标志位置位与否
assign full_div_p = (count_p < F_DIV - 1);
assign half_div_p = (count_p < (F_DIV>>1) - 1);
assign full_div_n = (count_n < F_DIV - 1);
assign half_div_n = (count_n < (F_DIV>>1) - 1);

//时钟输出
assign	clk_out = (F_DIV == 1) ? 
				clock : (F_DIV[0] ? (clk_p_r & clk_n_r) : clk_p_r);

//上升沿脉冲计数
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

//下降沿脉冲计数
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
