module top_level_mips(
	input		clk,
	input		rst,
	output		ZERO,
	
	input	[31:0]	wd_NI,
	input	[1:0]	current_node,
	input		mips_ni,
	input		data_valid,
	output	[31:0]	to_ni


);

wire		PC_src_F;
wire 	[31:0]	PC_target_F;
wire	[31:0]	instruction_F, instruction_D;
wire	[31:0]	PC_F, PC_D, PC_E;
wire	[31:0]	PC_Do;
wire	[31:0]	rd1_D, rd1_E;
wire	[31:0]	rd2_D, rd2_E;
wire	[4:0]	Radd_D, Radd_E, Radd_M, Radd_W;
wire 	[31:0]	extend_out_D, extend_out_E;

wire	[5:0]	opcode;
wire	[5:0]	fun;
wire	[1:0]	dest_add_D, dest_add_E;
wire		proc_valid_D, proc_valid_E;
wire		proc_ready_in_D, proc_ready_in_E;
wire		alu_out_D, alu_out_E;
wire		Jump_D, Jump_E;
wire		Beq_D, Beq_E;
wire		Bneq_D, Bneq_E;
wire		RegW_enable_D, RegW_enable_E, RegW_enable_M, RegW_enable_W;
wire	[1:0]	Extend_enable_D;
wire		ALU_src_D, ALU_src_E;
wire	[3:0]	ALU_control_D, ALU_control_E;
wire		Mem_Write_D, Mem_Write_E, Mem_Write_M;
wire		Mem_Read_D, Mem_Read_E, Mem_Read_M;
wire		Result_src_D, Result_src_E, Result_src_M, Result_src_W;
wire	[31:0]	ALU_result_E, ALU_result_M, ALU_result_W;
wire	[31:0]	Write_Data_E, Write_Data_M;
wire	[31:0]	mem_read_M, mem_read_W;
wire	[31:0]	RESULT_WB;
wire		reg_en;


assign 	fun 		= instruction_D[5:0];
assign	opcode		= instruction_D[31:26];
assign	PC_src_F	= Jump_E || (Beq_E && ZERO) || (Bneq_E && ~ZERO) || 0;

Instruction_Fetch IF(
		.clk(clk),
		.rst(rst),	
		.PC_src(PC_src_F),
		.PC_target(PC_target_F),
		.instruction_F(instruction_F),
		.PC_F(PC_F)
		);


IF_ID IF_ID_reg(
		.clk(clk),
		.rst(rst),
		.Instruction_F(instruction_F),
		.Instruction_D(instruction_D),
		.PC_F(PC_F),
		.PC_D(PC_D)
		);


Instruction_Decode ID(
		.clk(clk),
		.rst(rst),
		.Instruction_D(instruction_D),
		.PC_Di(PC_D),
		.rd(Radd_W),
		.wd(RESULT_WB),
		.we(RegW_enable_W),
		.extend_enable(Extend_enable_D),
		.reg_en(reg_en),
		.wd_NI(wd_NI),
		.rd1_D(rd1_D),
		.rd2_D(rd2_D),
		.PC_Do(PC_Do),
		.Radd_D(Radd_D),
		.extend_out_D(extend_out_D)
		);


control_unit controler(
		.opcode(opcode),
		.fun(fun),

		.mips_ni(mips_ni),
		.data_valid(data_valid),
		.current_node(current_node),
		.dest_add_D(dest_add_D),
		.proc_valid_D(proc_valid_D),
		.proc_ready_in_D(proc_ready_in_D),
		.alu_out_D(alu_out_D),
		.reg_en(reg_en),

		.Jump_D(Jump_D),
		.Beq_D(Beq_D),
		.Bneq_D(Bneq_D),
		.RegW_enable_D(RegW_enable_D),
		.Extend_enable_D(Extend_enable_D),
		.ALU_src_D(ALU_src_D),
		.ALU_control_D(ALU_control_D),
		.Mem_Write_D(Mem_Write_D),
		.Mem_Read_D(Mem_Read_D),
		.Result_src_D(Result_src_D)
		);


