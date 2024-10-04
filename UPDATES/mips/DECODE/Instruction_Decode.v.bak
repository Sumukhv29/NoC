module Instruction_Decode(
	input		clk,
	input	[31:0]	Instruction_D,
	input	[31:0]	PC_Di,
	input	[4:0]	rd,
	input 	[31:0]	wd,
	input		we,
	input	[1:0]	extend_enable,
	output	[31:0]	rd1_D,
	output	[31:0]	rd2_D,
	output	[31:0]	PC_Do,
	output	[4:0]	Radd_D,
	output	[31:0]	extend_out_D
);

wire [4:0]	rs;
wire [4:0] 	rt;
wire [25:0] 	immediate_in;

assign rs 		= Instruction_D[25:21];
assign rt 		= Instruction_D[20:16];
assign Radd_D	 	= Instruction_D[15:11];
assign immediate_in 	= Instruction_D[25:0];
assign PC_Di 		= PC_Do;

register_file regfile(
			.clk(clk),
			.rs(rs),
			.rt(rt),
			.rd(rd),
			.wd(wd),
			.we(we),
			.rd1(rd1_D),
			.rd2(rd2_D)
			);

sign_extender extend(
			.immediate_in(immediate_in),
			.extend_enable_D(extend_enable),
			.extend_out_D(extend_out_D)
			);

endmodule

