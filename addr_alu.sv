import register_types::addr_t;

module addr_alu(
	input addr_alu_types::cmd_t cmd,
	input addr_t x,
	/* verilator lint_off UNUSED */
	input addr_t y,
	/* verilator lint_on UNUSED */
	output addr_t z,
	output bit zflag
);

always_comb begin
	unique case(cmd)
		addr_alu_types::INC:
			z = x + 1;
		default:
			z = 0;
	endcase // cmd

	if (z == 0) zflag = 1;
	else zflag = 0;
end //always_comb

endmodule // addr_alu
