`timescale 1ns/1ps

module simple_logic_sa0 (
    input a,
    input b,
    input c,
    output z
);

    wire x, y;

    assign x = 1'b0; // x stuck-at-0
    assign y = x | c;
    assign z = y ^ c;

endmodule