import register_types::addr_t;
import mem_types::cmd_t;

module mem(
	input bit clk,
	input cmd_t cmd,
	input addr_t addr,
	input byte unsigned write_data,
	output byte unsigned read_data,

    // SRAM chip connections
	output addr_t chip_addr,
	inout wire logic[7:0] chip_data, // requires z-states. inouts must be wires.
	output bit not_ce,
	output bit not_oe,
	output bit not_we
);

bit write_mode;
// output for chip_data
assign chip_data = (write_mode && !clk) ? write_data : 'z;

always_comb begin
	read_data = chip_data;
	chip_addr = addr;
	not_oe = 0;
	not_ce = 0;
	not_we = !write_mode;
end //always_comb

always_ff @(posedge clk) begin
    write_mode <= cmd == mem_types::WRITE;
end

endmodule // mem
