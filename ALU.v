`timescale 1ns / 1ps
module ALU
(
	input [31:0] RegBusA,
	input [31:0] RegBusB,
	input ALUsrc,
	input [31:0] Extend,
	input [5:0] 
	input [3:0] ALUctr,
	output Zero,
	output reg [31:0] ALUresult
);	
	reg [31: 0] A;
	reg [31: 0] B;
	assign Zero=(ALUresult==0);
	always @(*) begin
		A = RegBusA; B = (ALUsrc == 0) ? RegBusB : Extend;
		case (ALUctr) 
			4'b0010: ALUresult = A + B;
			4'b0110: ALUresult = A - B;
			4'b0000: ALUresult = A & B;
			4'b0001: ALUresult = A | B;
			4'b0100: ALUresult = A ^ B;
			4'b0111: ALUresult = A < B ? 32'h00000001 : 32'h00000000;
			4'b1000: ALUresult = A << B;
			4'b1001: ALUresult = A >> B;
			default: ALUresult = 0;
		endcase
	end
endmodule