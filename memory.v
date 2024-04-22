`timescale 1ns / 1ps
module memory#(
                    parameter A_BITS = 10,
                    parameter D_BITS = 32,
                    parameter MEMSIZE = 1024)
              (
                    input clk,
                    input [A_BITS-1:0] address,
                    input [D_BITS-1:0] data_in,
                    input read_en,
                    input write_en,
                    output [D_BITS-1:0] data_out        
                );
                
    reg [D_BITS-1:0] internal_memory[0:MEMSIZE-1];
    
    always@(posedge clk) begin
        if(write_en)
            internal_memory[address] <= data_in;
    end
    
    assign data_out = (read_en) ? internal_memory[address] : 0;
    
endmodule