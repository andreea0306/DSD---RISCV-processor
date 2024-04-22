`timescale 1ns / 1ps
`include "defines.vh"

module read_unit #(parameter D_BITS = 32)(
               input [15:0] instr_in,
               input [D_BITS-1:0] op0,
               input [D_BITS-1:0] op1,
               
               output reg [2:0] src0,
               output reg [2:0] src1,
               output reg [6:0] opcode, // send opcode 
               output reg [2:0] dest,
               output reg [D_BITS-1:0] out_op0,
               output reg [D_BITS-1:0] out_op1
);

// decode
always@(*) begin
    opcode = instr_in[15:9]; 
    src0 = 0;
    src1 = 0;
    dest = 0;
    out_op0 = 0;
    out_op1 = 0; 
    case(opcode[6:5]) 
       2'b00: begin
            case(opcode)
            // all arithmetic ops have the same tamplate for instr
                `ADD, `ADDF, `SUB, `SUBF, `AND, `OR, `XOR, `NAND, `NOR, `NXOR: 
                begin
                    dest = instr_in[8:6];
                    src0 = instr_in[5:3];
                    src1 = instr_in[2:0];
                    out_op0 = op0;
                    out_op1 = op1;
                end
                `SHIFTR, `SHIFTRA, `SHIFTL: 
                begin
                    dest = instr_in[8:6];
                    src0 = instr_in[8:6]; // has the same dest with src
                    
                    out_op0 = op0; // the value to be shifted
                    out_op1 = instr_in[5:0]; // the value of shifting is the second operand
                end    
            endcase
        end 
       2'b01: begin
        case(opcode[6:2])
            `LOAD: begin 
                dest = instr_in[10:8];
                src1 = instr_in[2:0];
                out_op0 = op0; // address 
            end
            `LOADC: begin
                dest = instr_in[10:8];
                src0 = instr_in[10:8];
                out_op0 = op0; // from regs -> regs[src0]
                out_op1 = instr_in[7:0]; // const value                
            end
            `STORE: begin
                  src0 = instr_in[10:8];
                  src1 = instr_in[2:0];
                  
                  out_op0 = op0; // data
                  out_op1 = op1; // the address 
            end
        endcase
       end
       2'b10: begin
        case(opcode[6:3])
            `JMP: begin
                src1 = instr_in[2:0];
                out_op1 = op1;
            end
            `JMPR: begin
                out_op1 = $signed(instr_in[5:0]);
            end
            `JMPCOND: begin
                src0 = instr_in[8:6];
                src1 = instr_in[2:0];
                out_op0 = op0;
                out_op1 = op1;
            end
            `JMPRCOND: begin
                src0 = instr_in[8:6];
                out_op0 = op0;
                out_op1 = instr_in[5:0];
            end
        endcase
       end
    
    endcase

end

endmodule 