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
               output [9:0]  BallX, BallY, BallS, 
					output Bar_Reset );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Start=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Start=452;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=2;      // Step size on the Y axis
	 logic Ball_Reset;

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
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
        end  
        else 
        begin
				Bar_Reset <= 1'b0;
				if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max && ~Ball_Reset)  // Ball is at the bottom edge, BOUNCE!
				begin
					  Ball_Reset<=1'b1 ;  // 2's complement.
					Ball_Y_Motion <= 10'd0; 
				   Ball_X_Motion <= 10'd0; 
					Bar_Reset <= 1'b1;
					end
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
					  
				 else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;
				 else if(keycode==8'h2c  && Ball_Reset) //Game start
				 begin
				 Ball_X_Motion <=1;
				 Ball_Y_Motion <=-Ball_Y_Step;
				 Ball_Reset <= 1'b0;
				 end
				 else if(Ball_Reset)
				begin
					Ball_Y_Pos <= Ball_Y_Start;
					Ball_X_Pos <= BarX;
				 end
				 
				 // Collision with the bar
				 else if( (((Ball_X_Pos)<=(BarX+Bar_Sizex)) && ((Ball_X_Pos)>=(BarX-Bar_Sizex))) &&
				 ((Ball_Y_Pos+Ball_Size)>=(BarY-Bar_Sizey)) )
				 begin
					Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
					end

				 else 
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				
				 
				 if(~Ball_Reset)
				 begin
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 end
			
	 end
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
