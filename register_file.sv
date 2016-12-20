module register_file(
	input logic clk,
	output byte unsigned M, // same as logic[7:0], but only 0s and 1s (2-valued)
	output byte unsigned V,
	output shortint unsigned X, // same as logic[15:0], but only 2-valued
	output shortint unsigned OP0,
	output shortint unsigned OP1,
	output shortint unsigned SP,
	output shortint unsigned FP,
	output shortint unsigned GP,
	output bit[16:0] IP, // 2-valued

	input register_types::name mem_dest_select,
	input byte unsigned mem_dest
);

byte unsigned next_M;
byte unsigned next_V;
shortint unsigned next_X;
byte unsigned next_OP0H;
byte unsigned next_OP0L;
byte unsigned next_OP1H;
byte unsigned next_OP1L;
shortint unsigned next_SP;
shortint unsigned next_FP;
shortint unsigned next_GP;
bit[16:0] next_IP;

always_comb begin
	next_M = mem_dest_select == register_types::M ? mem_dest : M;
	next_V = mem_dest_select == register_types::V ? mem_dest : V;
	next_X = X;
	next_OP0H =
		mem_dest_select == register_types::OP0H ? mem_dest 
		: mem_dest_select == register_types::OP0 ? 0 
		: OP0[15:8];
	next_OP0L = 
		mem_dest_select == register_types::OP0L ? mem_dest 
		: mem_dest_select == register_types::OP0 ? mem_dest
		: OP0[7:0];
	next_OP1H = 
		mem_dest_select == register_types::OP1H ? mem_dest 
		: mem_dest_select == register_types::OP1 ? 0 
		: OP1[15:8];
	next_OP1L = 
		mem_dest_select == register_types::OP1L ? mem_dest 
		: mem_dest_select == register_types::OP1 ? mem_dest
		: OP1[7:0];
	next_SP = SP;
	next_FP = FP;
	next_GP = GP;
	next_IP = IP;
end // always_comb

always_ff @(posedge clk) begin
	M <= next_M;
	V <= next_V;
	X <= next_X;
	OP0[15:8] <= next_OP0H;
	OP0[7:0] <= next_OP0L;
	OP1[15:8] <= next_OP1H;
	OP1[7:0] <= next_OP1L;
	SP <= next_SP;
	FP <= next_FP;
	GP <= next_GP;
	IP <= next_IP;
end // always_ff

endmodule // registers
