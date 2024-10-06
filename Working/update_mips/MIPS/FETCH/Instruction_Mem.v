module Instruction_Mem(
	input		[31:0]	PC_F,
	input			rst,
	output	reg	[31:0]	instruction
);

reg	[31:0]	instrmem [16:0];

always @(*) begin
	if(rst) begin
		instruction	<= 0;
	end
	
	else 
	instruction = instrmem[PC_F >> 2];
end

initial begin
	$readmemb("instructions.txt", instrmem);
end
endmodule

