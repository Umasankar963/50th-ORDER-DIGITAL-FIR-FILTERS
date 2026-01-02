
I have designed the Digital FIR filters of 50th order   i.e.,  using 51 taps.

Specification :
    Input : Muti-tone frequency signal (20 cycles of each below mentioned frequencies)
                  20 KHz, 40 KHz, 50 KHz, 60 KHz, 80 KHz, 100 KHz. 
    for LPF and HPF :
      Fc = 50 KHz
    for BPF and BSF :
      F1 = 41 KHZ
      F0 = 50 KHz   (Center frequency / Resonant frequency)
      F2 = 61 MHZ
    Window : Hamming Window
    Fs = 1 MHz
    

In basic version codes of Filters, I have verified the functionality of all four filter (LPF, HPF, BPF, BSF), using Behavioral Simulation.

In the other version of code  i.e.,  I have used some other files like rom_interface, top module, constraints file to verify the same behaviour of filter in Arty A7 FPGA board.
It is because the board directly cant read input samples, so we use a ROM interface to achieve it.
