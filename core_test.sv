// core.sv のテストベンチ

module core_test();
  logic clk;
  logic rst;

  Core core(
    .clk_i(clk),
    .rst_i(rst)
  );

  parameter TIMING = 20;

  // Clock generator
  initial begin
    clk = 0;
    forever #TIMING clk = ~clk;
  end

  // Memory initializer
  initial begin
    $readmemh("./assembly/inst-mem_data.txt", core.i_mem.mem);
    $readmemh("./assembly/data-mem_data.txt", core.d_mem.mem);
  end

  // Reset & run simulation
  initial begin
    rst = 0;
    #TIMING
    rst = 1;
    #TIMING
    rst = 0;

    $display("start");

    #(TIMING*100) 
    $display("end");
    $finish;
  end

  // Output result file
  initial begin
    $dumpfile("core_test.vcd");
    $dumpvars(0, core);
  end

endmodule