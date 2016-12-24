module alu(
	input alu_types::cmd_t cmd,
	input shortint unsigned x,
	input shortint unsigned y,
	output shortint unsigned z,
	output bit zflag
);

always_comb begin
	unique case(cmd)
		alu_types::SUB:
			z = x - y;
		alu_types::INC:
			z = x + 1;
		alu_types::OR:
			z = x | y;
		default:
			z = 0;
	endcase // cmd

	if (z == 0) zflag = 1;
	else zflag = 0;
end //always_comb

endmodule // alu