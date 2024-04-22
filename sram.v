`timescale 1ns / 1ps
module sram#(
                    parameter A_BITS = 10,
                    parameter D_BITS = 32,
                    parameter MEMSIZE = 1024)
              (
                    input                       clk,
                    input                       nrst,
                    input                       [A_BITS-1:0] address,
                    input                       [D_BITS-1:0] data_in,
                    input                       read_en,
                    input                       write_en,
                    output reg [D_BITS-1:0]     data_out        
                );
                
    reg [D_BITS-1:0] internal_memory[0:MEMSIZE-1];
    integer index;
    
    always@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            for(index = 0; index < MEMSIZE; index = index + 1) begin
                internal_memory[index] <= 0;
            end
        end else if(write_en)
            internal_memory[address] <= data_in;
    end
    
//    assign data_out = (read_en) ? internal_memory[address] : 0;
//data_out should be on clock 
    always@(posedge clk   or negedge nrst) begin
        if(!nrst || !read_en) begin
            data_out <= 0;
        end else if(read_en) begin
            data_out <= internal_memory[address];
        end 
    end 
endmodule