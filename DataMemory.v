`timescale 1ns / 1ps
module DataMemory
(
    input CLK,
    input MemRead, // 是否读内存
    input MemWrite, // 是否写内存
    input [31:0] Address, // 操作地址
    input [31:0] din, // 写入数据
    output reg [31:0]dout // 读取数据
);
    initial dout=32'b0;
    reg [7:0] ram[0:127];
    always @(MemRead or Address) begin
       if(MemRead) begin
            dout[31:24]=ram[Address+0];
            dout[23:16]=ram[Address+1];
            dout[15: 8]=ram[Address+2];
            dout[ 7: 0]=ram[Address+3];
        end
        else dout=Address;
    end
    always @(negedge CLK)
        if (MemWrite) begin
            ram[Address+0]=din[31:24];
            ram[Address+1]=din[23:16];
            ram[Address+2]=din[15: 8];
            ram[Address+3]=din[ 7: 0];
        end
endmodule
