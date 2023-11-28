`timescale 1ns / 1ps

module lcd_init(
    input clk,
    output reg [7:0] data,
    output reg en, rs, rw
    );
    
    // Define the LCD commands
    parameter FUNC_SET = 8'h38; // function set: 5x8 dots, 2 lines, 8-bit interface
    parameter DISP_ON = 8'h0F; // display on: display on, cursor on, blink on
    parameter DISP_CLR = 8'h01; // display clear: clear display, set cursor to home position
    parameter ENTRY_MODE = 8'h06; // entry mode set: increment cursor, no display shift
    
    // States defined as parameters
    parameter INIT_1 = 0, // initial state, send first function set command
              INIT_2 = 1, // wait for 40 ms after VDD rise
              INIT_3 = 2, // send second function set command
              INIT_4 = 3, // wait for 4.1 ms
              INIT_5 = 4, // send third function set command
              INIT_6 = 5, // wait for 100 us
              INIT_7 = 6, // send display on/off control command
              INIT_8 = 7, // wait for 100 us
              INIT_9 = 8, // send display clear command
              INIT_10 = 9, // wait for 100 us
              INIT_11 = 10, // send entry mode set command
              INIT_12 = 11, // wait for 100 us
              IDLE = 12; // idle state, do nothing
    
    // Declare the state variable
    reg [3:0] state = INIT_1;

    // Declare the counter variable
    reg [12:0] count;

    // State transition logic
    always @ (posedge clk) begin
    case (state)
        INIT_1: state <= INIT_2; // go to wait state after sending first command
        
        INIT_2: if (count == 4000) state <= INIT_3; // go to next command state after 40 ms
                else state <= INIT_2; // stay in wait state
                
        INIT_3: state <= INIT_4; // go to wait state after sending second command
        
        INIT_4: if (count == 410) state <= INIT_5; // go to next command state after 4.1 ms
                else state <= INIT_4; // stay in wait state
                
        INIT_5: state <= INIT_6; // go to wait state after sending third command
        
        INIT_6: if (count == 5) state <= INIT_7; // go to next command state after 100 us
                else state <= INIT_6; // stay in wait state
                
        INIT_7: state <= INIT_8; // go to wait state after sending display on/off control command
        
        INIT_8: if (count == 5) state <= INIT_9; // go to next command state after 100 us
                else state <= INIT_8; // stay in wait state
                
        INIT_9: state <= INIT_10; // go to wait state after sending display clear command
        
        INIT_10: if (count == 5) state <= INIT_11; // go to next command state after 100 us
                 else state <= INIT_10; // stay in wait state
                 
        INIT_11: state <= INIT_12; // go to wait state after sending entry mode set command
        
        INIT_12: if (count == 5) state <= IDLE; // go to idle state after 100 us
                 else state <= INIT_12; // stay in wait state
                 
        IDLE: state <= IDLE; // stay in idle state
        default: state <= IDLE; // default state is idle
    endcase
    end

    // Counter logic
    always @ (posedge clk) begin
        case (state)
            INIT_2, INIT_4, INIT_6, INIT_8, INIT_10, INIT_12: begin
                if (count == 5000) count <= 0; // reset the counter after reaching the maximum value
                else count <= count + 1; // increment the counter
            end
            default: count <= 0; // reset the counter in other states
        endcase
    end

// Output logic
always @ (posedge clk) begin
        case (state)
            INIT_1: begin // send first function set command
                data <= FUNC_SET; // 5x8 dots, 2 lines, 8-bit interface
                rs <= 0; // command mode
                rw <= 0; // write mode
                en <= 1; // enable high
            end
            INIT_2: begin // wait for 40 ms
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            INIT_3: begin // send second function set command
                data <= FUNC_SET; // 5x8 dots, 2 lines, 8-bit interface
                rs <= 0; // command mode
                rw <= 0; // write mode
                en <= 1; // enable high
            end
            INIT_4: begin // wait for 4.1 ms
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            INIT_5: begin // send third function set command
                data <= FUNC_SET; // 5x8 dots, 2 lines, 8-bit interface
                rs <= 0; // command mode
                rw <= 0; // write mode
                en <= 1; // enable high
            end
            INIT_6: begin // wait for 100 us
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            INIT_7: begin // send display on/off control command
                data <= DISP_ON; // display on, cursor on, blink on
                rs <= 0; // command mode
                rw <= 0; // write mode
                en <= 1; // enable high
            end
            INIT_8: begin // wait for 100 us
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            INIT_9: begin // send display clear command
                data <= DISP_CLR; // clear display, set cursor to home position
                rs <= 0; // command mode
                rw <= 0; // write mode
                en <= 1; // enable high
            end
            INIT_10: begin // wait for 100 us
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            INIT_11: begin // send entry mode set command
                data <= ENTRY_MODE; // increment cursor, no display shift
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 1; // enable low
            end
            INIT_12: begin // wait for 100 us
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // enable low
            end
            IDLE: begin // idle state, do nothing
            end
            default: begin // default state, do nothing
                data <= 0; // no data
                rs <= 0; // no change
                rw <= 0; // no change
                en <= 0; // no change
            end
        endcase
    end

endmodule
