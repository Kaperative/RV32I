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


    logic [31:0] add_result;
    logic [31:0] sub_result;
    logic [31:0] shift_result;
    logic [31:0] slt_result;
    logic [31:0] sltu_result;
    logic [31:0] logic_result;
    
    logic        add_carry;
    logic        sub_carry;
    logic        add_overflow;
    logic        sub_overflow;


    assign {add_carry, add_result} = {1'b0, A} + {1'b0, B};
    assign {sub_carry, sub_result} = {1'b0, A} + {1'b0, ~B} + 1'b1;
    
    assign add_overflow = (A[31] == B[31]) && (add_result[31] != A[31]);
    assign sub_overflow = (A[31] == ~B[31]) && (sub_result[31] != A[31]);
    

    always_comb begin
        case (ALU_Code)
            ALU_CODE_SLL: shift_result = A << B[4:0];
            ALU_CODE_SRL: shift_result = A >> B[4:0];
            ALU_CODE_SRA: shift_result = $signed(A) >>> B[4:0];
            default:      shift_result = 32'b0;
        endcase
    end
    

    assign slt_result  = {31'b0, sub_result[31] ^ sub_overflow};  
    assign sltu_result = {31'b0, ~sub_carry};                     

    always_comb begin
        case (ALU_Code)
            ALU_CODE_AND: logic_result = A & B;
            ALU_CODE_OR:  logic_result = A | B;
            ALU_CODE_XOR: logic_result = A ^ B;
            default:      logic_result = 32'b0;
        endcase
    end
    

    always_comb begin
        case (ALU_Code)
            ALU_CODE_ADD:  Result = add_result;
            ALU_CODE_SUB:  Result = sub_result;
            ALU_CODE_SLL:  Result = shift_result;
            ALU_CODE_SRL:  Result = shift_result;
            ALU_CODE_SRA:  Result = shift_result;
            ALU_CODE_SLT:  Result = slt_result;
            ALU_CODE_SLTU: Result = sltu_result;
            ALU_CODE_AND:  Result = logic_result;
            ALU_CODE_OR:   Result = logic_result;
            ALU_CODE_XOR:  Result = logic_result;
            
            // LUI
            ALU_CODE_PASS: Result = B;    // подготовка константы производится в UC модуле       
            default:       Result = 32'b0;
        endcase
    end

    assign Zero     = (Result == 32'b0);
    assign Negative = Result[31];
    
    always_comb begin
        case (ALU_Code)
            ALU_CODE_ADD:  Carry = add_carry;
            ALU_CODE_SUB:  Carry = sub_carry;
            ALU_CODE_SLTU: Carry = sub_carry;
            default:       Carry = 1'b0;
        endcase
    end
    
    always_comb begin
        case (ALU_Code)
            ALU_CODE_ADD: Overflow = add_overflow;
            ALU_CODE_SUB: Overflow = sub_overflow;
            ALU_CODE_SLT: Overflow = sub_overflow;
            default:      Overflow = 1'b0;
        endcase
    end

endmodule