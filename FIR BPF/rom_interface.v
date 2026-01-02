`timescale 1ns / 1ps
module rom_interface  #(          
    parameter NUM_SAMPLES = 5500          
)(
    input wire clk,
    input wire rst,
    output reg signed [15:0] x_out,
    output reg valid_input_o
);
    reg [15:0] rom [0:11416-1];
    reg [13:0] addr; // Address index (enough for 2500 samples)
    //reg signed [15:0] xx_out;
    // Initialize ROM from external file (synthesizable for Vivado)
    initial begin
        $readmemh("input_samples.mem", rom);
    end

    always @(posedge clk) begin
        if (rst) begin
            addr <= 0;
            x_out <= 0;
            valid_input_o <= 0;
        end else begin
            x_out <= rom[addr];
            if (addr < NUM_SAMPLES-1) begin
                addr <= addr + 1;
                valid_input_o <= 1'b1;
            end
            else valid_input_o <= 0;
            if(addr==NUM_SAMPLES-1)addr<=0;   
        end
    end
endmodule
