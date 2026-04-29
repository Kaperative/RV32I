package FUNCT3_pkg;

// Branch - type opcode = 110 0011
    localparam FUNCT3_B_BEQ     = 3'b000;
    localparam FUNCT3_B_BNE     = 3'b001;
    localparam FUNCT3_B_BLT     = 3'b100;
    localparam FUNCT3_B_BLTU    = 3'b110;
    localparam FUNCT3_B_BGE     = 3'b101;
    localparam FUNCT3_B_BGEU    = 3'b111;


// Store - type opcode = 010 0011
    localparam FUNCT3_S_SB     = 3'b000;
    localparam FUNCT3_S_SH     = 3'b001;
    localparam FUNCT3_S_SW     = 3'b010;

// LOAD - type opcode = 000 0011
   localparam FUNCT3_L_LB      = 3'b000;
   localparam FUNCT3_L_LBU     = 3'b100;
   localparam FUNCT3_L_LH      = 3'b001;
   localparam FUNCT3_L_LHU     = 3'b101;
   localparam FUNCT3_L_LW      = 3'b010;

// REG -type opcode = 011 0011

   localparam FUNCT3_R_ADDSUB          = 3'b000;
   
   localparam FUNCT3_R_AND          = 3'b111;
   localparam FUNCT3_R_OR           = 3'b110;
   localparam FUNCT3_R_XOR          = 3'b100;
   localparam FUNCT3_R_SLL          = 3'b001;

   localparam FUNCT3_R_SR           = 3'b101;
   localparam FUNCT3_R_SLT          = 3'b010;
   localparam FUNCT3_R_SLTU         = 3'b011;

// Immediate -type opcode = 001 0011
  
  localparam FUNCT3_I_ADDI  = 3'b000;
  localparam FUNCT3_I_SLLI  = 3'b001;
  localparam FUNCT3_I_SLTI  = 3'b010;
  localparam FUNCT3_I_SLTIU = 3'b011;
  localparam FUNCT3_I_XORI  = 3'b100;
  localparam FUNCT3_I_SRXI  = 3'b101;
  localparam FUNCT3_I_ORI   = 3'b110;
  localparam FUNCT3_I_ANDI  = 3'b111;
   

endpackage
