module switch_cont(
	input			rst,
	input		[7:0]	flit_in_up,
	input		[7:0]	flit_in_NI,
	input		[1:0]	current_node,
	output	reg	[1:0]	vc_sel,
	output	reg		sel_NI_out,	//route to NI (exit node)
	output	reg		sel_vc,		
	output	reg		sel_up,
	output	reg		free,
	output	reg	[7:0]	flit_out_vc,
	output	reg	[7:0]	flit_out_ni
);

parameter HEAD = 6'b101111;
parameter TRAILER = 8'b11111111;

reg hold;

always@(*) begin
	if(rst) begin
		hold		<= 0;
		vc_sel		<= 2'b00;
		sel_NI_out	<= 0;
		sel_vc		<= 0;
		sel_up		<= 0;
		free		<= 1;
		flit_out_vc	<= 0;
		flit_out_ni	<= 0;
	end

	else if(flit_in_up && ~hold) begin
		flit_out_vc	<= flit_in_up;
		if(flit_in_up[7:2] == HEAD) begin	
			free		<= 0;
			if(flit_in_up[1:0] == current_node) begin
				vc_sel		<= 2'b00;
				sel_NI_out	<= 1;
				sel_vc		<= 0;
				sel_up		<= 0;
			end
			
			else begin
				vc_sel		<= 2'b01;
				sel_NI_out	<= 0;
				sel_vc		<= 1;
				sel_up		<= 1;
			end
		end

		else if(flit_in_up == TRAILER) begin
			flit_out_vc	<= flit_in_up;
			free		<= 1;
		end
	end

	if(flit_in_NI && free) begin
		hold		<= 1;
		flit_out_ni	<= flit_in_NI;
		flit_out_vc	<= 0;
		vc_sel		<= 2'b10;
		sel_NI_out	<= 0;
		sel_vc		<= 1;
		sel_up		<= 0;
		if(flit_in_NI == TRAILER) begin
			hold 	<= 0;
		end
	end

end

endmodule 