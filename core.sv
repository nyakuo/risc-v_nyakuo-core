module Core (
  input logic clk_i,
  input logic rst_i
);

  logic [31:0] pc;

  typedef enum logic [3:0] {
    RUNNING = 0,
    FETCH = 1, 
    DECODE = 2, 
    EXEC = 3, 
    WRITE_BACK = 4
  } state;
  state current_state;

  localparam READ  = 1'b0;
  localparam WRITE = 1'b1;

  // --------------- 
  // 命令メモリ
  // --------------- 
  logic        i_mem_rw;
  logic [31:0] i_mem_addr;
  logic [31:0] i_mem_data;
  logic [31:0] i_mem_out;

  Bram i_mem( 
    .clk_i(clk_i),
    .we_i(i_mem_rw),
    .addr_i(i_mem_addr),
    .data_i(i_mem_data),
    .data_o(i_mem_out)
  );

  assign i_mem_addr = pc;

  // --------------- 
  // データメモリ
  // --------------- 
  logic        d_mem_rw;
  logic [31:0] d_mem_addr;
  logic [31:0] d_mem_data;
  logic [31:0] d_mem_out;

  Bram d_mem( 
    .clk_i(clk_i),
    .we_i(d_mem_rw),
    .addr_i(d_mem_addr),
    .data_i(d_mem_data),
    .data_o(d_mem_out)
  );

  // --------------- 
  // Register file
  // --------------- 
  logic        rf_rw1; 
  logic [31:0] rf_addr1;
  logic [31:0] rf_data1;
  logic [31:0] rf_out1;
  logic        rf_rw2; 
  logic [31:0] rf_addr2;
  logic [31:0] rf_data2;
  logic [31:0] rf_out2;

  reg_file rf ( 
    .clk_i(clk_i),
    .rw1_i(rf_rw1),
    .addr1_i(rf_addr1),
    .data1_i(rf_data1),
    .data1_o(rf_out1),
    .rw2_i(rf_rw2),
    .addr2_i(rf_addr2),
    .data2_i(rf_data2),
    .data2_o(rf_out2)
  );

  // --------------- 
  // decoder 
  // --------------- 
Decoder decoder (
  .inst_i(i_mem_data),
);
  
  
  // --------------- 
  // ALU 
  // --------------- 
//  Alu alu_ins(
//    .clk_i(clk_i),
//    .inst_i(),
//    .operand_a_i(),
//    .operand_b_i(),
//    .result_o()
//);

  always @(posedge clk_i) begin
    // Reset
    if (rst_i == 1'b1) begin
      current_state <= FETCH;
      pc <= 32'h8000_0000;

      // register file
      rf_rw1 <= READ;
      rf_addr1 <= 32'h0000_0000;
      rf_data1 <= 32'h0000_0000;
      rf_rw2 <= READ;
      rf_addr2 <= 32'h0000_0000;
      rf_data2 <= 32'h0000_0000;

      // d_mem
      d_mem_addr <=  32'h0000_0000;
      d_mem_rw <= READ;
      d_mem_data <= 32'h0000_0000; 

      // i_mem
      i_mem_rw <= READ;
      i_mem_data <= 32'h0000_0000; 
    end
    else begin
      case (current_state)
        FETCH: begin
          i_mem_rw <= READ;
          current_state <= DECODE;
        end

        DECODE: begin
          current_state <= EXEC;
          rf_rw1 <= READ;
          rf_rw2 <= READ;
        end

        EXEC: begin
          current_state <= WRITE_BACK;
        end

        WRITE_BACK: begin
          current_state <= FETCH;
        end

        default:;
      endcase
    end 
  end 

endmodule
