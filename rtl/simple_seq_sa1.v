`timescale 1ns/1ps

// Stuck-at-1 fault model for simple_seq: wire n1 forced to 1
module simple_seq_sa1 (
    input clk,
    input rst,
    input a,
    input b,
    input c,
    input d,
    output reg z
);

    wire n1, n2, n3, n4, z_comb;

    assign n1 = 1'b1;        // n1 stuck-at-1 (was a & b)
    assign n2 = c | d;
    assign n3 = n1 ^ n2;
    assign n4 = a ^ d;
    assign z_comb = n3 ^ n4;

    always @(posedge clk) begin
        if (rst)
            z <= 1'b0;
        else
            z <= z_comb;
    end

endmodule
