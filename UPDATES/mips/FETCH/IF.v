module IF(
	input	clk,
	input 	rst,
	output	[31:0]	IR
);

wire	[31:0]	next_pc;
wire	[31:0]	pc;
wire	[31:0]	instruction;

PC pc_unit 
(
	.clk(clk), 
	.rst(rst), 
	.next_pc(next_pc), 
	.pc(pc)
);

IF_adder adder
(
	.pc(pc),
	.next_pc(next_pc)
);

Instruction_Mem	Instr_Mem
(
	.pc(pc),
	.instruction(instruction)
);

IF_ID register
(
	.clk(clk),
	.IR(IR),
	.instruction(instruction)
);	

endmodule
