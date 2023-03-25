`timescale 1ns / 1ps

module memory (
        input [2:0] row_addr, // memory row
        input sector, // first 4bits or the last 4bits 
        input read_write, // read "1" or write "0" flag
        input [3:0] data_in, // write input
        input clk,
        output reg [3:0] data_out // read output
    );

    reg [7:0] reg_array [0:7];
    
    always @ (posedge clk) begin
        if (read_write == 1'b1) begin
            // reading memory
            if (sector == 1'b1) begin
                data_out <= reg_array[row_addr][3:0];
            end else begin
                data_out <= reg_array[row_addr][7:4];
            end
        end else begin
            // setting memory
            if (sector == 1'b1) begin
                reg_array[row_addr][3:0] <= reg_array[row_addr][3:0] | data_in;
            end else begin
                reg_array[row_addr][7:4] <= reg_array[row_addr][7:4] | data_in;
            end
        end
       
    end

endmodule

module memory_tb;

    reg [2:0] row_addr;
    reg sector, read_write, clk; 
    reg [3:0] store_data;
    wire [3:0] data_out; // our register is at the same time input and output to the emory
    
    memory mem(
        .row_addr(row_addr),
        .sector(sector), 
        .read_write(read_write),
        .data_in(store_data),
        .clk(clk),
        .data_out(data_out)
    );
       
    // initializing memory
    initial begin
        store_data = 4'b0000;
        
        mem.reg_array[0] = 8'b01101010;
        mem.reg_array[1] = 8'b11001011;
        mem.reg_array[2] = 8'b00111001;
        mem.reg_array[3] = 8'b10010111;
        mem.reg_array[4] = 8'b01111000;
        mem.reg_array[5] = 8'b11000101;
        mem.reg_array[6] = 8'b01110001;
        mem.reg_array[7] = 8'b10001111;
        
        $monitor("time = %5d, reg = %b", $time, data_out);
    end
    
    // setting clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // instructions
    initial begin
    
        // load to r0 from 001 1
        #0 read_write = 1'b1; row_addr = 3'b001; sector = 1'b1;
        store_data = data_out;
         
        // store r0 to 010 1
        #20 read_write = 1'b0; row_addr = 3'b010; sector = 1'b1;
        store_data = data_out;
        
        // load to r0 from 010 1
        #20 read_write = 1'b1; row_addr = 3'b010; sector = 1'b1;
        store_data = data_out;
         
        // store r0 to 111 0
        #20 read_write = 1'b0; row_addr = 3'b111; sector = 1'b0;
        store_data = data_out;
        
        // reading resault from 111 0
        #20 read_write = 1'b1; row_addr = 3'b111; sector = 1'b0;
        store_data = data_out;
        
        $display("time = %5d, reg = %b", $time, data_out);
        
    end
endmodule
