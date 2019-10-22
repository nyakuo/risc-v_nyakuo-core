package nyakuo_pkg;

  // 対応している命令一覧
  typedef enum logic {
    SLL, SLLI, SRL, SRLI, SRA, SRAI, // Shift
    ADD, ADDI, SUB, LUI, AUIPC, // Calculate
    XOR, XORI, OR, ORI, AND, ANDI, // Logic
    SLT, SLTU, SLTIU, // Compare
    BEQ, BNE, SLT, BGE, BLTU, BGEU, JAL, JALR, // Branch
    LB, LH, LBU, LHU, LW, // Load
    SB, SH, SW, // Store

    // TODO: 以下に対応する
    FENCE, FENCE_I, ECALL, EBREAK
    CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
    } instruction;

endpackage