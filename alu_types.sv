package alu_types;

typedef enum bit[2:0] {
	NONE, INC, OR, SUB
} cmd_t /* verilator public */;

endpackage : alu_types
