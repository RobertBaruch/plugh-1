#include "register_file_register_types.h"
#include "register_file.h"
#include "verilated.h"

using name_t = register_file_register_types::name_t;

struct TestCase {
	const char* name;

	name_t mem_dest_select;
	uint8_t mem_data;

	name_t addr_alu_dest_select;
	uint32_t addr_alu_data;

  name_t alu_dest_select;
  uint16_t alu_data;

  name_t var_dest_select;
  uint32_t var_data;

	uint8_t expected_M;
 	uint8_t expected_V;
 	uint16_t expected_OP0;
 	uint16_t expected_OP1;
 	uint32_t expected_X;
 	uint32_t expected_SP;
 	uint32_t expected_FP;
 	uint32_t expected_GP;
  uint32_t expected_IP;
  uint32_t expected_AP;
};

TestCase test_cases[] {
  { "mem -> M", 
  	name_t::M, 0xA1,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> V", 
  	name_t::V, 0xA2,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0H", 
  	name_t::OP0H, 0xBB,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0xBB00, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0L", 
  	name_t::OP0L, 0xCC, 
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0xBBCC, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0", 
    name_t::OP0, 0x12, 
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1H", 
  	name_t::OP1H, 0xDD, 
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0xDD00, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1L", 
  	name_t::OP1L, 0xEE, 
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0xDDEE, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1", 
    name_t::OP1, 0x34, 
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0x0034, 0, 0, 0, 0, 0, 0},
  { "mem -> NONE", 
  	name_t::NONE, 0, 
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0, 0, 0, 0, 0, 0},

  { "addr_alu -> X", 
  	name_t::NONE, 0, 
  	name_t::X, 0x1FABC,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0, 0, 0, 0, 0},
  { "addr_alu -> SP", 
  	name_t::NONE, 0, 
  	name_t::SP, 0x01234,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0, 0, 0, 0},
  { "addr_alu -> FP", 
  	name_t::NONE, 0, 
  	name_t::FP, 0x19876,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0, 0, 0},
  { "addr_alu -> GP", 
  	name_t::NONE, 0, 
  	name_t::GP, 0x0102C,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0, 0},
  { "addr_alu -> IP", 
  	name_t::NONE, 0, 
  	name_t::IP, 0x1CCCC,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0},
  { "addr_alu -> AP", 
    name_t::NONE, 0, 
    name_t::AP, 0x09876,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},

  { "alu -> OP0", 
    name_t::NONE, 0, 
    name_t::NONE, 0, 
    name_t::OP0, 0x6543,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x6543, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},
  { "alu -> OP1", 
    name_t::NONE, 0, 
    name_t::NONE, 0, 
    name_t::OP1, 0xFDCB,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x6543, 0xFDCB, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},

  { "var -> X", 
    name_t::NONE, 0, 
    name_t::NONE, 0, 
    name_t::NONE, 0, 
    name_t::X, 0x14321,
    0xA1, 0xA2, 0x6543, 0xFDCB, 0x14321, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876}

};

bool test_expected_M(register_file* registers, TestCase *test_case) {
    if (registers->M == test_case->expected_M) {
      return true;
    }
    printf("%s: fail: expected M %02X but was %02X\n",
      test_case->name, test_case->expected_M, registers->M);
    return false;
}

bool test_expected_V(register_file* registers, TestCase *test_case) {
    if (registers->V == test_case->expected_V) {
      return true;
    }
    printf("%s: fail: expected V %02X but was %02X\n",
      test_case->name, test_case->expected_V, registers->V);
    return false;
}

bool test_expected_OP0(register_file* registers, TestCase *test_case) {
    if (registers->OP0 == test_case->expected_OP0) {
      return true;
    }
    printf("%s: fail: expected OP0 %04X but was %04X\n",
      test_case->name, test_case->expected_OP0, registers->OP0);
    return false;
}

