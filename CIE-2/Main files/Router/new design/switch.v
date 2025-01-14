module switch_new_des(
	input		rst,
	input	[7:0]	vc0_in,
	input	[7:0]	vc1_in,
	input	[7:0]	NI_in,
	input		sel_NI_out,
	input		sel_vc,
	input		sel_up,
	output		ena_vc0,
	output		ena_vc1,
	output		ena_ni,
	output	reg	[7:0]	out_down,
	output	reg	[7:0]	out_NI
);	

/* wire ena_vc0, ena_vc1, ena_ni ; */
reg sel_NI_int, sel_vc_int, sel_up_int;
	
assign ena_vc0 = (vc0_in == 8'd255) ? 1: 0;
assign ena_vc1 = (vc1_in == 8'd255) ? 1 : 0;
assign ena_ni = (NI_in == 8'd255) ? 1 : 0;
	
/* always@(*) begin
	if(rst) begin
		sel_NI_int	= 0;
		sel_vc_int	= 1;
		sel_up_int	= 0;
	end

	else if(ena_vc0 || ena_vc1 || ena_ni) begin
		sel_NI_int	= sel_NI_out;
		sel_vc_int	= sel_vc;
		sel_up_int	= sel_up;
	end
end */

always@(*) begin
	case({sel_NI_out, sel_vc, sel_up})
		3'b010: begin
			out_down = NI_in;
			out_NI	= 0;
		end
		3'b011: begin
			out_down = vc1_in;
			out_NI	= 0;
		end
		3'b100:begin
			out_NI	 = vc0_in;
			out_down = 0;
		end
		default: begin
			out_down	= 0;
			out_NI		= 0;
		end
	endcase
	
	
	
		
	/* case({sel_NI_out, sel_vc, sel_up})
			3'b010: begin
				out_down 	= NI_in;
				out_NI		= 0;
			end

			3'b011: begin
				out_down 	= vc1_in;
				out_NI		= 0;
			end
			
			3'b100: begin
				out_NI		= vc0_in;
				out_down	= 0;
			end

			default: begin
				out_down	= 0;
				out_NI		= 0;
			end
		endcase */
end

endmodule
