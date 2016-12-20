package microaddr_types;

typedef enum logic[2:0] {
	NONE, INC, LOAD, LOADNE, CALL, RET, IJMP
} cmd /* verilator public */;

typedef logic[10:0] uaddr /* verilator public */;

endpackage : microaddr_types
