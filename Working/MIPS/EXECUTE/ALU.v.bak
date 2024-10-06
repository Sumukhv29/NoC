module ALU(
	input		[3:0]	ALU_control_E,
	input		[31:0]	rd1_E,
	input		[31:0]	srcB_E,
	output			ZERO,
	output	reg	[31:0]	ALU_result_E
);

always @(*) begin
	case(ALU_control_E)
		4'b0000: ALU_result_E = rd1_E + srcB_E;
		default: ALU_result_E = 32'dx;
	endcase
end

endmodule