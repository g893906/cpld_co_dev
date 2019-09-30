module pulse
(
	input i_clk,
	input i_rst_n,
	output o_pulse
);
reg	r_pulse;
assign	o_pulse = r_pulse;
reg [3:0] div;
always @(posedge i_clk) begin
	if(~i_rst_n) begin
		r_pulse <= 1'b0;
        div     <= 4'b0000;
    end

	else if(div==4'b1111)begin
		r_pulse <= ~r_pulse;
        div <= 4'b0000;
    end

    else
        div <= div+1;
end

endmodule

