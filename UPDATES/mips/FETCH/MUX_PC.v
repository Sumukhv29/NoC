module MUX_PC(
	input		PC_src,
	input	[31:0]	PC_plus4,
	input	[31:0]	PC_target,
	output	[31:0]	PC_out
);

assign PC_out = PC_src ? PC_target : PC_plus4;

endmodule
