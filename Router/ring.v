module ring_network (
    input wire clk,
    input wire reset,
    
    // Inputs to Router 0 (external input)
    input wire [31:0] r0_in_data,   // Data input to Router 0
    input wire r0_in_valid,         // Valid signal for Router 0 input
    output wire r0_in_ready,        // Ready signal from Router 0 to external input
    input wire r0_in_head,          // Head flit signal for Router 0 input
    input wire r0_in_tail,          // Tail flit signal for Router 0 input

    // Outputs from Router 3 (external output)
    output wire [31:0] r3_out_data, // Data output from Router 3
    output wire r3_out_valid,       // Valid signal for Router 3 output
    input wire r3_out_ready,        // Ready signal for Router 3 output
    output wire r3_out_head,        // Head flit signal for Router 3 output
    output wire r3_out_tail         // Tail flit signal for Router 3 output
);
    
    // Internal signals for router interconnections (clockwise ring)
    wire [31:0] r0_out_data, r1_out_data, r2_out_data, r3_out_data_internal;
    wire r0_out_valid, r1_out_valid, r2_out_valid, r3_out_valid_internal;
    wire r0_out_ready, r1_out_ready, r2_out_ready, r3_out_ready_internal;
    wire r0_out_head, r1_out_head, r2_out_head, r3_out_head_internal;
    wire r0_out_tail, r1_out_tail, r2_out_tail, r3_out_tail_internal;
    
    // Instantiate Router 0 (connected to Router 1)
    router r0 (
        .clk(clk),
        .reset(reset),
        .in_data(r0_in_data),        // External input to Router 0
        .in_valid(r0_in_valid),      // External valid signal to Router 0
        .in_ready(r0_in_ready),      // External ready signal from Router 0
        .in_head(r0_in_head),        // External head flit signal
        .in_tail(r0_in_tail),        // External tail flit signal
        .out_data(r0_out_data),      // Output to Router 1
        .out_valid(r0_out_valid),
        .out_ready(r1_out_ready),    // Router 1's ready signal
        .out_head(r0_out_head),
        .out_tail(r0_out_tail)
    );
    
    // Instantiate Router 1 (connected to Router 2)
    router r1 (
        .clk(clk),
        .reset(reset),
        .in_data(r0_out_data),       // Input from Router 0
        .in_valid(r0_out_valid),
        .in_ready(r1_out_ready),     // Ready signal to Router 0
        .in_head(r0_out_head),
        .in_tail(r0_out_tail),
        .out_data(r1_out_data),      // Output to Router 2
        .out_valid(r1_out_valid),
        .out_ready(r2_out_ready),    // Router 2's ready signal
        .out_head(r1_out_head),
        .out_tail(r1_out_tail)
    );
    
    // Instantiate Router 2 (connected to Router 3)
    router r2 (
        .clk(clk),
        .reset(reset),
        .in_data(r1_out_data),       // Input from Router 1
        .in_valid(r1_out_valid),
        .in_ready(r2_out_ready),     // Ready signal to Router 1
        .in_head(r1_out_head),
        .in_tail(r1_out_tail),
        .out_data(r2_out_data),      // Output to Router 3
        .out_valid(r2_out_valid),
        .out_ready(r3_out_ready_internal),  // Router 3's internal ready signal
        .out_head(r2_out_head),
        .out_tail(r2_out_tail)
    );
    
    // Instantiate Router 3 (connected to external output and Router 0 internally)
    router r3 (
        .clk(clk),
        .reset(reset),
        .in_data(r2_out_data),       // Input from Router 2
        .in_valid(r2_out_valid),
        .in_ready(r3_out_ready_internal), // Ready signal to Router 2
        .in_head(r2_out_head),
        .in_tail(r2_out_tail),
        .out_data(r3_out_data_internal),  // Output to Router 0 (clockwise ring)
        .out_valid(r3_out_valid_internal),
        .out_ready(r0_out_ready),    // Router 0's ready signal
        .out_head(r3_out_head_internal),
        .out_tail(r3_out_tail_internal)
    );
    
    // Connect Router 3's external output to outside the ring
    assign r3_out_data = r3_out_data_internal;
    assign r3_out_valid = r3_out_valid_internal;
    assign r3_out_head = r3_out_head_internal;
    assign r3_out_tail = r3_out_tail_internal;
    assign r3_out_ready_internal = r3_out_ready;  // External ready signal
    
endmodule

