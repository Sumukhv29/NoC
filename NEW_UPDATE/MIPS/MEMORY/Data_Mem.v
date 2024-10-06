module Data_Mem(
	input			clk,
	input			Mem_Write_M,
	input			Mem_Read_M,
	input		[31:0]	ALU_result_M,
	input		[31:0]	Write_Data_M,
	output	reg	[31:0]	mem_read_M
);

reg [31:0] memory [0:15];

always @(posedge clk) begin
	if(Mem_Write_M)
		memory[ALU_result_M]	<= Write_Data_M;

	else if(Mem_Read_M)
		mem_read_M	<= memory[ALU_result_M];
	
	else
		mem_read_M <= 31'd0;
end

endmodule
