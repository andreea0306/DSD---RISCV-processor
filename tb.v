`timescale 1ns / 1ps
`include "defines.vh"

module tb();

    reg nrst;
    reg clk;
    reg [9:0] pc;
    
     wire [`A_BITS-1:0] pc;
//    reg [15:0] instr;
//    wire read;
//    wire write;
//    wire [`A_BITS-1:0] address;
//    wire [`D_BITS-1:0] sram_data_in;
//    wire [`D_BITS-1:0] sram_data_out;
    
//    reg [15:0] prog_mem[0:64];
    
//    pipeline_top #(.A_BITS(`A_BITS), .D_BITS(`D_BITS)) pipeline_top(
//        .clk(clk),
//        .nrst(nrst),
//        .instruction(instr),
//        .data_in(sram_data_out),
//        .pc(pc),
//        .read(read),
//        .write(write),
//        .address(address),
//        .data_out(sram_data_in)
//    );    
//    sram #(.A_BITS(`A_BITS), .D_BITS(`D_BITS), .MEMSIZE(1023)) SRAM (
//        .clk(clk),
//        .nrst(nrst),
//        .address(address),
//        .data_in(sram_data_in),
//        .read_en(read),
//        .write_en(write),
//        .data_out(sram_data_out)
//    );
    top DUT (
        .clk(clk),
        .nrst(nrst)
    );
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        nrst = 1'b0;
        @(posedge clk);
        #1;
        nrst = ~nrst;
//        DUT.pipeline_top.REGS.memory_reg[0] = 'd5;
        repeat(900) @(posedge clk);
        $stop();
        
    end
    
    initial begin
        
        pc = 0;
        
        DUT.ROM.mem[pc] = {`NOP};
        pc = pc + 1;
////        DUT.ROM.mem[pc] = {`SUB, `R1, `R0, `R3};
////        pc = pc + 1;
////        DUT.ROM.mem[pc] = {`ADD, `R1, `R0, `R3};
////        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`LOADC, `R1, 8'd7};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`NOP};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`NOP};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`STORE, `R0, 5'b0, `R1};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`NOP};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`NOP};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`LOAD, `R0, 5'b0, `R0};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`JMP, 9'b0, `R2};
//        pc = pc + 1;
//        DUT.ROM.mem[pc] = {`JMPR, 6'b0, 6'b110111};
//        pc = pc + 1;
        DUT.ROM.mem[pc] = {`LOADC, `R1, 8'd7}; // num1 - to be multiplied
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`LOADC, `R2, 8'd7}; // num2 - numberrs of multiplies - index
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`LOADC, `R3, 8'd0};  // CLEARED RESULT
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`LOADC, `R7, 8'd1}; // used for decrementing
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`LOADC, `R4, 8'd5}; // pointer to the start of multiply loop
        pc = pc + 1;
        // multiply loop
        DUT.ROM.mem[pc] = {`ADD, `R3, `R3, `R1};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`NOP};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`NOP};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`SUB, `R2, `R2, `R7};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`NOP};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`NOP};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`JMPCOND, `NZ, `R2, 3'b000, `R4};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`STORE, `R6, 5'b0, `R3};
        pc = pc + 1;
        DUT.ROM.mem[pc] = {`HALT};
        pc = pc + 1;
        
    end
    
//    integer i;
//    initial begin
//       @(posedge nrst);
//       //DUT.ROM.mem[pc] = {`ADD, `R1, `R0, `R3};
//       pipeline_top.REGS.memory_reg[0] = 'd5;
//       pipeline_top.REGS.memory_reg[3] = 'd5;
//       prog_mem[0] = {`ADD, `R1, `R0, `R3};
//       prog_mem[1] = {`NOP};
//       prog_mem[2] = {`NOP};
//       prog_mem[5] = {`SUB, `R3, `R0, `R1};
//       prog_mem[1] = {`NOP};
//       prog_mem[2] = {`NOP};
       
//       for(i=0;i<10;i=i+1) begin
//        instr = prog_mem[i];
//        pc = pc+1;
//       end 
//    end

//    initial begin
//        @(posedge nrst);
//        if(instr != `HALT) 
//            @(pc);
//    end
endmodule
