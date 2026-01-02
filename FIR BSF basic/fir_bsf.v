
//////////////////////////////////////////////////////////////////////////////////
// Name : Uma Sankar Gutta
// Engineer : AMS Design Engineer 
// 
// Create Date : 18.09.2025
// Design Name : 51 tap Digital Band Stop Filter 
// Module Name: fir_bandstop_51
// Project Name : Digital FIR Filters 
// Target Devices : Artix-7
// Tool Versions : Vivado 2022.2 
// Description : Band Stop Filter
//               Stopband : 41 KHz to 61 KHz,   F0=50 KHz,   Fs = 1 MHz
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps


module fir_bandstop_51 #(
    parameter N = 51,                    
    parameter DATA_WIDTH = 16,           
    parameter COEFF_WIDTH = 16          
)(
    input  wire                          clk,
    input  wire                          rst,   
    input  wire signed [DATA_WIDTH-1:0]  x_in,  
    output reg  signed [DATA_WIDTH+COEFF_WIDTH+6:0] y_out  
);
    // Kaiser window bandstop coefficients (Q15 scaled, ?=12)
    reg signed [COEFF_WIDTH-1:0] h [0:N-1];
    
// 51-tap FIR Bandstop (41-61 kHz) Q15

initial begin
        h[0]  = -16'sd47;    h[1]  = -16'sd40;    h[2]  = -16'sd28;    h[3]  = -16'sd14;
        h[4]  =  -16'sd1;    h[5]  =   16'sd0;    h[6]  = -16'sd22;    h[7]  = -16'sd77;
        h[8]  = -16'sd162;   h[9]  = -16'sd255;   h[10] = -16'sd316;   h[11] = -16'sd293;
        h[12] = -16'sd137;   h[13] =  16'sd176;   h[14] =  16'sd628;   h[15] =  16'sd1151;
        h[16] =  16'sd1631;  h[17] =  16'sd1934;  h[18] =  16'sd1938;  h[19] =  16'sd1569;
        h[20] =   16'sd831;  h[21] = -16'sd181;   h[22] = -16'sd1300;  h[23] = -16'sd2314;
        h[24] = -16'sd3022;  h[25] =  16'sd29476;     //  Center Tap
        h[26] = -16'sd3022;  h[27] = -16'sd2314;  h[28] = -16'sd1300;  h[29] = -16'sd181;
        h[30] =   16'sd831;  h[31] =  16'sd1569;  h[32] =  16'sd1938;  h[33] =  16'sd1934;
        h[34] =  16'sd1631;  h[35] =  16'sd1151;  h[36] =   16'sd628;  h[37] =   16'sd176;
        h[38] = -16'sd137;   h[39] = -16'sd293;   h[40] = -16'sd316;   h[41] = -16'sd255;
        h[42] = -16'sd162;   h[43] =  -16'sd77;   h[44] =  -16'sd22;   h[45] =   16'sd0;
        h[46] =   -16'sd1;   h[47] =  -16'sd14;   h[48] =  -16'sd28;   h[49] =  -16'sd40;
        h[50] =  -16'sd47;
end

    reg signed [DATA_WIDTH-1:0] x_buffer [0:N-1];
    reg signed [DATA_WIDTH+COEFF_WIDTH+7:0] accumulator;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) x_buffer[i] <= 16'sd0;
            accumulator <= 0;
            y_out <= 0;
        end else begin
            // shift register for input samples
            for (i = N-1; i > 0; i = i - 1) 
                x_buffer[i] <= x_buffer[i-1];
            x_buffer[0] <= x_in;
            // multiply-accumulate
            accumulator = 0;
            for (i = 0; i < N; i = i + 1) 
                accumulator = accumulator + (h[i] * x_buffer[i]);
            // scale back Q15
            y_out <= accumulator >>> 15;
        end
    end
endmodule

