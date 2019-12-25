`timescale 1ns / 1ps
module SignExtend
(
    input [15:0] din, // 输入
    input [15:0] ctr, // 是否阻止扩展
    output [31:0] dout // 输出
)
    assign dout[15: 0]=din; // 保留较低的16位
    assign dout[31:16]=!ctr&&din[15]? 16'hffff: 16'h0000; // 将输入的16位数的符号位扩展较高的16位得到32位数

endmodule
