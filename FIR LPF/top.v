

`timescale 1ns / 1ps

module top (
    input wire clk_i,
    input wire rst_i
);
    parameter num_samples = 5500;
    
    wire signed [15:0] x_in_t;
    wire signed [38:0] y_out_t;
    wire clk_out1;
    wire clk_out2;
    wire valid_o_t;
    wire valid_input_o_t;
    
clk_wiz_0 instance_ila_clk
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1 100Mhz
    .clk_out2(clk_out2),     // output clk_out2 50Mhz
   // Clock in ports
    .clk_in1(clk_i)
   );

	
    // ROM interface module supplies x_in
    rom_interface rom_inst (
        .clk(clk_out2),
        .rst(rst_i),
        .x_out(x_in_t),
        .valid_input_o(valid_input_o_t)
    );

	
    // FIR filter with 51 taps
    fir_highpass_51 fir_inst (
        .clk(clk_out2),
        .rst(rst_i),
        .x_in(x_in_t),
        .y_out(y_out_t),
        .valid_o(valid_o_t)
    );
    
    
ila_0 instance_lpf (
	.clk(clk_out1), // input wire clk
	.probe0(rst_i), // input wire [0:0]  probe0  
	.probe1(x_in_t), // input wire [15:0]  probe1 
	.probe2(y_out_t), // input wire [38:0]  probe2
	.probe3(valid_o_t), // input wire [0:0]  probe3 
	.probe4(valid_input_o_t) // input wire [0:0]  probe4
);


endmodule

