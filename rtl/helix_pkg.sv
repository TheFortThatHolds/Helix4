package helix_pkg;
    // Widths for major busses
    parameter int INPUT_W     = 256;   // user input / sensor vector width
    parameter int CONTEXT_W   = 512;   // Reservoir context vector width
    parameter int THOUGHT_W   = 1024;  // Reactor expanded state
    parameter int ACTION_W    = 256;   // Aperture output tokens
    parameter int FEEDBACK_W  = 384;   // Loom-generated feedback

    typedef struct packed {
        logic [CONTEXT_W-1:0] context;
        logic                 valid;
    } reservoir_packet_t;

    typedef struct packed {
        logic [THOUGHT_W-1:0] state;
        logic                 valid;
    } reactor_packet_t;

    typedef struct packed {
        logic [ACTION_W-1:0] action;
        logic [THOUGHT_W-1:0] efference;
        logic                  valid;
    } aperture_packet_t;

    typedef struct packed {
        logic [FEEDBACK_W-1:0] delta;
        logic                  valid;
    } loom_packet_t;
endpackage : helix_pkg