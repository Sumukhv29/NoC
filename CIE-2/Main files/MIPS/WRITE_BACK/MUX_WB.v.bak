module MUX_WB(
	input			Result_src_W,
	input		[31:0]	ALU_result_W,
	input		[31:0]	mem_read_W,
	output	reg	[31:0]	RESULT_WB
);

always @(*) begin
	case(Result_src_W)
		1'b0: RESULT_WB = ALU_result_W;
		1'b1: RESULT_WB = mem_read_W;
		default: RESULT_WB = 32'dx;
	endcase
end
endmodule

	