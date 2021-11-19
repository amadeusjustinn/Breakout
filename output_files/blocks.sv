module  blocks ( input Reset, frame_clk,
                output [9:0] Block_SizeX, Block_SizeY,
					 output [32:0] Block_Array);
					

	assign Block_SizeX = 40;  
	assign Block_SizeY = 10;
	always_ff @ (posedge Reset or posedge frame_clk )
	begin
   Block_Array = 32'b11111111111111111111111111111111;
	end
	 endmodule
	 
	 