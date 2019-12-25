`timescale 1ns / 1ps
module CPU
(
	input CLK,
	input Reset,
	output reg [31:0] PC, // 指令地址（in bytes）
	output reg [31:0] instruction, // 指令
	/*
		op=instruction[31:26];
		rs=instruction[25:21]; - RegBusA
		rt=instruction[20:16]; - RegBusB
		rd=instruction[15:11];
		funct=instruction[5:0];
		shamt=instruction[10:6];
		immediate/address=instruction[15:0];
	*/
	output reg [31:0] RegBusA,	// rs寄存器的值
	output reg [31:0] RegBusB,	// rt寄存器的值
	output reg Jump, 			// 跳跃信号
	output reg Jal, 			// 闪回信号
	output reg Branch, 			// 分支信号
	output reg Expect, 			// 期望分支条件
	output reg ExtCtr, 			// 是否阻止符号扩展
	output reg [31:0] Extend, 	// immediate/address段扩展结果
	output reg MemWrite,		// 是否写内存
	output reg MemRead, 		// 是否读内存
	output reg [31:0] MemRes,	// 读内存返回值
	output reg [2:0] ALUop, 	// ALU操作码(by op)
	output reg [3:0] ALUctr, 	// ALU操作码(by funct)
	output reg ALUsrc, 			// ALU第二输入量选择参数
	output reg [31:0] ALUres, 	// ALU的结果
	output reg RegDst, 			// rd寄存器是否有效
	output reg RegAvo 			// 是否写寄存器	
)
	ProgramCounter pc
	(
		.CLK(CLK),							// 输入时钟信号
		.Reset(Reset),						// 输入重置信号，当重置信号
		.Jump(Jump),						// 输入跳跃信号
		.JumpAddress(instruction[25:0]),	// 输入跳跃地址段
		.Branch(Branch),					// 输入分支信号
		.Expect(Expect),					// 输入期望分支条件
		.Zero(Zero),						// 输入相等信号
		.ALUresult(ALUresult),				// 输入分支相对地址
		.PC(PC)								// 输出PC
	);										// 管理PC寄存器
	Control ctr
	(
		.op(instruction[31:26]),	// 输入op
		.Jump(Jump),				// 输出跳跃信号
		.Branch(Branch),			// 输出分支信号
		.Expect(Expect),			// 输出期望分支信号
		.ExtCtr(ExtCtr),			// 输出反扩展符号位信号
		.MemWrite(MemWrite),		// 输出写内存信号 当lw
		.MemRead(MemRead),			// 输出读内存信号 当sw
		.ALUsrc(ALUsrc),			// 判断ALU的第二输入量 
		.RegDst(RegDst),			// 判断rd寄存器是否有效
		.RegAvo(RegAvo),			// 输出反写寄存器信号
		.ALUop(ALUop)				// 输出ALU
	);								// 管理控制信号
	Registers regs 
	(
		.CLK(CLK),						
		.PC(PC),						
		.RegisterS(instruction[25:21]),	// rs寄存器的编号（可能）J-type中rs寄存器无效
		.RegisterT(instruction[20:16]),	// rt寄存器的编号（可能）J-type中rt寄存器无效
		.RegisterD(instruction[15:11]),	// rd寄存器的编号（可能）I-type中rd寄存器无效
		.RegDst(RegDst),				// rd寄存器是否有效
		.RegAvo(RegAvo),				// 是否阻止将结果写回寄存器
		.JaL(JaL),						// 闪回信号 决定是否存下当前的PC值
		.WriteData(MemWrite),			// 写回寄存器的数据 当RegAvo为False时有效
		.DataS(RegBusA),				// rs寄存器的值 当rs有效时有效
		.DataT(RegBusB)					// rt寄存器的值 当rt有效时有效
	);									// 管理32个寄存器
	ALUcontrol aluctr
	(
		.ALUop(ALUop),					// ALUop
		.funct(instruction[5:0]),		// 为R-type指令另辟的function空间
		.ALUctr(ALUctr)					// 将I-type与R-type的function映射到同一个操作码空间中
	);									// 统一操作码
	SignExtend se
	{
		.din(instruction[15:0]),		// immediate/address段 需要扩展的数（可能）当不限制时进行符号位扩展
		.ctr(ExtCtr),					// 限制符号位扩展信号 当声明其为无符号数（而非无符号运算）的时候
		.dout(Extend)					// 扩展结果
	};									// 管理符号位扩展
	ALU alu
	(
		.RegBusA(RegBusA),				// rs寄存器上的值
		.RegBusB(RegBusB),				// rt寄存器上的值 可能的第二输入量
		.ALUsrc(ALUsrc),				// 第二输入量的选择 当shamt无效的时候
		.Extend(Extend),				// 扩展值 可能的第二输入量
		.Shamt(instruction[10:6]),		// 偏移量 
		.ALUctr(ALUctr),				// 操作码
		.Zero(Zero),					// 结果是否为0
		.ALUresult(ALUres)				// 结果
	);									// ALU运算
	DataMemory dm
	(
		.CLK(CLK),				// 时钟信号
		.MemRead(MemRead),		// 读内存 当lw
		.MemWrite(MemWrite),	// 写内存 当sw
		.Address(ALUres),		// 要操作的内存地址 / 运算结果
		.din(RegBusB),			// 写入的数据 当MemWrite=True时有效
		.dout(MemRes)			// 返回的数据 当MemRead=True时返回对应地址上的值（ALUres作为地址） 
								// 当MemRead=False时返回运算结果（ALUres作为运算结果）
	);							// 管理内存的读写和返回值
	
endmodule CPU