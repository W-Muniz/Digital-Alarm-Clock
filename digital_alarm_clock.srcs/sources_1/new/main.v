`timescale 1ns / 1ps

module main(
    input clk, pbu, pbd, pbl, pbr, pbc,
    input [3:0] als,
    input [1:0] hygro,
    input [2:0] switch,
    output reg [1:0] lcd,
    output reg [2:0] amp
    );
    
// States defined as parameters
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// State and next state registers
reg [2:0] state, next_state, previous_state;

// Interconections
reg [2:0] timer;
wire alarm;
assign alarm = {switch[0] & timer[0] | switch[1] & timer[1] | switch[2] & timer[2]};

// State transition logic
always @(pbc, alarm) begin
    case (state)
        S0: if (pbc == 1) next_state = S1; else next_state = S0;
        S1: if (pbc == 1) next_state = S3; else if (alarm != 0) next_state = S2; else next_state = S1;
        S2: if (alarm == 0) next_state = previous_state; else if (pbc == 1) next_state = S4; else next_state = S2;
        S3: if (pbc == 1) next_state = S1; else if (alarm != 0) next_state = S2; else next_state = S1;
        S4: if (alarm == 0) next_state = S1; else next_state = S4;
        default: next_state = S0;
    endcase
end

// State update logic
always @(next_state) begin
    state = next_state;
end

// Output logic
always @(state) begin
    case(state)
        S0: begin
            lcd = 1; 
            amp = 0;
        end
        S1: begin
            lcd = 1; 
            amp = 0;
        end
        S2: begin
            lcd = 0; 
            amp = 1;
        end
        S3: begin
            lcd = 1; 
            amp = 0;
        end
        S4: begin
            lcd = 0; 
            amp = 0;
        end
    endcase
end
endmodule
