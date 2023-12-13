`timescale 1ns / 1ps

module audio_controller(
    input clk,
    output reg audio_out
    ); 
	parameter STEP_SIZE = 32'h9F62;

	reg	[31:0]	phase;

	always @(posedge clk)
		phase <= phase + STEP_SIZE;

	always @(*)
		audio_out = phase[31];
	
endmodule
