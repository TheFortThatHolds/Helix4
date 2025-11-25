`ifndef HELIX_PKG_SVH
`define HELIX_PKG_SVH

`define HELIX_INPUT_W    256
`define HELIX_CONTEXT_W  512
`define HELIX_THOUGHT_W 1024
`define HELIX_ACTION_W   256
`define HELIX_FEEDBACK_W 384

typedef struct packed {
    logic [`HELIX_CONTEXT_W-1:0] context;
    logic                        valid;
} reservoir_packet_t;

typedef struct packed {
    logic [`HELIX_THOUGHT_W-1:0] state;
    logic                        valid;
} reactor_packet_t;

typedef struct packed {
    logic [`HELIX_ACTION_W-1:0]  action;
    logic [`HELIX_THOUGHT_W-1:0] efference;
    logic                        valid;
} aperture_packet_t;

typedef struct packed {
    logic [`HELIX_FEEDBACK_W-1:0] delta;
    logic                         valid;
} loom_packet_t;

`endif // HELIX_PKG_SVH