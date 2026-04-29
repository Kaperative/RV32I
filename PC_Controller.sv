`timescale 1ns / 1ps
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module PC_Controller (
    input  logic        Jump,
    input  logic        JumpReg,
    input  logic        BranchTaken,
    input  logic [31:0] JumpPointer,   
    input  logic [31:0] PC,            
    input  logic [31:0] Immediate,  
    input  logic [31:0] PC_Plus_4,
    
    output logic [31:0] PC_next
);

    logic [31:0] PCPtr;  

    assign PCPtr = PC + Immediate;

    always_comb begin
       
        if (JumpReg) begin
            PC_next = JumpPointer;     
        end else if (Jump) begin
            PC_next = PCPtr;          
        end else if (BranchTaken) begin
            PC_next = PCPtr;           
        end else begin
            PC_next = PC_Plus_4;       
        end
    end

endmodule