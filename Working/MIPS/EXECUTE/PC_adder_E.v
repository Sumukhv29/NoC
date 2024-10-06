module PC_adder_E(
	input	[31:0]	PC_E,
	input	[31:0]	extend_out_E,
	output	[31:0]	next_PC_target
);

assign next_PC_target = PC_E + extend_out_E;

endmodule