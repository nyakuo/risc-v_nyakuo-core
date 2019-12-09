module Core (
  input logic clk_i,
  input logic rst_i
);

  logic [31:0] pc;

  typedef enum logic [3:0] {
    FETCH,
    DECODE,
    EXEC,
    WRITE_BACK
  } state;
  state current_state;

  localparam READ  = 1'b0;
  localparam WRITE = 1'b1;

  // ---------------
  // 命令メモリ
  // ---------------
  logic        i_mem_we;
  logic [31:0] i_mem_addr;
  logic [31:0] i_mem_data;
  logic [31:0] i_mem_out;

  Bram i_mem(
    .clk_i(clk_i),
    .we_i(i_mem_we),
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
  logic [4:0] rf_addr1;
  logic [31:0] rf_data1;
  logic [31:0] rf_out1;
  logic        rf_rw2;
  logic [4:0] rf_addr2;
  logic [31:0] rf_data2;
  logic [31:0] rf_out2;

  reg_file rf (
    .clk_i(clk_i),
    .rst_i(rst_i),
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
  logic [31:0] instruction;
  logic [31:0] operand_a;
  logic [31:0] operand_b;
  logic [4:0] operand_d;
  logic [2:0] funct;
  logic [21:1] offset;
  logic is_calc;
  logic is_branch;
  logic is_shift;
  logic is_jal;
  logic is_jalr;
  logic is_load;
  logic is_store;

  assign instruction = i_mem_out;

  Decoder decoder(
    .inst_i(instruction),
    .regfile_data1_i(rf_out1),
    .regfile_data2_i(rf_out2),
    .regfile_addr1_o(rf_addr1),
    .regfile_addr2_o(rf_addr2),
    .operand_a_o(operand_a),
    .operand_b_o(operand_b),
    .operand_d_o(operand_d),
    .funct_o(funct),
    .offset_o(offset),
    .is_calc_o(is_calc),
    .is_branch_o(is_branch),
    .is_shift_o(is_shift),
    .is_jal_o(is_jal),
    .is_jalr_o(is_jalr),
    .is_load_o(is_load),
    .is_store_o(is_store)
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
      pc <= 32'h0000_0000;

      // register file
      rf_rw1 <= READ;
      rf_rw2 <= READ;
//      rf_addr1 <= 5'b0_0000;
//      rf_addr2 <= 5'b0_0000;
      rf_data1 <= 32'h0000_0000;
      rf_data2 <= 32'h0000_0000;

      // d_mem
      d_mem_addr <=  32'h0000_0000;
      d_mem_rw <= READ;
      d_mem_data <= 32'h0000_0000;

      // i_mem
      i_mem_we <= 1'b0;
      i_mem_data <= 32'h0000_0000;
    end
    else begin
      case (current_state)
        FETCH: begin
          current_state <= DECODE;
        end

        DECODE: begin
          rf_rw1 <= READ;
          rf_rw2 <= READ;
          current_state <= EXEC;
        end

        EXEC: begin
          current_state <= WRITE_BACK;
        end

        WRITE_BACK: begin
          current_state <= FETCH;
          if (!is_branch) begin
            pc <= pc + 1;
          end
        end

        default:;
      endcase
    end
  end

  // 命令メモリの初期化 (シミュレーション向け)
  initial begin
    $readmemb("../test/assembly/inst-mem_data.txt", i_mem.mem);
    $readmemb("../test/assembly/data-mem_data.txt", d_mem.mem);
  end

endmodule
