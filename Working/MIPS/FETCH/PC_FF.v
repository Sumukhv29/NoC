module PC_FF(
	input			clk,
	input		[31:0]	PC_next,
	output	reg	[31:0]	PC_F
);

always @(posedge clk) begin
	PC_F <= PC_next;
end

endmodule


