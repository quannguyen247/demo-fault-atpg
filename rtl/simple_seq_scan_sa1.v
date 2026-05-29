`timescale 1ns/1ps

module simple_seq_comb_sa1 (
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

    wire n1, n2, n3, n4, z_comb;

    assign n1 = 1'b1; // n1 SA1
    assign n2 = c | d;
    assign n3 = n1 ^ n2;
    assign n4 = a ^ d;
    assign z_comb = n3 ^ n4;

    assign z_out = z_comb;
    assign n1_obs = n1;
    assign n2_obs = n2;
    assign n3_obs = n3;
    assign n4_obs = n4;

endmodule