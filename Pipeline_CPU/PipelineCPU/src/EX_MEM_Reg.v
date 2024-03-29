module EX_MEM_Reg(
	clk ,reset, PC_add_4_in, 
	ALUOut_in, DataBusB_in, 
	Rt_in, Rd_in, RegDst_in, 
	MemRead_in, MemWrite_in, MemToReg_in, 
	RegWrite_in, AddrC_in, PC_add_4_out, 
	ALUOut_out, DataBusB_out, 
	Rt_out, Rd_out, RegDst_out,
	MemRead_out, MemWrite_out, MemToReg_out, 
	RegWrite_out, AddrC_out);
	
input clk;
input reset;
input [31:0] PC_add_4_in;
input [31:0] DataBusB_in;
input [31:0] ALUOut_in;

input [4:0] Rt_in;
input [4:0] Rd_in;
input [1:0] RegDst_in;
input MemRead_in;
input MemWrite_in;
input [1:0] MemToReg_in;
input RegWrite_in;
input [4:0] AddrC_in;

output reg [31:0] PC_add_4_out;
output reg [31:0] DataBusB_out;
output reg [31:0] ALUOut_out;

output reg [4:0] Rt_out;
output reg [4:0] Rd_out;
output reg [1:0] RegDst_out;
output reg MemRead_out;
output reg MemWrite_out;
output reg [1:0] MemToReg_out;
output reg RegWrite_out;
output reg [4:0] AddrC_out;

always @(posedge clk or negedge reset) begin
	if (~reset) begin
		PC_add_4_out <= 32'h0000_0000;
		DataBusB_out <= 32'h0000_0000;
		ALUOut_out <= 32'h0000_0000;
		Rt_out <= 5'h00;
		Rd_out <= 5'h00;
		RegDst_out <= 2'h0;
		MemRead_out <= 1'b0;
		MemWrite_out <= 1'b0;
		MemToReg_out <= 2'h0;
		RegWrite_out <= 1'b0;
		AddrC_out <= 5'h0;
	end
	else begin
		PC_add_4_out <= PC_add_4_in;
		DataBusB_out <= DataBusB_in;
		ALUOut_out <= ALUOut_in;
		Rt_out <= Rt_in;
		Rd_out <= Rd_in;
		RegDst_out <= RegDst_in;
		MemRead_out <= MemRead_in;
		MemWrite_out <= MemWrite_in;
		MemToReg_out <= MemToReg_in;
		RegWrite_out <= RegWrite_in;
		AddrC_out <= AddrC_in;
	end
end
endmodule