// TODO: FENCE への対応
// TODO: CSR への対応
module Decoder (
  input logic  [31:0] inst_i,
  input logic  [31:0] regfile_data1_i,
  input logic  [31:0] regfile_data2_i,
  output logic [4:0]  regfile_addr1_o,
  output logic [4:0]  regfile_addr2_o,
  output logic [31:0] operand_a_o,
  output logic [31:0] operand_b_o,
  output logic [4:0]  operand_d_o,
  output logic [2:0]  funct_o,
  output logic [20:0] offset_o,
  output logic        is_calc_o,
  output logic        is_branch_o,
  output logic        is_shift_o,
  output logic        is_jal_o,
  output logic        is_jalr_o,
  output logic        is_load_o,
  output logic        is_store_o
);
  logic [31:0] instruction;

  // TODO: LUI への対応
  localparam [31:0] OPCODE_LUI   = 32'b????????_????????_????????_?0110111;
  // TODO: AUIPC への対応
  localparam [31:0] OPCODE_AUIPC = 32'b????????_????????_????????_?0110111;

  // Branch
  localparam [31:0] OPCODE_JAL   = 32'b????????_????????_????????_?1101111;
  localparam [31:0] OPCODE_JALR  = 32'b????????_????????_000?????_?1100111;
  localparam [31:0] OPCODE_BEQ   = 32'b????????_????????_000?????_?1100011;
  localparam [31:0] OPCODE_BNE   = 32'b????????_????????_001?????_?1100011;
  localparam [31:0] OPCODE_BLT   = 32'b????????_????????_100?????_?1100011;
  localparam [31:0] OPCODE_BGE   = 32'b????????_????????_101?????_?1100011;
  localparam [31:0] OPCODE_BLTU  = 32'b????????_????????_110?????_?1100011;
  localparam [31:0] OPCODE_BGEU  = 32'b????????_????????_111?????_?1100011;

  // Load
  localparam [31:0] OPCODE_LB    = 32'b????????_????????_000?????_?0000011;
  localparam [31:0] OPCODE_LH    = 32'b????????_????????_001?????_?0000011;
  localparam [31:0] OPCODE_LW    = 32'b????????_????????_010?????_?0000011;
  localparam [31:0] OPCODE_LBU   = 32'b????????_????????_100?????_?0000011;
  localparam [31:0] OPCODE_LHU   = 32'b????????_????????_101?????_?0000011;

  // Store
  localparam [31:0] OPCODE_SB    = 32'b????????_????????_000?????_?0100011;
  localparam [31:0] OPCODE_SH    = 32'b????????_????????_001?????_?0100011;
  localparam [31:0] OPCODE_SW    = 32'b????????_????????_010?????_?0100011;

  // Calc immidiate
  localparam [31:0] OPCODE_ADDI  = 32'b????????_????????_000?????_?0010011;
  localparam [31:0] OPCODE_SLTI  = 32'b????????_????????_010?????_?0010011;
  localparam [31:0] OPCODE_SLTIU = 32'b????????_????????_011?????_?0010011;
  localparam [31:0] OPCODE_XORI  = 32'b????????_????????_100?????_?0010011;
  localparam [31:0] OPCODE_ORI   = 32'b????????_????????_110?????_?0010011;
  localparam [31:0] OPCODE_ANDI  = 32'b????????_????????_111?????_?0010011;

  // Shift
  localparam [31:0] OPCODE_SLLI  = 32'b0000000?_????????_001?????_?0010011;
  localparam [31:0] OPCODE_SRLI  = 32'b0000000?_????????_101?????_?0010011;
  localparam [31:0] OPCODE_SRAI  = 32'b0100000?_????????_101?????_?0010011;

  // Calc
  localparam [31:0] OPCODE_ADD   = 32'b0000000?_????????_000?????_?0110011;
  localparam [31:0] OPCODE_SUB   = 32'b0100000?_????????_000?????_?0110011;
  localparam [31:0] OPCODE_SLL   = 32'b0000000?_????????_001?????_?0110011;
  localparam [31:0] OPCODE_SLT   = 32'b0000000?_????????_010?????_?0110011;
  localparam [31:0] OPCODE_SLTU  = 32'b0000000?_????????_011?????_?0110011;
  localparam [31:0] OPCODE_XOR   = 32'b0000000?_????????_100?????_?0110011;
  localparam [31:0] OPCODE_SRL   = 32'b0000000?_????????_101?????_?0110011;
  localparam [31:0] OPCODE_SRA   = 32'b0100000?_????????_101?????_?0110011;
  localparam [31:0] OPCODE_OR    = 32'b0000000?_????????_110?????_?0110011;
  localparam [31:0] OPCODE_AND   = 32'b0000000?_????????_111?????_?0110011;

