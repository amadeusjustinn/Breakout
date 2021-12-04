//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
					input [9:0] BarX, BarY, Bar_Sizex, Bar_Sizey,
					input [9:0]  Block_SizeX, Block_SizeY,
					input [32:0] Block_Array,
               output [9:0]  BallX, BallY, BallS,
				   output[31:0]Blocks,
					output Bar_Reset,
					output [1:0] lives);

    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;

    parameter [9:0] Ball_X_Start=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Start=452;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=4;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=635;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=4;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=475;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=2;      // Step size on the X axis
	 parameter [9:0] Ball_X_Step2=2;
    parameter [9:0] Ball_Y_Step=3;      // Step size on the Y axis
	 logic Ball_Reset;
	 logic[9:0] BlockX, BlockY;


    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"


	logic moved;

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Start;
			Ball_X_Pos <= Ball_X_Start;
			Ball_Reset<= 1'b1;
			Bar_Reset <= 1'b1;
			Blocks<=Block_Array;
			moved<=1'b0;
			lives <= 3; /* start with 3 lives */
        end
        else

        begin
				Bar_Reset <= 1'b0;
				moved<=1'b0;
				if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max && ~Ball_Reset)  // Ball is at the bottom edge
				begin
					Ball_Reset<=1'b1 ;
					Ball_Y_Motion <= 10'd0;
				   	Ball_X_Motion <= 10'd0;
					Bar_Reset <= 1'b1;
				   	Ball_Y_Pos <= Ball_Y_Start;
				   	Ball_X_Pos <= BarX;
					moved<=1'b1;
					lives <= lives - 1; /* decrease lives by 1 if reset */
				end


				else if(keycode==8'h2c  && Ball_Reset) //Game start
				begin
				 	Ball_X_Motion <=Ball_X_Step;
				 	Ball_Y_Motion <=-Ball_Y_Step;
				 	Ball_Reset <= 1'b0;
				 	Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				 	Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 	moved<=1'b1;
				end
				else if(Ball_Reset)
				begin
					Ball_Y_Pos <= Ball_Y_Start;
					Ball_X_Pos <= BarX;
					moved<=1'b1;
				 end

				else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min || Ball_X_Pos>700)  // Ball is at the Left edge, BOUNCE!
					begin
					  Ball_X_Motion <= Ball_X_Step;
					  Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					  Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
					  moved<=1'b1;
					end


				else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min || Ball_Y_Pos>700 )  // Ball is at the top edge, BOUNCE!
					begin
						Ball_Y_Motion <= Ball_Y_Step;
						Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
						Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
						moved<=1'b1;
					end


				 else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max)  // Ball is at the Right edge, BOUNCE!
					  begin
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 	  Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
					  moved<=1'b1;

					  end





				 // Collision with the bar
				 else if( (((Ball_X_Pos)<=(BarX+Bar_Sizex)) && ((Ball_X_Pos)>=(BarX-Bar_Sizex))) &&
				 ((Ball_Y_Pos+Ball_Size)>=(BarY-Bar_Sizey)) &&(~Ball_Reset))
				 begin

					Ball_Y_Motion <= ( ~(Ball_Y_Step) + 1'b1);


					if(  Ball_X_Pos>(BarX+(Bar_Sizex>>1))  )
					begin
					Ball_X_Motion <=(Ball_X_Step2);
					end
					else if ((Ball_X_Pos)>=(BarX))
					begin
					Ball_X_Motion <=(Ball_X_Step);
					end
					else if(  Ball_X_Pos < (BarX-(Bar_Sizex>>1))  )
					begin
					Ball_X_Motion <=   (~(Ball_X_Step2)+1'b1);
					end
					else
					begin
					Ball_X_Motion <= ((~Ball_X_Step) + 1'b1 );
					end

				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			   	moved<=1'b1;
			     end



		 // Block interactions:

		for (int i =0; i<32; i++)
		 begin
			  BlockX = (10'b0000000000^((i%8)*80+40));
			  BlockY = (10'b0000000000^(10+20*(i>>3)));



			//Hit the bottom of block
			if(Blocks[i])
			begin
			if(  ((Ball_X_Pos<=(BlockX+Block_SizeX)) && (Ball_X_Pos>=(BlockX-Block_SizeX))) && ((Ball_Y_Pos<=(BlockY+Block_SizeY)) && (Ball_Y_Pos>=((BlockY+Block_SizeY)-Ball_Y_Step))))
			begin
			Ball_Y_Motion <= Ball_Y_Step;
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			moved<=1'b1;
			Blocks[i]<=0;

			end

			// Hit the Top of Brick
			else if(((Ball_X_Pos<=(BlockX+Block_SizeX)) && (Ball_X_Pos>=(BlockX-Block_SizeX))) && ((Ball_Y_Pos>=(BlockY-Block_SizeY)) && (Ball_Y_Pos<=((BlockY-Block_SizeY)+Ball_Y_Step))))
	      begin
			Ball_Y_Motion <= (~(Ball_Y_Step) + 1'b1);
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			moved<=1'b1;
			Blocks[i] <=0;

			end

			//Hit the left of Brick

			else if(((Ball_Y_Pos<=(BlockY+Block_SizeY)) && (Ball_Y_Pos>=(BlockY-Block_SizeY))) && ((Ball_X_Pos>=(BlockX-Block_SizeX)) && (Ball_X_Pos<=((BlockX-Block_SizeX)+Ball_X_Step))))
	      begin

			Ball_X_Motion <= (~(Ball_X_Step) + 1'b1);
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			moved<=1'b1;
			Blocks[i] <=0;

			end

			else if(((Ball_Y_Pos<=(BlockY+Block_SizeY)) && (Ball_Y_Pos>=(BlockY-Block_SizeY))) && ((Ball_X_Pos<=(BlockX+Block_SizeX)) && (Ball_X_Pos>=((BlockX+Block_SizeX)-Ball_X_Step))))
	      begin

			Ball_X_Motion <= Ball_X_Step;
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			moved<=1'b1;
			Blocks[i] <=0;

			end
			end

			end




				if(~moved)

					 begin
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				     Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					  moved<=1'b1;
                end





	    end
    end

    assign BallX = Ball_X_Pos;

    assign BallY = Ball_Y_Pos;

    assign BallS = Ball_Size;


endmodule