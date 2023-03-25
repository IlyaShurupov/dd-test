module Crc(
	input data,
	input clk,
	input reset,
	output [4:0] out);

	reg [4:0] DFF = 5'b01001;     
	wire  xorx;
	
	assign xorx = data ^ DFF[4];
	
	always@(posedge clk  or posedge reset)
	begin
		if(reset)
			DFF = 5'b0;
		else begin
			DFF[0] <= xorx;
			DFF[1] <= DFF[0];
			DFF[2] <= DFF[1];
			DFF[3] <= DFF[2] ^ xorx;
			DFF[4] <= DFF[3];
		end  
	 end

	assign out = DFF;

endmodule

module test();
	reg clk;
	reg d;
	reg reset;
	wire [4:0] Q;

	Crc crc(d, clk, reset, Q);

	initial clk=0;
		always#5 clk = ~clk;
	
	initial begin
		reset = 1'b0;
		
		#0  d = 1'b1;
		#10 d = 1'b0;
		#10 d = 1'b1; 
		#10 d = 1'b0; 
		#10 d = 1'b1; 
		
		#10 $display("Output - %b", Q);
		
		#20 reset = 1'b1;
	end
    
endmodule
