import register_types::addr_t;

// Calculates the real address of variable #V, except for
// V=0, which is not handled here. It is purely combinatorial.

// A user-stack frame is:
// FP+0  local 1
// FP+1  local 2

module vars(
	input byte unsigned V,
	input addr_t FP,
	input addr_t GP,
	output addr_t addr
);

always_comb begin
	addr = 0;
	unique if (V >= 8'h01 && V <= 8'h0F)
		addr = FP + 2 * addr_t'(V - 1);
	else if (V >= 8'h10)
		addr = GP + 2 * addr_t'(V - 8'h10);
	else
		addr = 0;
end // always_comb

endmodule // vars
