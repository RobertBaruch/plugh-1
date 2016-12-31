`timescale 1ns / 1ns

import register_types::addr_t;
import mem_types::cmd_t;

module mem_test_bench();

bit clk;
bit reset;
cmd_t cmd;
addr_t addr;
byte unsigned write_data;
byte unsigned read_data;

bit[18:0] sram_addr;
wire logic[7:0] sram_data;
bit sram_not_ce;
bit sram_not_oe;
bit sram_not_we;

assign sram_data = sram_not_oe ? 'z : 8'ha1;

mem mem(.*);

always #100 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    
    #200
    reset = 0;
    
    #90
    cmd = mem_types::WRITE0;
    addr = 8'h98;
    write_data = 8'hBC;   
    #10 
    
    #100
    
    #90
    cmd = mem_types::WRITE1;
    #10
    
    #100
    
    #90
    cmd = mem_types::READ;
    #10
    
    #100
    #100

    //assert(sram_not_we == 1) begin end
    //else begin
    //    $display("FAIL");
    //end
    $finish;
end

endmodule
