`timescale 1ns/1ps

module redundant_comb (
    input clk,
    input a,
    input b,
    input c,
    output y,
    output z
);

    wire na = ~a;
    wire p1 = na & b;
    wire p2 = a & c;
    wire p3 = b & c;

    assign y = p1 | p2; // y = (~a & b) | (a & c)
    assign z = p1 | p2 | p3; // z = y | (b & c) = y (redundant)

endmodule