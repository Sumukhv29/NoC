module EX_M(
	input			clk,
	input			RegW_enable_E,
	input			Mem_Write_E,
	input			Mem_Read_E,
	input			Result_src_E,
	input		[31:0]	ALU_result_E,
	input		[31:0]	Write_Data_E,
	input		[4:0]	RDadd_E,
	output	reg	[4:0]	RDadd_M,
	output	reg	[31:0]	Write_Data_M,
	output	reg		Mem_Read_M,
	output	reg	[31:0]	ALU_result_M,
	output	reg		Result_src_M,
	output	reg		Mem_Write_M,
	output	reg		RegW_enable_M
);

always @(posedge clk) begin
	RegW_enable_M	<= RegW_enable_E;
	Mem_Write_M	<= Mem_Write_E;
	Mem_Read_M	<= Mem_Read_E;
	Result_src_M	<= Result_src_E;
	ALU_result_M	<= ALU_result_E;
	Write_Data_M	<= Write_Data_E;
	RDadd_M		<= RDadd_E;
end

endmodule