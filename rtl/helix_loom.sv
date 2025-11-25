`include "helix_pkg.sv"

module helix_loom #(
    parameter int THOUGHT_W = helix_pkg::THOUGHT_W,
    parameter int ACTION_W  = helix_pkg::ACTION_W,
    parameter int FEEDBACK_W= helix_pkg::FEEDBACK_W
)(
    input  logic                      clk,
    input  logic                      rst_n,

    input  logic                      efference_valid,
    output logic                      efference_ready,
    input  logic [THOUGHT_W-1:0]      efference_data,

    input  logic                      world_valid,
    output logic                      world_ready,
    input  logic [ACTION_W-1:0]       world_data,

    output logic                      feedback_valid,
    input  logic                      feedback_ready,
    output logic [FEEDBACK_W-1:0]     feedback_delta
);

    logic [FEEDBACK_W-1:0] error_accum;
    assign efference_ready = world_ready & (feedback_ready | ~feedback_valid);
    assign world_ready     = efference_ready;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            feedback_valid <= 1'b0;
            feedback_delta <= '0;
            error_accum    <= '0;
        end else begin
            if(efference_valid && efference_ready && world_valid) begin
                error_accum <= efference_data[FEEDBACK_W-1:0] ^ { {(FEEDBACK_W-ACTION_W){1'b0}}, world_data };
                feedback_delta <= error_accum;
                feedback_valid <= 1'b1;
            end else if(feedback_ready) begin
                feedback_valid <= 1'b0;
            end
        end
    end
endmodule