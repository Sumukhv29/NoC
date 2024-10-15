module ID_EX(
    input clk,
    input rst,            // Added reset input
    input Jump_D,
    input Beq_D,
    input Bneq_D,
    input RegW_enable_D,
    input ALU_src_D,
    input [3:0] ALU_control_D,
    input Mem_Write_D,
    input Mem_Read_D,
    input Result_src_D,
    input [31:0] rd1,
    input [31:0] rd2,
    input [4:0] Radd_D,
    input [31:0] extend_out_D,
    input [31:0] PC_D,
    output reg Jump_E,
    output reg Beq_E,
    output reg Bneq_E,
    output reg RegW_enable_E,
    output reg ALU_src_E,
    output reg [3:0] ALU_control_E,
    output reg Mem_Write_E,
    output reg Mem_Read_E,
    output reg Result_src_E,
    output reg [31:0] rd1_E,
    output reg [31:0] rd2_E,
    output reg [4:0] Radd_E,
    output reg [31:0] PC_E,
    output reg [31:0] extend_out_E,
    
    input [1:0] dest_add_D,
    input proc_valid_D,
    input proc_ready_in_D,
    input alu_out_D,
    output reg [1:0] dest_add_E,
    output reg proc_valid_E,
    output reg proc_ready_in_E,
    output reg alu_out_E
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            Jump_E <= 0;
            Beq_E <= 0;
            Bneq_E <= 0;
            RegW_enable_E <= 0;
            ALU_src_E <= 0;
            ALU_control_E <= 4'b0;
            Mem_Write_E <= 0;
            Mem_Read_E <= 0;
            Result_src_E <= 0;
            rd1_E <= 32'b0;
            rd2_E <= 32'b0;
            Radd_E <= 5'b0;
            PC_E <= 32'b0;
            extend_out_E <= 32'b0;
            dest_add_E <= 2'b0;
            proc_valid_E <= 0;
            proc_ready_in_E <= 0;
            alu_out_E <= 0;
        end else begin
            //always @(posedge clk) begin
	dest_add_E	<= dest_add_D;
	proc_valid_E	<= proc_valid_D;
	proc_ready_in_E	<= proc_ready_in_D;
	alu_out_E	<= alu_out_D;
	
	Jump_E		<= Jump_D;
	Beq_E		<= Beq_D;
	Bneq_E		<= Bneq_D;
	RegW_enable_E	<= RegW_enable_D;
	ALU_src_E	<= ALU_src_D;
	ALU_control_E	<= ALU_control_D;
	Mem_Write_E	<= Mem_Write_D;
	Result_src_E	<= Result_src_D;
	rd1_E		<= rd1;
	rd2_E		<= rd2;
	Radd_E		<= Radd_D;
	PC_E		<= PC_D;
	extend_out_E	<= extend_out_D;
// Normal operation code here
        end
    end
endmodule