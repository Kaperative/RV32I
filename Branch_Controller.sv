// переписать под assign блоки
// как-то вынести funct3 отсюда и передавать только управляющий сигнал от UC
// возможно вынести extraction в ALU

import OFA_pkg::*;
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
    logic is_BEQ, is_BNE, is_BLT, is_BGE, is_BLTU, is_BGEU;

    assign less_than_signed = Negative ^ Overflow;

    assign less_than_unsigned = ~Carry;

    assign is_BEQ   =   Branch & (funct3 == FUNCT3_B_BEQ);
    assign is_BNE   =   Branch & (funct3 == FUNCT3_B_BEQ);
    assign is_BLT   =   Branch & (funct3 == FUNCT3_B_BEQ);
    assign is_BGE   =   Branch & (funct3 == FUNCT3_B_BEQ);
    assign is_BLTU  =   Branch & (funct3 == FUNCT3_B_BEQ);
    assign is_BGEU  =   Branch & (funct3 == FUNCT3_B_BEQ);
  

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