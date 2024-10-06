module VC(
	input			clk,
	input			rst,
	input		[7:0]	flit_in_up,
	input		[7:0]	flit_in_NI,
	input			NI_en,
	input		[1:0]	vc_sel,
	output	reg	[7:0]	vc_out_0,
	output	reg	[7:0]	vc_out_1,
	output	reg		vc0_full,
	output	reg		vc1_full,
	output	reg		vc0_valid,
	output	reg		vc1_valid,
	output	reg	[7:0]	vc_buf_NI
);

reg	[7:0]	vc_buf_0;
reg	[7:0]	vc_buf_1;


always @(posedge clk or posedge rst) begin
	if(rst) begin
		vc_out_0	<= 8'd0;
		vc_buf_0	<= 8'd0;	
		vc0_full	<= 0;
		vc0_valid	<= 0;
		vc_out_1	<= 8'd0;
		vc_buf_1	<= 8'd0;
		vc1_full	<= 0;
		vc1_valid	<= 0;
		vc_buf_NI	<= 8'd0;
	end

	else if(flit_in_up) begin
		case(vc_sel)
			2'b00: begin
				if(!vc0_full) begin
					vc_buf_0	<= flit_in_up;
					vc0_valid	<= 1;
					vc0_full	<= 1;
				end
			end

			2'b01: begin
				if(!vc1_full) begin
					vc_buf_1	<= flit_in_up;
					vc1_valid	<= 1;
					vc1_full	<= 1;
				end
			end

			2'b10: begin
				if(NI_en) begin
					vc_buf_NI	<= flit_in_NI;
				end
			end
		endcase
	end

end

always @(vc0_full | vc1_full) begin
	if(vc0_valid && vc0_full) begin
		vc_out_0	<= vc_buf_0;
		vc0_valid	<= 0;
		vc0_full	<= 0;
	end

	if(vc1_valid  && vc1_full) begin
		vc_out_1	<= vc_buf_1;
		vc1_valid	<= 0;
		vc1_full	<= 0;
	end
end
	
endmodule