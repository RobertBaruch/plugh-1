import register_types::addr_t;

// Calculates the real address of variable #V, except for
// V=0, which is not handled here. It is purely combinatorial.

// A frame is:
// FP    prev FP
// FP+2  ret addr // what if this is more than 16 bits?
// FP+4  local 1
// FP+6  local 2

module vars(
	input byte unsigned V,
	input addr_t FP,
	input addr_t GP,
	output addr_t addr
);

always_comb begin
	addr = 0;
	unique if (V >= 8'h01 && V <= 8'h0F)
		addr = FP + 2 + 2 * V;
	else if (V >= 8'h10)
		addr = GP + 2 * (V - 8'h10);
	else
		addr = 0;
end // always_comb

endmodule