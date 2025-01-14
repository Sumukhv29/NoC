module node(
	input		clk,
	input		rst,
	input	[7:0]	flit_in_vc,
	output	[7:0]	out_down
);

wire	[1:0] 	dest_add;
wire	[31:0]	write_data_NI;
wire		data_valid;
wire		mips_ni;		//indicates NI is ready to accept data from processor
wire	[31:0]	data_to_processor_from_NI;
wire		proc_valid;		//data from processor is valid
wire		proc_ready_in;		//processor is ready to accept the data
wire	[7:0]	flit_in_NI;
wire		noc_ready;		//noc ready to accept flit
wire		flit_in_valid;		//incoming flit to NI is valid
wire		flit_valid;		//flit from NI is valid
wire	[7:0]	out_NI;


MIPS processor(
		.clk(clk),
		.rst(rst),
		.mips_ni(mips_ni),
		.data_valid(data_valid),
		.wd_NI(data_to_processor_from_NI),
		.dest_add_E(dest_add),
		.proc_valid_E(proc_valid),
		.proc_ready_in_E(proc_ready_in),
		.NI_in(write_data_NI),
		
		.Instruction_F(),
		.rd1_D(),
		.rd2_D(),
		.ALU_result_E(),
		.ZERO_E(),
		.mem_read_M(),
		.RESULT_WB()
		);

router ROUTER(
		.clk(clk),
		.rst(rst),
		.flit_in_vc(flit_in_vc),
		.flit_in_NI(flit_in_NI),
		.flit_valid_from_NI(flit_valid),
		.noc_ready(noc_ready),
		.flit_in_valid(flit_in_valid),
		.out_down(out_down),
		.out_NI(out_NI),
		.current_node(2'b00),
		.NI_en()
		);

NI interface(
		.clk(clk),
		.rst(rst),
		.dest_add(dest_add),

		.data_in(write_data_NI),
		.proc_valid(proc_valid),
		.proc_ready(mips_ni),

		.data_out(data_to_processor_from_NI),
		.data_valid(data_valid),
		.proc_ready_in(proc_ready_in),

		.flit_in(out_NI),
		.flit_in_valid(flit_in_valid),
		.NI_ready(),

		.noc_ready(noc_ready),
		.flit_out(flit_in_NI),
		.flit_valid(flit_valid)
		);


endmodule

		