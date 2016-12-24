import microaddr_types::uaddr_t;
import plugh_types::upgm_t;

// uProgram ROM. The block RAM resources on Xilinx chips require
// a clock edge for reads. Also, Vivado will not recognize that
// this is a block RAM unless the module data port is a bit
// vector -- not even a struct which is a bit vector.
// Finally, Vivado requires a write capability in order for it
// to recognize that the block RAM can be initialized after
// synthesis. If there is no write capability, Vivado will convert
// the block RAM to hard-coded lookup tables.

module upgm(
	input bit clk,
	input bit we,
	input bit[$bits(upgm_t)-1:0] wdata,
	input uaddr_t addr,
	output bit[$bits(upgm_t)-1:0] data
);

bit[$bits(upgm_t)-1:0] upgm [2**$bits(uaddr_t)];

initial begin
	$readmemb("upgm.data", upgm);
end

always_ff @(negedge clk) begin
	if (we) upgm[addr] <= wdata;
	data <= upgm[addr];
end // always_ff

endmodule // upgm
