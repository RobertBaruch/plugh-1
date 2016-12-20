MODULES := microaddr_counter
TYPE_FILES := *_types.sv

% : %.sv $(TYPE_FILES) %_test.cpp
	verilator -Wall -cc $(TYPE_FILES) \
		$< -y . -Mdir $(<:%.sv=%) --prefix $(<:%.sv=%) \
  		--exe $(<:%.sv=%_test.cpp) -CFLAGS "-std=c++11"
	make -C $@ -j8 -f $@.mk

all : $(MODULES)

clean : 
	rm -rf $(MODULES)