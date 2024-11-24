module VC(
	input			clk,
	input			rst,
	input		[7:0]	flit_in_up,
	input		[7:0]	flit_in_NI,
	input			NI_en,
	input		[1:0]	vc_sel,
	output		[7:0]	vc_out_0,
	output		[7:0]	vc_out_1,
	output		[7:0]	vc_out_NI
);

reg	[7:0]	vc_buf_0;
reg	[7:0]	vc_buf_1;
reg	[7:0]	vc_buf_NI;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		vc_buf_0	<= 8'd0;	
		vc_buf_1	<= 8'd0;
		vc_buf_NI	<= 8'd0;
	end

	else begin
		case(vc_sel)
			2'b00: begin
					vc_buf_0	<= flit_in_up;
					vc_buf_1	<= 0;
					vc_buf_NI	<= 0;
				end

			2'b01: begin
					vc_buf_0	<= 0;
					vc_buf_1	<= flit_in_up;
					vc_buf_NI	<= 0;
				end

			2'b10: begin
				if(NI_en) begin
					vc_buf_0	<= 0;
					vc_buf_1	<= 0;
					vc_buf_NI	<= flit_in_NI;
				end
			end
			
			default: begin
				vc_buf_0	<= 0;
				vc_buf_1	<= 0;
				vc_buf_NI	<= 0;
			end
		endcase
	end

end

assign 	vc_out_0	= vc_buf_0;
assign 	vc_out_1	= vc_buf_1;
assign	vc_out_NI	= vc_buf_NI;
	
endmodule