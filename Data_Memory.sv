
module Data_Memory #(
    parameter SIZE = 1024,             
    parameter ADDR_WIDTH = 32
)(
    input  logic        clk,
    input  logic        MemRead,
    input  logic        MemWrite,
    input  logic [3:0]  WriteMask,       
    input  logic [31:0] Address,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData
);
   
    logic [31:0] mem [0:SIZE-1];
    

    logic [31:0] word_addr ;
    logic [9:0]  index;

    assign word_addr = Address >> 2;
    assign index     = word_addr[9:0];

    always_comb begin
        ReadData = mem[index];
    end
    
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (WriteMask[0]) mem[index][7:0]   <= WriteData[7:0];
            if (WriteMask[1]) mem[index][15:8]  <= WriteData[15:8];
            if (WriteMask[2]) mem[index][23:16] <= WriteData[23:16];
            if (WriteMask[3]) mem[index][31:24] <= WriteData[31:24];
        end
    end

initial begin


    $readmemh("init/data_mem/data_mem.hex", mem);
    $display("Data Memory loaded:");
    for (int i = 0; i < 4; i++) begin
        $display("  mem[%0d] = 0x%h", i, mem[i]);
    end
end
endmodule