bool test_expected_OP1(register_file* registers, TestCase *test_case) {
    if (registers->OP1 == test_case->expected_OP1) {
      return true;
    }
    printf("%s: fail: expected OP1 %04X but was %04X\n",
      test_case->name, test_case->expected_OP1, registers->OP1);
    return false;
}

bool test_expected_X(register_file* registers, TestCase *test_case) {
    if (registers->X == test_case->expected_X) {
      return true;
    }
    printf("%s: fail: expected X %08X but was %08X\n",
      test_case->name, test_case->expected_X, registers->X);
    return false;
}

bool test_expected_SP(register_file* registers, TestCase *test_case) {
    if (registers->SP == test_case->expected_SP) {
      return true;
    }
    printf("%s: fail: expected SP %08X but was %08X\n",
      test_case->name, test_case->expected_SP, registers->SP);
    return false;
}

bool test_expected_FP(register_file* registers, TestCase *test_case) {
    if (registers->FP == test_case->expected_FP) {
      return true;
    }
    printf("%s: fail: expected FP %08X but was %08X\n",
      test_case->name, test_case->expected_FP, registers->FP);
    return false;
}

bool test_expected_GP(register_file* registers, TestCase *test_case) {
    if (registers->GP == test_case->expected_GP) {
      return true;
    }
    printf("%s: fail: expected GP %08X but was %08X\n",
      test_case->name, test_case->expected_GP, registers->GP);
    return false;
}

bool test_expected_IP(register_file* registers, TestCase *test_case) {
    if (registers->IP == test_case->expected_IP) {
      return true;
    }
    printf("%s: fail: expected IP %08X but was %08X\n",
      test_case->name, test_case->expected_IP, registers->IP);
    return false;
}

bool test_expected_AP(register_file* registers, TestCase *test_case) {
    if (registers->AP == test_case->expected_AP) {
      return true;
    }
    printf("%s: fail: expected AP %08X but was %08X\n",
      test_case->name, test_case->expected_AP, registers->AP);
    return false;
}

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  register_file* registers = new register_file;
  
  registers->clk = 0;
  registers->mem_dest_select = name_t::NONE;
  registers->mem_data = 0;
  registers->addr_alu_dest_select = name_t::NONE;
  registers->addr_alu_data = 0;
  registers->alu_dest_select = name_t::NONE;
  registers->alu_data = 0;
  registers->var_dest_select = name_t::NONE;
  registers->var_data = 0;
  registers->eval();

  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);
  int num_passes = 0;

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];

  	registers->mem_dest_select = test_case->mem_dest_select;
    registers->mem_data = test_case->mem_data;
  	registers->alu_dest_select = test_case->alu_dest_select;
    registers->alu_data = test_case->alu_data;
    registers->addr_alu_dest_select = test_case->addr_alu_dest_select;
    registers->addr_alu_data = test_case->addr_alu_data;
    registers->var_dest_select = test_case->var_dest_select;
    registers->var_data = test_case->var_data;
    registers->eval();

    registers->clk = 1;
    registers->eval();
    registers->clk = 0;
    registers->eval();

    bool passed = true;
    passed &= test_expected_M(registers, test_case);
    passed &= test_expected_V(registers, test_case);
    passed &= test_expected_OP0(registers, test_case);
    passed &= test_expected_OP1(registers, test_case);
    passed &= test_expected_X(registers, test_case);
    passed &= test_expected_SP(registers, test_case);
    passed &= test_expected_FP(registers, test_case);
    passed &= test_expected_GP(registers, test_case);
    passed &= test_expected_IP(registers, test_case);
    passed &= test_expected_AP(registers, test_case);

    if (passed) {
      printf("%s: passed\n", test_case->name);
      num_passes++;
    }
  }
  registers->final();
  delete registers;
  printf("\n");
  printf("Tests passed: %d/%d\n", num_passes, num_test_cases);
  exit(0);
}
