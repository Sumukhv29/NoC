module VC_single_buf(
	input			clk,
	input			rst,
	input			pause,
	input			sel,
	input		[47:0]	packet_in_NI,
	input		[47:0]	packet_in_up,
	input		[1:0]	current_node,
	output	reg	[47:0]	packet_out_down,
	output	reg	[47:0]	packet_out_NI,
	output	reg		full,
	output	reg		do_not_send
);

parameter HEAD	= 6'b101111;
parameter TAIL	= 8'b11111111;

reg	[47:0]	packet_buf;
reg	[1:0]	node;
reg	[47:0]	packet_in;

assign packet_in = sel ? packet_in_NI : packet_in_up;

always @(packet_in) begin
	if(packet_in[47:42] ==  HEAD) begin
		node	<= packet_in[41:40];
	end
end

always @(posedge clk or posedge rst) begin
	if(rst) begin
		packet_out_NI	<= 48'd0;
		packet_out_down	<= 48'd0;
		packet_buf	<= 48'd0;
		full		<= 0;
		do_not_send	<= 0;
	end

	else if(!full) begin
			packet_buf	<= packet_in;
			full		<= 1;
	end

	/* else if(full && (node == current_node)) begin
		packet_out_NI	<= packet_buf;
		full		<= 0;
	end

	else if(full && !pause) begin
		packet_out_down	<= packet_buf;
		full		<= 0;
	end */
end

always@(full) begin
	if(full && (node == current_node)) begin
		packet_out_NI	<= packet_buf;
		full		<= 0;
	end

	else if(full && !pause) begin
		packet_out_down	<= packet_buf;
		full		<= 0;
	end
end 

endmodule
	