`timescale 1ns / 1ps

module pwm(
    input clk,
    input [7:0] lightLevel,
    input eot,
    output pwm
    );
    
    reg [2:0] counter;
    reg [2:0] duty_cycle;
    
    // Duty cycle logic
    always @ (posedge eot) begin
        if (lightLevel < 8'b1000) begin
            duty_cycle <= lightLevel[2:0];
        end
        else
            duty_cycle <= 3'b111;
    end
    
    // Counter logic
    always @ (posedge clk) begin
        counter <= counter + 1; // increment counter
    end
    
    // PWM output
    assign pwm = (counter < duty_cycle) ? 1 : 0; // compare counter with duty cycle
    
endmodule
