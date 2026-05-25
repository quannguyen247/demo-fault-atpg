`timescale 1ns/1ps

module fault_injection_tb;

    reg a;
    reg b;
    reg c;

    wire z_golden;
    wire z_sa0;
    wire z_sa1;

    reg [2:0] vec;
    integer i;
    integer detected_sa0;
    integer detected_sa1;

    simple_logic dut_golden (
        .a(a),
        .b(b),
        .c(c),
        .z(z_golden)
    );

    simple_logic_sa0 dut_sa0 (
        .a(a),
        .b(b),
        .c(c),
        .z(z_sa0)
    );

    simple_logic_sa1 dut_sa1 (
        .a(a),
        .b(b),
        .c(c),
        .z(z_sa1)
    );

    initial begin
        $dumpfile("results/fault_injection.vcd");
        $dumpvars(0, fault_injection_tb);

        detected_sa0 = 0;
        detected_sa1 = 0;

        $display("Vector | a b c | golden sa0 sa1 | detect_sa0 detect_sa1");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, c} = i[2:0];

            #1;

            if (z_golden !== z_sa0) begin
                detected_sa0 = detected_sa0 + 1;
            end

            if (z_golden !== z_sa1) begin
                detected_sa1 = detected_sa1 + 1;
            end

            $display(
                "  %0d    | %b %b %b |    %b    %b   %b  |     %b          %b",
                i,
                a, b, c,
                z_golden,
                z_sa0,
                z_sa1,
                z_golden !== z_sa0,
                z_golden !== z_sa1
            );
        end

        $display("Stuck-at-0 detections: %0d/8", detected_sa0);
        $display("Stuck-at-1 detections: %0d/8", detected_sa1);
        $display("FAULT INJECTION DEMO PASSED.");

        $finish;
    end

endmodule