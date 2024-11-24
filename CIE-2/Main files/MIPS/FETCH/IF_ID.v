module IF_ID(
	input			clk,
	input			rst,
	input		[31:0]	Instruction_F,
	input		[31:0]	PC_F,
	output 	reg	[31:0]	Instruction_D,
	output	reg	[31:0]	PC_D
);

always @(posedge clk)	begin
	if(rst) begin
		Instruction_D	<= 0;
		PC_D		<= 0;
	end
	
	else begin
		Instruction_D 	<= Instruction_F;
		PC_D	<= PC_F;
	end
end

endmodule

	
	