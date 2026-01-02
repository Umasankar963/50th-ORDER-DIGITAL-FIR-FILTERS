
//////////////////////////////////////////////////////////////////////////////////
// Name : Uma Sankar Gutta
// Engineer : AMS Design Engineer 
// Create Date : 01.09.2025 09:49:30
// Design Name : 51 tap SHARP Digital Band Pass Filter 
// Module Name: fir_bandpass_51
// Project Name : Digital FIR Filters 
// Target Devices : Artix-7
// Tool Versions : Vivado 2022.2 
// Description : Band Pass Filter
//               Passband: 41kHz-61kHz @ Fs = 1 MHz
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module fir_bandpass_51 #(
    parameter N = 51,                    
    parameter DATA_WIDTH = 16,           
    parameter COEFF_WIDTH = 16          
)(
    input  wire                          clk,
    input  wire                          rst,   
    input  wire signed [DATA_WIDTH-1:0]  x_in,  
    output reg  signed [DATA_WIDTH+COEFF_WIDTH+6:0] y_out  
);

    // Hamming Window - Band Pass Filter coefficients (Q15 scaled)
    reg signed [COEFF_WIDTH-1:0] h [0:N-1];
    
        h[0]  =  16'sd0;     h[1]  = -16'sd2;    h[2]  = -16'sd5;    h[3]  = -16'sd7;
        h[4]  = -16'sd9;     h[5]  = -16'sd8;    h[6]  = -16'sd4;    h[7]  =  16'sd2;
        h[8]  =  16'sd10;    h[9]  =  16'sd19;   h[10] =  16'sd28;   h[11] =  16'sd36;
        h[12] =  16'sd41;    h[13] =  16'sd42;   h[14] =  16'sd39;   h[15] =  16'sd31;
        h[16] =  16'sd18;    h[17] =  16'sd0;    h[18] = -16'sd21;   h[19] = -16'sd44;
        h[20] = -16'sd66;    h[21] = -16'sd83;   h[22] = -16'sd94;   h[23] = -16'sd96;
        h[24] = -16'sd88;    h[25] =  16'sd0;       //  Center Tap
        h[26] =  16'sd88;    h[27] =  16'sd96;   h[28] =  16'sd94;   h[29] =  16'sd83;
        h[30] =  16'sd66;    h[31] =  16'sd44;   h[32] =  16'sd21;   h[33] =  16'sd0;
        h[34] = -16'sd18;    h[35] = -16'sd31;   h[36] = -16'sd39;   h[37] = -16'sd42;
        h[38] = -16'sd41;    h[39] = -16'sd36;   h[40] = -16'sd28;   h[41] = -16'sd19;
        h[42] = -16'sd10;    h[43] = -16'sd2;    h[44] =  16'sd4;    h[45] =  16'sd8;
        h[46] =  16'sd9;     h[47] =  16'sd7;    h[48] =  16'sd5;    h[49] =  16'sd2;
        h[50] =  16'sd0;
end


    // Input sample buffer
    reg signed [DATA_WIDTH-1:0] x_buffer [0:N-1];
    
    // Multi-stage accumulator for better precision
    reg signed [DATA_WIDTH+COEFF_WIDTH+7:0] accumulator;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Clear all memory
            for (i = 0; i < N; i = i + 1) begin
                x_buffer[i] <= 16'sd0;
            end
            accumulator <= 0;
            y_out <= 0;
        end else begin
            // Shift register operation
            for (i = N-1; i > 0; i = i - 1) begin
                x_buffer[i] <= x_buffer[i-1];
            end
            x_buffer[0] <= x_in;
            
            // FIR convolution with high precision
            accumulator = 0;
            for (i = 0; i < N; i = i + 1) begin
                accumulator = accumulator + (h[i] * x_buffer[i]);
            end
            
            // Careful scaling to maintain signal while maximizing precision
            y_out <= accumulator >>> 16;  // Shift by 16 instead of 15 for better scaling
        end
    end

endmodule
