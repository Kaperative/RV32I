`timescale 1ns / 1ps
import FUNCT3_pkg::*;
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module Store_Controller (
    input  logic [31:0] Address,
    input  logic [31:0] WriteDataRaw,
    input  logic [2:0]  funct3,
    input  logic        MemWrite,
    
    output logic [31:0] WriteData,
    output logic [3:0]  WriteMask 
);

    always_comb begin
        if (MemWrite) begin
            case (funct3)
                
                FUNCT3_S_SB: begin
                    case (Address[1:0])
                        2'b00: begin
                            WriteMask = 4'b0001;
                            WriteData = {24'b0, WriteDataRaw[7:0]};
                        end
                        2'b01: begin
                            WriteMask = 4'b0010;
                            WriteData = {16'b0, WriteDataRaw[7:0], 8'b0};
                        end
                        2'b10: begin
                            WriteMask = 4'b0100;
                            WriteData = {8'b0, WriteDataRaw[7:0], 16'b0};
                        end
                        2'b11: begin
                            WriteMask = 4'b1000;
                            WriteData = {WriteDataRaw[7:0], 24'b0};
                        end
                    endcase
                end
                
             
                FUNCT3_S_SH: begin
                    if (Address[1]) begin
                        WriteMask = 4'b1100;
                        WriteData = {WriteDataRaw[15:0], 16'b0};
                    end else begin
                        WriteMask = 4'b0011;
                        WriteData = {16'b0, WriteDataRaw[15:0]};
                    end
                end
          
                FUNCT3_S_SW: begin
                    WriteMask = 4'b1111;
                    WriteData = WriteDataRaw;
                end
                
                default: begin
                    WriteMask = 4'b0000;
                    WriteData = 32'b0;
                end
            endcase
        end else begin
            WriteMask = 4'b0000;
            WriteData = 32'b0;
        end
    end

endmodule