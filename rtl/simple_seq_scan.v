`timescale 1ns/1ps

module simple_seq_comb (
    input clk,      
    input a,
    input b,
    input c,
    input d,
    output z_out,
    output n1_obs,  
    output n2_obs,  
    output n3_obs,
    output n4_obs 
);

    wire n1;
    wire n2;
    wire n3;
    wire n4;
    wire z_comb;

    assign n1 = a & b;
    assign n2 = c | d;
    assign n3 = n1 ^ n2;
    assign n4 = a ^ d;
    assign z_comb = n3 ^ n4;

    assign z_out  = z_comb;
    assign n1_obs = n1;
    assign n2_obs = n2;
    assign n3_obs = n3;
    assign n4_obs = n4;

endmodule

module simple_seq_scan (
    input clk,
    input rst,
    input a,
    input b,
    input c,
    input d,
    output reg z
);

    wire z_comb;
    wire n1_obs, n2_obs, n3_obs, n4_obs;

    simple_seq_comb u_comb (
        .clk(clk),
        .a(a), .b(b), .c(c), .d(d),
        .z_out(z_comb),
        .n1_obs(n1_obs),
        .n2_obs(n2_obs),
        .n3_obs(n3_obs),
        .n4_obs(n4_obs)
    );

    always @(posedge clk) begin
        if (rst)
            z <= 1'b0;
        else
            z <= z_comb;
    end

endmodule