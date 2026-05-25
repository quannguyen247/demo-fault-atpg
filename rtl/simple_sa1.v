`timescale 1ns/1ps

module simple_logic_sa1 (
    input a,
    input b,
    input c,
    output z
);

    wire x, y;

    assign x = 1'b1; // x stuck-at-1
    assign y = x | c;
    assign z = y ^ c;

endmodule