ID_EX ID_EX_reg(
		.clk(clk),
		.rst(rst),
		.Jump_D(Jump_D),
		.Beq_D(Beq_D),
		.Bneq_D(Bneq_D),
		.RegW_enable_D(RegW_enable_D),
		.ALU_src_D(ALU_src_D),
		.ALU_control_D(ALU_control_D),
		.Mem_Write_D(Mem_Write_D),
		.Mem_Read_D(Mem_Read_D),
		.Result_src_D(Result_src_D),
		.rd1(rd1_D),
		.rd2(rd2_D),
		.Radd_D(Radd_D),
		.extend_out_D(extend_out_D),
		.PC_D(PC_Do),
		.Jump_E(Jump_E),
		.Beq_E(Beq_E),
		.Bneq_E(Bneq_E),
		.RegW_enable_E(RegW_enable_E),
		.ALU_src_E(ALU_src_E),
		.ALU_control_E(ALU_control_E),
		.Mem_Write_E(Mem_Write_E),
		.Mem_Read_E(Mem_Read_E),
		.Result_src_E(Result_src_E),
		.rd1_E(rd1_E),
		.rd2_E(rd2_E),
		.Radd_E(Radd_E),
		.PC_E(PC_E),
		.extend_out_E(extend_out_E),

		.dest_add_D(dest_add_D),
		.proc_valid_D(proc_valid_D),
		.proc_ready_in_D(proc_ready_in_D),
		.alu_out_D(alu_out_D),
		.dest_add_E(dest_add_E),
		.proc_valid_E(proc_valid_E),
		.proc_ready_in_E(proc_ready_in_E),
		.alu_out_E(alu_out_E)
		);


Instruction_Execute EX(
		.rd1_E(rd1_E),
		.rd2_E(rd2_E),
		.PC_E(PC_E),
		.Radd_E(Radd_E),
		.extend_out_E(extend_out_E),
		.ALU_src_E(ALU_src_E),
		.ALU_control_E(ALU_control_E),
		.alu_out_E(alu_out_E),
		.NI_in(to_ni),
		.next_PC_target(PC_target_F),
		.ALU_result_E(ALU_result_E),
		.Write_Data_E(Write_Data_E),
		.ZERO(ZERO)
		);


EX_M EX_M_reg(
		.clk(clk),
		.rst(rst),
		.RegW_enable_E(RegW_enable_E),
		.Mem_Write_E(Mem_Write_E),
		.Mem_Read_E(Mem_Read_E),
		.Result_src_E(Result_src_E),
		.ALU_result_E(ALU_result_E),
		.Write_Data_E(Write_Data_E),	
		.RDadd_E(Radd_E),
		.RDadd_M(Radd_M),
		.Write_Data_M(Write_Data_M),
		.Mem_Read_M(Mem_Read_M),
		.ALU_result_M(ALU_result_M),
		.Result_src_M(Result_src_M),
		.Mem_Write_M(Mem_Write_M),
		.RegW_enable_M(RegW_enable_M)
		);


Data_Mem data_memory(
		.clk(clk),
		.rst(rst),
		.Mem_Write_M(Mem_Write_M),
		.Mem_Read_M(Mem_Read_M),
		.ALU_result_M(ALU_result_M),
		.Write_Data_M(Write_Data_M),
		.mem_read_M(mem_read_M)
		);


M_WB M_WB_reg(
		.clk(clk),	
		.rst(rst),
		.RegW_enable_M(RegW_enable_M),
		.Result_src_M(Result_src_M),
		.ALU_result_M(ALU_result_M),
		.mem_read_M(mem_read_M),
		.RDadd_M(Radd_M),
		.RegW_enable_W(RegW_enable_W),
		.Result_src_W(Result_src_W),
		.ALU_result_W(ALU_result_W),
		.mem_read_W(mem_read_W),
		.RDadd_W(Radd_W)
		);


MUX_WB WB(
		.Result_src_W(Result_src_W),
		.ALU_result_W(ALU_result_W),
		.mem_read_W(mem_read_W),
		.RESULT_WB(RESULT_WB)
		);

endmodule