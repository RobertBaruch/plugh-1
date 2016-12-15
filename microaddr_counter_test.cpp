#include "Microaddr_microaddr.h"
#include "Microaddr.h"
#include "verilated.h"

struct TestCase {
	const char* name;
  uint8_t reset;
	uint8_t cmd;
 	uint16_t load_addr;
 	uint16_t expected_addr;
};

TestCase test_cases[] {
	{ "reset", 1, Microaddr_microaddr::cmd::NONE, 0, 0 },
	{ "inc", 0, Microaddr_microaddr::cmd::INC, 0, 1 },
  { "none", 0, Microaddr_microaddr::cmd::NONE, 0, 1 },
  { "reset2", 1, Microaddr_microaddr::cmd::NONE, 0, 0 },
	{ "load", 0, Microaddr_microaddr::cmd::LOAD, 0xFA, 0xFA},
	{ "inc", 0, Microaddr_microaddr::cmd::INC, 0, 0xFB},
  { "reset3", 1, Microaddr_microaddr::cmd::NONE, 0, 0 },
};

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  Microaddr* counter = new Microaddr;
  
  counter->clk = 0;
  counter->reset = 0;
  counter->cmd = Microaddr_microaddr::cmd::NONE;
  counter->load_addr = 0;
  counter->eval();

  // while (!Verilated::gotFinish()) { 
  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];

  	counter->cmd = test_case->cmd;
    counter->reset = test_case->reset;
  	counter->load_addr = test_case->load_addr;  	
    counter->eval();

    counter->clk = 1;
    counter->eval();
    counter->clk = 0;
    counter->eval();

    if (counter->addr == test_case->expected_addr) {
    	printf("%s: passed\n", test_case->name);
    } else {
    	printf("%s: fail (expected %04X but was %04X)\n",
    		test_case->name, test_case->expected_addr,
    		counter->addr);
    }
  }
  counter->final();
  delete counter;
  exit(0);
}
