`timescale 1ns / 1ps

import OPCODE_pkg::*;
import  ALU_pkg::*;
import FUNCT3_pkg::*;
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module RV32I(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc_debug,
    output logic [31:0] instr_debug,
    output logic [31:0] alu_result_debug
    );

 logic [31:0] pc, pc_next, pc_plus_4;
 
 logic [31:0] instruction;
 
    logic [6:0]  opcode;
    logic [4:0]  rs1, rs2, rd;
    logic [2:0]  funct3;
    logic [6:0]  funct7;   
    
    logic [31:0] immediate;
    
    logic        RegWrite;
    logic        ALUSrcA;
    logic        ALUSrcB;
    logic        MemRead;
    logic        MemWrite;
    logic [1:0]  MemtoReg;
    logic        Branch;
    logic        Jump;
    logic        JumpReg;
               
logic pc_en;
assign pc_en = 1'b1;
     logic [31:0] rd1, rd2;
     logic [31:0] write_data;  
     
     logic [31:0] alu_a, alu_b;
     logic [5:0]  alu_code;
     logic [31:0] alu_result;
     logic        alu_zero, alu_negative, alu_carry, alu_overflow;
     
     logic        branch_taken;
     logic [31:0] mem_read_data;
     logic [31:0] mem_write_data;
     logic [3:0]  mem_write_mask;
     
     logic [31:0] load_result;
     logic [31:0] jump_pointer;
     
  
     
     
      Instruction_Memory u_imem (
          .address    (pc),
          .instruction(instruction)
      );
        
     Instruction_Decoder u_decoder (
         .Instruction(instruction),
         .opcode     (opcode),
         .rd         (rd),
         .rs1        (rs1),
         .rs2        (rs2),
         .funct3     (funct3),
         .funct7     (funct7)
     );
            
    IMM_GEN u_imm_gen (
        .Instruction(instruction),
        .opcode     (opcode),
        .Immediate  (immediate)
    );        
    
    Control_Signals u_control (
            .opcode   (opcode),
            .Jump     (Jump),
            .JumpReg  (JumpReg),
            .Branch   (Branch),
            .src_ALU_A  (ALUSrcA),
            .src_ALU_B  (ALUSrcB),
            .W_mem (MemWrite),
            .R_mem  (MemRead),
            .W_reg (RegWrite),
            .src_W_Data_reg (MemtoReg)
        );
    
           RegFile u_regfile (
               .clk       (clk),
               .W_EN      (RegWrite),
               .W_Addr    (rd),
               .W_Data    (write_data),
               .R_Addr_0  (rs1),
               .R_Addr_1  (rs2),
               .R_Data_0  (rd1),
               .R_Data_1  (rd2)
           );

           ALU_Controller u_alu_ctrl (
               .opcode   (opcode),
               .funct3   (funct3),
               .funct7   (funct7),
               .ALU_Code (alu_code)
           );
           
           assign alu_a = ALUSrcA ? pc : rd1;      
           assign alu_b = ALUSrcB ? immediate : rd2;

           ALU u_alu (
               .A        (alu_a),
               .B        (alu_b),
               .ALU_Code (alu_code),
               .Result   (alu_result),
               .Zero     (alu_zero),
               .Negative (alu_negative),
               .Carry    (alu_carry),
               .Overflow (alu_overflow)
           );
           

           Branch_Controller u_branch (
               .Branch      (Branch),
               .Zero        (alu_zero),
               .Negative    (alu_negative),
               .Overflow    (alu_overflow),
               .Carry       (alu_carry),
               .funct3      (funct3),
               .BranchTaken (branch_taken)
           );
           

           Store_Controller u_store (
               .Address       (alu_result),
               .WriteDataRaw  (rd2),
               .funct3        (funct3),
               .MemWrite      (MemWrite),
               .WriteData     (mem_write_data),
               .WriteMask     (mem_write_mask)
           );
           

           Data_Memory u_dmem (
               .clk       (clk),
               .MemRead   (MemRead),
               .MemWrite  (MemWrite),
               .WriteMask (mem_write_mask),
               .Address   (alu_result),
               .WriteData (mem_write_data),
               .ReadData  (mem_read_data)
           );

           Load_Controller u_load (
               .Address     (alu_result),
               .ReadDataRaw (mem_read_data),
               .funct3      (funct3),
               .ReadData    (load_result)
           );
           

           always_comb begin
               case (MemtoReg)
                   2'b00:   write_data = alu_result;      // ALU
                   2'b01:   write_data = load_result;     // Mem
                   2'b10:   write_data = pc_plus_4;       // PC+4
                   default: write_data = 32'b0;
               endcase
           end
           
           assign jump_pointer = {alu_result[31:1], 1'b0};
           
           PC_Controller u_pc_ctrl (
               .Jump        (Jump),
               .JumpReg     (JumpReg),
               .BranchTaken (branch_taken),
               .JumpPointer (jump_pointer),
               .PC          (pc),
               .Immediate   (immediate),
               .PC_Plus_4   (pc_plus_4),
               .PC_next     (pc_next)
           );

           
           PC #(.WIDTH(32)) u_pc (
               .clk    (clk),
               .rst_n  (~reset), 
               .pc_en  (pc_en),
               .pc_next(pc_next),
               .pc_out (pc)
           );

           PC_Plus4 #(
               .PC_WIDTH (32),
               .INSTR_LEN(32)
           ) u_pc_plus4 (
               .PC_in (pc),
               .PC_out(pc_plus_4)
           );
           
            // debug 
           assign pc_debug = pc;
           assign instr_debug = instruction;
           assign alu_result_debug = alu_result;
       
       endmodule
