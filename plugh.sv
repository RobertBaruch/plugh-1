import microaddr_types::uaddr_t;
import register_types::addr_t;
import plugh_types::upgm_t;

module plugh(
	input bit clk,
	input bit reset,
	output uaddr_t uaddr,

	output addr_t sram_addr,
	inout logic[7:0] sram_data,
	output bit sram_not_ce,
	output bit sram_not_oe,
	output bit sram_not_we
);

// Workaround for Vivado bug
bit[$bits(upgm_t)-1:0] pgm_bits;
upgm_t pgm;

upgm upgm(
	.clk,
	.addr(uaddr),
	.data(pgm_bits)
);

shortint unsigned alu_x;
shortint unsigned alu_y;
shortint unsigned alu_z;
bit zflag;

alu alu(
	.cmd(pgm.alu_cmd),
	.x(alu_x),
	.y(alu_y),
	.z(alu_z),
	.zflag(zflag)
);

addr_t addr_alu_x;
addr_t addr_alu_y;
addr_t addr_alu_z;

addr_alu addr_alu(
	.cmd(pgm.addr_alu_cmd),
	.x(addr_alu_x),
	.y(addr_alu_y),
	.z(addr_alu_z)
);

addr_t mem_addr;
byte unsigned mem_write_data;
byte unsigned mem_read_data;

mem mem(
	.clk,
	.cmd(pgm.mem_cmd),
	.addr(mem_addr),
	.write_data(mem_write_data),
	.read_data(mem_read_data),

	.chip_addr(sram_addr),
	.chip_data(sram_data),
	.not_ce(sram_not_ce),
	.not_oe(sram_not_oe),
	.not_we(sram_not_we)
);

addr_t vars_addr;

vars vars(
	.V,
	.FP,
	.GP,
	.addr(vars_addr)
);

/* verilator lint_off UNUSED */
byte unsigned M;
byte unsigned V;
addr_t X;
shortint unsigned OP0;
shortint unsigned OP1;
addr_t SP;
addr_t FP;
addr_t GP;
addr_t IP;
addr_t AP;
/* verilator lint_on UNUSED */

register_file register_file(
	.clk,
	.M,
	.V,
	.X,
	.OP0,
	.OP1,
	.SP,
	.FP,
	.GP,
	.IP,
	.AP,
	.mem_dest_select(pgm.mem_dest_select),
	.mem_data(mem_read_data),
	.alu_dest_select(pgm.alu_dest_select),
	.alu_data(alu_z),
	.addr_alu_dest_select(pgm.addr_alu_dest_select),
	.addr_alu_data(addr_alu_z),
	.var_dest_select(pgm.var_dest_select),
	.var_data(vars_addr)
);

microaddr_counter microaddr_counter #(.opjump_table_file="opjump_table.data") (
	.clk,
	.reset,
	.zflag(zflag),
	.M,
	.cmd(pgm.uaddr_cmd),
	.load_addr(pgm.load_uaddr),
	.addr(uaddr)
);

always_comb begin
	pgm = upgm_t'(pgm_bits);

	alu_x = 0;
	alu_y = 0;
	addr_alu_x = 0;
	addr_alu_y = 0;
	mem_addr = 0;
	mem_write_data = 0;

	unique case(pgm.alu_x_select)
		register_types::NONE: alu_x = 0;
		register_types::M: alu_x[7:0] = M;
		register_types::V: alu_x[7:0] = V;
		register_types::OP0: alu_x = OP0;
		register_types::OP0H: alu_x[7:0] = OP0[15:8];
		register_types::OP0L: alu_x[7:0] = OP0[7:0];
		register_types::OP1: alu_x = OP1;
		register_types::OP1H: alu_x[7:0] = OP1[15:8];
		register_types::OP1L: alu_x[7:0] = OP1[7:0];
		default: alu_x = 0;
	endcase

	unique case(pgm.alu_y_select)
		register_types::NONE: alu_y = 0;
		register_types::M: alu_y[7:0] = M;
		register_types::V: alu_y[7:0] = V;
		register_types::OP0: alu_y = OP0;
		register_types::OP0H: alu_y[7:0] = OP0[15:8];
		register_types::OP0L: alu_y[7:0] = OP0[7:0];
		register_types::OP1: alu_y = OP1;
		register_types::OP1H: alu_y[7:0] = OP1[15:8];
		register_types::OP1L: alu_y[7:0] = OP1[7:0];
		default: alu_y = 0;
	endcase

	unique case(pgm.addr_alu_x_select)
		register_types::NONE: addr_alu_x = 0;
		register_types::X: addr_alu_x = X;
		register_types::SP: addr_alu_x = SP;
		register_types::FP: addr_alu_x = FP;
		register_types::GP: addr_alu_x = GP;
		register_types::IP: addr_alu_x = IP;
		register_types::AP: addr_alu_x = AP;
		default: addr_alu_x = 0;
	endcase

	unique case(pgm.addr_alu_y_select)
		register_types::NONE: addr_alu_y = 0;
		register_types::X: addr_alu_y = X;
		register_types::SP: addr_alu_y = SP;
		register_types::FP: addr_alu_y = FP;
		register_types::GP: addr_alu_y = GP;
		register_types::IP: addr_alu_y = IP;
		register_types::AP: addr_alu_y = AP;
		default: addr_alu_y = 0;
	endcase

	unique case(pgm.mem_addr_select)
		register_types::NONE: mem_addr = 0;
		register_types::X: mem_addr = X;
		register_types::SP: mem_addr = SP;
		register_types::FP: mem_addr = FP;
		register_types::GP: mem_addr = GP;
		register_types::IP: mem_addr = IP;
		register_types::AP: mem_addr = AP;
		default: mem_addr = 0;
	endcase

	unique case(pgm.mem_write_data_select)
		register_types::NONE: mem_write_data = 0;
		register_types::M: mem_write_data = M;
		register_types::V: mem_write_data = V;
		register_types::OP0H: mem_write_data = OP0[15:8];
		register_types::OP0L: mem_write_data = OP0[7:0];
		register_types::OP1H: mem_write_data = OP1[15:8];
		register_types::OP1L: mem_write_data = OP1[7:0];
		default: mem_write_data = 0;
	endcase
end

endmodule // plugh
