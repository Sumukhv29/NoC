module switch_controller(
	input			clk,
	input			rst,
	input		[7:0]	flit_in_vc,
	input		[7:0]	flit_in_NI,
	input		[1:0]	current_node,
	output	reg		vc_sel,		//VC mod
	output	reg		sel_up,		//switch mod
	output	reg		sel_vc,		//switch mod
	output	reg		sel_NI,		//switch mod
	output	reg		flit_in_valid,
	output	reg		noc_ready
);

parameter HEAD = 6'b101111;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		sel_up		<= 0;
		sel_vc		<= 0;
		sel_NI		<= 0;
		flit_in_valid	<= 0;
		noc_ready	<= 0;
	end

	else begin
		if(flit_in_vc) begin
			if(flit_in_vc[7:2] == HEAD) begin
				if(flit_in_vc[1:0] == current_node) begin
					vc_sel		<= 0;
					sel_up		<= 0;
					sel_vc		<= 0;
					sel_NI		<= 0;
					flit_in_valid	<= 1;	//incoming flit is valid
					noc_ready	<= 0;	//do not accept flit from NI
				end
				else begin
					vc_sel		<= 1;
					sel_up		<= 1;
					sel_vc		<= 1;
					sel_NI		<= 0;
					flit_in_valid	<= 1;	//incoming flit is valid
					noc_ready	<= 0;	//do not accept flit from NI
				end
			end
		end
		
		else if(flit_in_NI) begin
			sel_up		<= 0;
			sel_vc		<= 0;
			sel_NI		<= 1;
			noc_ready	<= 1;
			flit_in_valid	<= 0;
		end

		else begin
			sel_up		<= 0;
			sel_vc		<= 0;
			sel_NI		<= 1;
			noc_ready	<= 1;
			flit_in_valid	<= 0;
		end	
	end
end
			
endmodule