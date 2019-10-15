module core (
  input logic clk,
  input logic rst
);

  logic [31:0] pc;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      pc <= 32'h8000_0000;
    end 
    else begin
    end
  end 

endmodule
