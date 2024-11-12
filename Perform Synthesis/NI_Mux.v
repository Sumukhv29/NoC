module NI_Mux(
	input		[31:0]	ALU_OUT,
	input			alu_out_E,
	output	reg	[31:0]	ALU_result_E,
	output	reg	[31:0]	NI_in
);

always @(*) begin
	case(alu_out_E)
		0: begin
			ALU_result_E	= ALU_OUT;
			NI_in 		= 0;
		end

		1: begin
			NI_in 		= ALU_OUT;
			ALU_result_E 	= ALU_OUT;
		end
	
		default: ALU_result_E	= ALU_OUT;
	endcase
end

endmodule