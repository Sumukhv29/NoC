module router (
    input wire clk,
    input wire reset,
    input wire [31:0] in_data,
    input wire in_valid,
    input wire in_head,
    input wire in_tail,
    output wire in_ready,
    output wire [31:0] out_data,
    output wire out_valid,
    input wire out_ready,
    output wire out_head,
    output wire out_tail
);

// Internal wires for Virtual Channel 0 and 1
wire [31:0] vc0_data, vc1_data;
wire vc0_valid, vc1_valid, vc0_ready, vc1_ready;
wire vc0_head, vc0_tail, vc1_head, vc1_tail;
wire [1:0] selected_vc;

// Internal signal to control VC selection for input flits
reg vc_select;

// Instantiate two VC modules
vc_module vc0 (
    .clk(clk),
    .reset(reset),
    .in_data(in_data),
    .in_valid(in_valid && (vc_select == 1'b0)), // Gate in_valid by vc_select
    .in_ready(vc0_ready),
    .out_data(vc0_data),
    .out_valid(vc0_valid),
    .out_ready(vc0_ready),
    .in_head(in_head),
    .in_tail(in_tail),
    .out_head(vc0_head),
    .out_tail(vc0_tail)
);

vc_module vc1 (
    .clk(clk),
    .reset(reset),
    .in_data(in_data),
    .in_valid(in_valid && (vc_select == 1'b1)), // Gate in_valid by vc_select
    .in_ready(vc1_ready),
    .out_data(vc1_data),
    .out_valid(vc1_valid),
    .out_ready(vc1_ready),
    .in_head(in_head),
    .in_tail(in_tail),
    .out_head(vc1_head),
    .out_tail(vc1_tail)
);

// Controller to select active VC for output flits
controller_module controller_inst (
    .clk(clk),
    .reset(reset),
    .vc0_valid(vc0_valid),
    .vc1_valid(vc1_valid),
    .selected_vc(selected_vc)
);

// Logic for selecting which VC receives incoming flits
always @(posedge clk or posedge reset) begin
    if (reset) begin
        vc_select <= 1'b0;  // Default to VC0
    end else if (in_valid && (vc0_ready || vc1_ready)) begin
        if (vc0_ready) begin
            vc_select <= 1'b0;  // Select VC0 if it's ready
        end else if (vc1_ready) begin
            vc_select <= 1'b1;  // Select VC1 if VC0 isn't ready
        end
    end
end

// Output multiplexer (switch) to forward the data from selected VC
switch_module switch_inst (
    .clk(clk),
    .reset(reset),
    .vc0_data(vc0_data),
    .vc0_valid(vc0_valid),
    .vc1_data(vc1_data),
    .vc1_valid(vc1_valid),
    .vc0_ready(vc0_ready),
    .vc1_ready(vc1_ready),
    .selected_vc(selected_vc),
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_head(out_head),
    .out_tail(out_tail),
    .vc0_head(vc0_head),
    .vc0_tail(vc0_tail),
    .vc1_head(vc1_head),
    .vc1_tail(vc1_tail)
);

// Set the in_ready signal to true when either VC is ready to receive flits
assign in_ready = (vc0_ready && vc_select == 1'b0) || (vc1_ready && vc_select == 1'b1);

endmodule
