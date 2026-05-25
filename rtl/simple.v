`timescale 1ns/1ps

module simple_logic (
    input a,
    input b,
    input c,
    output z
);

    wire x, y;

    assign x = a & b;
    assign y = x | c;
    assign z = y ^ c;

endmodule