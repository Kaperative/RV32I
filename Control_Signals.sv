`timescale 1ns / 1ps
import OPCODE_pkg::*;
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module Control_Signals(
    input logic[6:0] opcode,
    
    output logic Jump,
    output logic JumpReg,
    output logic Branch,
    output logic src_ALU_A,
    output logic src_ALU_B,
    output logic W_mem,
    output logic R_mem,
    output logic W_reg,

    output logic[1:0] src_W_Data_reg
    
    );

 

 always_comb begin
 Jump            = 1'b0;  
 JumpReg         = 1'b0;  
 Branch          = 1'b0;  
 src_ALU_A       = 1'b0;  
 src_ALU_B       = 1'b0;  
 W_mem           = 1'b0;  
 R_mem           = 1'b0;  
 W_reg           = 1'b0;  
 src_W_Data_reg  = 2'b0;
 
    case (opcode)
    
               // R - type
               OPCODE_REG: 
               begin    
                  W_reg = 1'b1;
                  src_ALU_A = 1'b0;
                  src_ALU_B = 1'b0;
                  src_W_Data_reg = 2'b0;
               end
               
               // I - type
               OPCODE_IMM: 
               begin
                  W_reg = 1'b1;
                  src_ALU_A = 1'b0;
                  src_ALU_B = 1'b1;
                  src_W_Data_reg = 2'b0;
               end
               
                  // I - type
                 OPCODE_LOAD: 
                 begin
                    W_reg = 1'b1;
                    src_ALU_A = 1'b0;
                    src_ALU_B = 1'b1;
                    R_mem = 1'b1;
                    src_W_Data_reg = 2'b01;
                 end
               
               // S -type
               OPCODE_STORE: 
               begin
                   src_ALU_A = 1'b0;
                   src_ALU_B = 1'b1;
                   W_mem = 1'b1;
                  // src_W_Data_reg = 2'b0;
               end
    
               // B - type
               OPCODE_BRANCH: 
               begin
                   src_ALU_A = 1'b0;
                   src_ALU_B = 1'b0;
                   Branch = 1'b1;
                  // src_W_Data_reg = 2'b0;
               end
               
               // J - type 
               OPCODE_JAL: 
               begin
               W_reg = 1'b1;
               src_ALU_A = 1'b1;
               src_ALU_B = 1'b1;
                Jump     = 1'b1;
               src_W_Data_reg = 2'b10;
               end 
               
               OPCODE_JALR: 
               begin
               W_reg = 1'b1;
               src_ALU_A = 1'b0;
               src_ALU_B = 1'b1;
               JumpReg     = 1'b1;
               src_W_Data_reg = 2'b10;
               end
               
               // U-type
               OPCODE_LUI: 
               begin
                W_reg = 1'b1;  
                src_ALU_B = 1'b1;
                src_W_Data_reg = 2'b00;
               end      
               
               OPCODE_AUIPC: 
               begin
                W_reg = 1'b1;  
                src_ALU_A = 1'b1;
                src_ALU_B = 1'b1;
                src_W_Data_reg = 2'b00;
               end   
                  
               OPCODE_SYSTEM: begin 
               end   
                 
               default: 
               begin
                  
               end    
           endcase
 end
   
    
endmodule
