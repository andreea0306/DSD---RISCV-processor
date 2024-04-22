`timescale 1ns / 1ps
module register1 #(parameter D_BITS = 32)
    (
        input                   clk, 
        input                   nrst,
        input                   halt_op,
        input                   clr_sgn,
        input [6:0]             opcode,
        input [2:0]             dest,
        input [D_BITS-1:0]      op0,
        input [D_BITS-1:0]      op1,
        
        output reg [6:0]        reg1_out_opcode,
        output reg [2:0]        reg1_out_dest,
        output reg [D_BITS-1:0] reg1_out_op0,
        output reg [D_BITS-1:0] reg1_out_op1
    );
    
    always@(posedge clk or negedge nrst) begin
        if(!nrst || clr_sgn) begin
            // if rst  or clr pipeline send NOP op
            reg1_out_opcode <= 0;
            reg1_out_dest <= 0;
            reg1_out_op0 <= 0;
            reg1_out_op1 <= 0;
            
        end else if(halt_op) begin // if halt keep values
            reg1_out_opcode <= reg1_out_opcode;
            reg1_out_dest <= reg1_out_dest;
            reg1_out_op0 <= reg1_out_op0;
            reg1_out_op1 <= reg1_out_op1;
        end else begin
            // if normal op send input data to next stage
            reg1_out_opcode <= opcode;
            reg1_out_dest <= dest;
            reg1_out_op0 <= op0;
            reg1_out_op1 <= op1;
        end 
    end
    
endmodule
