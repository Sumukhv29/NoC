module MIPS(
	input		clk,
	input		rst,

	input		mips_ni,
	input		data_valid,
	input	[31:0]	wd_NI,
	output	[1:0]	dest_add_E,
	output		proc_valid_E,
	output		proc_ready_in_E,
	output	[31:0]	NI_in,

	output	[31:0]	Instruction_F,
	output	[31:0]	rd1_D,
	output	[31:0]	rd2_D,
	output	[31:0]	ALU_result_E,
	output		ZERO_E,
	output	[31:0]	mem_read_M,
	output	[31:0]	RESULT_WB



);

wire [1:0]	dest_add_D;
wire		proc_valid_D;
wire		proc_ready_in_D;
wire		reg_en;
wire		alu_out_D;
wire		alu_out_E;

wire		PC_src;
wire [31:0]	PC_target;
wire [31:0]	PC_F, PC_D, PC_Do, PC_E;
wire [31:0]	Instruction_D;
wire [4:0]	Radd_D, Radd_E, RDadd_M, RDadd_W;
wire 		RegW_enable_D, RegW_enable_E, RegW_enable_M, RegW_enable_W;
wire [31:0]	Write_Data_E;
wire [1:0]	extend_enable;
wire [31:0]	extend_out_D, extend_out_E;
wire [5:0]	opcode;
wire [5:0]	fun;
wire		Jump_D, Jump_E;
wire		Beq_D, Bneq_D, Beq_E, Bneq_E;
wire		Branch_E;
wire		ALU_src_D, ALU_src_E;
wire [3:0]	ALU_control_D, ALU_control_E;
wire		Mem_Write_D, Mem_Write_E, Mem_Write_M;
wire		Mem_Read_D, Mem_Read_E, Mem_Read_M;
wire		Result_src_D, Result_src_E, Result_src_M, Result_src_W;
wire [31:0]	rd1_E;
wire [31:0]	rd2_E;
//wire [31:0]	ALU_result_E;
//wire		ZERO_E;
wire [31:0]	Write_Data_M;
wire [31:0]	ALU_result_M, ALU_result_W;
wire [31:0]	mem_read_W;


assign fun 	= Instruction_D[5:0];
assign opcode 	= Instruction_D[31:26];
assign PC_src	= Jump_E || (Beq_E && ZERO_E) || (Bneq_E && ~ZERO_E);

Instruction_Fetch Fetch(
			.clk(clk),
			.PC_src(PC_src),
			.PC_target(PC_target),
			.instruction_F(Instruction_F),
			.PC_F(PC_F)
			);

IF_ID register_IF_ID(
			.clk(clk),
			.Instruction_F(Instruction_F),
			.PC_F(PC_F),
			.Instruction_D(Instruction_D),
			.PC_D(PC_D)
			);

			
Instruction_Decode Decode(
			.clk(clk),
			.rst(rst),
			.Instruction_D(Instruction_D),
			.PC_Di(PC_D),
			.rd(RDadd_W),
			.wd(RESULT_WB),
			.we(RegW_enable_W),
			.extend_enable(extend_enable),
			.rd1_D(rd1_D),
			.rd2_D(rd2_D),
			.PC_Do(PC_Do),
			.Radd_D(Radd_D),
			.extend_out_D(extend_out_D),

			.reg_en(reg_en),
			.wd_NI(wd_NI)
			);

control_unit controller(
			.opcode(opcode),
			.fun(fun),
			.Jump_D(Jump_D),
			.Beq_D(Beq_D),
			.Bneq_D(Bneq_D),
			.RegW_enable_D(RegW_enable_D),
			.Extend_enable_D(extend_enable),
			.ALU_src_D(ALU_src_D),
			.ALU_control_D(ALU_control_D),
			.Mem_Write_D(Mem_Write_D),
			.Mem_Read_D(Mem_Read_D),
			.Result_src_D(Result_src_D),

			.reg_en(reg_en),
			.alu_out_D(alu_out_D),
			.mips_ni(mips_ni),
			.data_valid(data_valid),
			.dest_add_D(dest_add_D),
			.proc_valid_D(proc_valid_D),
			.proc_ready_in_D(proc_ready_in_D)
			);

ID_EX register_ID_EX(
			.clk(clk),
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

Instruction_Execute Execute(
			.rd1_E(rd1_E),
			.rd2_E(rd2_E),
			.PC_E(PC_E),
			.Radd_E(Radd_E),
			.extend_out_E(extend_out_E),
			.ALU_src_E(ALU_src_E),
			.ALU_control_E(ALU_control_E),
			.next_PC_target(PC_target),
			.ALU_result_E(ALU_result_E),
			.Write_Data_E(rd2_E),
			.ZERO(ZERO_E),

			.alu_out_E(alu_out_E),
			.NI_in(NI_in)
			);

EX_M register_EX_M(
			.clk(clk),
			.RegW_enable_E(RegW_enable_E),
			.Mem_Write_E(Mem_Write_E),
			.Mem_Read_E(Mem_Read_E),
			.Result_src_E(Result_src_E),
			.ALU_result_E(ALU_result_E),
			.Write_Data_E(Write_Data_E), // rd2_E
			.RDadd_E(Radd_E),
			.RDadd_M(RDadd_M),
			.Write_Data_M(Write_Data_M),
			.Mem_Read_M(Mem_Read_M),
			.ALU_result_M(ALU_result_M),
			.Result_src_M(Result_src_M),
			.Mem_Write_M(Mem_Write_M),
			.RegW_enable_M(RegW_enable_M)
			);

Data_Mem data_memory(
			.clk(clk),
			.Mem_Write_M(Mem_Write_M),
			.Mem_Read_M(Mem_Read_M),
			.ALU_result_M(ALU_result_M),
			.Write_Data_M(Write_Data_M),
			.mem_read_M(mem_read_M)
			);

M_WB register_M_W(
			.clk(clk),
			.RegW_enable_M(RegW_enable_M),
			.Result_src_M(Result_src_M),
			.ALU_result_M(ALU_result_M),
			.mem_read_M(mem_read_M),
			.RDadd_M(RDadd_M),
			.RegW_enable_W(RegW_enable_W),
			.Result_src_W(Result_src_W),
			.ALU_result_W(ALU_result_W),
			.mem_read_W(mem_read_W),
			.RDadd_W(RDadd_W)
			);

MUX_WB write_back(
			.Result_src_W(Result_src_W),
			.ALU_result_W(ALU_result_W),
			.mem_read_W(mem_read_W),
			.RESULT_WB(RESULT_WB)
			);

endmodule