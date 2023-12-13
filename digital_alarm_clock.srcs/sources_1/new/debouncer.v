`timescale 1ns / 1ps

module debouncer(
  input clk, in,
  output out
  );

    reg [1:0] hold;

    always@(posedge clk)
    begin
        hold <= {hold[0], in};
    end

    assign out = (~hold[1]) & hold[0]; //rising edge
endmodule
