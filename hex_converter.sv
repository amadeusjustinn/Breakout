module hex_converter(input [15:0] in,
							output logic [7:0] out_th, out_hu, out_te, out_on
							);

	logic [31:00] temp;
	always_comb
	begin
		temp = 32'h0;
		case(in[3:0])
			4'h0 : temp[7:0] = 8'h30; // 0
			4'h1 : temp[7:0] = 8'h31; // 1
			4'h2 : temp[7:0] = 8'h32; // 2
			4'h3 : temp[7:0] = 8'h33; // 3
			4'h4 : temp[7:0] = 8'h34; // 4
			4'h5 : temp[7:0] = 8'h35; // 5
			4'h6 : temp[7:0] = 8'h36; // 6
			4'h7 : temp[7:0] = 8'h37; // 7
			4'h8 : temp[7:0] = 8'h38; // 8
			4'h9 : temp[7:0] = 8'h39; // 9
			4'ha : temp[7:0] = 8'h41; // A
			4'hb : temp[7:0] = 8'h42; // B
			4'hc : temp[7:0] = 8'h43; // C
			4'hd : temp[7:0] = 8'h44; // D
			4'he : temp[7:0] = 8'h45; // E
			4'hf : temp[7:0] = 8'h46; // F
			default: ;
		endcase

		case(in[7:4])
			4'h0 : temp[15:8] = 8'h30; // 0
			4'h1 : temp[15:8] = 8'h31; // 1
			4'h2 : temp[15:8] = 8'h32; // 2
			4'h3 : temp[15:8] = 8'h33; // 3
			4'h4 : temp[15:8] = 8'h34; // 4
			4'h5 : temp[15:8] = 8'h35; // 5
			4'h6 : temp[15:8] = 8'h36; // 6
			4'h7 : temp[15:8] = 8'h37; // 7
			4'h8 : temp[15:8] = 8'h38; // 8
			4'h9 : temp[15:8] = 8'h39; // 9
			4'ha : temp[15:8] = 8'h41; // A
			4'hb : temp[15:8] = 8'h42; // B
			4'hc : temp[15:8] = 8'h43; // C
			4'hd : temp[15:8] = 8'h44; // D
			4'he : temp[15:8] = 8'h45; // E
			4'hf : temp[15:8] = 8'h46; // F
			default: ;
		endcase

		case(in[11:8])
			4'h0 : temp[23:16] = 8'h30; // 0
			4'h1 : temp[23:16] = 8'h31; // 1
			4'h2 : temp[23:16] = 8'h32; // 2
			4'h3 : temp[23:16] = 8'h33; // 3
			4'h4 : temp[23:16] = 8'h34; // 4
			4'h5 : temp[23:16] = 8'h35; // 5
			4'h6 : temp[23:16] = 8'h36; // 6
			4'h7 : temp[23:16] = 8'h37; // 7
			4'h8 : temp[23:16] = 8'h38; // 8
			4'h9 : temp[23:16] = 8'h39; // 9
			4'ha : temp[23:16] = 8'h41; // A
			4'hb : temp[23:16] = 8'h42; // B
			4'hc : temp[23:16] = 8'h43; // C
			4'hd : temp[23:16] = 8'h44; // D
			4'he : temp[23:16] = 8'h45; // E
			4'hf : temp[23:16] = 8'h46; // F
			default: ;
		endcase

		case(in[15:11])
			4'h0 : temp[31:24] = 8'h30; // 0
			4'h1 : temp[31:24] = 8'h31; // 1
			4'h2 : temp[31:24] = 8'h32; // 2
			4'h3 : temp[31:24] = 8'h33; // 3
			4'h4 : temp[31:24] = 8'h34; // 4
			4'h5 : temp[31:24] = 8'h35; // 5
			4'h6 : temp[31:24] = 8'h36; // 6
			4'h7 : temp[31:24] = 8'h37; // 7
			4'h8 : temp[31:24] = 8'h38; // 8
			4'h9 : temp[31:24] = 8'h39; // 9
			4'ha : temp[31:24] = 8'h41; // A
			4'hb : temp[31:24] = 8'h42; // B
			4'hc : temp[31:24] = 8'h43; // C
			4'hd : temp[31:24] = 8'h44; // D
			4'he : temp[31:24] = 8'h45; // E
			4'hf : temp[31:24] = 8'h46; // F
			default: ;
		endcase

	end

	assign out_th = temp[31:24];
	assign out_hu = temp[23:16];
	assign out_te = temp[15:08];
	assign out_on = temp[07:00];

endmodule