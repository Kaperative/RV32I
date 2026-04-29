`timescale 1ns / 1ps
import OPCODE_pkg::*;
import ALU_pkg::*;
import FUNCT3_pkg::*;

// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module ALU_Controller(
    
    input   logic[6:0]   opcode,
    input   logic[2:0]   funct3,
    input   logic[6:0]   funct7,
    
    output  logic[3:0]   ALU_Code
);

always_comb begin
   
    case (opcode)
   
              // R - type
              OPCODE_REG: 
              begin    
                  case(funct3)
                     
                     FUNCT3_R_ADDSUB: 
                        begin
                            if (funct7 == 7'b0000000) begin
                                ALU_Code = ALU_CODE_ADD;  
                            end
                            
                            else if (funct7 == 7'b0100000) begin
                                 ALU_Code = ALU_CODE_SUB;  
                            end
                            else begin ALU_Code = ALU_CODE_NOP; end
                        end
                                 
                     FUNCT3_R_AND :  
                        begin
                            if (funct7 == 7'b0000000) begin
                                ALU_Code = ALU_CODE_AND;  
                            end 
                            else begin ALU_Code = ALU_CODE_NOP; end
                        
                        end
                     FUNCT3_R_OR  :  
                        begin
                            if (funct7 == 7'b0000000) begin
                                ALU_Code = ALU_CODE_OR;  
                            end 
                            else begin ALU_Code = ALU_CODE_NOP; end
                        end    
                        
                     FUNCT3_R_XOR  :                                                  
                      begin  
                      
                      if (funct7 == 7'b0000000) begin        
                          ALU_Code = ALU_CODE_XOR;            
                      end                                    
                      else begin ALU_Code = ALU_CODE_NOP; end  
                     end    
                     
                     
                     FUNCT3_R_SLL  : 
                        begin  
                        
                        if (funct7 == 7'b0000000) begin        
                            ALU_Code = ALU_CODE_SLL;            
                        end                                    
                        else begin ALU_Code = ALU_CODE_NOP; end
                        
                     end    
                       
                                    
                     FUNCT3_R_SR  :  
                      begin  
                      if (funct7 == 7'b0000000) begin
                          ALU_Code = ALU_CODE_SRL;  
                      end
                      
                      else if (funct7 == 7'b0100000) begin
                           ALU_Code = ALU_CODE_SRA;  
                      end
                      else begin ALU_Code = ALU_CODE_NOP; end
                      
                     end    
                     
                     
                     FUNCT3_R_SLT:   
                     begin  
                        if (funct7 == 7'b0000000) begin        
                            ALU_Code = ALU_CODE_SLT;            
                        end                                    
                        else begin ALU_Code = ALU_CODE_NOP; end
                     end    
                     
                     FUNCT3_R_SLTU : 
                     begin  
                        if (funct7 == 7'b0000000) begin        
                            ALU_Code = ALU_CODE_SLTU;            
                        end                                    
                        else begin ALU_Code = ALU_CODE_NOP; end
                     end 
              endcase
              end
              
              // I - type
              OPCODE_IMM: 
              begin
               case(funct3)
                 FUNCT3_I_ADDI: 
                    begin
                        ALU_Code = ALU_CODE_ADD;  
                    end
                             
                 FUNCT3_I_ANDI :  
                    begin
                        ALU_Code = ALU_CODE_AND;                
                    end
                 FUNCT3_I_ORI:  
                    begin
                        ALU_Code = ALU_CODE_OR;  
                    end    
                    
                 FUNCT3_I_XORI  :                                                  
                  begin    
                        ALU_Code = ALU_CODE_XOR;            
                 end    
    
                 FUNCT3_I_SLTI: 
                    begin      
                        ALU_Code = ALU_CODE_SLT;                          
                    end  
                      
                 FUNCT3_I_SLTIU: 
                  begin      
                      ALU_Code = ALU_CODE_SLTU;                          
                  end     
                 
                  FUNCT3_I_SLLI: 
                  begin      
                      ALU_Code = ALU_CODE_SLL;                          
                  end   
                 
                 FUNCT3_I_SRXI:  
                  begin  
                  if (funct7 == 7'b0000000) begin
                      ALU_Code = ALU_CODE_SRL;  
                  end
                  
                  else if (funct7 == 7'b0100000) begin
                       ALU_Code = ALU_CODE_SRA;  
                  end
                  else begin ALU_Code = ALU_CODE_NOP; end
                  
                 end    
                endcase
              end
              
              // I - type
              OPCODE_LOAD: 
                  begin
                    ALU_Code = ALU_CODE_ADD; 
                  end
              
              // S -type
              OPCODE_STORE: 
                  begin
                    ALU_Code = ALU_CODE_ADD; 
                  end
   
              // B - type
            OPCODE_BRANCH: ALU_Code = ALU_CODE_SUB; 
              
              // J - type 
              OPCODE_JAL: 
                  begin
                    ALU_Code = ALU_CODE_ADD;
                  end 
              
              OPCODE_JALR: 
                  begin
                    ALU_Code = ALU_CODE_ADD;
                  end
              
              // U-type
              OPCODE_LUI: 
                  begin
                   ALU_Code = ALU_CODE_PASS;
                  end
              
              OPCODE_AUIPC: 
                  begin
                    ALU_Code = ALU_CODE_ADD;
                  end   
                 
              OPCODE_SYSTEM: 
                  begin 
                    ALU_Code = ALU_CODE_NOP;
                  end   
                
              default:   
                  begin
                    ALU_Code = ALU_CODE_NOP;
                  end 
                 
          endcase
    
end
endmodule
