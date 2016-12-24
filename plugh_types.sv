package plugh_types;

import microaddr_types::uaddr_t;
import register_types::addr_t;

typedef struct packed {
	microaddr_types::cmd_t uaddr_cmd; // 3 bits
	uaddr_t load_uaddr; // 11 bits

	alu_types::cmd_t alu_cmd; // 3 bits
	register_types::name_t alu_x_select; // 4 bits
	register_types::name_t alu_y_select; // 4 bits
	register_types::name_t alu_dest_select; // 4 bits

	addr_alu_types::cmd_t addr_alu_cmd; // 3 bits
	register_types::name_t addr_alu_x_select; // 4 bits
	register_types::name_t addr_alu_y_select; // 4 bits
	register_types::name_t addr_alu_dest_select; // 4 bits

	mem_types::cmd_t mem_cmd; // 2 bits
	register_types::name_t mem_write_data_select; // 4 bits
	register_types::name_t mem_dest_select; // 4 bits
	register_types::name_t mem_addr_select; // 4 bits

	register_types::name_t var_dest_select; // 4 bits
} upgm_t /* verilator public */; // 62 bits

endpackage : plugh_types