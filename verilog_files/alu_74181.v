// 4-bit ALU 74181 Verilog Implementation
// Author: bytesculptor097
// This module implements the logic functionality of the classic 74181 ALU chip

module alu_74181(
    input [3:0] A,      // 4-bit input operand A
    input [3:0] B,      // 4-bit input operand B
    input [3:0] S,      // 4-bit select lines for ALU function selection
    input M,            // Mode select: 1 for logic, 0 for arithmetic
    input Cn,           // Carry-in input (for arithmetic operations)
    output reg [3:0] F, // 4-bit output result
    output G,           // Generate output (carry generate)
    output P,           // Propagate output (carry propagate)
    output E,           // Equality flag (A == B)
    output Cn4          // Carry-out output (carry out of MSB)
);

// Intermediate wire for sum and carry-out calculation
wire [4:0] temp_sum;
assign temp_sum = A + B + Cn; // Used for carry-out
assign G = & (A & B);         // Generate: all bits of A AND B are set
assign P = | (A ^ B);         // Propagate: any bit differs between A and B
assign E = (A == B);          // Equality: A equals B
assign Cn4 = temp_sum[4];     // Carry-out: MSB of sum

// ALU main logic block
always @(*) begin
    if (M == 1'b1) begin
        // Logic operations (M = 1)
        case (S)
            4'b0000: F = ~A;              // NOT A
            4'b0001: F = ~(A & B);        // NAND
            4'b0010: F = ~A + B;          // NOT A + B (bitwise NOT then add)
            4'b0011: F = 4'b1111;         // All ones
            4'b0100: F = ~(A + B);        // NOT (A + B)
            4'b0101: F = ~B;              // NOT B
            4'b0110: F = ~(A ^ B);        // XNOR
            4'b0111: F = A + ~B;          // A + (NOT B)
            4'b1000: F = ~A & B;          // (NOT A) AND B
            4'b1001: F = A ^ B;           // XOR
            4'b1010: F = B;               // Pass B
            4'b1011: F = A + B;           // Addition (no carry-in)
            4'b1100: F = 4'b0000;         // All zeros
            4'b1101: F = A & ~B;          // A AND (NOT B)
            4'b1110: F = A & B;           // AND
            4'b1111: F = A;               // Pass A
        endcase
    end else begin
        // Arithmetic operations (M = 0)
        if (Cn == 1'b0) begin
            // Carry-in = 0
            case (S)
                4'b0000: F = A - 1;                               // Decrement A
                4'b0001: F = (A & B) - 1;                         // (A AND B) - 1
                4'b0010: F = (A & ~B) - 1;                        // (A AND NOT B) - 1
                4'b0011: F = -1;                                  // All ones (signed -1)
                4'b0100: F = A + (A + ~B);                        // A + (A + NOT B)
                4'b0101: F = (A & B) + (A + ~B);                  // (A AND B) + (A + NOT B)
                4'b0110: F = A - B - 1;                           // A minus B minus 1
                4'b0111: F = A + ~B;                              // A + (NOT B)
                4'b1000: F = A + (A + B);                         // A + (A + B)
                4'b1001: F = A + B;                               // A plus B
                4'b1010: F = (A & ~B) + (A + B);                  // (A AND NOT B) + (A + B)
                4'b1011: F = A + B;                               // A plus B
                4'b1100: F = A;                                   // Pass A
                4'b1101: F = (A & B) + A;                         // (A AND B) + A
                4'b1110: F = (A & ~B) + A;                        // (A AND NOT B) + A
                4'b1111: F = A;                                   // Pass A
            endcase
        end else begin
            // Carry-in = 1
            case (S)
                4'b0000: F = A;                                   // Pass A
                4'b0001: F = (A & B);                             // A AND B
                4'b0010: F = (A & ~B);                            // A AND NOT B
                4'b0011: F = 4'b0000;                             // All zeros
                4'b0100: F = A + (A + ~B) + 1;                    // A + (A + NOT B) + 1
                4'b0101: F = (A & B) + (A + ~B) + 1;              // (A AND B) + (A + NOT B) + 1
                4'b0110: F = A - B;                               // A minus B
                4'b0111: F = A + ~B + 1;                          // A + (NOT B) + 1
                4'b1000: F = A + (A + B) + 1;                     // A + (A + B) + 1
                4'b1001: F = A + B + 1;                           // A plus B plus 1
                4'b1010: F = (A & ~B) + (A + B) + 1;              // (A AND NOT B) + (A + B) + 1
                4'b1011: F = A + B + 1;                           // A plus B plus 1
                4'b1100: F = (A + A) + 1;                         // Double A plus 1
                4'b1101: F = (A & B) + A + 1;                     // (A AND B) + A + 1
                4'b1110: F = (A & ~B) + A + 1;                    // (A AND NOT B) + A + 1
                4'b1111: F = A + 1;                               // A plus 1 (increment)
            endcase
        end
    end
end

endmodule
