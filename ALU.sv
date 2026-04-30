import OFA_pkg::*;

module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALU_Code,
    
    output logic [31:0] Result,
    output logic        Zero,
    output logic        Negative,
    output logic        Carry,
    output logic        Overflow
);

    logic [31:0] add_result, sub_result;
    logic        add_carry, sub_carry;
    logic        add_overflow, sub_overflow;

    assign {add_carry, add_result} = {1'b0, A} + {1'b0, B};
    assign {sub_carry, sub_result} = {1'b0, A} + {1'b0, ~B} + 1'b1;
    
    assign add_overflow = (A[31] == B[31]) && (add_result[31] != A[31]);
    assign sub_overflow = (A[31] == ~B[31]) && (sub_result[31] != A[31]);

    logic [31:0] sll_res, srl_res, sra_res;
    assign sll_res = A << B[4:0];
    assign srl_res = A >> B[4:0];
    assign sra_res = $signed(A) >>> B[4:0];

    logic [31:0] and_res, or_res, xor_res, slt_res, sltu_res;
    assign and_res  = A & B;
    assign or_res   = A | B;
    assign xor_res  = A ^ B;
    assign slt_res  = {31'b0, sub_result[31] ^ sub_overflow};
    assign sltu_res = {31'b0, ~sub_carry};

    assign Result = (ALU_Code == ALU_CODE_ADD)  ? add_result :
                    (ALU_Code == ALU_CODE_SUB)  ? sub_result :
                    (ALU_Code == ALU_CODE_SLL)  ? sll_res    :
                    (ALU_Code == ALU_CODE_SRL)  ? srl_res    :
                    (ALU_Code == ALU_CODE_SRA)  ? sra_res    :
                    (ALU_Code == ALU_CODE_SLT)  ? slt_res    :
                    (ALU_Code == ALU_CODE_SLTU) ? sltu_res   :
                    (ALU_Code == ALU_CODE_AND)  ? and_res    :
                    (ALU_Code == ALU_CODE_OR)   ? or_res     :
                    (ALU_Code == ALU_CODE_XOR)  ? xor_res    :
                    (ALU_Code == ALU_CODE_PASS) ? B          : 32'b0;


    assign Zero     = (Result == 32'b0);
    assign Negative = Result[31];

    assign Carry    = (ALU_Code == ALU_CODE_ADD)  ? add_carry :
                      (ALU_Code == ALU_CODE_SUB)  ? sub_carry :
                      (ALU_Code == ALU_CODE_SLTU) ? sub_carry : 1'b0;

    assign Overflow = (ALU_Code == ALU_CODE_ADD)  ? add_overflow :
                      (ALU_Code == ALU_CODE_SUB)  ? sub_overflow :
                      (ALU_Code == ALU_CODE_SLT)  ? sub_overflow : 1'b0;

endmodule