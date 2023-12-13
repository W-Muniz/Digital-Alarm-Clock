`timescale 1ns / 1ps

module main(
    input clk,
    inout [2:0] als,
    input sw, btnL, btnR, btnC, btnU,
    output [7:0] lcd,
    output en, rs, led_en, pm, LED,
    output audio_out, audio_gain, audio_off
    );
    
    wire rst, btn_event, tmr_rst;
    wire div0, clk_div, clk_disp, clk_db;
    wire c1, c2, c3;
    wire [3:0] bcd1, bcd2, bcd3, bcd4;
    reg [3:0] num1, num2, num3, num4;
    wire [3:0] timer1, timer2, timer3, timer4;
    reg alarm, display;
    reg time_mode = 0, dig_set = 0;
    wire eot;
    wire [7:0] lightLevel;
    wire cp0, cp2, tc1, tc2, tp2, tc3;
    reg p0, p2, p3, tp0;
    
    // Reset the counters when the time reaches 24:00
    assign rst = ({bcd4, bcd3} > 8'b00100011) ? 1'b1 : 1'b0;
    assign tmr_rst = ({timer4, timer3} > 8'b00100011) ? 1'b1 : 1'b0;
    
    // Generate clock signals for different time units
    clock_divider #(.FREQ(50000)) disp (clk, 0, clk_disp);
    clock_divider #(.FREQ(5000000)) btn (clk, 0, clk_db);
    clock_divider oneSec (clk, rst, div0);
    clock_divider #(.FREQ(30)) oneMin (div0, rst, clk_div);
    
    // Implement BCD counters for each digit of the time
    assign cp0 = clk_div ^ p0;
    assign cp2 = c2 ^ p2;
    assign tp2 = tc2 ^ p3;
    
    bcd_counter #(.MAX(9)) m0 (cp0, rst, bcd1, c1);
    bcd_counter #(.MAX(5)) m1 (c1, rst, bcd2, c2);
    bcd_counter #(.MAX(9)) h0 (cp2, rst, bcd3, c3);
    bcd_counter #(.MAX(2)) h1 (c3, rst, bcd4);
    
    bcd_counter #(.MAX(9)) t0 (tp0, tmr_rst, timer1, tc1);
    bcd_counter #(.MAX(5)) t1 (tc1, tmr_rst, timer2, tc2);
    bcd_counter #(.MAX(9)) t2 (tp2, tmr_rst, timer3, tc3);
    bcd_counter #(.MAX(2)) t3 (tc3, tmr_rst, timer4);
    
    // Debounce the button inputs to avoid glitches
    wire middle, left, right, up;
    debouncer btn_middle (clk_db, btnC, middle);
    debouncer btn_left (clk_db, btnL, left);
    debouncer btn_right (clk_db, btnR, right);
    debouncer btn_up (clk_db, btnU, up);
       
    // Read light level from ALS PMOD via SPI 
    als_interface als_spi (clk, als[1], als[2], als[0], lightLevel, eot);
    
    // Control LCD backlight with PWM based on light level
    pwm pwm (clk, lightLevel, eot, led_en);
    
    assign btn_event = middle | left | right;
    always @ (posedge btn_event) begin
        if (middle) begin
            time_mode <= time_mode + 1'b1;
            dig_set <= 1'b0;
            display <= 1'b0;
        end
        if (left) begin
            dig_set <= dig_set + 1'b1;
            display <= 1'b0;
        end
        if (right) begin
            dig_set <= dig_set + 1'b1;
            display <= 1'b1;
        end
    end
    
    always @ (up) begin
        if (display == 1'b0) begin 
            if (dig_set == 1'b0) p0 <= up;
            else if (dig_set == 1'b1) p2 <= up;
        end
        else begin
            if (dig_set == 1'b0) tp0 <= up;
            else if (dig_set == 1'b1) p3 <= up;
        end
    end
    
    always @ (posedge clk) begin
        if (sw && ({timer4, timer3, timer2, timer1} == {bcd4, bcd3, bcd2, bcd1})) alarm <= 1'b1;
        else if (sw == 1'b0) alarm <= 0;
        else alarm <= alarm;
    end
    
    always @ (posedge clk_disp) begin
        if (display == 1'b1) begin
            num1 <= timer1;
            num2 <= timer2;
            
            if (time_mode == 1) begin
                if (!(timer4 | timer3)) begin
                    num4 <= 4'b0001;
                    num3 <= 4'b0010;
                end
                else if ({timer4, timer3} < 8'b00010011) begin
                    num4 <= timer4;
                    num3 <= timer3;
                end
                else if ({timer4, timer3} < 8'b00100000) begin
                    num4 <= 4'b0000;
                    num3 <= timer3 - 4'b0010;
                end
                else if ({timer4, timer3} < 8'b00100010) begin
                    num4 <= 4'b0000;
                    num3 <= timer3 + 4'b1000;
                end
                else begin
                    num4 <= 4'b0001;
                    num3 <= timer3 - 4'b0010;
                end           
            end
            else begin
                num4 <= timer4;
                num3 <= timer3;
            end
        end
        else if (display == 1'b0) begin
            num1 <= bcd1;
            num2 <= bcd2;
            
            if (time_mode == 1) begin
                if (!(bcd4 | bcd3)) begin
                    num4 <= 4'b0001;
                    num3 <= 4'b0010;
                end
                else if ({bcd4, bcd3} < 8'b00010011) begin
                    num4 <= bcd4;
                    num3 <= bcd3;
                end
                else if ({bcd4, bcd3} < 8'b00100000) begin
                    num4 <= 4'b0000;
                    num3 <= bcd3 - 4'b0010;
                end
                else if ({bcd4, bcd3} < 8'b00100010) begin
                    num4 <= 4'b0000;
                    num3 <= bcd3 + 4'b1000;
                end
                else begin
                    num4 <= 4'b0001;
                    num3 <= bcd3 - 4'b0010;
                end           
            end
            else begin
                num4 <= bcd4;
                num3 <= bcd3;
            end
        end
    end
    assign pm = (time_mode == 1 && {bcd4, bcd3} > 8'b00010001) ? 1: 0;
    assign LED = sw;
    lcd_controller lcd_ctrl (clk_disp, num1, num2, num3, num4, lcd, en, rs);
    
    audio_controller audio_ctrl (clk, audio_out);
    assign audio_off = alarm ? div0: 0;
	assign	audio_gain = 1'b0;
    
endmodule
