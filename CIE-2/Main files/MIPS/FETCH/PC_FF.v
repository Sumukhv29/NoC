module PC_FF(
	input			clk,
	input			rst,
	input		[31:0]	PC_next,
	output	reg	[31:0]	PC_F
);

always @(posedge clk or posedge rst) begin
	if(rst) begin
		PC_F 	<= 0;
	end
	else 
		PC_F <= PC_next;
end

endmodule


