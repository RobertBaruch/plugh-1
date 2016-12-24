import register_types::addr_t;
import register_types::name_t;

module register_file(
	input bit clk,
	output byte unsigned M,
	output byte unsigned V,
	output shortint unsigned OP0,
	output shortint unsigned OP1,
	output addr_t X,
	output addr_t SP,
	output addr_t FP,
	output addr_t GP,
	output addr_t IP,
	output addr_t AP,

	input name_t mem_dest_select,
	input byte unsigned mem_data,

	input name_t alu_dest_select,
	input shortint unsigned alu_data,

	input name_t addr_alu_dest_select,
	input addr_t addr_alu_data,

	input name_t var_dest_select,
	input addr_t var_data
);

byte unsigned next_M;
byte unsigned next_V;
byte unsigned next_OP0H;
byte unsigned next_OP0L;
byte unsigned next_OP1H;
byte unsigned next_OP1L;
addr_t next_X;
addr_t next_SP;
addr_t next_FP;
addr_t next_GP;
addr_t next_IP;
addr_t next_AP;

always_comb begin
	next_M = mem_dest_select == register_types::M ? mem_data : M;
	next_V = mem_dest_select == register_types::V ? mem_data : V;

	next_OP0H =
		mem_dest_select == register_types::OP0H ? mem_data
		: mem_dest_select == register_types::OP0 ? 0
		: alu_dest_select == register_types::OP0 ? alu_data[15:8]
		: OP0[15:8];
	next_OP0L = 
		mem_dest_select == register_types::OP0L ? mem_data
		: mem_dest_select == register_types::OP0 ? mem_data
		: alu_dest_select == register_types::OP0 ? alu_data[7:0]
		: OP0[7:0];
		
	next_OP1H = 
		mem_dest_select == register_types::OP1H ? mem_data
		: mem_dest_select == register_types::OP1 ? 0 
		: alu_dest_select == register_types::OP1 ? alu_data[15:8]
		: OP1[15:8];
	next_OP1L = 
		mem_dest_select == register_types::OP1L ? mem_data
		: mem_dest_select == register_types::OP1 ? mem_data
		: alu_dest_select == register_types::OP1 ? alu_data[7:0]
		: OP1[7:0];

	next_X = 
		addr_alu_dest_select == register_types::X ? addr_alu_data 
		: var_dest_select == register_types::X ? var_data
		: X;
	next_SP = addr_alu_dest_select == register_types::SP ? addr_alu_data : SP;
	next_FP = addr_alu_dest_select == register_types::FP ? addr_alu_data : FP;
	next_GP = addr_alu_dest_select == register_types::GP ? addr_alu_data : GP;
	next_IP = addr_alu_dest_select == register_types::IP ? addr_alu_data : IP;
	next_AP = addr_alu_dest_select == register_types::AP ? addr_alu_data : AP;
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
	AP <= next_AP;
end // always_ff

endmodule // registers
