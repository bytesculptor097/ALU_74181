`timescale 1ns/1ps

module tb_alu_74181;

    // DUT signals
    reg  [3:0] A, B, S;
    reg        M, Cn;
    wire [3:0] F;
    wire       G, P, E, Cn4;

    // Instantiate ALU
    alu_74181 dut (
        .A(A),
        .B(B),
        .S(S),
        .M(M),
        .Cn(Cn),
        .F(F),
        .G(G),
        .P(P),
        .E(E),
        .Cn4(Cn4)
    );

    // Task for printing results in a readable way
    task print_result;
        begin
            $display("M=%b | Cn=%b | S=%b | A=%b | B=%b || F=%b | G=%b | P=%b | E=%b | Cn4=%b",
                M, Cn, S, A, B, F, G, P, E, Cn4);
        end
    endtask

    initial begin
        $display("----- 74181 ALU Functional Testbench -----");
        // Example test vectors
        // Try a variety of S, M, Cn, and A/B values!
        A  = 4'b0011; B = 4'b1010; S = 4'b0000; M = 1'b1; Cn = 1'b0; #5; print_result(); // Logic op
        S  = 4'b1001;                                 #5; print_result();
        S  = 4'b1111;                                 #5; print_result();

        M  = 1'b0; S = 4'b1001; Cn = 1'b0;           #5; print_result(); // Arithmetic op
        Cn = 1'b1;                                   #5; print_result();
        S  = 4'b0000;                                #5; print_result();

        // Sweep S in logic mode
        M = 1; A = 4'b1100; B = 4'b0111; Cn = 1'b0;
        for (integer i = 0; i < 16; i = i+1) begin
            S = i;
            #2; print_result();
        end

        // Sweep S in arithmetic mode
        M = 0; A = 4'b1010; B = 4'b0011; Cn = 0;
        for (integer i = 0; i < 16; i = i+1) begin
            S = i;
            #2; print_result();
        end

        $display("----- End of Simulation -----");
        $finish;
    end

endmodule
