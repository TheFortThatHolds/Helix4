`include "helix_pkg.sv"

module helix4_quad_cluster #(
    parameter int INPUT_W    =  `HELIX_INPUT_W ,
    parameter int ACTION_W   =  `HELIX_ACTION_W 
)(
    input  logic                       clk,
    input  logic                       rst_n,

    input  logic [3:0]                 user_valid,
    output logic [3:0]                 user_ready,
    input  logic [3:0][INPUT_W-1:0]    user_data,

    input  logic [3:0]                 world_valid,
    output logic [3:0]                 world_ready,
    input  logic [3:0][ACTION_W-1:0]   world_data,

    output logic [3:0]                 action_valid,
    input  logic [3:0]                 action_ready,
    output logic [3:0][ACTION_W-1:0]   action_data
);

    // instantiate four dies representing LookIn, SpiralUp, FlowOut, Return roles
    genvar g;
    for(g = 0; g < 4; g++) begin : gen_dies
        helix4_die u_die (
            .clk         (clk),
            .rst_n       (rst_n),
            .user_valid  (user_valid[g]),
            .user_ready  (user_ready[g]),
            .user_data   (user_data[g]),
            .world_valid (world_valid[g]),
            .world_ready (world_ready[g]),
            .world_data  (world_data[g]),
            .action_valid(action_valid[g]),
            .action_ready(action_ready[g]),
            .action_data (action_data[g])
        );
    end

endmodule
