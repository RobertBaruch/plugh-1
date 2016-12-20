package register_types;

typedef enum logic[3:0] {
	NONE, M, V, X, OP0, OP0H, OP0L, OP1, OP1H, 
	OP1L, SP, FP, GP, IP
} name /* verilator public */;

endpackage : register_types
