`timescale 1ns / 1ps
module ALUcontrol
(
    input [2:0] ALUop,
    input [5:0] funct,
    output reg [3:0] ALUctr;
);
    always @(ALUop or funct) begin
        casex ({ALUop, funct})  // 3 + 6 = 9 bits
            // I type
            9'b000_xxxxxx: ALUctr = 4'b0010; // add
            9'b001_xxxxxx: ALUctr = 4'b0110; // sub
            9'b010_xxxxxx: ALUctr = 4'b0000; // and
            9'b011_xxxxxx: ALUctr = 4'b0001; // or
            9'b100_xxxxxx: ALUctr = 4'b0100; // xor
            9'b101_xxxxxx: ALUctr = 4'b0111; // slt
            9'b110_xxxxxx: ALUctr = 4'b1011; // lui

            // R type
            9'b111_100000: ALUctr = 4'b0010; // add
            9'b111_100001: ALUctr = 4'b0010; // addu
            9'b111_100010: ALUctr = 4'b0110; // sub
            9'b111_100011: ALUctr = 4'b0110; // subu
            9'b111_100100: ALUctr = 4'b0000; // and
            9'b111_100111: ALUctr = 4'b0101; // nor
            9'b111_100101: ALUctr = 4'b0001; // or
            9'b111_100110: ALUctr = 4'b0100; // xor
            9'b111_101010: ALUctr = 4'b0111; // slt
            9'b111_101011: ALUctr = 4'b0111; // sltu
            9'b111_000000: ALUctr = 4'b1000; // sll
            9'b111_000010: ALUctr = 4'b1001; // srl
            9'b111_000011: ALUctr = 4'b1010; // sra
            9'b111_000100: ALUctr = 4'b1000; // sllv
            9'b111_000110: ALUctr = 4'b1001; // srlv
            9'b111_000111: ALUctr = 4'b1010; // srav

        //  9'b111_011000: ALUctr = 4'b1011; // mult
        //  9'b111_011010: ALUctr = 4'b1100; // div
            default:       ALUctr = 4'b0010;
        endcase
    end
endmodule