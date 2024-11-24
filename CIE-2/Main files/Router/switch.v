module switch(
	input		rst,
	input	[7:0]	vc0_in,
	input	[7:0]	vc1_in,
	input	[7:0]	NI_in,
	input		sel_NI_out,
	input		sel_vc,
	input		sel_up,
	output	reg	[7:0]	out_down,
	output	reg	[7:0]	out_NI
);	

always@(*) begin
	if(rst) begin
		out_down	= 0;
		out_NI		= 0;
	end
	else begin
		case({sel_NI_out, sel_vc, sel_up})
			3'b010: out_down = NI_in;
			3'b011: out_down = vc1_in;
			3'b100: out_NI	 = vc0_in;
			default: begin
				out_down	= 0;
				out_NI		= 0;
			end
		endcase

	/* case({sel_NI_out, sel_vc, sel_up})
			3'b010: begin
				out_down 	= NI_in;
				out_NI		= 0;
			end

			3'b011: begin
				out_down 	= vc1_in;
				out_NI		= 0;
			end
			
			3'b100: begin
				out_NI		= vc0_in;
				out_down	= 0;
			end

			default: begin
				out_down	= 0;
				out_NI		= 0;
			end
		endcase */
	end
end

endmodule