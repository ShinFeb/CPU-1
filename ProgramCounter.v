`timescale 1ns / 1ps
module ProgramCounter // PC作为寄存器名，pc作为实例名
(
    input CLK, // 时钟信号
    input Reset, // 重置信号
    input Jump, // 是否跳跃
    input [25:0] JumpAddress, // 跳跃地址
    input Branch, // 是否考虑分支
    input Expect, // 当Zero=Branch时考虑分支
    input Zero, // ALU的结果是否为0
    input Relative, // 分支相对地址
    output reg [31:0] PC // 指令地址（in bytes）
);
    initial PC=0;
    always @(posedge CLK or negedge Reset) begin
        PC= Reset==0? 0:
            Jump? {PC[31:28],JumpAddress,2'b00}:
            Branch&&Zero==Expect? PC=PC+4+Relative*4:
            PC+4;
        /*
        if(Reset==0) PC=0; else 
        if(Jump) PC={PC[31:28],JumpAddress,2'b00}; else 
        if(Branch&&Zero==Expect) PC=PC+4+ALUresult*4; 
        else PC=PC+4; 
        */
        /*
        if(Reset==0) PC=0;
        else if(Jump) PC={PC[31:28],JumpAddress,2'b00};
        else if(Branch&&Zero==Expect) PC=PC+4+ALUresult*4;
        else PC=PC+4; 
        */
    end
endmodule