module reg_file (
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        rw1_i, // read or write
  input  logic [4:0] addr1_i,
  input  logic [31:0] data1_i,
  input  logic        rw2_i, // read or write
  input  logic [4:0] addr2_i,
  input  logic [31:0] data2_i,
  output logic [31:0] data1_o,
  output logic [31:0] data2_o
);

  localparam WRITE = 1'b1;

  logic [31:0] regs [0:31];

  assign data1_o = {32 {~rw1_i}} & regs[addr1_i];
  assign data2_o = {32 {~rw2_i}} & regs[addr2_i];

  int i;
  always @(posedge clk_i) begin
    if (rst_i == 1'b1) begin
      for (i=0; i<32; i=i+1) begin
        regs[i] <= 32'd0;
      end
    end 
    else begin
      if (rw1_i == WRITE) begin
        regs[addr1_i] <= data1_i;
      end
      if (rw2_i == WRITE) begin
        regs[addr2_i] <= data2_i;
      end
    end
  end

endmodule
