module microaddr_counter(
	input logic clk,
	input logic reset,
	input logic zflag,
	input microaddr_types::cmd cmd,
	input microaddr_types::uaddr load_addr,
	output microaddr_types::uaddr addr
);

microaddr_types::uaddr next_addr;
microaddr_types::uaddr call_stack[4];
microaddr_types::uaddr next_call_stack[4];
logic[1:0] call_stack_ptr;
logic[1:0] next_call_stack_ptr;

always_comb begin
	next_call_stack_ptr = call_stack_ptr;
	next_call_stack = call_stack;

	unique case(cmd)
		microaddr_types::NONE:
			next_addr = addr;

		microaddr_types::INC:
			next_addr = addr + 1;

		microaddr_types::LOAD:
			next_addr = load_addr;

		microaddr_types::LOADNE:
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
