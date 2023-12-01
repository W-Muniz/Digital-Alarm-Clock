`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 10:41:47 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk,
    input rst,
    output reg clk_div
    );
    
    // Parameter for base frequency
    parameter FREQ = 50000000; 
    
    // Counter variable
    reg [25:0] count;
    
    // Clock divider logic
    always @ (posedge clk or posedge rst) 
    begin
        if (rst)
        begin
            count <= 0;
            clk_div <= 0;
        end
        else
        begin
            count <= count + 1;
            if (count == FREQ - 1)
            begin
                count <= 0;
                clk_div <= ~clk_div;
            end
        end
    end
endmodule
