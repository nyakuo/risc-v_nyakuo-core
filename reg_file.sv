module reg_file (
  input logic rst,
  input logic [31:0] addr,
  input logic [31:0] idata,
  output logic [31:0] out
);

  logic [31:0] [0:31] regs;

  int i;

  assign begin
    // reset
    if (rst == 1'b1) begin
      for (i=0; i<32; ++i) begin
        regs[i] = 0;
      end
    end
    else begin
      out = regs[addr]; 
      regs[addr] = idata;
    end
  end

endmodule
