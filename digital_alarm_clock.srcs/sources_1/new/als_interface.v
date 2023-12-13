`timescale 1ns / 1ps

module als_interface(
    input clk,
    input sdo,
    output reg sclk = 1,
    output reg cs,
    output reg [7:0] lightLevel,
    output reg transferEnd
    );
    
    // Counter variables
    reg [7:0] count = 0;
    reg [7:0] data_count = 0;
    reg [3:0] internal_count;
    reg [2:0] bit_count = 3'b111;
    
    // Clock divider logic
    always @(posedge clk) begin
        if(count == 8'd25) begin
            count <= 8'd0;
            sclk <= ~sclk;
        end
        else
            count <= count + 8'd1;
    end
    
    // CS control logic
    always @(negedge sclk) begin
        if(data_count == 8'd15) begin
            cs <= 1'd1;
            data_count <= data_count + 1;
            end
        else if(data_count == 8'd19) begin
            data_count <= 8'd0;
            end
        else if(data_count == 8'd0) begin
            cs <= 1'd0;
            data_count <= data_count + 1;
            end
        else
            data_count <= data_count + 1;
    end
    
    // data transfer logic
    always @(negedge sclk) begin
    if((cs == 1'b0)) begin
        if ((data_count == internal_count) & (transferEnd == 1'b0)) begin
              lightLevel[bit_count] <= sdo;  // Sample data
              bit_count <= bit_count - 1;
              internal_count = internal_count + 16'd1;
              if (bit_count == 3'b000)
                    transferEnd   <= 1'b1;   // Byte done pulse
        end
        else begin
            // Default
            transferEnd   <= 1'b0;
            bit_count <= 3'b111;
            internal_count <= 16'd4;
            lightLevel <= 8'd0;
         end
        end
    end
    
endmodule
