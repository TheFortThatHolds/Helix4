`include "helix_pkg.sv"

module helix4_die #(
    parameter int INPUT_W    =  `HELIX_INPUT_W ,
    parameter int CONTEXT_W  =  `HELIX_CONTEXT_W ,
    parameter int THOUGHT_W  =  `HELIX_THOUGHT_W ,
    parameter int ACTION_W   =  `HELIX_ACTION_W ,
    parameter int FEEDBACK_W =  `HELIX_FEEDBACK_W 
)(
    input  logic                      clk,
    input  logic                      rst_n,

    // External stimulus into Reservoir
    input  logic                      user_valid,
    output logic                      user_ready,
    input  logic [INPUT_W-1:0]        user_data,

    // Environment feedback toward Loom
    input  logic                      world_valid,
    output logic                      world_ready,
    input  logic [ACTION_W-1:0]       world_data,

    // Action output after Aperture
    output logic                      action_valid,
    input  logic                      action_ready,
    output logic [ACTION_W-1:0]       action_data
);

    logic                        ctx_valid, ctx_ready;
    logic [CONTEXT_W-1:0]        ctx_data;

    logic                        thought_valid, thought_ready;
    logic [THOUGHT_W-1:0]        thought_data;

    logic                        efference_valid, efference_ready;
    logic [THOUGHT_W-1:0]        efference_data;

    logic                        feedback_valid, feedback_ready;
    logic [FEEDBACK_W-1:0]       feedback_delta;

    logic [1:0]                  precision_mode;

    // simple state machine for precision stepping
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            precision_mode <= 2'b00;
        end else if(action_valid && action_ready) begin
            precision_mode <= precision_mode + 2'b01;
        end
    end

    helix_reservoir #(
        .INPUT_W(INPUT_W),
        .CONTEXT_W(CONTEXT_W),
        .FEEDBACK_W(FEEDBACK_W)
    ) u_reservoir (
        .clk            (clk),
        .rst_n          (rst_n),
        .in_valid       (user_valid),
        .in_ready       (user_ready),
        .in_data        (user_data),
        .feedback_valid (feedback_valid),
        .feedback_delta (feedback_delta),
        .ctx_valid      (ctx_valid),
        .ctx_ready      (ctx_ready),
        .ctx_data       (ctx_data)
    );

    helix_reactor #(
        .CONTEXT_W(CONTEXT_W),
        .THOUGHT_W(THOUGHT_W)
    ) u_reactor (
        .clk            (clk),
        .rst_n          (rst_n),
        .ctx_valid      (ctx_valid),
        .ctx_ready      (ctx_ready),
        .ctx_data       (ctx_data),
        .precision_mode (precision_mode),
        .thought_valid  (thought_valid),
        .thought_ready  (thought_ready),
        .thought_data   (thought_data)
    );

    helix_aperture #(
        .THOUGHT_W(THOUGHT_W),
        .ACTION_W (ACTION_W)
    ) u_aperture (
        .clk             (clk),
        .rst_n           (rst_n),
        .thought_valid   (thought_valid),
        .thought_ready   (thought_ready),
        .thought_data    (thought_data),
        .action_valid    (action_valid),
        .action_ready    (action_ready),
        .action_data     (action_data),
        .efference_valid (efference_valid),
        .efference_ready (efference_ready),
        .efference_data  (efference_data)
    );

    helix_loom #(
        .THOUGHT_W(THOUGHT_W),
        .ACTION_W (ACTION_W),
        .FEEDBACK_W(FEEDBACK_W)
    ) u_loom (
        .clk             (clk),
        .rst_n           (rst_n),
        .efference_valid (efference_valid),
        .efference_ready (efference_ready),
        .efference_data  (efference_data),
        .world_valid     (world_valid),
        .world_ready     (world_ready),
        .world_data      (world_data),
        .feedback_valid  (feedback_valid),
        .feedback_ready  (feedback_ready),
        .feedback_delta  (feedback_delta)
    );

    // close feedback loop to Reservoir
    assign feedback_ready = ctx_ready;

endmodule
