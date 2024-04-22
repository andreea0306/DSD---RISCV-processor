`timescale 1ns / 1ps

module rom #(parameter A_BITS = 10)(
        input [A_BITS-1:0] pc,
        output [15:0] instr
    );
    
    reg [15:0] mem[0:1023];
    
    assign instr = mem[pc];
    
endmodule
