module M_WB(
	input			clk,
	input			RegW_enable_M,
	input			Result_src_M,
	input		[31:0]	ALU_result_M,
	input		[31:0]	mem_read_M,
	input		[4:0]	RDadd_M,
	output	reg		RegW_enable_W,
	output	reg		Result_src_W,
	output	reg	[31:0]	ALU_result_W,
	output	reg	[31:0]	mem_read_W,
	output	reg	[4:0]	RDadd_W
);

always @(posedge clk) begin
	RegW_enable_W	<= RegW_enable_M;
	Result_src_W	<= Result_src_M;
	ALU_result_W	<= ALU_result_M;
	mem_read_W	<= mem_read_M;
	RDadd_W		<= RDadd_M;
end

endmodule
	
