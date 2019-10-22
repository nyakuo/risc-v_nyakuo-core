module memory (
  input logic clk_i,
  input logi rst_i,
  input logic rw_i, // read or wriet
  input logic [31:0] addr_i,
  input logic [31:0] data_i,
  output logic [31:0] out_o
);

  logic [31:0] [0:1023] mem;
  integer i;

  always @(posedge clk_i) begin
    if (rst_i) begin
      for (i=0; i<1024; i=i+1) begin
        mem[i] <= 32'h0000_0000;
      end
    end
    else begin
      case (rw_i)
        1'b0: out_o <= mem[addr_i]; // read 
        1'b1: mem[addr_i] <= data_i; // write
    end
  end

endmodule
