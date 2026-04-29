`timescale 1ns / 1ps
import FUNCT3_pkg::*;
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module Branch_Controller (
    input  logic        Branch,
    input  logic        Zero,
    input  logic        Negative,
    input  logic        Overflow,
    input  logic        Carry,
    input  logic [2:0]  funct3,
    
    output logic        BranchTaken
);

    logic less_than_signed;
    logic less_than_unsigned;


    assign less_than_signed = Negative ^ Overflow;

    assign less_than_unsigned = ~Carry;

    always_comb begin
        if (Branch) begin
            case (funct3)
                FUNCT3_B_BEQ:  BranchTaken = Zero;
                FUNCT3_B_BNE:  BranchTaken = ~Zero;
                FUNCT3_B_BLT:  BranchTaken = less_than_signed;
                FUNCT3_B_BGE:  BranchTaken = ~less_than_signed;
                FUNCT3_B_BLTU: BranchTaken = less_than_unsigned;
                FUNCT3_B_BGEU: BranchTaken = ~less_than_unsigned;
                default:       BranchTaken = 1'b0;
            endcase
        end else begin
            BranchTaken = 1'b0;
        end
    end

endmodule