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
										input	[01:00] lives,
                       output logic [7:0]  Red, Green, Blue );

    logic ball_on;
	 logic bar_on;
	 logic block_on;
	 logic [10:0] char_data;
	 logic [7:0] char, currLine;
	 logic life_block_on;
	 logic score_on;

	 font_rom rom(.addr(char_data), .data(currLine));
	
	 
	 
	 


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
		  begin: blocks_code
		  
		  block_on =1'b0;
		  color1 = 1'b0;
		  color2 = 1'b0;

		 for (int i =0; i<32; i++)
		 begin
			  BlockX = (10'b0000000000^((i%8)*80+40));
			  BlockY = (10'b0000000000^(10+20*(i>>3)));
			  
		  if(Block_Array[i] && (((DrawX<=BlockX+Block_SizeX) && (DrawX>=BlockX-Block_SizeX))  && ((DrawY<=BlockY+Block_SizeY) && (DrawY>=BlockY-Block_SizeY))) && (BlockX-Block_SizeX>=0) && (BlockX-Block_SizeX<=639))
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
		  begin: Draw_Score
		  
		   char = 8'h00;  
			score_on = 1'b0;
			
			if (DrawY>463 && DrawY<480 && DrawX>=0 && DrawX<=79)
			begin
			score_on = 1'b1;
			if(DrawX<=7 && DrawX>=0)
			char = 8'h53;
			else if(DrawX>7 && DrawX<=15)
			char = 8'h63;
			else if(DrawX>15 && DrawX<=23)
			char = 8'h6f;
			else if(DrawX>23 && DrawX<=31)
			char = 8'h72;
			else if(DrawX>31 && DrawX<=39)
			char = 8'h65;
			else if(DrawX>39 && DrawX<=47)
			char = 8'h3a;
			else if(DrawX>47 && DrawX<=55)
			char = 8'h30;
			else if(DrawX>55 && DrawX<=63)
			char = 8'h30;
			else if(DrawX>63 && DrawX<=71)
			char = 8'h30;
			else if(DrawX>71 && DrawX<=79)
			char = 8'h30;
			
			end
			
			end
			
	always_comb
	begin: life_blocks_proc
	life_block_on = 1'b0;
	if (lives >= 3) begin
		if ((DrawX >= 565) && (DrawX <= 579) && (DrawY >= 465) && (DrawY <= 479))
			life_block_on = 1'b1;
	end
	if (lives >= 2) begin
		if ((DrawX >= 595) && (DrawX <= 609) && (DrawY >= 465) && (DrawY <= 479))
			life_block_on = 1'b1;
	end
	if (lives >= 1) begin
		if ( (DrawX >= 624) && (DrawX <= 638) && (DrawY >= 465) && (DrawY <= 479))
			life_block_on = 1'b1;
	end

	end			
			
			
			
		

    always_comb
    begin:RGB_Display
		char_data = char[6:0] * 16 + DrawY[3:0];
		Red = 8'b0;
		Green = 8'b0;
		Blue = 8'b0;
	   if(DrawX>=0 && DrawX<=639 && DrawY>=0 && DrawY<=479)
		begin
	  	Red = 8'b0;
		Green = 8'b0;
		Blue = 8'hff;
		end
		if (score_on==1'b1)
		begin
			if (currLine[7 - DrawX[2:0]])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
	     end
		
		else if ((ball_on == 1'b1))
			  begin
					Red = 8'hff;
					Green = 8'h55;
					Blue = 8'h00;
			  end
		

		if(bar_on== 1'b1)
		begin
			   Red = 8'h80;
            Green = 8'h80;
            Blue = 8'h80;
		end
		
		if(block_on == 1'b1)
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
	
	 if (life_block_on == 1'b1)
		begin
			Red = 8'he0;
			Green = 8'he7;
			Blue = 8'h22;
		end
		

    end

endmodule
