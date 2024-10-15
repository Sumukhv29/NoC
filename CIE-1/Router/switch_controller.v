module switch_controller(
	input			clk,
	input			rst,
	input		[7:0]	flit_in_vc,
	input		[7:0]	flit_in_NI,
	input			flit_valid,	//enable to send data from NI
	input		[1:0]	current_node,
	output	reg	[1:0]	vc_sel,		//VC mod
	output	reg		sel_up,		//switch mod
	output	reg		sel_vc,		//switch mod
	output	reg		sel_NI,		//switch mod
	output	reg		flit_in_valid,
	output	reg		noc_ready,
	output	reg	[7:0]	flit_out_vc,
	output	reg	[7:0]	flit_out_NI,
	output	reg		NI_en		//enable to send data from NI to VC_NI
);

parameter HEAD = 6'b101111;
parameter TRAILER = 8'b11111111;

always @(*) begin
	if(rst) begin
		vc_sel		<= 2'b00;
		sel_up		<= 0;
		sel_vc		<= 0;
		sel_NI		<= 0;
		flit_in_valid	<= 0;
		noc_ready	<= 0;
		NI_en		<= 0;
	end

	else begin
		if(flit_in_vc && !flit_valid) begin
			if(flit_in_vc[7:2] == HEAD) begin
				if(flit_in_vc[1:0] == current_node) begin
					vc_sel		<= 2'b00;
					sel_up		<= 0;
					sel_vc		<= 0;
					sel_NI		<= 0;
					flit_in_valid	<= 1;	//incoming flit is valid
					noc_ready	<= 0;	//do not accept flit from NI
					flit_out_vc	<= flit_in_vc;
					NI_en		<= 0;
				end
				else begin
					vc_sel		<= 2'b01;
					sel_up		<= 1;
					sel_vc		<= 1;
					sel_NI		<= 0;
					flit_in_valid	<= 1;	//incoming flit is valid
					noc_ready	<= 0;	//do not accept flit from NI
					flit_out_vc	<= flit_in_vc;
					NI_en		<= 0;
				end
			end
			else begin
				flit_out_vc	<= flit_in_vc;
			end
		end
		
		else if(flit_in_NI && flit_valid) begin
			flit_out_NI	<= flit_in_NI;
			sel_up		<= 0;
			sel_vc		<= 0;
			sel_NI		<= 1;
			noc_ready	<= 1;
			flit_in_valid	<= 0;
			NI_en		<= 1;
			vc_sel		<= 2'b10;
			end

		else begin
			sel_up		<= 0;
			sel_vc		<= 0;
			sel_NI		<= 1;
			noc_ready	<= 1;
			flit_in_valid	<= 0;
			NI_en		<= 0;
		end	
	end
end
			
endmodule