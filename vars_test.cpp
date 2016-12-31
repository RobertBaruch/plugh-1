#include "vars.h"
#include "verilated.h"

struct TestCase {
	const char* name;
  uint32_t FP;
  uint32_t GP;
 	uint8_t V;
  uint32_t expected_addr;
};

TestCase test_cases[] {
  { "invalid", 0xF012, 0x12, 0, 0},

	{ "local1", 0xF012, 0x12, 1, 0xF012},
  { "local2", 0xF012, 0x12, 2, 0xF014},

  { "global10", 0xF012, 0x12, 0x10, 0x12},
  { "global11", 0xF012, 0x12, 0x11, 0x14}
};

bool test_expected_addr(vars* device, TestCase *test_case) {
    if (device->addr == test_case->expected_addr) {
      return true;
    }
    printf("%s: fail: expected addr %08X but was %08X\n",
      test_case->name, test_case->expected_addr,
      device->addr);
    return false;
}

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  vars* device = new vars;
  
  device->FP = 0;
  device->GP = 0;
  device->V = 0;
  device->eval();

  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);
  int num_passes = 0;

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];

  	device->FP = test_case->FP;
    device->GP = test_case->GP;
    device->V = test_case->V;
    device->eval();

    bool passed = true;
    passed &= test_expected_addr(device, test_case);

    if (passed) {
      printf("%s: passed\n", test_case->name);
      num_passes++;
    }
  }
  device->final();
  delete device;
  printf("\n");
  printf("Tests passed: %d/%d\n", num_passes, num_test_cases);
  exit(0);
}
