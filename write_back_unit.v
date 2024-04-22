`timescale 1ns / 1ps
`include "defines.vh"

module write_back_unit #(parameter D_BITS = 32) (
    input [D_BITS-1:0] data_in,
    
    input read,
    input write_en,
    input [D_BITS-1:0] result,
    input jmp_op,
    output clr_sgn,
    output reg [D_BITS-1:0] writeback_out_result
);

always@(*) begin
    if(read) begin
        writeback_out_result = data_in;
    end else if(write_en) begin
        writeback_out_result = result;
    end else begin
        writeback_out_result = 0;
    end
end

assign clr_sgn = jmp_op; // if 1 -> jump -> clr pipeline

endmodule