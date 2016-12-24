package mem_types;

typedef enum bit[1:0] {
	NONE, READ, WRITE
} cmd_t /* verilator public */;

endpackage : mem_types