// calc
  logic is_calc;

  assign is_calc = (instruction === OPCODE_ADD)
                 | (instruction === OPCODE_SUB)
                 | (instruction === OPCODE_SLL)
                 | (instruction === OPCODE_SLT)
                 | (instruction === OPCODE_SLTU)
                 | (instruction === OPCODE_XOR)
                 | (instruction === OPCODE_SRL)
                 | (instruction === OPCODE_SRA)
                 | (instruction === OPCODE_OR)
                 | (instruction === OPCODE_AND);

  logic [4:0] calc_rd;
  logic [2:0] calc_funct;
  logic [4:0] calc_rs1;
  logic [4:0] calc_rs2;

  assign calc_rd = instruction[11:7];
  assign calc_funct = instruction[14:12];
  assign calc_rs1 = instruction[19:15];
  assign calc_rs2 = instruction[24:20];

// calc immediate
  logic is_calc_imm;

  assign is_calc_imm = (instruction === OPCODE_ADDI)
                     | (instruction === OPCODE_SLTI)
                     | (instruction === OPCODE_SLTIU)
                     | (instruction === OPCODE_XORI)
                     | (instruction === OPCODE_ORI)
                     | (instruction === OPCODE_ANDI);


  logic [2:0] calc_imm_funct;
  logic [4:0] calc_imm_rd;
  logic [4:0] calc_imm_rs1;
  logic [11:0] calc_imm_imm;

  assign calc_imm_funct = instruction[14:12];
  assign calc_imm_rd    = instruction[11:7];
  assign calc_imm_rs1   = instruction[19:15];
  assign calc_imm_imm   = instruction[31:20];


// shift immediate
  logic is_shift_imm;

  assign is_shift_imm = (instruction === OPCODE_SLLI)
                      | (instruction === OPCODE_SRLI)
                      | (instruction === OPCODE_SRAI);

  logic [4:0]  shift_imm_rd;
  logic [2:0]  shift_imm_funct;
  logic [4:0]  shift_imm_rs1;
  logic [4:0]  shift_imm_imm;

  assign shift_imm_rd = instruction[11:7];
  assign shift_imm_funct = instruction[14:12];
  assign shift_imm_rs1 = instruction[19:15];
  assign shift_imm_imm = instruction[24:20];

// jump (jal)
  assign is_jal_o = instruction === OPCODE_JAL;

  logic [20:0] jal_offset;
  logic [4:0] jal_rd;

  assign jal_offset = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
  assign jal_rd = instruction[11:7];

// jump (jalr)
  assign is_jalr_o = instruction === OPCODE_JALR;
  logic [4:0] jalr_rd;
  logic [4:0] jalr_rs1;
  logic [11:0] jalr_imm;

  assign jalr_rd = instruction[11:7];
  assign jalr_rs1 = instruction[19:15];
  assign jalr_imm = instruction[31:20];

// branch
  assign is_branch_o = (instruction === OPCODE_BEQ)
                    | (instruction === OPCODE_BNE)
                    | (instruction === OPCODE_BLT)
                    | (instruction === OPCODE_BGE)
                    | (instruction === OPCODE_BLTU)
                    | (instruction === OPCODE_BGEU);

  logic [4:0] branch_rs1;
  logic [4:0] branch_rs2;
  logic [2:0] branch_funct;
  logic [12:0] branch_offset;

  assign branch_rs1 = instruction[19:15];
  assign branch_rs2 = instruction[24:20];
  assign branch_funct = instruction[14:12];
  assign branch_offset = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

