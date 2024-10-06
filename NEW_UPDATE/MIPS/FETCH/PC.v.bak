module PC(
	input			clk,
	input			rst,
	input		[31:0]	next_pc,
	output	reg	[31:0]	pc
);
initial pc = 0;

always @(posedge clk or posedge rst)	begin
	case (rst)
		1'b1:	 pc <= 0;
		1'b0:	 pc <= next_pc;
		default: pc <= 0;
	endcase
end

endmodule 

