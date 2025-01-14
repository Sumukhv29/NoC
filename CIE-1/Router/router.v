module router(
	input 		clk,
	input		rst,
	input	[7:0]	flit_in_vc,
	input	[7:0]	flit_in_NI,
	input		flit_valid_from_NI,
	input	[1:0]	current_node,
	output		noc_ready,
	output		flit_in_valid,
	output	[7:0]	out_down,
	output	[7:0]	out_NI,
	output		NI_en
);

wire 	[1:0]	vc_sel;
wire 		sel_up;
wire		sel_vc;
wire 		sel_NI;
wire	[7:0]	flit_out_vc;
wire	[7:0]	flit_out_NI;
wire	[7:0]	vc0_in;
wire	[7:0]	vc1_in;
wire	[7:0]	NI_in;

switch_controller controller(
			.clk(clk),
			.rst(rst),
			.flit_in_vc(flit_in_vc),
			.flit_in_NI(flit_in_NI),
			.flit_valid(flit_valid_from_NI),
			.current_node(current_node),
			.vc_sel(vc_sel),
			.sel_up(sel_up),
			.sel_vc(sel_vc),
			.sel_NI(sel_NI),
			.flit_in_valid(flit_in_valid),
			.noc_ready(noc_ready),
			.flit_out_vc(flit_out_vc),
			.flit_out_NI(flit_out_NI),
			.NI_en(NI_en)
			);

crossbar_switch switch(
			.vc0_in(vc0_in),
			.vc1_in(vc1_in),
			.NI_in(NI_in),
			.sel_up(sel_up),
			.sel_vc(sel_vc),
			.sel_NI(sel_NI),
			.out_down(out_down),
			.out_NI(out_NI)
			);


VC virtual_channels(
			.clk(clk),
			.rst(rst),
			.flit_in_up(flit_out_vc),
			.flit_in_NI(flit_out_NI),
			.NI_en(NI_en),
			.vc_sel(vc_sel),
			.vc_out_0(vc0_in),
			.vc_out_1(vc1_in),
			.vc0_full(),
			.vc1_full(),
			.vc0_valid(),
			.vc1_valid(),
			.vc_buf_NI(NI_in)
			);


endmodule 
