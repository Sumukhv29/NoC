module switch_module (
     input wire clk,
     input wire reset,
     input wire [31:0] vc_data,      // Incoming flit data from VC
     input wire vc_valid,            // Valid signal from VC
     output wire vc_ready,           // Ready signal to VC
     input wire vc_head,             // Head flit from VC
     input wire vc_tail,             // Tail flit from VC
     output reg [31:0] out_data,     // Outgoing flit data
     output reg out_valid,           // Outgoing valid signal
     input wire out_ready,           // Ready signal from downstream router
     output reg out_head,            // Head flit to downstream
     output reg out_tail             // Tail flit to downstream
);
    
reg selected_vc;   // Static allocation: select VC 0 or 1
assign vc_ready = out_ready && vc_valid;
    
// Switch Controller Logic 
always @(posedge clk or posedge reset) begin
    if (reset) begin
        selected_vc <= 1'b0;
    end 
    else if (vc_valid && vc_ready) begin
         out_data <= vc_data;
         out_head <= vc_head;
         out_tail <= vc_tail;
         out_valid <= 1'b1;
    end 
    else if (out_valid && out_ready) begin
         out_valid <= 1'b0;  // Clear valid after transmission
    end
end
endmodule