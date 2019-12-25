`timescale 1ns / 1ps
module Instruction
(
    input [31:0] PC, // 指令地址（in bytes）
    output reg [31:0] instruction // 取出的指令
);
    reg [7:0] rom[255:0];
    initial begin
        //$readmemb("C:\\Users\\Promising\\Desktop\\bcode2.coe", rom);
    end
    
    always @(PC) begin
        inst[31:24]=rom[PC+0];
        inst[23:16]=rom[PC+1];
        inst[15: 8]=rom[PC+2];
        inst[ 7: 0]=rom[PC+3];
        $display("instruction: %h", inst);
    end
endmodule
