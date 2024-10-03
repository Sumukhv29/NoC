module router(
	input 		clk,
	input		rst,
	input	[7:0]	flit_in_vc,
	input	[7:0]	flit_in_NI,
	input		proc_ready_in,
	output		flit_in_valid,
	output		noc_ready_out,
	output		flit_valid,
	output		noc_ready,
	output	[7:0]	out_down,
	output	[7:0]	out_NI
);

wire 		vc_sel;
wire 		sel_up;
wire		sel_vc;
wire 		sel_NI;
wire	[7:0] 	vc_out_0;
wire	[7:0]	vc_out_1;

crossbar_switch switch(
			.vc0_in(vc_out_0),
			.vc1_in(vc_out_1),
			.NI_in(flit_in_NI),
			.sel_up(sel_up),
			.sel_vc(sel_vc),
			.sel_NI(sel_NI),
			.out_down(out_down),
			.out_NI(out_NI)
			);


VC VC_buffers(
		.clk(clk),
		.rst(rst),
		.flit_in(flit_in_vc),
		.vc_sel(vc_sel),
		.vc_out_0(vc_out_0),
		.vc_out_1(vc_out_1),
		.vc0_full(),
		.vc1_full(),
		.vc0_valid(),
		.vc1_valid(),
		.dest_add()
		);

switch_controller controller(
				.clk(clk),
				.rst(rst),
				.flit_in_vc(flit_in_vc),
				.flit_in_NI(flit_in_NI),
				.current_node(2'b00),
				.vc_sel(vc_sel),
				.sel_up(sel_up),
				.sel_vc(sel_vc),
				.sel_NI(sel_NI),
				.flit_in_valid(flit_in_valid),
				.noc_ready(noc_ready)
				);


endmodule 
