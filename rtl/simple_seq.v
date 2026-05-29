`timescale 1ns/1ps

module simple_seq (
    input clk,
    input rst,
    input a,
    input b,
    input c,
    input d,
    output reg z
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

    always @(posedge clk) begin
        if (rst) 
            z <= 1'b0;
        else 
            z <= z_comb;
    end

endmodule