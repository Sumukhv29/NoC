module ALU_Mux(
	input		ALU_src_E,
	input	[31:0]	rd2_E,
	input	[31:0]	extend_out_E,
	output	[31:0]	srcB_E
);

assign srcB_E = ALU_src_E ? extend_out_E : rd2_E;

endmodule