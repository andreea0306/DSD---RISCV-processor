`define D_BITS 32
`define A_BITS 10
`define MEMSIZE 1024
// define macros for registers
`define R0 3'd0
`define R1 3'd1
`define R2 3'd2
`define R3 3'd3
`define R4 3'd4
`define R5 3'd5
`define R6 3'd6
`define R7 3'd7

// define macros for opcode
// aritmetic operations - prefix 00
`define ADD      7'b00_00001
`define ADDF     7'b00_00010
`define SUB      7'b00_00011
`define SUBF     7'b00_00100
`define AND      7'b00_00101
`define OR       7'b00_00110
`define XOR      7'b00_00111
`define NAND     7'b00_01000
`define NOR      7'b00_01001
`define NXOR     7'b00_01010
`define SHIFTR   7'b00_01011
`define SHIFTRA  7'b00_01100
`define SHIFTL   7'b00_01101

// memory access - prefix 01
`define LOAD     5'b01_001
`define LOADC    5'b01_010
`define STORE    5'b01_011

// jump ops - prefix 10
`define JMP      4'b10_00
`define JMPR     4'b10_01
`define JMPCOND  4'b10_10
`define JMPRCOND 4'b10_11

// special ops
`define NOP     16'b00_0000_0000000000
`define HALT 16'b1111_111111111111

// define COND 
`define N 3'b000
`define NN 3'b001
`define Z 3'b010
`define NZ 3'b011