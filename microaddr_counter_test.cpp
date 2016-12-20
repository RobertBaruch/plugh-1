#include "microaddr_counter_microaddr_types.h"
#include "microaddr_counter.h"
#include "verilated.h"

struct TestCase {
	const char* name;
  uint8_t reset;
  uint8_t zflag;
	uint8_t cmd;
 	uint16_t load_addr;
 	uint16_t expected_addr;
};

TestCase test_cases[] {
	{ "reset", 1, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 0},
	{ "inc", 0, 0, microaddr_counter_microaddr_types::cmd::INC, 0, 1},
  { "none", 0, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 1},
  { "reset2", 1, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 0},
	{ "load", 0, 0, microaddr_counter_microaddr_types::cmd::LOAD, 0xFA, 0xFA},
	{ "inc", 0, 0, microaddr_counter_microaddr_types::cmd::INC, 0, 0xFB},
  { "reset3", 1, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 0},

  { "call1", 0, 0, microaddr_counter_microaddr_types::cmd::CALL, 0xA0, 0xA0},
  { "ret1", 0, 0, microaddr_counter_microaddr_types::cmd::RET, 0, 0x01},

  { "reset4", 1, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 0},
  { "call2.1", 0, 0, microaddr_counter_microaddr_types::cmd::CALL, 0xA0, 0xA0},
  { "call2.2", 0, 0, microaddr_counter_microaddr_types::cmd::CALL, 0xB0, 0xB0},
  { "ret2.2", 0, 0, microaddr_counter_microaddr_types::cmd::RET, 0, 0xA1},
  { "ret2.1", 0, 0, microaddr_counter_microaddr_types::cmd::RET, 0, 0x01},

  { "reset5", 1, 0, microaddr_counter_microaddr_types::cmd::NONE, 0, 0},
  { "loadne", 0, 1, microaddr_counter_microaddr_types::cmd::LOADNE, 0xA0, 0x01},
  { "loadne2", 0, 0, microaddr_counter_microaddr_types::cmd::LOADNE, 0xA0, 0xA0}

};

bool test_expected_addr(microaddr_counter* counter, TestCase *test_case) {
    if (counter->addr == test_case->expected_addr) {
      return true;
    }
    printf("%s: fail: expected addr %04X but was %04X\n",
      test_case->name, test_case->expected_addr,
      counter->addr);
    return false;
}

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  microaddr_counter* counter = new microaddr_counter;
  
  counter->clk = 0;
  counter->reset = 0;
  counter->cmd = microaddr_counter_microaddr_types::cmd::NONE;
  counter->load_addr = 0;
  counter->eval();

  // while (!Verilated::gotFinish()) { 
  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);
  int num_passes = 0;

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];

  	counter->cmd = test_case->cmd;
    counter->reset = test_case->reset;
  	counter->load_addr = test_case->load_addr;  	
    counter->zflag = test_case->zflag;
    counter->eval();

    counter->clk = 1;
    counter->eval();
    counter->clk = 0;
    counter->eval();

    bool passed = true;
    passed &= test_expected_addr(counter, test_case);

    if (passed) {
      printf("%s: passed\n", test_case->name);
      num_passes++;
    }
  }
  counter->final();
  delete counter;
  printf("\n");
  printf("Tests passed: %d/%d\n", num_passes, num_test_cases);
  exit(0);
}
