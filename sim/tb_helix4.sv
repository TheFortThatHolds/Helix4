`timescale 1ns/1ps

module tb_helix4;

    localparam int INPUT_W_TB   = 32;
    localparam int CONTEXT_W_TB = 64;
    localparam int THOUGHT_W_TB = 96;
    localparam int ACTION_W_TB  = 24;
    localparam int FEEDBACK_W_TB= 32;

    logic clk;
    logic rst_n;

    logic user_valid;
    logic user_ready;
    logic [INPUT_W_TB-1:0] user_data;

    logic world_valid;
    logic world_ready;
    logic [ACTION_W_TB-1:0] world_data;

    logic action_valid;
    logic action_ready;
    logic [ACTION_W_TB-1:0] action_data;

    helix4_die #(
        .INPUT_W   (INPUT_W_TB),
        .CONTEXT_W (CONTEXT_W_TB),
        .THOUGHT_W (THOUGHT_W_TB),
        .ACTION_W  (ACTION_W_TB),
        .FEEDBACK_W(FEEDBACK_W_TB)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .user_valid   (user_valid),
        .user_ready   (user_ready),
        .user_data    (user_data),
        .world_valid  (world_valid),
        .world_ready  (world_ready),
        .world_data   (world_data),
        .action_valid (action_valid),
        .action_ready (action_ready),
        .action_data  (action_data)
    );

    // clock gen
    initial clk = 0;
    always #5 clk = ~clk;

    // simple scoreboard
    int action_count = 0;
    logic [ACTION_W_TB-1:0] action_hist [0:7];

    // tasks
    task automatic send_user(input logic [INPUT_W_TB-1:0] value);
        begin
            @(posedge clk);
            user_data  <= value;
            user_valid <= 1'b1;
            do @(posedge clk); while(!user_ready);
            user_valid <= 1'b0;
        end
    endtask

    task automatic send_world(input logic [ACTION_W_TB-1:0] value);
        begin
            @(posedge clk);
            world_data  <= value;
            world_valid <= 1'b1;
            do @(posedge clk); while(!world_ready);
            world_valid <= 1'b0;
        end
    endtask

    // capture action stream
    always_ff @(posedge clk) begin
        if(action_valid && action_ready) begin
            action_hist[action_count] <= action_data;
            action_count <= action_count + 1;
            $display("[TB] action #%0d = %0d", action_count, action_data);
        end
    end

    initial begin
        rst_n = 0;
        user_valid = 0;
        world_valid = 0;
        action_ready = 1;
        user_data = '0;
        world_data = '0;
        repeat(5) @(posedge clk);
        rst_n = 1;

        send_user(32'd25);
        send_world(24'd50);

        send_user(32'd125);
        send_world(24'd30);

        send_user(32'd55);
        send_world(24'd10);

        repeat(30) @(posedge clk);
        $display("[TB] total actions observed=%0d", action_count);
        $finish;
    end

endmodule
