//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, BarX, BarY, Bar_Sizex, Bar_Sizey,
										input [9:0]  Block_SizeX, Block_SizeY,
										input [32:0] Block_Array,
                       output logic [7:0]  Red, Green, Blue );

    logic ball_on;
	 logic bar_on;
	 logic block_on;

 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.

    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */

    int BallDistX, BallDistY, BallSize,BarYSize,BarXSize;
	 assign BallDistX = DrawX - BallX;
    assign BallDistY = DrawY - BallY;

    assign BallSize = Ball_size;
	 
	 assign BarYSize = Bar_Sizey;
	 assign BarXSize = Bar_Sizex;
	 
	logic[9:0] BlockX, BlockY;
	logic color1,color2;

    always_comb
    begin:Ball_on_proc
        if ( ( BallDistX*BallDistX + BallDistY*BallDistY) <= (BallSize * BallSize) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 

    always_comb begin : Bar_on_proc
        if (((DrawX<=BarX+BarXSize) && (DrawX>=BarX-BarXSize))  && ((DrawY<=BarY+BarYSize) && (DrawY>=BarY-BarYSize)))
            bar_on = 1'b1;
        else 
            bar_on = 1'b0;
    end
	 
	 
	     always_comb 
		  begin
		  
		  block_on =1'b0;
		  color1 = 1'b0;
		  color2 = 1'b0;

		 for (int i =0; i<32; i++)
		 begin
			  BlockX = (10'b0000000000^((i%8)*80+40));
			  BlockY = (10'b0000000000^(10+20*(i>>3)));
			  
		  if(Block_Array[i] && (((DrawX<=BlockX+Block_SizeX) && (DrawX>=BlockX-Block_SizeX))  && ((DrawY<=BlockY+Block_SizeY) && (DrawY>=BlockY-Block_SizeY))))
            begin
				block_on = 1'b1;
				if(1'b0^(i%2))
				color1=1'b1;
				else if(1'b0^(i%3))
				color2 =1'b1;
				break;
				end		  
		  
		  end
		  end
	 
	 

    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1))
        begin
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end

		else if(bar_on== 1'b1)
		begin
			   Red = 8'h80;
            Green = 8'h80;
            Blue = 8'h80;
		end
		
		else if(block_on == 1'b1)
		begin
				if(color1)
				begin
				Red = 8'h80;
            Green = 8'h1f;
            Blue = 8'h80;
				end
				else if(color2)
				begin
				Red = 8'h80;
            Green = 8'hff;
            Blue = 8'h55;
				end
				else
				begin
				Red = 8'h10;
				Blue = 8'h01;
				Green = 8'ha2;
				end
				
		end

		else
        begin
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'hff;
        end
    end

endmodule
