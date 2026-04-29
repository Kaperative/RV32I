`timescale 1ns / 1ps
// // (* keep_hierarchy = "yes" *)
// // (* dont_touch = "yes" *)
module PC_Plus4 #(parameter 
    PC_WIDTH         = 32,
    INSTR_LEN        = 32
)
(    
    input  logic[PC_WIDTH-1:0] PC_in,
    output logic[PC_WIDTH-1:0] PC_out 
);

localparam  INC = INSTR_LEN/8;

assign PC_out = PC_in + INC;    
    
endmodule
