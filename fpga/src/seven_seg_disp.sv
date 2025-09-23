// seven_seg_disp.sv
// encodes a 7 segment display to show the first 16 Hexidecimal Digits
// george davis gdavis@hmc.edu
// 8/30/2025

module seven_seg_disp (
	input	logic [3:0] s,
	output	logic [6:0] seg
);
    logic	[6:0]	seg_state;
	always_comb begin
		case(s)
			4'b0000:    seg_state = 7'b1000000; //Display Hex 0    
			4'b0001:    seg_state = 7'b1111001; //Display Hex 1
			4'b0010:    seg_state = 7'b0100100; //Display Hex 2 
			4'b0011:    seg_state = 7'b0110000; //Display Hex 3 
			4'b0100:    seg_state = 7'b0011001; //Display Hex 4 
			4'b0101:    seg_state = 7'b0010010; //Display Hex 5 
			4'b0110:    seg_state = 7'b0000010; //Display Hex 6 
			4'b0111:    seg_state = 7'b1111000; //Display Hex 7 
			4'b1000:    seg_state = 7'b0000000; //Display Hex 8 
			4'b1001:    seg_state = 7'b0011000; //Display Hex 9 
			4'b1010:    seg_state = 7'b0001000; //Display Hex A 
			4'b1011:    seg_state = 7'b0000011; //Display Hex B 
			4'b1100:    seg_state = 7'b1000110; //Display Hex C 
			4'b1101:    seg_state = 7'b0100001; //Display Hex D 
			4'b1110:    seg_state = 7'b0000110; //Display Hex E
			4'b1111:    seg_state = 7'b0001110; //Display Hex F 
			default:    seg_state = 7'b1000000; //Default to all LEDs off
    endcase
	end

    assign seg = seg_state;
endmodule