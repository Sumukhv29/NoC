module crossbar_switch(
	input		[7:0]	vc0_in,
	input		[7:0]	vc1_in,
	input		[7:0]	NI_in,
	input			sel_up,	//1 => up stream to down stream and 0 => NI to up stream
	input			sel_vc,
	input			sel_NI,
	output	reg	[7:0]	out_down,
	output	reg	[7:0] 	out_NI
);

always@(*) begin 
	out_down 	= 8'd0;
	out_NI		= 8'd0;

	case({sel_up, sel_vc, sel_NI})
		3'b100: out_down 	= vc0_in;
		3'b110:	out_down 	= vc1_in;
		3'b000: out_NI		= vc0_in;
		3'b010:	out_NI		= vc1_in;
		3'b001: out_down	= NI_in;
		default: begin
			out_down 	= 8'd0;
			out_NI		= 8'd0;
		end
	endcase
end

endmodule 


