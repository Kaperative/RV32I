package OPCODE_pkg;
     // R-type
     localparam OPCODE_REG  = 7'b0110011;
     
     // I - type
     localparam OPCODE_IMM  = 7'b0010011;
     localparam OPCODE_LOAD   = 7'b0000011;
     localparam OPCODE_JALR   = 7'b1100111;
     localparam OPCODE_SYSTEM   = 7'b1110011;

     // S - type
     localparam OPCODE_STORE  = 7'b0100011;
     
     // B - type 
     localparam OPCODE_BRANCH = 7'b1100011;
     
     // J - type
     localparam OPCODE_JAL    = 7'b1101111;
     
     // U - type
     localparam OPCODE_LUI     = 7'b0110111;
     localparam OPCODE_AUIPC   = 7'b0010111;
endpackage