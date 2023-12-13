`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 10:53:13 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;
    
    // Input signals
    reg clk;
    
    // Output signals
    wire [2:0] als;
    reg sw0, sw1, sw2;
    wire [7:0] lcd;
    wire en, rs, led_en;
    wire audio_out, audio_gain, audio_off;
    
    assign als = 4;
    
    main main (clk, als1, sw0, sw1, sw2, lcd, en, rs, led_en, audio_out, audio_gain, audio_off);
    
    // Input signals logic
    initial
    begin
        clk = 0;
        sw0 = 1;
        
        forever #5000 clk = ~clk;

    end
endmodule
