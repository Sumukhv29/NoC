module new_switch_cont_new_des(
	input			rst,
	input		[7:0]	flit_in_up,
	input		[7:0]	flit_in_NI,
	input		[1:0]	current_node,
	input			ena_ni,
	input			ena_vc1,
	input			ena_vc0,
	output	reg	[1:0]	vc_sel,
	output	reg		sel_NI_out,	//route to NI (exit node)
	output	reg		sel_vc,		
	output	reg		sel_up,
	output	reg		free,
	output	reg 		hold,
	output	reg	[7:0]	flit_out_vc,
	output	reg	[7:0]	flit_out_ni
);

parameter HEAD = 6'b101111;

/* wire ena_vc, ena_ni;

assign ena_vc = (flit_in_up == 8'd255) ? 1 : 0;
assign ena_ni = (flit_in_NI == 8'd255) ? 1 : 0;
*/

always@(*) begin
	if(rst) begin
		hold		= 0;
		vc_sel		= 2'b00;
		sel_NI_out	= 0;
		sel_vc		= 0;
		sel_up		= 0;
		free		= 1;
		flit_out_vc	= 8'd255;
		flit_out_ni	= 8'd255;
	end
	
	else if(~hold) begin
		if(|flit_in_up) begin
			flit_out_vc	= flit_in_up;
			if(flit_in_up[7:2] == HEAD) begin
				if(flit_in_up[1:0] == current_node) begin
					sel_NI_out	= 1;
					sel_vc		= 0;
					sel_up		= 0;
				end
			
				else begin
					sel_NI_out	= 0;
					sel_vc		= 1;
					sel_up		= 1;
				end

				vc_sel = (flit_in_up[1:0] == current_node) ? 2'b00 : 2'b01;
				free	= 0;
			end
		end	

		if(ena_vc1 || ena_vc0) begin
			flit_out_vc	= flit_in_up;
			free		= 1;
		end
	end
	
	if(free) begin 
		if(|flit_in_NI) begin
			hold		= 1;
			flit_out_ni	= flit_in_NI;
			vc_sel		= 2'b10;
			sel_NI_out	= 0;
			sel_vc		= 1;
			sel_up		= 0;
		end
		
		if(ena_ni) begin
			flit_out_ni	= flit_in_NI;
			hold 	= 0;
		end
	end

end

endmodule 