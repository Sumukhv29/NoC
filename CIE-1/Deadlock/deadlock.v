module deadlock(
	input		clk,
	input		rst,
	input	[47:0] 	pkt_0,
	input	[47:0] 	pkt_1,
	input	[47:0] 	pkt_2,
	input	[47:0] 	pkt_3,
	input		sel0,
	input		sel1,
	input		sel2,
	input		sel3,
	output	[47:0]	packet_out_down_0,
	output	[47:0]	packet_out_down_1,
	output	[47:0]	packet_out_down_2,
	output	[47:0]	packet_out_down_3,
	output	[47:0]	packet_out_NI_0,
	output	[47:0]	packet_out_NI_1,
	output	[47:0]	packet_out_NI_2,
	output	[47:0]	packet_out_NI_3
);

wire	do_not_send_0;
wire	do_not_send_1;
wire	do_not_send_2;
wire	do_not_send_3;
wire	full_0;
wire	full_1;
wire	full_2;
wire	full_3;


VC_single_buf node0(
			.clk(clk),
			.rst(rst),
			.pause(do_not_send_1),
			.sel(sel0),
			.packet_in_NI(pkt_0),
			.packet_in_up(packet_out_down_3),
			.current_node(2'b00),
			.packet_out_down(packet_out_down_0),
			.packet_out_NI(packet_out_NI_0),
			.full(full_0),
			.do_not_send(do_not_send_0)
		);

VC_single_buf node1(
			.clk(clk),
			.rst(rst),
			.pause(do_not_send_2),
			.sel(sel1),
			.packet_in_NI(pkt_1),
			.packet_in_up(packet_out_down_0),
			.current_node(2'b01),
			.packet_out_down(packet_out_down_1),
			.packet_out_NI(packet_out_NI_1),
			.full(full_0),
			.do_not_send(do_not_send_1)
		);

VC_single_buf node2(
			.clk(clk),
			.rst(rst),
			.pause(do_not_send_3),
			.sel(sel2),
			.packet_in_NI(pkt_2),
			.packet_in_up(packet_out_down_1),
			.current_node(2'b10),
			.packet_out_down(packet_out_down_2),
			.packet_out_NI(packet_out_NI_2),
			.full(full_0),
			.do_not_send(do_not_send_2)
		);

VC_single_buf node3(
			.clk(clk),
			.rst(rst),
			.pause(do_not_send_0),
			.sel(sel3),
			.packet_in_NI(pkt_3),
			.packet_in_up(packet_out_down_2),
			.current_node(2'b11),
			.packet_out_down(packet_out_down_3),
			.packet_out_NI(packet_out_NI_3),
			.full(full_0),
			.do_not_send(do_not_send_3)
		);



endmodule