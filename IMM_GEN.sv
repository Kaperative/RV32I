`timescale 1ns / 1ps
import OPCODE_pkg::*;
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module IMM_GEN #(parameter INSTR_LEN =32, IMM_LEN = 32)
(
    input   logic[INSTR_LEN-1:0] Instruction,  
    input   logic[6:0] opcode,  
    output  logic[IMM_LEN-1:0]   Immediate 
);

    always_comb begin
    
        case (opcode)
            // I - type
            OPCODE_IMM, OPCODE_LOAD, OPCODE_JALR, OPCODE_SYSTEM: 
            begin
                Immediate = { {20{Instruction[31]}}, Instruction[31:20] };
            end
            
            // S -type
            OPCODE_STORE: 
            begin
                Immediate = { {20{Instruction[31]}}, Instruction[31:25],Instruction[11:7]};
            end
 
            // B - type
            OPCODE_BRANCH: 
            begin
                Immediate = { {19{Instruction[31]}}, Instruction[31], Instruction[7],
                            Instruction[30:25], Instruction[11:8], 1'b0 };
            end
            
            // J - type 
            OPCODE_JAL: 
            begin
                Immediate = { {11{Instruction[31]}}, Instruction[31], Instruction[19:12],
                            Instruction[20], Instruction[30:21], 1'b0 };
            end
            
            // U-type
            OPCODE_LUI,OPCODE_AUIPC: 
            begin
                Immediate = { Instruction[31:12], 12'b0 };
            end      
                        
            default: 
            begin
                Immediate = 32'b0;
            end    
        endcase
    end
endmodule
