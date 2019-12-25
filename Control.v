`timescale 1ns / 1ps
module Control
(
	input [5:0] op,
	output reg Jump,		// 跳跃信号
	output reg Branch,		// 分支信号
	output reg Expect, 		// 分支条件
	output reg ExtCtr, 		// 是否扩展
	output reg MemWrite, 	// 是否写内存
	output reg MemRead, 	// 是否读内存
	output reg ALUsrc,		// ALU第二输入量选择参数
	output reg RegDst, 		// rd寄存器是否有效
	output reg RegAvo, 		// 是否阻止写寄存器	
	output reg [2:0] ALUop 	// ALU操作码
);
#(
	parameter rtyp	=6'0000000,
	parameter addi  =6'b001000,
	parameter addiu =6'b001001,
	parameter andi	=6'b001100,
	parameter ori	=6'b001101,
	parameter xori	=6'b001110,
	parameter lui	=6'b001111,
	parameter lw	=6'b100011,
	parameter sw	=6'b101011,
	parameter beq	=6'b000100,
	parameter bne	=6'b000101,
	parameter slti	=6'b001010,
	parameter sltiu =6'b001011,
	parameter j	 	=6'b000010,
	parameter jal	=6'b000011
)
	alway @(op) begin
		Jump	=(op==j)	||(op==jal);
		Branch	=(op==beq)	||(op==bne);
		Expect	=(op==beq);
		ExtCtr	=(op==sltiu);
		MemWrite=(op==sw);
		MemRead	=(op==lw);
		ALUsrc	=(op==beq)	||(op==bne)	||(op==rtyp);
		RegDst	=(op==rtyp);
		RegAvo	=(op==beq)	||(op==bne)	||(op==j)	||(op==jal);
		JaL		=(op==jal);
		case(op)
			6'b000000:	ALUop=3'b111; // rtyp
			6'b001000:	ALUop=3'b000; // addi
			6'b001001:	ALUop=3'b000; // addiu
			6'b001100:	ALUop=3'b010; // andi
			6'b001101:	ALUop=3'b011; // ori	 
			6'b001110:	ALUop=3'b100; // xori
			6'b001111:	ALUop=3'b110; // lui
			6'b100011:	ALUop=3'b000; // lw
			6'b101011:	ALUop=3'b000; // sw
			6'b000100:	ALUop=3'b001; // beq
			6'b000101:	ALUop=3'b001; // bne
			6'b001010:	ALUop=3'b001; // slti
			6'b001011:	ALUop=3'b001; // sltiu
			6'b000010:	ALUop=3'b000; // j	 
			6'b000011:	ALUop=3'b000; // jal
		endcase
	end
endmodule

/*	Extra
R type
	6'b000000:			0	 	1		1		?		?		??		0		0		0		3'b111
I type                  ExtCtr  RegDst  RegWri	ALUsrcA	ALUsrcB	PCsrc	DMread	DMwri	WBsrc	ALUop	
	6'b001000: addi 	1		0		1		0		1		00		0		0		0		3'b000		
	6'b001001: addiu	1		0		1		0		1		00		0		0		0		3'b000
	6'b001100: andi		1		0		1		0		1		00		0		0		0		3'b010
	6'b001101: ori		1		0		1		0		1		00		0		0		0		3'b011		
	6'b001110: xori		1		0		1		0		1		00		0		0		0		3'b100	
	6'b001111: lui		1		0		1		0		1		00		0		0		0		3'b110	
	6'b100011: lw		1		0		1		0		1		00		1		0		1		3'b000	
	6'b101011: sw		1		0		1		0		1		00		0		1		0		3'b000	
	6'b000100: beq		1		0		0		0		0		00/01	0		0		0		3'b001		
	6'b000101: bne		1		0		0		0		0		00/01	0		0		0		3'b001		
	6'b001010: slti		1		0		1		0		1		00		0		0		0		3'b001	
	6'b001011: sltiu	0		0		1		0		1		00		0		0		0		3'b001	
	6'b000010: j		0		0		0		0		0		10		0		0		0		3'b000	
	6'b000011: jal		0		0		0		0		0		10		0		0		0		3'b000	

R type
	6'b000000:			0	 	1		1		?		?		??		0		0		0		3'b111
I type                  ExtCtr  RegDst  RegWri	ALUsrcA	ALUsrcB	PCsrc	DMread	DMwri	WBsrc	ALUop	
	6'b001000: addi 	1		0		1		0		1		00		0		0		0		3'b000		
	6'b001001: addiu	1		0		1		0		1		00		0		0		0		3'b000
	6'b001100: andi		1		0		1		0		1		00		0		0		0		3'b010
	6'b001101: ori		1		0		1		0		1		00		0		0		0		3'b011		
	6'b001110: xori		1		0		1		0		1		00		0		0		0		3'b100	
	6'b001111: lui		1		0		1		0		1		00		0		0		0		3'b110	
	6'b100011: lw		1		0		1		0		1		00		1		0		1		3'b000	
	6'b101011: sw		1		0		1		0		1		00		0		1		0		3'b000	
	6'b000100: beq		1		0		0		0		0		00/01	0		0		0		3'b001		
	6'b000101: bne		1		0		0		0		0		00/01	0		0		0		3'b001		
	6'b001010: slti		1		0		1		0		1		00		0		0		0		3'b001	
	6'b001011: sltiu	0		0		1		0		1		00		0		0		0		3'b001	
	6'b000010: j		0		0		0		0		0		10		0		0		0		3'b000	
	6'b000011: jal		0		0		0		0		0		10		0		0		0		3'b000	

	Jump, // 跳跃信号
	Branch, // 分支信号
	Expect, // 分支条件
	ExtCtr, // 是否扩展
	MemWrite, // 是否写内存
	MemRead, // 是否读内存
	ALUsrc, // ALU第二输入量选择参数
	RegDst, // rd寄存器是否有效
	RegAvo // 是否阻止写寄存器	
	[2:0] ALUop, // ALU操作码
*/