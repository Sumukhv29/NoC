module router_new(
	input		clk,
	input		rst,
	input	[7:0]	flit_in_up,
	input	[7:0]	flit_in_NI,
	input	[1:0]	current_node,
	output	[7:0]	flit_out_down,
	output	[7:0]	flit_out_NI,
	output		free
);

wire	[1:0]	vc_sel;
wire		sel_NI_out;
wire		sel_vc;
wire		sel_up;
wire	[7:0]	flit_out_vc;
wire	[7:0]	flit_out_ni;
wire	[7:0]	vc_out_0, vc_out_1, vc_ni;


switch_cont controller(
			.rst(rst),
			.flit_in_up(flit_in_up),
			.flit_in_NI(flit_in_NI),
			.current_node(current_node),
			.vc_sel(vc_sel),
			.sel_NI_out(sel_NI_out),
			.sel_vc(sel_vc),
			.sel_up(sel_up),
			.free(free),
			.flit_out_vc(flit_out_vc),
			.flit_out_ni(flit_out_ni)
			);

VC virtual_channels(
			.clk(clk),
			.rst(rst),
			.flit_in_up(flit_out_vc),
			.flit_in_NI(flit_out_ni),
			.NI_en(1'b1),
			.vc_sel(vc_sel),
			.vc_out_0(vc_out_0),
			.vc_out_1(vc_out_1),
			.vc0_full(),
			.vc1_full(),
			.vc0_valid(),
			.vc1_valid(),
			.vc_buf_NI(vc_ni)
			);

switch crossbar(
			.rst(rst),
			.vc0_in(vc_out_0),
			.vc1_in(vc_out_1),
			.NI_in(vc_ni),
			.sel_NI_out(sel_NI_out),
			.sel_vc(sel_vc),
			.sel_up(sel_up),
			.out_down(flit_out_down),
			.out_NI(flit_out_NI)
			);

endmodule 