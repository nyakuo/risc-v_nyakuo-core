import nyakuo_pkg::*;

module alu (
  input logic clk_i,
  input instruction inst_i,
  input logic [31:0] operand_a_i,
  input logic [31:0] operand_b_i,
  output logic [31:0] result_o
);
    instruction inst;

    always_comb begin
      unique case (inst_i)
      // Shift
        SLL, SLLI: result_o = operand_a_i <<  operand_b_i[4:0];
        SRL, SRLI: result_o = operand_a_i >>  operand_b_i[4:0];
        SRA, SRAI: result_o = operand_a_i >>> operand_b_i[4:0];

      // Calculate
      // Logic
      // Compare
      // Branch
        default:;
      endcase
    end

endmodule