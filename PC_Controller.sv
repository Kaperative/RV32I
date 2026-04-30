`timescale 1ns / 1ps

module PC_Controller (
    input  logic         Jump,
    input  logic         JumpReg,
    input  logic         BranchTaken,
    input  logic [31:0]  JumpPointer,   
    input  logic [31:0]  PC,            
    input  logic [31:0]  Immediate,  
    input  logic [31:0]  PC_Plus_4,
    
    output logic [31:0]  PC_next
);

    logic [31:0] PC_target;  
    assign PC_target = PC + Immediate;

    assign PC_next = (JumpReg)     ? JumpPointer :
                     (Jump)        ? PC_target   :
                     (BranchTaken) ? PC_target   : PC_Plus_4;

endmodule