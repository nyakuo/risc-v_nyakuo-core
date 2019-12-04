#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"

unsigned int main_time = 0;     // Current simulation time

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;
}

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  Vcore *top = new Vcore();

  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("wave.vcd");

  top->clk_i = 0;
  top->rst_i = 0;

  while (!Verilated::gotFinish()) {
    if (main_time > 10)
      top->rst_i = 1;

    if (main_time % 5 == 0)
      top->clk_i = !top->clk_i;

    // 評価および出力
    top->eval();
    printf("Time %d\n", main_time);
    tfp->dump(main_time);

    if (main_time > 100)
      break;

    ++main_time;
  }

  tfp->close();
  top->final();
  return 0;
}
