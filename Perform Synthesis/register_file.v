module register_file(
	input			clk,
	input			rst,
	input		[4:0]	rs, 	// source add.1
	input		[4:0]	rt,	// source add.2
	input		[4:0]	rd,	// destination add
	input 		[31:0]	wd,	// write data into reg_array
	input			we,	// write enable
	
	input			reg_en,
	input		[31:0]	wd_NI,
	
	output		[31:0]	rd1,	// outputs data corresponding to add.1 
	output		[31:0]	rd2	// outputs data corresponding to add.2
);

reg	[31:0] 	reg_array [31:0];
reg 	[4:0] 	rd_NI;

always @(negedge clk or posedge rst) begin
	if(rst) begin
		rd_NI		<= 3'd1;
 		reg_array[0]	<= 0;
	end

	else if(we) begin
		reg_array[rd] <= wd;
	end

	else if(reg_en) begin
		reg_array[rd_NI] <= wd;
		rd_NI <= rd_NI + 1;
		if(rd_NI == 5'd7) begin
			rd_NI <= 5'd1;
		end
	end
end

/*always @(posedge clk or posedge rst) begin
	if(rst) begin
		rd_NI		<= 3'd1;
		rd1		<= 0;
		rd2		<= 0;
	end
*/

assign	rd1 = (rs == 5'd0) ? 32'b0 : reg_array[rs];	// first reg in reg_array is a zero register
assign	rd2 = (rt == 5'd0) ? 32'b0 : reg_array[rt];
	

endmodule	