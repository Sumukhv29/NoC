module sign_extender(
	input		[25:0]	immediate_in,
	input		[1:0]	extend_enable_D,
	output	reg	[31:0]	extend_out_D
);

always @(*) begin
	case(extend_enable_D)
		2'b10:	extend_out_D = {{16{immediate_in[15]}}, immediate_in[15:0]};
		2'b11:	extend_out_D = {{6{immediate_in[15]}}, immediate_in};
		default: extend_out_D = 32'd0;
	endcase
end

endmodule 