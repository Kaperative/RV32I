// переписать под assign блоки
// как-то вынести funct3 отсюда и передавать только управляющий сигнал от UC

import OFA_pkg::*;
module Load_Controller (
    input  logic [31:0] Address,
    input  logic [31:0] ReadDataRaw, 
    input  logic [2:0]  funct3, // ----
    
    output logic [31:0] ReadData   
);

    logic [31:0] extracted;

    always_comb begin
        case (funct3)

            FUNCT3_L_LB, FUNCT3_L_LBU: begin
                case (Address[1:0])
                    2'b00: extracted = {24'b0, ReadDataRaw[7:0]};
                    2'b01: extracted = {24'b0, ReadDataRaw[15:8]};
                    2'b10: extracted = {24'b0, ReadDataRaw[23:16]};
                    2'b11: extracted = {24'b0, ReadDataRaw[31:24]};
                endcase
            end
            

            FUNCT3_L_LH, FUNCT3_L_LHU: begin
                if (Address[1])
                    extracted = {16'b0, ReadDataRaw[31:16]};
                else
                    extracted = {16'b0, ReadDataRaw[15:0]};
            end

            FUNCT3_L_LW: begin
                extracted = ReadDataRaw;
            end
            
            default: extracted = 32'b0;
        endcase
    end

    always_comb begin
        case (funct3)
            FUNCT3_L_LB:  ReadData = { {24{extracted[7]}},  extracted[7:0] }; 
            FUNCT3_L_LBU: ReadData = { 24'b0,                extracted[7:0] }; 
            FUNCT3_L_LH:  ReadData = { {16{extracted[15]}}, extracted[15:0] };
            FUNCT3_L_LHU: ReadData = { 16'b0,               extracted[15:0] }; 
            FUNCT3_L_LW:  ReadData = extracted; 
            default:      ReadData = 32'b0;
        endcase
    end

endmodule