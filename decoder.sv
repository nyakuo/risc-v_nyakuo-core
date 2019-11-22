import nyakuo_pkg::*;

// TODO: FENCE への対応
// TODO: CSR への対応
module Decoder (
  input logic  [31:0] inst_i,
  input logic  [31:0] regfile_data1_i,
  input logic  [31:0] regfile_data2_i,
  output logic [31:0] regfile_addr1_i,
  output logic [31:0] regfile_addr2_i,
  output logic [31:0] operand_a_o,
  output logic [31:0] operand_b_o,
  output logic [4:0]  operand_d_o,
  output logic [2:0]  funct_o,
  output logic        is_calc_o,
  output logic        is_branch_o,
  output logic        is_jump_o,
  output logic        is_load_o,
  output logic        is_store_o
);

  // TODO: LUI への対応
  localparam [31:0] OPCODE_LUI   = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0110111;
  // TODO: AUIPC への対応
  localparam [31:0] OPCODE_AUIPC = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0110111;

  // Branch
  localparam [31:0] OPCODE_JAL   = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x1101111;
  localparam [31:0] OPCODE_JALR  = 32'bxxxxxxxx_xxxxxxxx_000xxxxx_x1100111;
  localparam [31:0] OPCODE_BEQ   = 32'bxxxxxxxx_xxxxxxxx_000xxxxx_x1100011;
  localparam [31:0] OPCODE_BNE   = 32'bxxxxxxxx_xxxxxxxx_001xxxxx_x1100011;
  localparam [31:0] OPCODE_BLT   = 32'bxxxxxxxx_xxxxxxxx_100xxxxx_x1100011;
  localparam [31:0] OPCODE_BGE   = 32'bxxxxxxxx_xxxxxxxx_101xxxxx_x1100011;
  localparam [31:0] OPCODE_BLTU  = 32'bxxxxxxxx_xxxxxxxx_110xxxxx_x1100011;
  localparam [31:0] OPCODE_BGEU  = 32'bxxxxxxxx_xxxxxxxx_111xxxxx_x1100011;

  // Load 
  localparam [31:0] OPCODE_LB    = 32'bxxxxxxxx_xxxxxxxx_000xxxxx_x0000011;
  localparam [31:0] OPCODE_LH    = 32'bxxxxxxxx_xxxxxxxx_001xxxxx_x0000011;
  localparam [31:0] OPCODE_LW    = 32'bxxxxxxxx_xxxxxxxx_010xxxxx_x0000011;
  localparam [31:0] OPCODE_LBU   = 32'bxxxxxxxx_xxxxxxxx_100xxxxx_x0000011;
  localparam [31:0] OPCODE_LHU   = 32'bxxxxxxxx_xxxxxxxx_101xxxxx_x0000011;

  // Store
  localparam [31:0] OPCODE_SB    = 32'bxxxxxxxx_xxxxxxxx_000xxxxx_x0100011;
  localparam [31:0] OPCODE_SH    = 32'bxxxxxxxx_xxxxxxxx_001xxxxx_x0100011;
  localparam [31:0] OPCODE_SW    = 32'bxxxxxxxx_xxxxxxxx_010xxxxx_x0100011;

  // Calc immidiate
  localparam [31:0] OPCODE_ADDI  = 32'bxxxxxxxx_xxxxxxxx_000xxxxx_x0010011;
  localparam [31:0] OPCODE_SLTI  = 32'bxxxxxxxx_xxxxxxxx_010xxxxx_x0010011;
  localparam [31:0] OPCODE_SLTIU = 32'bxxxxxxxx_xxxxxxxx_011xxxxx_x0010011;
  localparam [31:0] OPCODE_XORI  = 32'bxxxxxxxx_xxxxxxxx_100xxxxx_x0010011;
  localparam [31:0] OPCODE_ORI   = 32'bxxxxxxxx_xxxxxxxx_110xxxxx_x0010011;
  localparam [31:0] OPCODE_ANDI  = 32'bxxxxxxxx_xxxxxxxx_111xxxxx_x0010011;
  localparam [31:0] OPCODE_SLLI  = 32'b0000000x_xxxxxxxx_001xxxxx_x0010011;
  localparam [31:0] OPCODE_SRLI  = 32'b0000000x_xxxxxxxx_101xxxxx_x0010011;
  localparam [31:0] OPCODE_SRAI  = 32'b0100000x_xxxxxxxx_101xxxxx_x0010011;

  // Calc
  localparam [31:0] OPCODE_ADD   = 32'b0000000x_xxxxxxxx_000xxxxx_x0110011;
  localparam [31:0] OPCODE_SUB   = 32'b0100000x_xxxxxxxx_000xxxxx_x0110011;
  localparam [31:0] OPCODE_SLL   = 32'b0000000x_xxxxxxxx_001xxxxx_x0110011;
  localparam [31:0] OPCODE_SLT   = 32'b0000000x_xxxxxxxx_010xxxxx_x0110011;
  localparam [31:0] OPCODE_SLTU  = 32'b0000000x_xxxxxxxx_011xxxxx_x0110011;
  localparam [31:0] OPCODE_XOR   = 32'b0000000x_xxxxxxxx_100xxxxx_x0110011;
  localparam [31:0] OPCODE_SRL   = 32'b0000000x_xxxxxxxx_101xxxxx_x0110011;
  localparam [31:0] OPCODE_SRA   = 32'b0100000x_xxxxxxxx_101xxxxx_x0110011;
  localparam [31:0] OPCODE_OR    = 32'b0000000x_xxxxxxxx_110xxxxx_x0110011;
  localparam [31:0] OPCODE_AND   = 32'b0000000x_xxxxxxxx_111xxxxx_x0110011;

