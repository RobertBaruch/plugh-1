package microaddr_types;

typedef enum bit[2:0] {
	NONE, INC, JMP, JNZ, CALL, RET, OPJMP
} cmd_t /* verilator public */;

typedef bit[10:0] uaddr_t /* verilator public */;

endpackage : microaddr_types
