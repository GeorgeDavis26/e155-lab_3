// swtich_mux_tb.sv
// testbench file for the switch_encoder
// george davis gdavis@hmc.edu
// 8/31/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module switch_mux_tb; 
	
	//input/output variables
    logic           enable;
	logic	[3:0]   sA, sB;
	int     		a, b;
	logic   [3:0]   s;

	//32 bit vectornum indicates the number of test vectors applied
	//32 bit errors indicates number of errros found
	logic	[31:0] errors;
	
	//instatiate device to be tested
	switch_mux dut(enable, sA, sB, s); 

	initial
		errors = 0;

		for (a = 0; a < 16; a = a + 1) begin
			for(b = 0; b < 16; b = b + 1)begin

				sA = a;
				sB = b;
				#1
				enable = 0;
				assert(s == sA) else begin
					$error("Error: inputs = %b", {sA, sB}); 
					$error(" outputs = %b", {s});
					errors = errors + 1;
				end
				#5
				enable = 1;
				assert(s == sB) else begin
					$error("Error: inputs = %b", {sA, sB}); 
					$error(" outputs = %b", {s});
					errors = errors + 1;
				end
				#4

				if(a == 15 && b == 15)begin
					$error("%d tests completed with %d errors", (a*b), errors);
					$stop;
				end
			end
		end

endmodule