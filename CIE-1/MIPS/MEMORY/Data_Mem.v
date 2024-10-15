module Data_Mem(
	input			clk,
	input			Mem_Write_M,
	input			Mem_Read_M,
	input		[31:0]	ALU_result_M,
	input		[31:0]	Write_Data_M,
	output	reg	[31:0]	mem_read_M
);
wire mem_loc = ALU_result_M[3:0];
reg [31:0] memory [0:15];

always @(posedge clk) begin
	if(Mem_Write_M)
		memory[mem_loc]	<= Write_Data_M;

	else if(Mem_Read_M)
		mem_read_M	<= memory[mem_loc];
	
	else
		mem_read_M <= 31'd0;
end

endmodule
