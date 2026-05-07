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
    logic        isSW;
    logic        isSH;

    assign sb_mask = (4'b0001 << Address[1:0]);    
    assign sh_mask = Address[1] ? 4'b1100 : 4'b0011;

    assign isSW    = funct3[1];
    assign isSH    = funct3[0];
    
    assign WriteMask =  (isSW) ? 4'b1111 :
                        (isSH) ? sh_mask : sb_mask; 

    assign WriteData =  (isSW) ?       WriteDataRaw         :
                        (isSH) ?    {2{WriteDataRaw[15:0]}} : 
                                    {4{WriteDataRaw[7:0]} } ; // SB - default

endmodule