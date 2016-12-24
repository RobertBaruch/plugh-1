package register_types;

typedef enum bit[3:0] {
	NONE, M, V, X, 
	OP0, OP0H, OP0L, OP1, 
	OP1H, OP1L, SP, FP, 
	GP, IP, AP
} name_t /* verilator public */;

typedef bit[16:0] addr_t /* verilator public */;

endpackage : register_types
