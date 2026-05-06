import OFA_pkg::*;
module Store_Controller (
    input  logic [31:0] Address,
    input  logic [31:0] WriteDataRaw,
    input  logic [2:0]  funct3, 
    input  logic        MemWrite,
    
    output logic [31:0] WriteData,
    output logic [3:0]  WriteMask 
);

    logic [3:0]  sb_mask;    
    logic [3:0]  sh_mask;

    assign sb_mask = (4'b0001 << Address[1:0]);    
    assign sh_mask = Address[1] ? 4'b1100 : 4'b0011;
    
    assign WriteMask = (!MemWrite)             ? 4'b0000 :
                       (funct3 == FUNCT3_S_SB) ? sb_mask :
                       (funct3 == FUNCT3_S_SH) ? sh_mask :
                       (funct3 == FUNCT3_S_SW) ? 4'b1111 : 4'b0000;

    assign WriteData = (funct3 == FUNCT3_S_SB) ? {4{WriteDataRaw[7:0]} } :
                       (funct3 == FUNCT3_S_SH) ? {2{WriteDataRaw[15:0]}} :
                       (funct3 == FUNCT3_S_SW) ?    WriteDataRaw         : 32'b0;

endmodule