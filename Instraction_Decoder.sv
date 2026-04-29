`timescale 1ns / 1ps
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module Instruction_Decoder #( parameter INSTR_LEN = 32)
(
  input logic[INSTR_LEN-1:0] Instruction,
  output logic[6:0] opcode,
  
  output logic[4:0] rd,
  output logic[4:0] rs1,
  output logic[4:0] rs2,
  
  output logic[2:0] funct3,
  output logic[6:0] funct7    
);

    assign opcode = Instruction[6:0];
    
    assign rd  = Instruction[11:7];
    assign rs1 = Instruction[19:15];
    assign rs2 = Instruction[24:20];
    
    assign funct3 = Instruction[14:12];
    assign funct7 = Instruction[31:25];

endmodule
