module plugh(
	input logic clk,
	input logic reset,
	input microaddr_types::cmd uaddr_cmd,
	input microaddr_types::uaddr uaddr_load_addr,
	output microaddr_types::uaddr uaddr,
	input alu_types::cmd alu_cmd
);

logic zflag = 0;

/* verilator lint_off UNUSED */
byte unsigned M = 0;
byte unsigned V = 0;
shortint unsigned X = 0;
shortint unsigned OP0 = 0;
shortint unsigned OP1 = 0;
shortint unsigned SP = 0;
shortint unsigned FP = 0;
shortint unsigned GP = 0;
bit[16:0] IP = 0;

shortint unsigned alu_x = 0;
shortint unsigned alu_y = 0;
shortint unsigned alu_z = 0;
/* verilator lint_on UNUSED */

register_types::name mem_dest_select = register_types::NONE;
byte unsigned mem_dest = 0;

alu alu(
	.cmd(alu_cmd),
	.x(alu_x),
	.y(alu_y),
	.z(alu_z),
	.zflag(zflag)
);

register_file register_file(
	.clk(clk),
	.M(M),
	.V(V),
	.X(X),
	.OP0(OP0),
	.OP1(OP1),
	.SP(SP),
	.FP(FP),
	.GP(GP),
	.IP(IP),
	.mem_dest_select(mem_dest_select),
	.mem_dest(mem_dest));

microaddr_counter microaddr_counter(
	.clk(clk),
	.reset(reset),
	.zflag(zflag),
	.cmd(uaddr_cmd),
	.load_addr(uaddr_load_addr),
	.addr(uaddr));

endmodule // plugh
