module IF_ID(
	input			clk,
	input		[31:0]	Instruction_F,
	input		[31:0]	PC_F,
	output 	reg	[31:0]	Instruction_D,
	output	reg	[31:0]	PC_D
);

always @(posedge clk)	begin
	Instruction_D 	<= Instruction_F;
	PC_D	<= PC_F;
end

endmodule

	
	