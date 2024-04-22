`timescale 1ns / 1ps
`include "defines.vh"

module execute_unit #(parameter D_BITS = 32,
                      parameter A_BITS = 10) (
            input [D_BITS-1:0]          op0_data,
            input [D_BITS-1:0]          op1_data,
            input [6:0]                 opcode,
            output reg                  halt_op,
            output reg                  jmp_op,
            output reg                  jmp_relative_op,
            output     [A_BITS-1:0]     jmp_val,
            output reg                  read,
            output reg                  write,
            output reg                  write_en,
            output reg    [D_BITS-1:0]     data_out,
            output reg    [A_BITS-1:0]     address,
            output reg [D_BITS-1:0]     result
);

always@(*) begin
// clear signals everytime
 halt_op = 0;
 jmp_op = 0;
 jmp_relative_op = 0;
 read = 0;
 write = 0;
 result = 0;
 
 case(opcode[6:5])
    2'b00: begin
        case(opcode) 
            `ADD: begin
                result = op0_data + op1_data;
                write_en = 1'b1;
            end
            `ADDF: begin
                result = op0_data + op1_data;
                write_en = 1'b1;
            end 
            `SUB: begin
                result = op0_data - op1_data;
                write_en = 1'b1;
            end
            `SUBF: begin
                result = op0_data - op1_data;
                write_en = 1'b1;
            end
            `AND: begin
                result = op0_data & op1_data;
                write_en = 1'b1;
            end
            `OR: begin
                result = op0_data | op1_data;
                write_en = 1'b1;
            end
            `XOR: begin
                result = op0_data ^ op1_data;
                write_en = 1'b1;
            end
            `NAND: begin
                result = ~(op0_data & op1_data);
                write_en = 1'b1;
            end
            `NOR: begin
                result = ~(op0_data | op1_data);
                write_en = 1'b1;
            end
            `NXOR: begin
                result = ~(op0_data ^ op1_data);
                write_en = 1'b1;
            end
            `SHIFTR: begin
                result = op0_data >> op1_data;
                write_en = 1'b1;
            end
            `SHIFTRA: begin
                result = $signed(op0_data) >>> $signed(op1_data);
                write_en = 1'b1;
            end
            `SHIFTL: begin
                result = op0_data << op1_data;
                write_en = 1'b1;
            end
        endcase
    end
    2'b01: begin
        case(opcode[6:2])
            `LOAD: begin
                address = op0_data[A_BITS-1:0];
                read = 1'b1;
                write = 1'b0;
            end
            `LOADC: begin
                result = {op0_data[D_BITS-1:8],op1_data[7:0]};
                read = 1'b0;
                write = 1'b0;
                write_en = 1'b1;
            end
            `STORE: begin
                address = op1_data[A_BITS-1:0];
                read = 1'b0;
                write = 1'b1;
                data_out = op0_data;
            end
        endcase
    end
    2'b10: begin
        case(opcode[6:3])
            `JMP: begin
                jmp_op = 1'b1;
            end
            `JMPR: begin
                jmp_op = 1'b1;
                jmp_relative_op = 1'b1;
            end
            `JMPCOND: begin
                case(opcode[2:0])
                    `N: begin
                        jmp_op = (op0_data == 0) ? 1'b1 : 1'b0;
                    end
                    `NN: begin
                        jmp_op = (op0_data != 0) ? 1'b1 : 1'b0;
                    end
                    `Z: begin
                        jmp_op = (op0_data < 0) ? 1'b1 : 1'b0;
                    end
                    `NZ: begin
                        jmp_op = (op0_data > 0) ? 1'b1 : 1'b0;
                    end
                endcase
            end
            `JMPRCOND: begin
                case(opcode[2:0])
                    `N: begin
                        jmp_op = (op0_data == 0) ? 1'b1 : 1'b0;
                        jmp_relative_op = (op0_data == 0) ? 1'b1 : 1'b0;
                    end
                    `NN: begin
                        jmp_op = (op0_data != 0) ? 1'b1 : 1'b0;
                        jmp_relative_op = (op0_data != 0) ? 1'b1 : 1'b0;
                    end
                    `Z: begin
                        jmp_op = (op0_data < 0) ? 1'b1 : 1'b0;
                        jmp_relative_op = (op0_data < 0) ? 1'b1 : 1'b0;
                    end
                    `NZ: begin
                        jmp_op = (op0_data > 0) ? 1'b1 : 1'b0;
                        jmp_relative_op = (op0_data > 0) ? 1'b1 : 1'b0;
                    end
                endcase
            end
        endcase
    end
    2'b11: begin // halt
       halt_op = 1'b1;
    end
 endcase
 
end

//assign data_out = op0_data;
assign jmp_val = op1_data;

endmodule