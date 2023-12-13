`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 11:29:59 PM
// Design Name: 
// Module Name: bcd_counter
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


module bcd_counter(
    input clk,
    input rst,
    output reg [0:3] bcd_out,
    output reg carry
    );
    
    // Parameter for count limit
    parameter MAX = 9;
    
    // Counter variable
    reg [3:0] count;
    
    // BCD counter logic
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            count <= 0;
            bcd_out <= 0;
            carry <= 0;
        end
        else if (clk)
        begin
            if (count == MAX)
            begin
                count <= 0;
                bcd_out <= 0;
                carry <= 1;
            end
            else
            begin
                count = count + 1;
                bcd_out <= count;
                carry <= 0;
            end
        end
    end
endmodule