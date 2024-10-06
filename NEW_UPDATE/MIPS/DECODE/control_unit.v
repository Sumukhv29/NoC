module control_unit(
	input		[5:0]	opcode,
	input		[5:0]	fun,			//fun[1:0] is dest add and fun[3:0] is operand
	
	input 			mips_ni,		//indicates NI can accept data
	input			data_valid,		//indicates data to processor is valid
	output	reg	[1:0]	dest_add_D,		
	output	reg		proc_valid_D,		//indicates data from processor is valid (control to send data to NI)
	output	reg		proc_ready_in_D,	//indicates processor is ready to accept the data
	output	reg		alu_out_D,		//sel to send data from alu to NI
	output	reg		reg_en,

	output	reg		Jump_D,
	output	reg		Beq_D,
	output	reg		Bneq_D,
	output 	reg		RegW_enable_D,
	output	reg	[1:0]	Extend_enable_D,
	output	reg		ALU_src_D,
	output	reg	[3:0]	ALU_control_D,
	output	reg		Mem_Write_D,
	output	reg		Mem_Read_D,
	output	reg		Result_src_D
);

localparam
	lw 	= 6'b100000,
	sw 	= 6'b100001,
	beq 	= 6'b100010,
	bne 	= 6'b100011,
	addi	= 6'b100100,
	andi 	= 6'b100101,
	ori	= 6'b100110,
	slti	= 6'b100111,
	
	Jtype	= 6'b111111,

	Rtype	= 6'b110000,
	
	NOP	= 6'b000000,

	ni_out	= 6'b010101,
	ni_in 	= 6'b011010;


always @(*) begin
	alu_out_D	= 0;
	proc_ready_in_D	= 1;
	proc_valid_D	= 0;
	reg_en		= 0;

	Jump_D		= 0; //PC_src = 1;
	Beq_D		= 0;
	Bneq_D		= 0;
	RegW_enable_D 	= 0;
	Extend_enable_D	= 0;
	ALU_src_D	= 0;
	ALU_control_D	= 0;
	Mem_Write_D	= 0;
	Mem_Read_D	= 0;
	Result_src_D	= 0;

	case(opcode)
		Rtype: begin
			RegW_enable_D = 1;
			ALU_control_D = fun[3:0];
			end
		
		lw: begin
			RegW_enable_D = 1;
			Extend_enable_D = 2'b10;
			ALU_src_D = 1;
			ALU_control_D = 4'b0001; //add
			Mem_Read_D = 1;
			Result_src_D = 1;
			end

		sw: begin
			Extend_enable_D = 2'b10;
			ALU_src_D = 1;
			ALU_control_D = 4'b0001; //add
			Mem_Write_D = 1;
			end
		
		beq: begin
			Beq_D = 1;
			Extend_enable_D = 2'b10;
			ALU_control_D = 4'b0010; // sub and compare
			//PC_Src =1;
			end
		
		bne: begin
			Bneq_D = 1;
			Extend_enable_D = 2'b10;
			ALU_control_D = 4'b0010; //sub and compare
			//PC_scr = 1;
			end
	
		addi: begin
			Extend_enable_D = 2'b10;
			RegW_enable_D = 1;
			ALU_src_D = 1;
			ALU_control_D = 4'b0001;
			end
		
		andi: begin
			Extend_enable_D = 2'b10;
			RegW_enable_D = 1;
			ALU_src_D = 1;
			ALU_control_D = 4'b0101;
			end
		
		ori: begin
			Extend_enable_D = 2'b10;
			RegW_enable_D = 1;
			ALU_src_D = 1;
			ALU_control_D = 4'b0110;
			end
		
		Jtype: begin
			Jump_D = 1;
			Extend_enable_D = 2'b11;
			ALU_control_D = 4'b0000; //output of ALU is zero
			end

		ni_out: begin	
			if(mips_ni) begin
				dest_add_D = fun[5:4];
				proc_valid_D = 1;
				alu_out_D = 1;
				end
			end

		ni_in: begin
			if(data_valid) begin
				reg_en = 1;
				end	
			end
			
	  	default: begin
			alu_out_D	= 1'b0;
			proc_ready_in_D	= 1'b1;
			proc_valid_D	= 1'b0;
			reg_en		= 1'b0;

			Jump_D		= 1'b0; 
			Beq_D		= 1'b0;
			Bneq_D		= 1'b0;
			RegW_enable_D 	= 1'b0;
			Extend_enable_D	= 2'b00;
			ALU_src_D	= 1'b0;
			ALU_control_D	= 4'b0000;
			Mem_Write_D	= 1'b0;
			Mem_Read_D	= 1'b0;
			Result_src_D	= 1'b0;
			end
	endcase
end
		
endmodule