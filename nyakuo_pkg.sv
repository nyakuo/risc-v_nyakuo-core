package nyakuo_pkg;

// 対応している命令一覧
typedef enum logic {
SLL, SLLI, SRL, SRLI, SRA, SRAI, // Shift
ADD, ADDI, SUB, LUI, AUIPC, // Calculate
XOR, XORI, OR, ORI, AND, ANDI, // Logic
SLT, SLTU, SLTI, SLTIU, // Compare
BEQ, BNE, BGE, BLT, BLTU, BGEU, JAL, JALR, // Branch
LB, LH, LBU, LHU, LW, // Load
SB, SH, SW, // Store

// TODO: 以下に対応する
FENCE, FENCE_I, ECALL, EBREAK
CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
} instruction;

// Register file のレジスタアドレスとレジスタタイプのマッピング
typedef enum reg_addr {
  ZERO = 0,
  RA   = 1,
  SP   = 2,
  GP   = 3,
  TP   = 4,
  T0   = 5,
  T1   = 6,
  T2   = 7,
  S0   = 8,
  FP   = 8,
  S1   = 9,
  A0   = 10,
  A1   = 11,
  A2   = 12,
  A3   = 13,
  A4   = 14,
  A5   = 15,
  A6   = 16,
  A7   = 17,
  S2   = 18,
  S3   = 19,
  S4   = 20,
  S5   = 21,
  S6   = 22,
  S7   = 23,
  S8   = 24,
  S9   = 25,
  S10  = 26,
  S11  = 27,
  T3   = 28,
  T4   = 29,
  T5   = 30,
  T6   = 31
}

parameter READ = 1'b0;
parameter LOAD = 1'b1;

endpackage