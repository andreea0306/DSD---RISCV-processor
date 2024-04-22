`timescale 1ns / 1ps

module register#(parameter D_BITS = 32)(
                 input clk,
                 input nrst,
                 input [2:0] src_op0,
                 input [2:0] src_op1,
                 input we,
                 input [2:0] addr_w,
                 input [D_BITS - 1 : 0] data,
                 output [D_BITS - 1 : 0] data_op0,
                 output [D_BITS - 1 : 0] data_op1
    );
    
    reg [D_BITS - 1 : 0] memory_reg[0:7];
   
    always@(posedge clk) begin
        if(!nrst) begin
            memory_reg[0] <= 8'd0;
            memory_reg[1] <= 8'd0;
            memory_reg[2] <= 8'd0;
            memory_reg[3] <= 8'd0;
            memory_reg[4] <= 8'd0;
            memory_reg[5] <= 8'd0;
            memory_reg[6] <= 8'd0;
            memory_reg[7] <= 8'd0;
        end else if(we) begin // if it is a writte op in regs
            memory_reg[addr_w] <= data;
        end
    end 
    assign data_op0 = memory_reg[src_op0];
    assign data_op1 = memory_reg[src_op1];        
endmodule
