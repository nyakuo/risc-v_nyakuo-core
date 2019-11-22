#!/bin/bash

iverilog -o result/core_test -g2005-sv nyakuo_pkg.sv bram.sv core_test.sv core.sv memory.sv reg_file.sv &&\
cd result;\
./core_test;
