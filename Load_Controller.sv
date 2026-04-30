import OFA_pkg::*;

module Load_Controller (
    input  logic [31:0] Address,
    input  logic [31:0] ReadDataRaw, 
    input  logic [2:0]  funct3, 
    
    output logic [31:0] ReadData   
);

    logic [7:0]  selected_byte;
    logic [15:0] selected_half;
    assign selected_byte = (Address[1:0] == 2'b00) ? ReadDataRaw[7:0]   :
                           (Address[1:0] == 2'b01) ? ReadDataRaw[15:8]  :
                           (Address[1:0] == 2'b10) ? ReadDataRaw[23:16] :
                                                     ReadDataRaw[31:24];

    assign selected_half = Address[1] ? ReadDataRaw[31:16] : ReadDataRaw[15:0];
    assign ReadData = (funct3 == FUNCT3_L_LB)  ? { {24{selected_byte[7]}}, selected_byte } : 
                      (funct3 == FUNCT3_L_LBU) ? { 24'b0, selected_byte }                  : 
                      (funct3 == FUNCT3_L_LH)  ? { {16{selected_half[15]}}, selected_half }:
                      (funct3 == FUNCT3_L_LHU) ? { 16'b0, selected_half }                  : 
                      (funct3 == FUNCT3_L_LW)  ? ReadDataRaw : 32'b0;
                                                                                       

endmodule