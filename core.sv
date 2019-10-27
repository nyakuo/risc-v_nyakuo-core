

module core (
  input logic clk_i,
  input logic rst_i
);

  typedef enum logic [3:0] {
    RESET, RESETTING, RUNNING,
    FETCH, DECODE, EXEC
  } state;
  state current_state;

  logic [31:0] pc;

  // --------------- 
  // 命令メモリ
  // --------------- 
  logic        i_mem_rw;
  logic [31:0] i_mem_addr;
  logic [31:0] i_mem_data;
  logic [31:0] i_mem_out;

  memory i_mem( 
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rw_i(i_mem_rw),
    .addr_i(i_mem_addr),
    .data_i(i_mem_data),
    .out_o(i_mem_out)
  );

  assign i_mem_addr = pc;

  // --------------- 
  // データメモリ
  // --------------- 
  logic        d_mem_rw;
  logic [31:0] d_mem_addr;
  logic [31:0] d_mem_data;
  logic [31:0] d_mem_out;

  memory d_mem( 
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rw_i(d_mem_rw),
    .addr_i(d_mem_addr),
    .data_i(d_mem_data),
    .out_o(d_mem_out)
  );

  // --------------- 
  // Register file
  // --------------- 
  logic        rf_rw; 
  logic [31:0] rf_addr;
  logic [31:0] rf_data;
  logic [31:0] rf_out;

  reg_file rf ( 
    .rw_i(rf_rw),
    .addr_i(rf_addr),
    .data_i(rf_data),
    .out_o(rf_out)
  );


  // --------------- 
  // decoder 
  // --------------- 
  
  // --------------- 
  // ALU 
  // --------------- 
  Alu alu_ins(
    .clk_i(clk_i),
    .inst_i(),
    .operand_a_i(),
    .operand_b_i(),
    .result_o()
  );

  always @(posedge clk_i) begin
    if (rst_i == 1'b1) begin
      current_state <= RESET;
    end
    else
      unique case (current_state)
        RESET: begin
          current_state <= RESETTING;
          pc <= 32'h8000_0000;

          // register file
          rf_rw <= 1'b1;
          rf_addr <= 32'h0000_0000;
          rf_data <= 32'h0000_0000;
        end

        RESETTING: begin
          rf_addr <= rf_addr + 1;

          if (rf_addr == 32'h0000_001f) begin
            current_state <= FETCH;
            rf_rw <= 1'b0;
          end
        end

        FETCH: begin
          i_mem_rw <= 1'b0;
        end
      endcase
    end 
  end 

endmodule
