`timescale 1ns / 1ps
`include "defines.vh"
module fetch_unit#(
                    parameter A_BITS = 10
                  )(
                    input                           clk,
                    input                           nrst,
                    input                           halt_op,
                    input                           clr_sgn,
                    input                           jmp_op,
                    input                           jmp_relative_op,
                    input       [A_BITS-1 : 0]      jmp_val,
                    input       [15 : 0]            instr_in,
                    output reg  [15 : 0]            instr_out, 
                    output reg  [A_BITS-1 : 0]      PC                                         
);

    // program counter logic
    always@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            // reset PC
            PC <= 0;
        end else if(halt_op) begin // if halt op -> flag 1
            // stop incr PC
            PC <= PC;
        end else if(jmp_op) begin
            if(jmp_relative_op) begin
                PC <= PC + jmp_val - 2'b10; // if relative jmp -> apply pipeline correction 2
            end else begin
                PC <= jmp_val; // jump to jmp val
            end
        end else begin
            PC <= PC + 1'b1;
        end
    end

    // instr_out logic -> IR 
    always@(posedge clk or negedge nrst) begin
        if(!nrst || clr_sgn) begin
            instr_out <= 0;
        end else if(halt_op) begin
            instr_out <= instr_out; // keep the value
        end else begin
            instr_out <= instr_in;
        end
    end

endmodule   
