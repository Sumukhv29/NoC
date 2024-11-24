module node(
	input		clk,
	input		rst,
	input	[1:0]	current_node,
	input	[7:0]	flit_in_up,
	output	[7:0]	flit_out_down
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
wire	[7:0]	flit_out_NI;
wire		ZERO;


top_level_mips MIPS(
		.clk(clk),
		.rst(rst),
		.ZERO(ZERO),
		.wd_NI(data_to_processor_from_NI),
		.current_node(current_node),
		.mips_ni(mips_ni),
		.data_valid(data_valid),
		.to_ni(write_data_NI),
		.dest_add_E(dest_add),
		.proc_valid_E(proc_valid),
		.proc_ready_in_E(proc_ready_in)
		);


NI network_interface(
		.clk(clk),
		.rst(rst),
		.dest_add(dest_add),

		.data_in(write_data_NI),
		.proc_valid(proc_valid),
		.proc_ready(mips_ni),

		.data_out(data_to_processor_from_NI),
		.data_valid(data_valid),
		.proc_ready_in(proc_ready_in),

		.flit_in(flit_out_NI),
		.flit_in_valid(1'b1),
		

		.noc_ready(noc_ready),
		.flit_out(flit_in_NI),
		.flit_valid()
		);


router_new router(
		.clk(clk),
		.rst(rst),
		.flit_in_up(flit_in_up),
		.flit_in_NI(flit_in_NI),
		.current_node(current_node),
		.flit_out_down(flit_out_down),
		.flit_out_NI(flit_out_NI),
		.free(noc_ready),
		.hold()
		);
endmodule

		