module ALU(
	input		[3:0]	ALU_control_E,
	input		[31:0]	rd1_E,
	input		[31:0]	srcB_E,
	output			ZERO,
	output	reg	[31:0]	ALU_result_E
);

always @(*) begin
	case(ALU_control_E)
		4'b0001: ALU_result_E = rd1_E + srcB_E;   
		4'b0010: ALU_result_E = rd1_E - srcB_E;   
		4'b0011: ALU_result_E = rd1_E * srcB_E;   
		4'b0100: ALU_result_E = rd1_E / srcB_E;   
		4'b0101: ALU_result_E = rd1_E & srcB_E;   
		4'b0110: ALU_result_E = rd1_E | srcB_E;   
		4'b0111: ALU_result_E = rd1_E ^ srcB_E;   
		4'b1000: ALU_result_E = ~rd1_E;           
		4'b1001: ALU_result_E = rd1_E << 3;  
		4'b1010: ALU_result_E = rd1_E >> 3;
		4'b1011: ALU_result_E = srcB_E << 3;  
		4'b1100: ALU_result_E = srcB_E >> 3;
		4'b1101: ALU_result_E = rd1_E <<< 3;  
		4'b1110: ALU_result_E = rd1_E >>> 3;
		default: ALU_result_E = 32'd0;
	endcase
end

assign ZERO = (ALU_result_E == 32'd0) ? 1'b1 : 1'b0;

endmodule