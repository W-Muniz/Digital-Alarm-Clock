`timescale 1ns / 1ps

module lcd_controller(
    input clk,
    input [3:0] bcd1, bcd2, bcd3, bcd4,
    output reg [7:0] data,
    output reg en, rs
    );
    
    // Define the LCD commands
    parameter FUNC_SET = 8'h38; // function set: 5x8 dots, 2 lines, 8-bit interface
    parameter DISP_ON = 8'h0C; // display on: display on, cursor off, blink off
    parameter DISP_CLR = 8'h01; // display clear: clear display, set cursor to home position
    parameter ENTRY_MODE = 8'h06; // entry mode set: increment cursor, no display shift
    
    // Declare the state variable
    reg [7:0] state = 0;

    // Declare the counter variable
    reg [8:0] count;
    reg [3:0] bcd1_curr;

    // State transition logic
    always @ (posedge clk) begin
    case (state)
        0: if (count == 4) state <= 1; // go to next command state after 40 ms
                else state <= 0; // stay in wait state
                
        255: begin // stay in idle state
            if (bcd1_curr != bcd1) begin
                state <= 13;
                bcd1_curr <= bcd1;
            end
        end 
        default: state <= state + 1; // default state
    endcase
    end

    // Counter logic
    always @ (posedge clk) begin
        case (state)
            0: begin
                if (count == 7) count <= 0; // reset the counter after reaching the maximum value
                else count <= count + 1; // increment the counter
            end
            default: count <= 0; // reset the counter in other states
        endcase
    end

// Output logic
always @ (posedge clk) begin
        case (state)
            1, 3, 5: begin // send first function set command
                data <= FUNC_SET; // 5x8 dots, 2 lines, 8-bit interface
                en <= 1; // enable high
            end
            7: begin // send display on/off control command
                data <= DISP_ON; // display on, cursor on, blink on
                en <= 1; // enable high
            end
            9: begin // send display clear command
                data <= DISP_CLR; // clear display, set cursor to home position
                en <= 1;
            end
            11: begin // send entry mode set command
                data <= ENTRY_MODE; // increment cursor, no display shift
                en <= 1;
            end
            13: begin // send display clear command
                data <= DISP_CLR; // clear display, set cursor to home position
                en <= 1;
            end
            15: begin
                data <= 8'h82;
                en <= 1;
            end
            17: begin
                rs <= 1; // write mode
                data <= {4'h3, bcd4};
                en <= 1;
            end
            19: begin
                rs <= 1; // write mode
                data <= {4'h3, bcd3};
                en <= 1;
            end
            21, 59: begin
                rs <= 1; // write mode
                data <= 8'h48;
                en <= 1;
            end
            23, 43, 47, 51, 61, 65, 69: begin
                rs <= 1; // write mode
                data <= 8'h20;
                en <= 1;
            end
            25: begin
                rs <= 1; // write mode
                data <= {4'h3, bcd2};
                en <= 1;
            end
            27: begin
                rs <= 1; // write mode
                data <= {4'h3, bcd1};
                en <= 1;
            end
            29: begin
                rs <= 1; // write mode
                data <= 8'h4D;
                en <= 1;
            end
            31: begin
                data <= 8'h8B;
                en <= 1;
            end
            33, 35, 53, 55: begin
                rs <= 1; // write mode
                data <= 8'h23;
                en <= 1;
            end
            37: begin
                rs <= 1; // write mode
                data <= 8'h46;
                en <= 1;
            end
            39: begin
                data <= 8'hC0;
                en <= 1;
            end
            41, 45, 49, 63, 67, 71: begin
                rs <= 1; // write mode
                data <= 8'h2D;
                en <= 1;
            end
            57: begin
                rs <= 1; // write mode
                data <= 8'h52;
                en <= 1;
            end
            255: begin
            end
            default: begin // default state, do nothing
                rs <= 0; // command mode
                en <= 0; // enable low
            end
        endcase
    end
    
endmodule
