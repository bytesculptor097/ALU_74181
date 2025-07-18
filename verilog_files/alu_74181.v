module alu_74181(
    input [3:0] A,
    input [3:0] B,
    input [3:0] S,
    input M,
    input Cn,
    output reg [3:0] F,
    output G,
    output P,
    output E,
    output Cn4
);

wire [4:0] temp_sum;
assign temp_sum = A + B + Cn;
assign G = & (A & B);
assign P = | (A ^ B);
assign E = (A == B);
assign Cn4 = temp_sum[4];

always @(*) begin
    if (M == 1'b1) begin
        case (S)
            4'b0000: F = ~A;
            4'b0001: F = ~(A & B);
            4'b0010: F = ~A + B;
            4'b0011: F = 4'b1111;
            4'b0100: F = ~(A + B);
            4'b0101: F = ~B;
            4'b0110: F = ~(A ^ B);
            4'b0111: F = A + ~B;
            4'b1000: F = ~A & B;
            4'b1001: F = A ^ B;
            4'b1010: F = B;
            4'b1011: F = A + B;
            4'b1100: F = 4'b0000;
            4'b1101: F = A & ~B;
            4'b1110: F = A & B;
            4'b1111: F = A;
        endcase
    end else begin
        if (Cn == 1'b0) begin
            case (S)
                4'b0000: F = A - 1;
                4'b0001: F = (A & B) - 1;
                4'b0010: F = (A & ~B) - 1;
                4'b0011: F = -1;
                4'b0100: F = A + (A + ~B);
                4'b0101: F = (A & B) + (A + ~B);
                4'b0110: F = A - B - 1;
                4'b0111: F = A + ~B;
                4'b1000: F = A + (A + B);
                4'b1001: F = A + B;
                4'b1010: F = (A & ~B) + (A + B);
                4'b1011: F = A + B;
                4'b1100: F = A;
                4'b1101: F = (A & B) + A;
                4'b1110: F = (A & ~B) + A;
                4'b1111: F = A;
            endcase
        end else begin
            case (S)
                4'b0000: F = A;
                4'b0001: F = (A & B);
                4'b0010: F = (A & ~B);
                4'b0011: F = 4'b0000;
                4'b0100: F = A + (A + ~B) + 1;
                4'b0101: F = (A & B) + (A + ~B) + 1;
                4'b0110: F = A - B;
                4'b0111: F = A + ~B + 1;
                4'b1000: F = A + (A + B) + 1;
                4'b1001: F = A + B + 1;
                4'b1010: F = (A & ~B) + (A + B) + 1;
                4'b1011: F = A + B + 1;
                4'b1100: F = (A + A) + 1;
                4'b1101: F = (A & B) + A + 1;
                4'b1110: F = (A & ~B) + A + 1;
                4'b1111: F = A + 1;
            endcase
        end
    end
end

endmodule