module ALU(A, B, ALUFun, Sign, Z);

/*
ALUFun:
000000: add
000001: sub
010001: nor
010110: xor
011110: or(lui)
011000: and
100000: sll
100001: srl
100011: sra
110101: slt
110011: beq
110001: bne
*/

input Sign;
input [5:0] ALUFun;
input [31:0] A, B;
output [31:0] Z;//Z: zero label
wire zero,neg;
wire [31:0] S0, S1, S2, S3;
  
AddSub AddSub(.A(A), .B(B), .ALUFun(ALUFun), .Sign(Sign), .Z(zero), .N(neg), .S(S0));
Cmp Cmp(.ALUFun(ALUFun), .Sign(Sign), .Z(zero), .N(neg), .S(S1));
Logic Logic(.A(A), .B(B), .ALUFun(ALUFun), .S(S2));
Shift Shift(.A(A), .B(B), .ALUFun(ALUFun), .S(S3));

// Choose the type of calculation
assign Z =
(ALUFun[5:4] == 2'b00)? S0:
(ALUFun[5:4] == 2'b10)? S3:
(ALUFun[5:4] == 2'b01)? S2: S1;

endmodule



// add or sub calculation
module AddSub(A, B, ALUFun, Sign, Z, N, S);
input Sign;
input [5:0] ALUFun;
input [31:0] A, B;
output Z, N;        //N = 1 : negative, sub; 0 : positive, add
output [32:0] S;    //S : result

// Choose which number to compare when determining Z
assign Z =
(ALUFun[3] && |A)? 0: 
(~ALUFun[3] && |S)? 0: 1;

// Choose to perform add or sub
assign S = 
(ALUFun[0])? ({1'b0, A} - {1'b0, B}): ({1'b0, A} + {1'b0, B});

// Determine N according to the Sign signal and carryin
assign N = 
(ALUFun[3] && Sign && A[31])? 1:
(~ALUFun[3] && Sign && S[31])? 1:
(~ALUFun[3] && ~Sign && S[32])? 1: 0;

endmodule



// comparation calculation
module Cmp(ALUFun, Sign, Z, N, S);
input Sign, Z, N;
input [5:0] ALUFun;
output [31:0] S;

// Determine output according to N and Z
assign S[0] = 
(ALUFun[3:1] == 3'b001)? Z:
(ALUFun[3:1] == 3'b000)? ~Z:
(ALUFun[3:1] == 3'b010)? N:
(ALUFun[3:1] == 3'b110)? (N || Z):
(ALUFun[3:1] == 3'b101)? N: (~N && ~Z);
assign S[31:1]=0;

endmodule


// logical calculation
module Logic(A, B, ALUFun, S);
input [5:0] ALUFun;
input [31:0] A, B;
output [31:0] S;

// result of logical calculation
assign S = 
(ALUFun[3:0] == 4'b0001)? ~(A | B):
(ALUFun[3:0] == 4'b1110)? (A | B):
(ALUFun[3:0] == 4'b1000)? (A & B):
(ALUFun[3:0] == 4'b0110)? (A ^ B): A;

endmodule



// shift calculation
module Shift(A, B, ALUFun, S);
input [5:0] ALUFun;
input [31:0] A, B; 
output [31:0] S;

assign S =

// srl or sra with the msb being '0'
(ALUFun[1:0] == 2'b01 || (ALUFun[1:0] == 2'b11 && B[31] == 0))? B >> A[4:0]:

// sra with the msb being '1'
(ALUFun[1:0] == 2'b11 && B[31] == 1)? ({32'hFFFFFFFF, B} >> A[4:0]):

// sll
(ALUFun[1:0] == 2'b00)? B << A[4:0]: 0;

endmodule