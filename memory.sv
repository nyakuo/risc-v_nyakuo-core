module memory (
  input  logic clk_i,
  input  logic rst_i,
  input  logic rw_i, // read or wriet
  input  logic [31:0] addr_i,
  input  logic [31:0] data_i,
  output logic [31:0] out_o
);

  parameter READ = 1'b0;
  parameter WRITE = 1'b1;

  logic [31:0] mem [0:1023];
  integer i;

  always @(posedge clk_i) begin
    if (rst_i) begin
      for (i=0; i<1024; i=i+1) begin
        mem[i] <= 32'h0000_0000;
      end
    end
    else begin
      case (rw_i)
        READ:  out_o <= mem[addr_i]; 
        WRITE: mem[addr_i] <= data_i; 
      endcase
    end
  end

endmodule
