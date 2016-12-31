import register_types::addr_t;
import mem_types::cmd_t;

module mem(
	input bit clk,
	input bit reset,
	input cmd_t cmd,
	input addr_t addr,
	input byte unsigned write_data,
	output byte unsigned read_data,

    // SRAM connections
	output bit[18:0] sram_addr,
	inout wire logic[7:0] sram_data, // requires z-states. inouts must be wires.
	output bit sram_not_ce,
	output bit sram_not_oe = 1,
	output bit sram_not_we = 1
);

cmd_t cmd_register;
cmd_t next_cmd_register;
bit next_sram_not_oe;
bit next_sram_not_we;

// 0 = read from sram, 1 = write to sram
bit data_dir = 0;
bit next_data_dir;

// output or tristate
assign sram_data = data_dir == 1 ? write_data : 'z;

always_comb begin
	read_data = sram_data;
	sram_addr = addr;
	sram_not_ce = 0;
	next_cmd_register = cmd;
	next_sram_not_oe = next_cmd_register != mem_types::READ;
	next_sram_not_we = next_cmd_register != mem_types::WRITE0;
	next_data_dir = cmd_register == mem_types::WRITE0;
	
	if (reset) begin
	   next_cmd_register = mem_types::READ;
	   next_sram_not_oe = 0;
	   next_sram_not_we = 1;
	   next_data_dir = 0;
	end
end //always_comb

always_ff @(posedge clk) begin
    cmd_register <= next_cmd_register;
    sram_not_oe <= next_sram_not_oe;
    sram_not_we <= next_sram_not_we;
end

always_ff @(negedge clk) begin
    data_dir <= next_data_dir;
end

endmodule // mem
