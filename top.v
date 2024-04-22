`timescale 1ns / 1ps
`include "defines.vh"
module top(
        input clk,
        input nrst
    );
    
    wire [`A_BITS-1:0] pc;
    wire [15:0] instr;
    wire read;
    wire write;
    wire [`A_BITS-1:0] address;
    wire [`D_BITS-1:0] sram_data_in;
    wire [`D_BITS-1:0] sram_data_out;
    
    rom #(.A_BITS(`A_BITS)) ROM(
        .pc(pc),
        .instr(instr)
    );
    
    pipeline_top #(.A_BITS(`A_BITS), .D_BITS(`D_BITS)) pipeline_top(
        .clk(clk),
        .nrst(nrst),
        .instruction(instr),
        .data_in(sram_data_out),
        .pc(pc),
        .read(read),
        .write(write),
        .address(address),
        .data_out(sram_data_in)
    );
    
    
    sram #(.A_BITS(`A_BITS), .D_BITS(`D_BITS), .MEMSIZE(1023)) SRAM (
        .clk(clk),
        .nrst(nrst),
        .address(address),
        .data_in(sram_data_in),
        .read_en(read),
        .write_en(write),
        .data_out(sram_data_out)
    );
    
endmodule
