module vc_module (
     input wire clk,
     input wire reset,
     input wire [31:0] in_data,      // Incoming Data
     input wire in_valid,            // Incoming valid signal
     output wire in_ready,           // Ready to accept data from upstream
     output wire [31:0] out_data,    // Outgoing flit data (head-of-line)
     output wire out_valid,          // Outgoing valid signal
     input wire out_ready,           // Ready signal from switch to accept flit
     input wire in_head,             // Incoming head flit
     input wire in_tail,             // Incoming tail flit
     output wire out_head,           // Outgoing head flit
     output wire out_tail            // Outgoing tail flit
);
    
// FIFO buffers for 2 VCs 
reg [31:0] vc_buffer[1:0];     
reg vc_valid[1:0];              // Valid flag for each VC
reg vc_head[1:0];               // Head flit flag for each VC
reg vc_tail[1:0];               // Tail flit flag for each VC
reg [1:0] selected_vc;          // Current Selected VC 
assign in_ready = !vc_valid[in_valid];  // Ready to accept when no valid flit in VC
    
// Incoming flit storage in VC
always @(posedge clk or posedge reset) begin
    if (reset) begin
        vc_valid[0] <= 1'b0;
        vc_valid[1] <= 1'b0;
    end 
    else if (in_valid && in_ready) begin
        vc_buffer[in_valid] <= in_data;
        vc_head[in_valid] <= in_head;
        vc_tail[in_valid] <= in_tail;
        vc_valid[in_valid] <= 1'b1;  // Mark VC as valid 
    end
end
    
// Transmit
assign out_data = vc_buffer[selected_vc];
assign out_valid = vc_valid[selected_vc];
assign out_head = vc_head[selected_vc];
assign out_tail = vc_tail[selected_vc];
    
// Clear VC valid flag when flit is sent 
always @(posedge clk) begin
    if (out_valid && out_ready) begin
        vc_valid[selected_vc] <= 1'b0;
    end
end
endmodule