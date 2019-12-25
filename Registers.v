`timescale 1ns / 1ps
module Registers
(
    input CLK,
    input PC,
    input [4:0] RegisterS, // rs寄存器
    input [4:0] RegisterT, // rt寄存器
    input [4:0] RegisterD, // rd寄存器
    input RegDst, // rd寄存器是否有效
    input RegAvo, // 是否写入寄存器
    input JaL, // Jump and Link 控制信号
    input [31:0] WriteData, // 写入数据当 RegAvo=False 且 写入寄存器不是 $0
    output reg [31:0] DataS, // 于 RegisterS 存储的数据
    output reg [31:0] DataT, // 于 RegisterT 存储的数据
);
    integer i;
    reg [31: 0] regs[31: 0]; // 
    reg [ 4: 0] RegisterW; // 写入哪一个寄存器
    initial begin
        DataS=32'b0;
        DataT=32'b0;
        for(i=0;i<32;i++)regs[i]=0;
    end
    always @(RegisterS or RegisterT or RegisterD or RegDst) begin
        DataS=regs[RegisterS];
        DataT=regs[RegisterT];
        RegisterW=RegDst?RegisterD:RegisterT;
    end
    always @(negedge CLK) begin
        if(!RegAvo && RegisterW!=0) regs[RegisterW]=WriteData;
        if(JAL) regs[31]=PC+4;
    end
endmodule
