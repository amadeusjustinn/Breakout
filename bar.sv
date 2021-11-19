// modified from provided Bar.sv

module  bar ( input Reset, frame_clk, Ball_out,
					input [7:0] keycode,
               output [9:0]  BarX, BarY, Bar_Sizex, Bar_Sizey);

    logic [9:0] Bar_X_Pos, Bar_X_Motion, BarSizex,BarSizey;

    parameter [9:0] Bar_X_Begin=320;  // Center position on the X axis
    parameter [9:0] Bar_Y_Begin=460;  // Center position on the Y axis
    parameter [9:0] Bar_X_Min=10;       // Leftmost point on the X axis
    parameter [9:0] Bar_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bar_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bar_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bar_X_Step=2;      // Step size on the X axis


	assign BarSizex = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign BarSizey = 3;

		  
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bar
        if (Reset)  // Asynchronous Reset
        begin
				Bar_X_Motion <= 10'd0; //Bar_X_Step;
				Bar_X_Pos <= Bar_X_Begin;
        end
		  else if(keycode == 10'd0)
		  begin
		  Bar_X_Motion <= 10'd0;
		  end
		  else if(Ball_out)
		  Bar_X_Pos = Bar_X_Begin;

        else
        begin

				if ( (Bar_X_Pos + BarSizex) >= Bar_X_Max )  // Bar is at the Right edge, BOUNCE!
					  Bar_X_Motion <= 0;  // 

				 else if ( (Bar_X_Pos - BarSizex) <= Bar_X_Min )  // Bar is at the Left edge, BOUNCE!
					  Bar_X_Motion <= 0;




				 case (keycode)
					8'h04 : begin // A
									Bar_X_Motion <= -Bar_X_Step;
								end
							  

					8'h07 : begin // D

					        Bar_X_Motion <=Bar_X_Step;
							  end



					default: Bar_X_Motion <=0;
			   endcase

			// Update Bar position
			if(((Bar_X_Pos + Bar_X_Motion+ BarSizex)<=Bar_X_Max) && ((Bar_X_Pos + Bar_X_Motion-BarSizex)>= Bar_X_Min))
				 Bar_X_Pos <= (Bar_X_Pos + Bar_X_Motion);




		end
    end

    assign BarX = Bar_X_Pos;

    assign BarY = Bar_Y_Begin;
	 
	 assign Bar_Sizey = BarSizey ;
	 
	 assign Bar_Sizex = BarSizex;
	 
	 


endmodule
