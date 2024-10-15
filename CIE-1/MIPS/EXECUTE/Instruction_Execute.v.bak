module Instruction_Execute(
	input	[31:0]	rd1_E,
	input	[31:0]	rd2_E,
	input	[31:0]	PC_E,
	input	[4:0]	Radd_E,
	input	[31:0]	extend_out_E,
	input		ALU_src_E,
	input	[3:0]	ALU_control_E,
	output	[31:0]	next_PC_target,
	output	[31:0]	ALU_result_E,
	output	[31:0]	Write_Data_E,
	output		ZERO
);

wire [31:0] srcB_E;

ALU_Mux mux(
		.ALU_src_E(ALU_src_E),
		.rd2_E(rd2_E),
		.extend_out_E(extend_out_E),
		.srcB_E(srcB_E)
		);

ALU alu(
	.ALU_control_E(ALU_control_E),
	.rd1_E(rd1_E),
	.srcB_E(srcB_E),
	.ZERO(ZERO),
	.ALU_result_E(ALU_result_E)
	);

PC_adder_E PC_target(
			.PC_E(PC_E),
			.extend_out_E(extend_out_E),
			.next_PC_target(next_PC_target)
);

assign Write_Data_E = rd2_E;

endmodule


