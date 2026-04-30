import OFA_pkg::*;

module RV32I(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc_debug,
    output logic [31:0] instr_debug,
    output logic [31:0] alu_result_debug
);


    logic [31:0] pc, pc_next, pc_plus_4;
    logic [31:0] instruction;
    logic [31:0] rd1, rd2, write_data, alu_a, alu_b, alu_result;
    logic [31:0] immediate, mem_read_data, mem_write_data, load_result;
    
    logic [6:0]  funct7;
    logic [4:0]  rs1, rs2, rd;
    logic [2:0]  funct3;
    logic [3:0]  alu_code;
    logic [1:0]  mem_to_reg;
    logic        reg_write, alu_src_a, alu_src_b, mem_read, mem_write;
    logic        branch, jump, jump_reg, branch_taken;
    logic [3:0]  mem_write_mask;
    logic alu_zero, alu_negative, alu_overflow;
    
    Instruction_Memory u_imem (
        .address     (pc),
        .instruction (instruction)
    );


    Unit_Controller u_unit_ctrl (
        .Instruction (instruction),
        .rd(rd), .rs1(rs1), .rs2(rs2),
        .funct3      (funct3), .funct7(funct7),
        .Jump        (jump), .JumpReg(jump_reg), .Branch(branch),
        .src_ALU_A     (alu_src_a), .src_ALU_B(alu_src_b),
        .W_mem    (mem_write), .R_mem(mem_read), .W_reg(reg_write),
        .src_W_Data_reg    (mem_to_reg),
        .Immediate   (immediate),
        .ALU_code    (alu_code)
    );

    RegFile u_regfile (
        .clk      (clk),
        .W_EN     (reg_write),
        .W_Addr   (rd),
        .W_Data   (write_data),
        .R_Addr_0 (rs1),
        .R_Addr_1 (rs2),
        .R_Data_0 (rd1),
        .R_Data_1 (rd2)
    );

    assign alu_a = alu_src_a ? pc : rd1;
    assign alu_b = alu_src_b ? immediate : rd2;

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
        .Branch      (branch),
        .Zero        (alu_zero),
        .Negative    (alu_negative),
        .Overflow    (alu_overflow),
        .Carry       (alu_carry),
        .funct3      (funct3),
        .BranchTaken (branch_taken)
    );

    Store_Controller u_store (
        .Address      (alu_result),
        .WriteDataRaw (rd2),
        .funct3       (funct3),
        .MemWrite     (mem_write),
        .WriteData    (mem_write_data),
        .WriteMask    (mem_write_mask)
    );

    Data_Memory u_dmem (
        .clk       (clk),
        .MemRead   (mem_read),
        .MemWrite  (mem_write),
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
        case (mem_to_reg)
            2'b00:   write_data = alu_result;
            2'b01:   write_data = load_result;
            2'b10:   write_data = pc_plus_4;
            default: write_data = 32'b0;
        endcase
    end

    PC_Controller u_pc_ctrl (
        .Jump        (jump),
        .JumpReg     (jump_reg),
        .BranchTaken (branch_taken),
        .JumpPointer ({alu_result[31:1], 1'b0}),
        .PC          (pc),
        .Immediate   (immediate),
        .PC_Plus_4   (pc_plus_4),
        .PC_next     (pc_next)
    );

    PC #(.WIDTH(32)) u_pc (
        .clk    (clk),
        .rst_n  (~reset),
        .pc_en  (1'b1),
        .pc_next(pc_next),
        .pc_out (pc)
    );

    PC_Plus4 u_pc_plus4 (
        .PC_in (pc),
        .PC_out(pc_plus_4)
    );

 
    assign pc_debug = pc;
    assign instr_debug = instruction;
    assign alu_result_debug = alu_result;

endmodule