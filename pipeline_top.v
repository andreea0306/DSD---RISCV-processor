`timescale 1ns / 1ps

module pipeline_top #(
                        parameter D_BITS = 32,
                        parameter A_BITS = 10
                      )(
               input                clk,
               input                nrst,
               input [15:0]         instruction,
               input [D_BITS-1:0]   data_in,
               output [A_BITS-1:0]  pc,
               output               read,
               output               write,
               output [A_BITS-1:0]  address,
               output [D_BITS-1:0]  data_out
);
// fetch wires
wire                    halt_op;
wire                    clr_sgn;
wire                    jmp_op;
wire                    jmp_relative_op;
wire [A_BITS-1 : 0]     jmp_val;
wire [15:0]             instr_out;

// read wires
wire [6:0]              opcode;
wire [2:0]              dest;
wire [D_BITS-1:0]       op0;
wire [D_BITS-1:0]       op1;
wire [2:0]              src0;
wire [2:0]              src1;
wire [D_BITS-1:0]       read_out_op0;
wire [D_BITS-1:0]       read_out_op1;

// REGS wires
wire                    we;
wire [D_BITS-1:0]       writeback_out_result;
wire [2:0]              addr_w;
//
wire [6:0]              reg1_out_opcode;
wire [2:0]              reg1_out_dest;
wire [D_BITS-1:0]       reg1_out_op0;
wire [D_BITS-1:0]       reg1_out_op1;

// execute wires

wire write_en;
wire [D_BITS-1:0] result;

//register 2 wires
wire [2:0] reg2_out_dest;
wire reg2_out_halt_op;
wire reg2_out_clr_sgn;
wire reg2_out_jmp_op;
wire reg2_out_jmp_relative_op;
wire [A_BITS-1:0] reg2_out_jmp_val;
wire [D_BITS-1:0] reg2_out_result;

fetch_unit #(.A_BITS(A_BITS) ) fetch_unit (
    .clk(clk),
    .nrst(nrst),
    .halt_op(reg2_out_halt_op),
    .clr_sgn(reg2_out_clr_sgn),
    .jmp_op(reg2_out_jmp_op),
    .jmp_relative_op(reg2_out_jmp_relative_op),
    .jmp_val(reg2_out_jmp_val),
    .instr_in(instruction),
    .instr_out(instr_out),
    .PC(pc)
);
read_unit #(.D_BITS(D_BITS)) read_unit (
    .instr_in(instr_out),
    .op0(op0),
    .op1(op1),
    .src0(src0),
    .src1(src1),
    .opcode(opcode),
    .dest(dest),
    .out_op0(read_out_op0),
    .out_op1(read_out_op1)
);

register #(.D_BITS(D_BITS)) REGS (
    .clk(clk),
    .nrst(nrst),
    .src_op0(src0),
    .src_op1(src1),
    .we(reg2_out_write_en), // wwriten_en from r2
    .addr_w(reg2_out_dest), // dest from r2
    .data(writeback_out_result), // data from write back
    .data_op0(op0),
    .data_op1(op1)
);

register1 #(.D_BITS(D_BITS)) register1_pipeline (
    .clk(clk),
    .nrst(nrst),
    .halt_op(reg2_out_halt_op),
    .clr_sgn(reg2_out_clr_sgn),
    .opcode(opcode),
    .dest(dest),
    .op0(read_out_op0),
    .op1(read_out_op1),
    .reg1_out_opcode(reg1_out_opcode),
    .reg1_out_dest(reg1_out_dest),
    .reg1_out_op0(reg1_out_op0),
    .reg1_out_op1(reg1_out_op1)
);

execute_unit #(.D_BITS(D_BITS),
               .A_BITS(A_BITS)) execute_unit (
               
                .op0_data(reg1_out_op0),
                .op1_data(reg1_out_op1),
                .opcode(reg1_out_opcode),
                .halt_op(halt_op),
                .jmp_op(jmp_op),
                .jmp_relative_op(jmp_relative_op),
                .jmp_val(jmp_val),
                .read(read), // to sram
                .write(write), // to sram
                .write_en(write_en),
                .data_out(data_out), // to sram
                .address(address), // to sram
                .result(result)
               
               );
               
register2 #(.D_BITS(D_BITS),
            .A_BITS(A_BITS)) register2_pipeline (
            
            .clk(clk),
            .nrst(nrst),
            .halt_op(halt_op),
            .jmp_op(jmp_op),
            .jmp_relative_op(jmp_relative_op),
            .jmp_val(jmp_val),
            .clr_sgn(reg2_out_clr_sgn),
            .read(read),
            .write(write),
            .dest(reg1_out_dest),
            .result(result),
            .write_en(write_en),
            .reg2_out_result(reg2_out_result),
            .reg2_out_dest(reg2_out_dest),
            .reg2_out_halt_op(reg2_out_halt_op),
            .reg2_out_jmp_op(reg2_out_jmp_op),
            .reg2_out_jmp_relative_op(reg2_out_jmp_relative_op),
            .reg2_out_jmp_val(reg2_out_jmp_val),
            .reg2_out_read(reg2_out_read),
            .reg2_out_write_en(reg2_out_write_en)
            );
            
write_back_unit #(.D_BITS(D_BITS)) write_back_unit (
            .data_in(data_in),
            .read(reg2_out_read),
            .write_en(reg2_out_write_en),
            .result(reg2_out_result),
            .jmp_op(reg2_out_jmp_op),
            .clr_sgn(reg2_out_clr_sgn),
            .writeback_out_result(writeback_out_result) 
);

endmodule