// calc
  logic is_calc;

  assign is_calc = (inst_i == OPCODE_ADD)
                | (inst_i == OPCODE_SUB)
                | (inst_i == OPCODE_SLL)
                | (inst_i == OPCODE_SLT)
                | (inst_i == OPCODE_SLTU)
                | (inst_i == OPCODE_XOR)
                | (inst_i == OPCODE_SRL)
                | (inst_i == OPCODE_SRA)
                | (inst_i == OPCODE_OR) 
                | (inst_i == OPCODE_AND);
  
  logic [4:0] calc_rd;
  logic [9:0] calc_funct;
  logic [4:0] calc_rs1;
  logic [4:0] calc_rs2;

  assign calc_rd = inst[12:7];
  assign calc_funct = inst[15:12];
  assign calc_rs1 = inst[20:15];
  assign calc_rs2 = inst[25:20];

// calc immediate
  logic is_calc_imm;

  assign is_calc_imm = (inst_i == OPCODE_ADDI)
                  | (inst_i == OPCODE_SLTI) 
                  | (inst_i == OPCODE_SLTIU)
                  | (inst_i == OPCODE_XORI) 
                  | (inst_i == OPCODE_ORI)  
                  | (inst_i == OPCODE_ANDI);

  assign is_calc_o = (is_calc | is_calc_imm);

  logic [2:0] calc_imm_funct;
  logic [4:0] calc_imm_rd;
  logic [4:0] calc_imm_rs1;
  logic [11:0] calc_imm_ope_b;

  assign calc_imm_funct = inst[14:12];
  assign calc_imm_rd    = inst[11:7];
  assign calc_imm_rs1   = inst[19:15];
  assign calc_imm_imm   = inst[31:20];


// shift immediate
  logic is_shift_imm;

  assign is_shift_imm = (inst_i == OPCODE_SLLI) 
                  | (inst_i == OPCODE_SRLI) 
                  | (inst_i == OPCODE_SRAI); 

  logic [4:0]  shift_imm_rd;
  logic [2:0]  shift_imm_funct;
  logic [4:0]  shift_imm_rs1;
  logic [11:0] shift_imm_imm;
  
  assign shift_imm_rd = inst[11:7];
  assign shift_imm_funct = inst[14:12];
  assign shift_imm_rs1 = inst[19:15];
  assign shift_imm_imm = inst[31:20];

// jump
  assign is_jump_o = (inst_i == OPCODE_JAL)
                    | (inst_i == OPCODE_JALR);

  logic [20:0] jal_offset;
  logic [4:0] jal_rd;

  assign jal_offset = {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
  assign jal_rd = inst[11:7];

  logic [4:0] jalr_rd;
  logic [4:0] jalr_rs1;
  logic [11:0] jalr_imm;

  assign jalr_rd = inst[11:7];
  assign jalr_rs1 = inst[19:15];
  assign jalr_imm = inst[31:20];

// branch
   assign is_branch_o = (inst_i == OPCODE_BEQ)
                    | (inst_i == OPCODE_BNE) 
                    | (inst_i == OPCODE_BLT)  
                    | (inst_i == OPCODE_BGE)  
                    | (inst_i == OPCODE_BLTU) 
                    | (inst_i == OPCODE_BGEU);
  
  logic [4:0] branch_rs1;
  logic [4:0] branch_rs2;
  logic [2:0] branch_funct;
  logic [12:0] branch_offset;

  assign branch_rs1 = inst[19:15];
  assign branch_rs2 = inst[24:20];
  assign branch_funct = inst[14:12];
  assign branch_offset = {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

// Load
  assign is_load_o = (inst_i == OPCODE_LB)
                | (inst_i == OPCODE_LH)
                | (inst_i == OPCODE_LW)
                | (inst_i == OPCODE_LBU)
                | (inst_i == OPCODE_LHU);

  logic [4:0] load_rd;
  logic [2:0] load_funct;
  logic [4:0] load_rs1;
  logic [11:0] load_offset;

  assign load_rd = inst[11:7];
  assign load_funct = inst[14:12];
  assign load_rs1 = inst[19:15];
  assign load_offset = inst[31:20];

// Store
  assign is_store_o = (inst_i == OPCODE_SB)
                | (inst_i == OPCODE_SH)
                | (inst_i == OPCODE_SW);

  logic [4:0] store_rs1;
  logic [4:0] store_rs2;
  logic [2:0] store_funct;
  logic [11:0] store_offset;

  assign store_rs1 = inst[19:15];
  assign store_rs2 = inst[24:20];
  assign store_funct = inst[14:12];
  assign store_offset = {inst[31:25], inst[11:7]};

// Operand
  always_comb begin
    if (is_calc_imm) begin 
      regfile_addr1_i = calc_imm_rs1;
      operand_a_o = register_data1_i; 
      operand_b_o = calc_imm_imm;
      funct_o = calc_imm_funct;
    end
  end

endmodule