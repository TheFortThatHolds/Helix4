`include "helix_pkg.sv"

module helix_reservoir #(
    parameter int INPUT_W   = helix_pkg::INPUT_W,
    parameter int CONTEXT_W = helix_pkg::CONTEXT_W,
    parameter int FEEDBACK_W= helix_pkg::FEEDBACK_W
)(
    input  logic                       clk,
    input  logic                       rst_n,

    // External stimulus
    input  logic                       in_valid,
    output logic                       in_ready,
    input  logic   [INPUT_W-1:0]       in_data,

    // Feedback from Loom updates latent potential
    input  logic                       feedback_valid,
    input  logic   [FEEDBACK_W-1:0]    feedback_delta,

    // Context vector output toward Reactor
    output logic                       ctx_valid,
    input  logic                       ctx_ready,
    output logic   [CONTEXT_W-1:0]     ctx_data
);

    logic [CONTEXT_W-1:0] latent_state;
    logic                 ctx_fire;

    assign in_ready = ctx_ready | ~ctx_valid; // accept new input when downstream ready
    assign ctx_fire = in_valid & in_ready;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            latent_state <= '0;
            ctx_valid    <= 1'b0;
        end else begin
            // integrate Loom feedback as xor-mix for placeholder behavior
            if(feedback_valid) begin
                latent_state[FEEDBACK_W-1:0] <= latent_state[FEEDBACK_W-1:0] ^ feedback_delta;
            end

            if(ctx_fire) begin
                latent_state <= {latent_state[CONTEXT_W-INPUT_W-1:0], in_data};
                ctx_data     <= latent_state ^ { {(CONTEXT_W-INPUT_W){1'b0}}, in_data };
                ctx_valid    <= 1'b1;
            end else if(ctx_ready) begin
                ctx_valid <= 1'b0;
            end
        end
    end
endmodule