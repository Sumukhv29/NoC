module Data_Mem(
	input			clk,
	input			rst,
	input			Mem_Write_M,
	input			Mem_Read_M,
	input		[31:0]	ALU_result_M,
	input		[31:0]	Write_Data_M,
	output	reg	[31:0]	mem_read_M
);
wire [3:0] mem_loc;
reg [31:0] memory [0:15];

assign mem_loc = ALU_result_M[3:0];

always @(posedge clk or posedge rst) begin
	if(rst) begin
		mem_read_M <= 31'd0;
	end
		
	if(Mem_Write_M) begin
		memory[mem_loc]	<= Write_Data_M;
	end
end

always@(*) begin
	if(Mem_Read_M) begin
		mem_read_M	<= memory[mem_loc];
	end

	else begin
		mem_read_M <= 31'd0;
	end
		
end

endmodule
