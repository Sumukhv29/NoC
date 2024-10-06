module Instruction_Mem(
	input		[31:0]	PC_F,
	output	reg	[31:0]	instruction
);

reg	[31:0]	instrmem [16:0];

always @(*) begin
	instruction = instrmem[PC_F >> 2];
end

initial begin
	$readmemb("instructions.txt", instrmem);
end
endmodule

