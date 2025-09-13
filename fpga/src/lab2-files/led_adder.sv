// led_adder.sv
// adds two 4 binary numbers and outputs the sum as a 5 binary bit number
// george davis gdavis@hmc.edu
// 9/8/2025	
    
module led_adder(
    input   logic   [3:0]   sA, sB,
    output  logic   [4:0]   led
);
    // Five bit adder 
	assign led = {1'b0,sA} + {1'b0,sB};

endmodule