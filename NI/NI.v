module NI(
	input			clk,
	input			rst,
	input		[1:0]	dest_add,
	
	//processor interface
	input		[31:0]	data_in,	//data from processor
	input			proc_valid,	//indicates data from processor is valid
	output	reg		proc_ready,	//indicates NI is ready to accept new data	
	
	output	reg	[31:0]	data_out,	//data to processor
	output	reg		data_valid,	//indicates data to the processor is valid 
	input			proc_ready_in,	//indicates processor is ready to accept the data

	//NoC interface
	input		[7:0]	flit_in,	//flit from NoC to NI
	input			flit_in_valid,	//indicates incoming flit is valid
	output	reg		noc_ready_out,	//indicates if NI is ready to accept incoming flits from router

	output	reg	[7:0]	flit_out,	//flit from NI to NoC
	output	reg		flit_valid,	//indicates flit valid for transmission
	input			noc_ready	//indicates if router is ready to accept the flit
);

parameter HEADER = 6'b111111;
parameter TAILER = 8'b11111111;

reg	[47:0]	packet_buffer_in;
reg	[47:0]	packet_buffer_out;
reg	[2:0]	flit_count_out;
reg	[2:0]	flit_count_in;
reg	[1:0]	state_out;
reg	[1:0]	state_in;

localparam
	IDLE		= 2'b00,
	SEND_HEAD	= 2'b01,
	SEND_DATA	= 2'b10,
	SEND_TAIL	= 2'b11,

	RECV_HEAD	= 2'b00,
	RECV_DATA	= 2'b01,
	RECV_TAIL	= 2'b10,
	RECV_DONE	= 2'b11;

//MIPS to NoC
always @(posedge clk or posedge rst) begin
	if(rst) begin
		packet_buffer_out	<= 48'd0;
		state_out		<= IDLE;
		flit_count_out		<= 0;
		proc_ready		<= 1;
		flit_valid		<= 0;
	end

	else begin
		case(state_out)
			IDLE: begin
				if(proc_valid) begin
					packet_buffer_out[47:40]	<= {HEADER, dest_add};
					packet_buffer_out[39:8]		<= data_in;
					packet_buffer_out[7:0]		<= TAILER;
					proc_ready			<= 0;
					state_out			<= SEND_HEAD;
				end
			end

			SEND_HEAD: begin
				if(noc_ready) begin
					flit_out	<= packet_buffer_out[47:40];
					flit_valid	<= 1;
					flit_count_out	<= 1;
					state_out	<= SEND_DATA;
				end
			end

			SEND_DATA: begin
				if(noc_ready && (flit_count_out <= 4)) begin
					case(flit_count_out)
						1: flit_out <= packet_buffer_out[39:32];
						2: flit_out <= packet_buffer_out[31:24];
						3: flit_out <= packet_buffer_out[23:16];
						4: flit_out <= packet_buffer_out[15:8];
					endcase
					flit_count_out <= flit_count_out + 1;
				end
				else if(flit_count_out == 5) begin
					state_out <= SEND_TAIL;
				end
			end

			SEND_TAIL: begin
				if(noc_ready) begin
					flit_out 	<= packet_buffer_out[7:0];
					state_out	<= IDLE;
				end
			end
		endcase
	end
end

//NoC to MIPS
always @(posedge clk or posedge rst) begin
	if(rst) begin
		packet_buffer_in	<= 48'd0;
		state_in		<= RECV_HEAD;
		flit_count_in		<= 0;
		data_valid		<= 0;
	end

	else begin
		case(state_in)
			RECV_HEAD: begin
				if(flit_in_valid) begin
					packet_buffer_in[47:40]	<= flit_in;
					flit_count_in		<= 1;
					state_in		<= RECV_DATA;
				end
			end

			RECV_DATA: begin
				if(flit_in_valid && (flit_count_in <= 4))begin
					case(flit_count_in)
						1: packet_buffer_in[39:32] <= flit_in;
						2: packet_buffer_in[31:24] <= flit_in;
						3: packet_buffer_in[23:16] <= flit_in;
						4: packet_buffer_in[15:8]  <= flit_in;
					endcase
					flit_count_in <= flit_count_in + 1;
				end
				else if(flit_count_in == 5) begin
						state_in <= RECV_DONE;
				end 
			end

			RECV_TAIL: begin
				if(flit_in_valid) begin
					packet_buffer_in[7:0]	<= flit_in;
					state_in		<= RECV_DONE;
				end	
			end

			RECV_DONE: begin
				data_out 	<= packet_buffer_in[39:8];
				data_valid	<= 1;
				state_in	<= RECV_HEAD;
			end
		endcase
	end
end

endmodule