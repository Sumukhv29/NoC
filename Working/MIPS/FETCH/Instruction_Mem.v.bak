module Instruction_Mem(
	input		[31:0]	pc,
	output	reg	[31:0]	instruction
);

reg	[31:0]	instrmem [16:0];

always @(*) begin
	instruction = instrmem[pc >> 2];
end

initial begin
	$readmemb("instructions.txt", instrmem);
end
endmodule

