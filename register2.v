`timescale 1ns / 1ps

module register2 #(parameter A_BITS = 10,
                   parameter D_BITS = 32)(
        input                       clk,
        input                       nrst,
        input                       halt_op,
        input                       jmp_op,
        input                       jmp_relative_op,
        input       [A_BITS-1:0]    jmp_val,
        input                       clr_sgn,
        input                       read,
        input                       write,
        input       [2:0]           dest,
        input       [A_BITS-1:0]    result,
        input                       write_en,
        output reg  [D_BITS-1:0]    reg2_out_result,
        output reg  [2:0]           reg2_out_dest,
        output reg                  reg2_out_halt_op,
        output reg                  reg2_out_jmp_op,
        output reg                  reg2_out_jmp_relative_op,
        output reg  [A_BITS-1:0]    reg2_out_jmp_val,
        output reg                  reg2_out_read,
        output reg                  reg2_out_write_en
    );
    
    always@(posedge clk or negedge nrst) begin
        if(!nrst || clr_sgn) begin
            //reset all output regs
            reg2_out_result <= 0;
            reg2_out_dest <= 0;
            reg2_out_halt_op <= 0;
            reg2_out_jmp_op <= 0;
            reg2_out_jmp_relative_op <= 0;
            reg2_out_jmp_val <= 0;
            reg2_out_read <= 0;
            reg2_out_write_en <= 0;
        end else if(halt_op) begin
            reg2_out_result <= reg2_out_result;
            reg2_out_dest <= reg2_out_dest;
            reg2_out_halt_op <= reg2_out_halt_op;
            reg2_out_jmp_op <= reg2_out_jmp_op;
            reg2_out_jmp_relative_op <= reg2_out_jmp_relative_op;
            reg2_out_jmp_val <= reg2_out_jmp_val;
            reg2_out_read <= reg2_out_read;
            reg2_out_write_en <= reg2_out_write_en;
        end else begin
            reg2_out_result <= result;
            reg2_out_dest <= dest;
            reg2_out_halt_op <= halt_op;
            reg2_out_jmp_op <= jmp_op;
            reg2_out_jmp_relative_op <= jmp_relative_op;
            reg2_out_jmp_val <= jmp_val;
            reg2_out_read <= read;
            reg2_out_write_en <= write_en;
        end
    end
    
endmodule
