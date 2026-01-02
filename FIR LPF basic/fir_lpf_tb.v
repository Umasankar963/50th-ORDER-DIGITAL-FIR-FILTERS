
//////////////////////////////////////////////////////////////////////////////////
// Name : Uma Sankar Gutta
// Engineer : AMS Design Engineer 
// 
// Create Date : 01.09.2025 09:49:30
// Design Name : 51 tap Digital Low Pass Filter 
// Module Name: tb_fir_lowpass_51
// Project Name : Digital FIR Filters 
// Target Devices : Artix-7
// Tool Versions : Vivado 2022.2 
// Description : Testbench to read 5500 input samples from "sine_wave_data.mem" 
//               and apply them to FIR Low Pass Filter
//////////////////////////////////////////////////////////////////////////////////




//module fir_lowpass_51_tb;

//    // Parameters
//    localparam CLK_PER   = 1000;        // 1 MHz clock => 1000 ns period
//    localparam Fs        = 1_000_000;   // sample frequency
//    localparam N_SAMPLES = 5500;        // total simulation samples

//    // DUT ports
//    reg  clk;
//    reg  rst;
//    reg  signed [15:0] x_in;
//    wire signed [38:0] y_out;  // DATA_WIDTH + COEFF_WIDTH + 6:0 = 39 bits

//    integer n;
//    real t;

//    // Instantiate DUT
//    fir_lowpass_51 dut (
//        .clk(clk),
//        .rst(rst),
//        .x_in(x_in),
//        .y_out(y_out)
//    );

//    // Clock generation (1 MHz)
//    always #(CLK_PER/2) clk = ~clk;

//    // Stimulus
//    initial begin
//        clk = 0;
//        rst = 1;
//        x_in = 0;
//        #(5*CLK_PER);   // hold reset for 5 cycles
//        rst = 0;

//        // Apply input: 20 cycles each of 20k, 40k, 50K, 60k, 80k, 100k
//        for (n = 0; n < N_SAMPLES; n = n + 1) begin
//            t = n * (1.0/Fs); // time in seconds

//      if (n < 1000) begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*20000*t) ); // 20kHz
//      end else if (n < 1500) begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*40000*t) ); // 40kHz
//      end else if (n < 1900) begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*50000*t) ); // 50kHz
//      end else if (n < 2233) begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*60000*t) ); // 60kHz
//      end else if (n < 2483) begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*80000*t) ); // 80kHz
//      end else begin
//          x_in = $rtoi( 10000 * $sin(2*3.14159*100000*t) ); // 100kHz
//      end

//            @(posedge clk);
//        end

//        #(20*CLK_PER);
//        $stop;
//    end

//endmodule



`timescale 1ns / 1ps

module tb_fir_lowpass_51;

    reg clk;
    reg rst;
    reg signed [15:0] x_in;
    wire signed [37:0] y_out;

    // Instantiate DUT
    fir_lowpass_51 uut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    // Memory for input samples
    parameter NUM_SAMPLES = 5500;
    reg signed [15:0] sample_mem [0:NUM_SAMPLES-1];
    integer i;

    initial begin
        clk = 0;
        rst = 1;
        x_in = 0;

        // Load 5500 samples from file (HEX format)
        $readmemh("sine_wave_data.mem", sample_mem);

        #50 rst = 0;  // Release reset

        // Apply exactly 5500 samples
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            @(posedge clk);
            x_in = sample_mem[i];
        end

        $stop;
    end

    // Monitor input and output
    initial begin
        $monitor("Time=%0t ns, x_in=%d, y_out=%d", $time, x_in, y_out);
    end     

endmodule

