module controller_module (
     input wire clk,
     input wire reset,
     input wire vc0_valid,
     input wire vc1_valid,
     output reg [1:0] selected_vc,   // Selected VC for transmission
     input wire [31:0] in_flit,      // Incoming flit for routing decision
     output reg [1:0] out_port       // Selected output port 
);
    
always @(posedge clk or posedge reset) begin
    if (reset) begin
        selected_vc <= 2'b00;
    end 
    else begin
// Static VC selection: if VC0 is valid, select it, otherwise VC1
        if(vc0_valid) begin
            selected_vc <= 2'b00;
        end 
        else if(vc1_valid) begin
            selected_vc <= 2'b01;
        end
    end
end
    
// Output port selection based on input flit
always @(in_flit) begin
    if(in_flit[31:24] == 8'h01) begin
        out_port <= 2'b00;      // Route to port 0
    end 
    else if(in_flit[31:24] == 8'h02) begin
        out_port <= 2'b01;      // Route to port 1
    end
end
endmodule