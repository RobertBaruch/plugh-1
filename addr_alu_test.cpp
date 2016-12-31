#include "addr_alu_addr_alu_types.h"
#include "addr_alu.h"
#include "verilated.h"

struct TestCase {
	const char* name;
	uint8_t cmd;
  uint32_t x;
  uint32_t y;
 	uint32_t expected_z;
  uint8_t expected_zflag;
};

using cmd_t = addr_alu_addr_alu_types::cmd_t;

TestCase test_cases[] {
	{ "none", cmd_t::NONE, 0, 0, 0, 1},

  { "inc", cmd_t::INC, 0x12, 0, 0x13, 0},
  { "inc_overflow", cmd_t::INC, 0x1FFFF, 0, 0, 1},
};

bool test_expected_z(addr_alu* device, TestCase *test_case) {
    if (device->z == test_case->expected_z) {
      return true;
    }
    printf("%s: fail: expected z %04X but was %04X\n",
      test_case->name, test_case->expected_z,
      device->z);
    return false;
}

bool test_expected_zflag(addr_alu* device, TestCase *test_case) {
    if (device->zflag == test_case->expected_zflag) {
      return true;
    }
    printf("%s: fail: expected zflag %d but was %d\n",
      test_case->name, test_case->expected_zflag,
      device->zflag);
    return false;
}

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  addr_alu* device = new addr_alu;
  
  device->cmd = cmd_t::NONE;
  device->x = 0;
  device->y = 0;
  device->eval();

  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);
  int num_passes = 0;

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];

  	device->cmd = test_case->cmd;
    device->x = test_case->x;
    device->y = test_case->y;
    device->eval();

    bool passed = true;
    passed &= test_expected_z(device, test_case);
    passed &= test_expected_zflag(device, test_case);

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
