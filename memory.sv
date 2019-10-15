module memory (
  input logic clk,
  input logic rst,
  input logic [31:0] addr,
  input logic [31:0] idata,
  output logic [31:0] out
);

logic [31:0] [0:1024] mem;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
    end 
    else begin

    end
  end

endmodule
