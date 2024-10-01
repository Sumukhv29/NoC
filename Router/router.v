module router (
     input wire clk,
     input wire reset,
     input wire [31:0] in_data,      // Incoming flit data
     input wire in_valid,            // Incoming valid signal
     output wire in_ready,           // Ready to accept data from upstream
     input wire in_head,             // Head flit
     input wire in_tail,             // Tail flit
     output wire [31:0] out_data,    // Outgoing flit data
     output wire out_valid,          // Outgoing valid signal
     input wire out_ready,           // Ready signal from downstream
     output wire out_head,           // Outgoing head flit
     output wire out_tail            // Outgoing tail flit
);
    
wire [31:0] vc_data;
wire vc_valid, vc_ready, vc_head, vc_tail;
wire [1:0] selected_vc;

vc_module vc_inst (
      .clk(clk),
      .reset(reset),
      .in_data(in_data),
      .in_valid(in_valid),
      .in_ready(in_ready),
      .out_data(vc_data),
      .out_valid(vc_valid),
      .out_ready(vc_ready),
      .in_head(in_head),
      .in_tail(in_tail),
      .out_head(vc_head),
      .out_tail(vc_tail)
);
    

controller_module controller_inst (
      .clk(clk),
      .reset(reset),
      .vc0_valid(vc_valid),         
      .vc1_valid(vc_valid),         
      .selected_vc(selected_vc)
);
    

switch_module switch_inst (
      .clk(clk),
      .reset(reset),
      .vc_data(vc_data),
      .vc_valid(vc_valid),
      .vc_ready(vc_ready),
      .vc_head(vc_head),
      .vc_tail(vc_tail),
      .out_data(out_data),
      .out_valid(out_valid),
      .out_ready(out_ready),
      .out_head(out_head),
      .out_tail(out_tail)
);
    
endmodule
	