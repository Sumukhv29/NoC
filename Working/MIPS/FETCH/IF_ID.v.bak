module IF_ID(
	input			clk,
	input		[31:0]	instruction,
	input		[31:0]	PC_F,
	output 	reg	[31:0]	IR,
	output	reg	[31:0]	PC_D
);

always @(posedge clk)	begin
	IR 	<= instruction;
	PC_D	<= PC_F;
end

endmodule

	
	