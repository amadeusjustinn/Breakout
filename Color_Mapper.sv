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


module  color_mapper ( input        [09:00] BallX, BallY, DrawX, DrawY, Ball_size, BarX, BarY, Bar_Sizex, Bar_Sizey,
							  input 			[09:00] Block_SizeX, Block_SizeY,
							  input 			[32:00] Block_Array,
							  input			[01:00] lives,
							  input			[07:00] keycode,
							  input					  clk, Reset,
							  input			[15:00] curr_score,
                       output logic [07:00] Red, Green, Blue,
							  output logic			  start_menu_1);

	logic ball_on;
	logic bar_on;
	logic block_on;
	logic [10:0] char_data;
	logic [7:0] char, currLine;
	logic life_block_on;
	logic score_on;
	logic start_menu = 1'b1;
	logic start_menu_pixel;
	logic [7:0] thousands, hundreds, tens, ones;

	font_rom rom(.addr(char_data), .data(currLine));
	
	hex_converter hc(.in(curr_score),
						  .out_th(thousands), .out_hu(hundreds), .out_te(tens), .out_on(ones));

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
		  
		block_on = 1'b0;
		color1 = 1'b0;
		color2 = 1'b0;

		for (int i =0; i<32; i++)
		begin
			BlockX = (10'b0000000000^((i%8)*80+40));
			BlockY = (10'b0000000000^(10+20*(i>>3)));
			  
			if(Block_Array[i] && (((DrawX<=BlockX+Block_SizeX) && (DrawX>=BlockX-Block_SizeX)) && ((DrawY<=BlockY+Block_SizeY) && (DrawY>=BlockY-Block_SizeY))) && (BlockX-Block_SizeX>=0) && (BlockX-Block_SizeX<=639))
         begin
				block_on = 1'b1;
				if(1'b0^(i%2))
					color1=1'b1;
				else if(1'b0^(i%3)) begin
					color2 =1'b1;
					break;
				end
			end		  
		  
		end
	end
	 
	always_ff @(posedge clk)
	begin: Whether_Start_Menu
		if (Reset)
			start_menu <= 1'b1;
		else if (keycode != 8'h00 && keycode != 8'h04 && keycode != 8'h07 && keycode != 8'h2c) begin
			start_menu <= 1'b0;
		end
		start_menu_1 <= start_menu;
	end

	always_comb 
	begin: Draw_Score
	  
		char = 8'h00;  
		score_on = 1'b0;
		start_menu_pixel = 1'b0;
		if (start_menu == 1'b0)
		begin
			if (DrawY > 463 && DrawY < 480 && DrawX >= 0 && DrawX <= 79)
			begin
	
				score_on = 1'b1;
				if(DrawX<=7 && DrawX>=0)
					char = 8'h53; // S
				else if(DrawX>7 && DrawX<=15)
					char = 8'h63; // c
				else if(DrawX>15 && DrawX<=23)
					char = 8'h6f; // o
				else if(DrawX>23 && DrawX<=31)
					char = 8'h72; // r
				else if(DrawX>31 && DrawX<=39)
					char = 8'h65; // e
				else if(DrawX>39 && DrawX<=47)
					char = 8'h3a; // :
				else if(DrawX>47 && DrawX<=55)
					char = thousands;
				else if(DrawX>55 && DrawX<=63)
					char = hundreds;
				else if(DrawX>63 && DrawX<=71)
					char = tens;
				else if(DrawX>71 && DrawX<=79)
					char = ones;
			
			end
		end

		else begin
			if (DrawY > 176 && DrawY < 193)
			begin
				
				start_menu_pixel = 1'b1;
				if (DrawX >= 0 && DrawX <= 7)
					char = 8'h45; // E
				else if (DrawX >= 8  && DrawX <= 15)
					char = 8'h43; // C
				else if (DrawX >= 16  && DrawX <= 23)
					char = 8'h45; // E
				else if (DrawX >= 32  && DrawX <= 39)
					char = 8'h33; // 3
				else if (DrawX >= 40  && DrawX <= 47)
					char = 8'h38; // 8
				else if (DrawX >= 48  && DrawX <= 55)
					char = 8'h35; // 5
				else if (DrawX >= 64  && DrawX <= 71)
					char = 8'h46; // F
				else if (DrawX >= 72  && DrawX <= 79)
					char = 8'h69; // i
				else if (DrawX >= 80  && DrawX <= 87)
					char = 8'h6e; // n
				else if (DrawX >= 88  && DrawX <= 95)
					char = 8'h61; // a
				else if (DrawX >= 96  && DrawX <= 103)
					char = 8'h6c; // l
				else if (DrawX >= 112  && DrawX <= 119)
					char = 8'h70; // p
				else if (DrawX >= 120  && DrawX <= 127)
					char = 8'h72; // r
				else if (DrawX >= 128  && DrawX <= 135)
					char = 8'h6f; // o
				else if (DrawX >= 136  && DrawX <= 143)
					char = 8'h6a; // j
				else if (DrawX >= 144  && DrawX <= 151)
					char = 8'h65; // e
				else if (DrawX >= 152  && DrawX <= 159)
					char = 8'h63; // c
				else if (DrawX >= 160  && DrawX <= 167)
					char = 8'h74; // t
				else if (DrawX >= 168  && DrawX <= 175)
					char = 8'h3a; // :
				else if (DrawX >= 184  && DrawX <= 191)
					char = 8'h42; // B
				else if (DrawX >= 192  && DrawX <= 199)
					char = 8'h72; // r
				else if (DrawX >= 200  && DrawX <= 207)
					char = 8'h65; // e
				else if (DrawX >= 208  && DrawX <= 215)
					char = 8'h61; // a
				else if (DrawX >= 216  && DrawX <= 223)
					char = 8'h6b; // k
				else if (DrawX >= 224  && DrawX <= 231)
					char = 8'h6f; // o
				else if (DrawX >= 232  && DrawX <= 239)
					char = 8'h75; // u
				else if (DrawX >= 240  && DrawX <= 247)
					char = 8'h74; // t
			end
			
			else if (DrawY > 223 && DrawY < 240)
			begin

				start_menu_pixel = 1'b1;
				if (DrawX >= 0  && DrawX <= 7 )
					char = 8'h42; // B
				else if (DrawX >= 8  && DrawX <= 15 )
					char = 8'h79; // y
				else if (DrawX >= 24  && DrawX <= 31 )
					char = 8'h4d; // M
				else if (DrawX >= 32  && DrawX <= 39 )
					char = 8'h61; // a
				else if (DrawX >= 40  && DrawX <= 47 )
					char = 8'h72; // r
				else if (DrawX >= 48  && DrawX <= 55 )
					char = 8'h65; // e
				else if (DrawX >= 56  && DrawX <= 63 )
					char = 8'h6b; // k
				else if (DrawX >= 72  && DrawX <= 79 )
					char = 8'h26; // &
				else if (DrawX >= 88  && DrawX <= 95 )
					char = 8'h41; // A
				else if (DrawX >= 96  && DrawX <= 103 )
					char = 8'h6d; // m
				else if (DrawX >= 104  && DrawX <= 111 )
					char = 8'h61; // a
				else if (DrawX >= 112  && DrawX <= 119 )
					char = 8'h64; // d
				else if (DrawX >= 120  && DrawX <= 127 )
					char = 8'h65; // e
				else if (DrawX >= 128  && DrawX <= 135 )
					char = 8'h75; // u
				else if (DrawX >= 136  && DrawX <= 143 )
					char = 8'h73; // s
					
			end
			
			else if (DrawY > 270 && DrawY < 287)
			begin
			
				start_menu_pixel = 1'b1;
				if (DrawX >= 0  && DrawX <= 7 )
					char = 8'h50; // P
				else if (DrawX >= 8  && DrawX <= 15 )
					char = 8'h72; // r
				else if (DrawX >= 16  && DrawX <= 23 )
					char = 8'h65; // e
				else if (DrawX >= 24  && DrawX <= 31 )
					char = 8'h73; // s
				else if (DrawX >= 32  && DrawX <= 39 )
					char = 8'h73; // s
				else if (DrawX >= 48  && DrawX <= 55 )
					char = 8'h61; // a
				else if (DrawX >= 56  && DrawX <= 63 )
					char = 8'h6e; // n
				else if (DrawX >= 64  && DrawX <= 71 )
					char = 8'h79; // y
				else if (DrawX >= 80  && DrawX <= 87 )
					char = 8'h6b; // k
				else if (DrawX >= 88  && DrawX <= 95 )
					char = 8'h65; // e
				else if (DrawX >= 96  && DrawX <= 103 )
					char = 8'h79; // y

			end 
		end
	end
			
	always_comb
	begin: life_blocks_proc
	life_block_on = 1'b0;

	if (DrawY >= 465 - 5 && DrawY <= 479 - 5) begin
		if (lives >= 3) begin
			if ((DrawX >= 565) && (DrawX <= 579) && (DrawY >= 465) && (DrawY <= 479))
				life_block_on = 1'b1;
		end
		if (lives >= 2) begin
			if ((DrawX >= 595) && (DrawX <= 609) && (DrawY >= 465) && (DrawY <= 479))
				life_block_on = 1'b1;
		end
		if (lives >= 1) begin
			if ((DrawX >= 624) && (DrawX <= 638) && (DrawY >= 465) && (DrawY <= 479))
				life_block_on = 1'b1;
		end
	end
	
	end			
			
			
			
		

	always_comb
   begin:RGB_Display
		char_data = char[6:0] * 16 + DrawY[3:0];
		Red = 8'b0;
		Green = 8'b0;
		Blue = 8'b0;
		if (start_menu == 1'b0)
		begin
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
				else begin
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

		else begin
			if (start_menu_pixel == 1'b1)
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
		end

	end
endmodule
