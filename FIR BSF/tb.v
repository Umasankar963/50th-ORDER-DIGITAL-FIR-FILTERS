
`timescale 1ns / 1ps

module tb;

reg clk, rst;

top dut_top (clk,rst);

initial begin
 clk=0;
 forever #5 clk=~clk;
end

initial begin
    rst=1;
    #12;
    rst=0;
end

endmodule
