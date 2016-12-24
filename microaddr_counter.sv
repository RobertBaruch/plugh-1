import microaddr_types::uaddr_t;

module microaddr_counter(
	input bit clk,
	input bit reset,
	input bit zflag,
	input byte unsigned M,
	input microaddr_types::cmd_t cmd,
	input uaddr_t load_addr,
	output uaddr_t addr
);

parameter opjump_table_file="";

uaddr_t next_addr;
uaddr_t call_stack[4];
uaddr_t next_call_stack[4];
bit[1:0] call_stack_ptr;
bit[1:0] next_call_stack_ptr;

uaddr_t opjump_table[256];
initial $readmemh(opjump_table_file, opjump_table);

always_comb begin
	next_call_stack_ptr = call_stack_ptr;
	next_call_stack = call_stack;

	unique case(cmd)
		microaddr_types::NONE:
			next_addr = addr;

		microaddr_types::INC:
			next_addr = addr + 1;

		microaddr_types::JMP:
			next_addr = load_addr;

		microaddr_types::JNZ:
			next_addr = zflag == 0 ? load_addr : addr + 1;

		microaddr_types::CALL: begin
			next_call_stack[call_stack_ptr] = addr + 1;
			next_call_stack_ptr = call_stack_ptr + 1;
			next_addr = load_addr;
			end

		microaddr_types::RET: begin
			next_addr = call_stack[call_stack_ptr - 1];
			next_call_stack_ptr = call_stack_ptr - 1;
			end

		microaddr_types::OPJMP:
			next_addr = opjump_table[M];

		default:
			next_addr = 0;

	endcase // cmd

	if (reset == 1) begin
		next_addr = 0;
		next_call_stack_ptr = 0;
	end
end // always_comb

always_ff @(posedge clk) begin
	addr <= next_addr;
	call_stack_ptr <= next_call_stack_ptr;
	call_stack <= next_call_stack;
end // always_ff

endmodule // microaddr_counter
