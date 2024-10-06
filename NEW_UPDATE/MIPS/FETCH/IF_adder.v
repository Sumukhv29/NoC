module IF_adder(
	input	[31:0]	PC_F,
	output	[31:0]	PC_plus4
);

assign	PC_plus4 = PC_F + 4;

endmodule 