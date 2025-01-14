module VC(
	input			clk,
	input			rst,
	input		[7:0]	flit_in,
	input			vc_sel,
	output	reg	[7:0]	vc_out_0,
	output	reg	[7:0]	vc_out_1,
	output	reg		vc0_full,
	output	reg		vc1_full,
	output	reg		vc0_valid,
	output	reg		vc1_valid,
	output	reg	[1:0]	dest_add
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
	end

	else if(flit_in) begin
		case(vc_sel)
			0: begin
				if(!vc0_full) begin
					vc_buf_0	<= flit_in;
					vc0_valid	<= 1;
					vc0_full	<= 1;
				end
			end

			1: begin
				if(!vc1_full) begin
					vc_buf_1	<= flit_in;
					vc1_valid	<= 1;
					vc1_full	<= 1;
				end
			end
		endcase
	end
	
	else begin
		vc0_valid	<= 0;
		vc1_valid	<= 0;
	end
end

always @(posedge clk) begin
	if(vc0_valid) begin
		vc_out_0	<= vc_buf_0;
		vc0_valid	<= 0;
		vc0_full	<= 0;
	end

	if(vc1_valid) begin
		vc_out_1	<= vc_buf_1;
		vc1_valid	<= 0;
		vc1_full	<= 0;
	end
end
		
endmodule