// Load
  assign is_load_o = (instruction === OPCODE_LB)
                | (instruction === OPCODE_LH)
                | (instruction === OPCODE_LW)
                | (instruction === OPCODE_LBU)
                | (instruction === OPCODE_LHU);

  logic [4:0] load_rd;
  logic [2:0] load_funct;
  logic [4:0] load_rs1;
  logic [11:0] load_offset;

  assign load_rd = instruction[11:7];
  assign load_funct = instruction[14:12];
  assign load_rs1 = instruction[19:15];
  assign load_offset = instruction[31:20];

// Store
  assign is_store_o = (instruction === OPCODE_SB)
                | (instruction === OPCODE_SH)
                | (instruction === OPCODE_SW);

  logic [4:0] store_rs1;
  logic [4:0] store_rs2;
  logic [2:0] store_funct;
  logic [11:0] store_offset;

  assign store_rs1 = instruction[19:15];
  assign store_rs2 = instruction[24:20];
  assign store_funct = instruction[14:12];
  assign store_offset = {instruction[31:25], instruction[11:7]};

// Operand
  assign is_calc_o = (is_calc | is_calc_imm);

  localparam [7:0] IS_CALC     = 8'b10000000;
  localparam [7:0] IS_CALC_IMM = 8'b01000000;
  localparam [7:0] IS_SHIFT    = 8'b00100000;
  localparam [7:0] IS_JAL      = 8'b00010000;
  localparam [7:0] IS_JALR     = 8'b00001000;
  localparam [7:0] IS_BRANCH   = 8'b00000100;
  localparam [7:0] IS_LOAD     = 8'b00000010;
  localparam [7:0] IS_STORE    = 8'b10000001;

  logic [7:0] status;
  assign status = {is_calc, is_calc_imm, is_shift_imm, is_jal_o,
                  is_jalr_o, is_branch_o, is_load_o, is_store_o};

 // always_comb begin
  always @(*) begin
    case (status)
      IS_CALC: begin
        regfile_addr1_o = calc_rs1;
        regfile_addr2_o = calc_rs2;
        operand_a_o = regfile_data1_i;
        operand_b_o = regfile_data2_i;
        operand_d_o = calc_rd;
        funct_o = calc_funct;
      end

      IS_CALC_IMM: begin
        regfile_addr1_o = calc_imm_rs1;
        operand_a_o = regfile_data1_i;
        operand_b_o = calc_imm_imm;
        operand_d_o = calc_imm_rd;
        funct_o = calc_imm_funct;
      end

      IS_SHIFT: begin
        regfile_addr1_o = shift_imm_rs1;
        operand_a_o = regfile_data1_i;
        operand_b_o = shift_imm_imm;
        operand_d_o = shift_imm_rd;
        funct_o = shift_imm_funct;
      end

      IS_JAL: begin
        operand_a_o = jal_offset;
        operand_d_o = jal_rd;
      end

      IS_JALR: begin
        operand_a_o = jalr_rs1;
        operand_b_o = jalr_imm;
        operand_d_o = jalr_rd;
      end

      IS_BRANCH: begin
        regfile_addr1_o = branch_rs1;
        regfile_addr2_o = branch_rs2;
        operand_a_o = regfile_data1_i;
        operand_b_o = regfile_data2_i;
        funct_o = branch_funct;
        offset_o = branch_offset;
      end

      IS_LOAD: begin
        regfile_addr1_o = load_rs1;
        operand_a_o = regfile_data1_i;
        operand_d_o = load_rd;
        funct_o = load_funct;
        offset_o = load_offset;
      end

      IS_STORE: begin
        regfile_addr1_o = store_rs1;
        operand_a_o = regfile_data1_i;
        funct_o = store_funct;
        offset_o = store_offset;
      end
    endcase
  end

endmodule
