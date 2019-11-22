HDL_FILE:= nyakuo_pkg.sv\
	bram.sv\
	test/test_core.sv\
	core.sv\
	memory.sv\
	reg_file.sv

.PHONY: all
all: result/core_test
	./result/core_test

core_test: 
	iverilog -o result/core_test -g2005-sv ${HDL_FILE}
