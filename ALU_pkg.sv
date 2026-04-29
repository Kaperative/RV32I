package ALU_pkg;

    localparam ALU_CODE_ADD	  =  4'b0000;
    localparam ALU_CODE_SUB	  =  4'b0001;
    localparam ALU_CODE_AND	  =  4'b0010;
    localparam ALU_CODE_OR	  =  4'b0011;
    localparam ALU_CODE_XOR	  =  4'b0100;
    localparam ALU_CODE_SLT	  =  4'b0101;
    localparam ALU_CODE_SLTU  =  4'b0110;
    localparam ALU_CODE_SLL	  =  4'b0111;
    localparam ALU_CODE_SRL	  =  4'b1000;
    localparam ALU_CODE_SRA	  =  4'b1001;
    localparam ALU_CODE_PASS  =  4'b1010;
    localparam ALU_CODE_NOP   =  4'b1111;
  
endpackage
