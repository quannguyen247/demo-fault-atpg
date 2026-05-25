`timescale 1ns/1ps

module simple_tb;

    reg a;
    reg b;
    reg c;
    wire z;

    reg [2:0] vec;
    integer i;

    simple_logic dut (
        .a(a),
        .b(b),
        .c(c),
        .z(z)
    );

    initial begin
        $dumpfile("results/simple.vcd");
        $dumpvars(0, simple_tb);
        $display("Vector | a b c | z");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, c} = i[2:0];

            #1;
            
            $display("  %0d    | %b %b %b | %b", i, a, b, c, z);
        end

        $finish;
    end

endmodule