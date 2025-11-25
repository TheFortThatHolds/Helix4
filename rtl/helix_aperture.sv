`include "helix_pkg.sv"

module helix_aperture #(
    parameter int THOUGHT_W = helix_pkg::THOUGHT_W,
    parameter int ACTION_W  = helix_pkg::ACTION_W
)(
    input  logic                      clk,
    input  logic                      rst_n,

    input  logic                      thought_valid,
    output logic                      thought_ready,
    input  logic [THOUGHT_W-1:0]      thought_data,

    output logic                      action_valid,
    input  logic                      action_ready,
    output logic [ACTION_W-1:0]       action_data,

    output logic                      efference_valid,
    input  logic                      efference_ready,
    output logic [THOUGHT_W-1:0]      efference_data
);

    logic collapse_arm;

    assign thought_ready   = (action_ready | ~action_valid) & (efference_ready | ~efference_valid);
    assign collapse_arm    = thought_valid & thought_ready;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            action_valid    <= 1'b0;
            efference_valid <= 1'b0;
            action_data     <= '0;
            efference_data  <= '0;
        end else begin
            if(collapse_arm) begin
                action_data     <= ^thought_data ? thought_data[THOUGHT_W-1 -: ACTION_W] : thought_data[ACTION_W-1:0];
                action_valid    <= 1'b1;
                efference_data  <= thought_data;
                efference_valid <= 1'b1;
            end else begin
                if(action_ready)
                    action_valid <= 1'b0;
                if(efference_ready)
                    efference_valid <= 1'b0;
            end
        end
    end
endmodule