module reg_file (
  input logic rw_i, // read or write
  input logic [31:0] addr_i,
  input logic [31:0] data_i,
  output logic [31:0] out_o
);

  logic [31:0] [0:31] regs;

  assign out_o = ~rw_i & regs[addr_i];
  assign regs[addr] = rw_i ? data_i : regs[addr_i];

endmodule
