
////////////////////////////////////////////////////////////////////////////////////////////////
// Name : Uma Sankar Gutta
// Engineer : AMS Design Engineer 
// 
// Create Date : 14.09.2025 17:30:00
// Design Name : 51 tap Digital Band Stop Filter 
// Project Name : Digital FIR Filters 
// Target Devices : Artix-7
// Tool Versions : Vivado 2022.2 
// Description : Band Stop Filter
//               Input: 20kHz (PASS) | 40kHz, 50kHz, 60kHz (ELIMINATE) | 80kHz, 100kHz (PASS)
////////////////////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module fir_highpass_51 #(
    parameter N = 51,                    
    parameter DATA_WIDTH = 16,           
    parameter COEFF_WIDTH = 16          
)(
    input  wire                          clk,
    input  wire                          rst,   
    input  wire signed [DATA_WIDTH-1:0]  x_in,  
    output reg  signed [DATA_WIDTH+COEFF_WIDTH+6:0] y_out,  
    output reg valid_o
);

    // Coefficients for MAXIMUM stopband attenuation

    reg signed [COEFF_WIDTH-1:0] h [0:N-1];
    

initial begin
        h[0]  = -16'sd47;    h[1]  = -16'sd40;    h[2]  = -16'sd28;    h[3]  = -16'sd14;
        h[4]  =  -16'sd1;    h[5]  =   16'sd0;    h[6]  = -16'sd22;    h[7]  = -16'sd77;
        h[8]  = -16'sd162;   h[9]  = -16'sd255;   h[10] = -16'sd316;   h[11] = -16'sd293;
        h[12] = -16'sd137;   h[13] =  16'sd176;   h[14] =  16'sd628;   h[15] =  16'sd1151;
        h[16] =  16'sd1631;  h[17] =  16'sd1934;  h[18] =  16'sd1938;  h[19] =  16'sd1569;
        h[20] =   16'sd831;  h[21] = -16'sd181;   h[22] = -16'sd1300;  h[23] = -16'sd2314;
        h[24] = -16'sd3022;  h[25] =  16'sd29476;       // Center Tap
        h[26] = -16'sd3022;  h[27] = -16'sd2314;  h[28] = -16'sd1300;  h[29] = -16'sd181;
        h[30] =   16'sd831;  h[31] =  16'sd1569;  h[32] =  16'sd1938;  h[33] =  16'sd1934;
        h[34] =  16'sd1631;  h[35] =  16'sd1151;  h[36] =   16'sd628;  h[37] =   16'sd176;
        h[38] = -16'sd137;   h[39] = -16'sd293;   h[40] = -16'sd316;   h[41] = -16'sd255;
        h[42] = -16'sd162;   h[43] =  -16'sd77;   h[44] =  -16'sd22;   h[45] =   16'sd0;
        h[46] =   -16'sd1;   h[47] =  -16'sd14;   h[48] =  -16'sd28;   h[49] =  -16'sd40;
        h[50] =  -16'sd47;
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
            valid_o<=0;
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
            
            valid_o<=1;
            // Careful scaling to maintain signal while maximizing precision
            y_out <= accumulator >>> 15;  // Shift by 15 for scaling
        end
    end

endmodule
