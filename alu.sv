module alu(
	input alu_types::cmd cmd,
	input shortint unsigned x,
	input shortint unsigned y,
	output shortint unsigned z,
	output logic zflag
);

always_comb begin
	unique case(cmd)
		alu_types::OR:
			z = x | y;
		default:
			z = 0;
	endcase // cmd

	if (z == 0) zflag = 1;
	else zflag = 0;
end //always_comb

endmodule // alu