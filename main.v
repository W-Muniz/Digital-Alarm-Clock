`timescale 1ns / 1ps

module main(
    input clk,
    inout [2:0] als,
    input sw0, sw1, sw2,
    output [7:0] lcd,
    output en, rs, led_en,
    output audio_out, audio_gain, audio_off
    );
    
    wire rst;
    wire eot;
    wire [7:0] lightLevel;
    wire div0, clk_div, clk_disp;
    wire c1, c2, c3;
    wire [3:0] bcd1, bcd2, bcd3, bcd4;
    reg time0 = {4'h0, 4'h0, 4'h0, 4'h1};
    wire alarm0;
    
    als_interface als_spi (clk, als[1], als[2], als[0], lightLevel, eot);
    pwm pwm (clk, lightLevel, eot, led_en);
    
    assign rst = (bcd4 == 4'b0010 && bcd3 == 4'b0100) ? 1'b1 : 1'b0;
    clock_divider #(.FREQ(50000)) disp (clk, 0, clk_disp);
    clock_divider oneSec (clk, rst, div0);
    clock_divider #(.FREQ(30)) oneMin (div0, rst, clk_div);
    
    bcd_counter #(.MAX(9)) m0 (clk_div, rst, bcd1, c1);
    bcd_counter #(.MAX(5)) m1 (c1, rst, bcd2, c2);
    bcd_counter #(.MAX(9)) h0 (c2, rst, bcd3, c3);
    bcd_counter #(.MAX(2)) h1 (c3, rst, bcd4);
    
    assign alarm0 = (sw0 & time0 == {bcd4, bcd3, bcd2, bcd1});
    
    // States defined as parameters
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // State registers
    reg [2:0] state, next_state, previous_state;

    // State transition logic
    always @(clk) begin
    case (state)
        S0: begin
        end
        S1: begin
        end
        S2: begin
        end
        S3: begin
        end
        S4: begin
        end
        endcase
    end
    
    // State update deassign
    always @(next_state) begin
        previous_state <= state;
        state <= next_state;
    end

    // Output logic
    lcd_controller lcd_ctrl (clk_disp, bcd1, bcd2, bcd3, bcd4, lcd, en, rs);
    
    audio_controller audio_ctrl (clk, audio_out);
    assign audio_off = alarm0 ? div0: 0;
	assign	audio_gain = 1'b0;
    
endmodule
