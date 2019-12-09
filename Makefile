HDL_FILE:=\
	core.sv\
	bram.sv\
	decoder.sv

.PHONY: all, test, clean
all:
	verilator -Wno-lint --trace -cc $(HDL_FILE)  --exe test_core.cpp

test: obj_dir
	cd obj_dir &&\
	make -f ./Vcore.mk &&\
  ./Vcore

open: obj_dir/wave.vcd
	open obj_dir/wave.vcd

clean: obj_dir
	rm -rf obj_dir
