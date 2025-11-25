`include "helix_pkg.sv"

module helix_reactor #(
    parameter int CONTEXT_W =  `HELIX_CONTEXT_W ,
    parameter int THOUGHT_W =  `HELIX_THOUGHT_W 
)(
    input  logic                      clk,
    input  logic                      rst_n,

    input  logic                      ctx_valid,
    output logic                      ctx_ready,
    input  logic [CONTEXT_W-1:0]      ctx_data,

    input  logic [1:0]                precision_mode,

    output logic                      thought_valid,
    input  logic                      thought_ready,
    output logic [THOUGHT_W-1:0]      thought_data
);

    logic [THOUGHT_W-1:0] accumulator;

    assign ctx_ready = thought_ready | ~thought_valid;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            accumulator  <= '0;
            thought_valid<= 1'b0;
            thought_data <= '0;
        end else begin
            if(ctx_valid && ctx_ready) begin
                case(precision_mode)
                    2'b00: accumulator <= {{(THOUGHT_W-CONTEXT_W){1'b0}}, ctx_data};
                    2'b01: accumulator <= {ctx_data, accumulator[THOUGHT_W-CONTEXT_W-1:0]};
                    2'b10: accumulator <= accumulator ^ {{(THOUGHT_W-CONTEXT_W){1'b0}}, ctx_data};
                    default: accumulator <= accumulator + {{(THOUGHT_W-CONTEXT_W){1'b0}}, ctx_data};
                endcase
                thought_data  <= accumulator;
                thought_valid <= 1'b1;
            end else if(thought_ready) begin
                thought_valid <= 1'b0;
            end
        end
    end
endmodule
