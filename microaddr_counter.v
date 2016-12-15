module microaddr_counter(
	input logic clk,
	input logic reset,
	input microaddr::cmd cmd,
	input logic[10:0] load_addr,
	output logic[10:0] addr
);

logic[10:0] next_addr;

always_comb begin
	unique case(cmd)
		microaddr::NONE:
			next_addr = addr;
		microaddr::INC:
			next_addr = addr + 1;
		microaddr::LOAD:
			next_addr = load_addr;
		default:
			next_addr = 0;
	endcase // cmd

	if (reset == 1)
		next_addr = 0;
end // always_comb

always_ff @(posedge clk) begin
	addr <= next_addr;
end // always_ff

endmodule // microaddr_counter
