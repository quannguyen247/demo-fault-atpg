`timescale 1ns/1ps

module partial_scan (
    input clk,
    input rst,
    input a,
    input b,
    input c,
    input d,
    output y,
    output reg z
);

    wire n1 = a ^ b;
    wire n2 = c | d;

    assign y = n1 & n2; // combinational output (testable)

    wire z_comb = n1 | n2; // different function for z path

    always @(posedge clk) begin
        if (rst)
            z <= 1'b0;
        else
            z <= z_comb;
    end

endmodule