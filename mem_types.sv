package mem_types;

typedef enum bit[1:0] {
	READ, WRITE0, WRITE1
} cmd_t /* verilator public */;

endpackage : mem_types
