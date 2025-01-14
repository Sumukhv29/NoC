module tt_um_router_new(
	input  wire [7:0] ui_in,    // Dedicated inputs
	output wire [7:0] uo_out,   // Dedicated outputs
    	input  wire [7:0] uio_in,   // IOs: Input path
   	output wire [7:0] uio_out,  // IOs: Output path
   	output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
   	input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    	input  wire       clk,      // clock
   	 input  wire      rst_n 
);
	
wire		rst;	
wire	[7:0]	flit_in_up;
wire	[7:0]	flit_in_NI;
wire	[1:0]	current_node;
wire	[7:0]	flit_out_down;
wire	[7:0]	flit_out_NI;
wire		free;

assign	rst		= rst_n;
assign	flit_in_up	= ui_in;
assign	flit_in_NI	= uio_in;
assign	uo_out		= flit_out_down;
assign	uio_out		= flit_out_NI;
assign	uio_oe[0]	= free;
assign	current_node	= 2'b00;
assign	uio_oe[7:1]	= 0;

wire _unused = &{ena, 1'b0};
	
wire	[1:0]	vc_sel;
wire		sel_NI_out;
wire		sel_vc;
wire		sel_up;
wire	[7:0]	flit_out_vc;
wire	[7:0]	flit_out_ni;
wire	[7:0]	vc_out_0, vc_out_1, vc_ni;
wire		ena_vc1, ena_vc0, ena_ni;

	
new_switch_cont_new_des controller(
			.rst(rst),
			.flit_in_up(flit_in_up),
			.flit_in_NI(flit_in_NI),
			.current_node(current_node),
			.ena_vc0(ena_vc0),
			.ena_vc1(ena_vc1),
			.ena_ni(ena_ni),
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
			.vc_out_NI(vc_ni)
			);

switch_new_des crossbar(
			.rst(rst),
			.vc0_in(vc_out_0),
			.vc1_in(vc_out_1),
			.NI_in(vc_ni),
			.sel_NI_out(sel_NI_out),
			.sel_vc(sel_vc),
			.sel_up(sel_up),
			.ena_vc0(ena_vc0),
			.ena_vc1(ena_vc1),
			.ena_ni(ena_ni),
			.out_down(flit_out_down),
			.out_NI(flit_out_NI)
			);

endmodule 