MODULES := microaddr_counter register_file alu addr_alu vars 

TYPE_FILES := register_types.sv microaddr_types.sv alu_types.sv \
	addr_alu_types.sv mem_types.sv plugh_types.sv

EXTRA_FLAGS_microaddr_counter := -Gopjump_table_file='"opjump_table_test.data"'

% : %.sv $(TYPE_FILES) %_test.cpp
	verilator -Wall -cc $(TYPE_FILES) $@.sv -y . -Mdir $@ --prefix $@ \
  		--exe $(@:%=%_test.cpp) -CFLAGS "-std=c++11" $($(@:%=EXTRA_FLAGS_%))
	make -C $@ -j8 -f $@.mk

all : $(MODULES)

clean : 
	rm -rf $(MODULES)
