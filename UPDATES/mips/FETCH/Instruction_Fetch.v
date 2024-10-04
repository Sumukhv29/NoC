module Instruction_Fetch(
	input		clk,
	input		PC_src,
	// input	[31:0]	PC_plus4,
	input	[31:0]	PC_target,
	output	[31:0]	instruction_F,
	output	[31:0]	PC_F
);

wire [31:0] PC_next;
wire [31:0] PC_plus4;
/* wire [31:0] PC_F;
wire [31:0] instruction_F; */

MUX_PC	PC_sel(
		.PC_src(PC_src),
		.PC_plus4(PC_plus4),
		.PC_target(PC_target),
		.PC_out(PC_next)
		);

PC_FF PC(
	.clk(clk),
	.PC_next(PC_next),
	.PC_F(PC_F)
	);

Instruction_Mem IM(
			.PC_F(PC_F),
			.instruction(instruction_F)
		   );
			
IF_adder PC_adder(
			.PC_F(PC_F),
			.PC_plus4(PC_plus4)
		  );

/* IF_ID IF_ID_reg(
			.clk(clk),
			.instruction(instruction_F),
			.PC_F(PC_F),
			.IR(instruction_D),
			.PC_D(PC_D)
		);	*/


endmodule




