// write first Block-memory
module Bram (
  input  logic clk_i,
  input  logic we_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] data_i,
  output logic [31:0] data_o
);

  logic [31:0] mem [0:1023];

  always @(posedge clk_i) begin
    if (we_i) begin
      data_o <= data_i;
      mem[addr_i] <= data_i;
    end
    else begin
      data_o <= mem[addr_i];
    end
  end

endmodule
