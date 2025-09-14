// shifter.sv
// testbench file for the shifter module
// george davis gdavis@hmc.edu
// 9/13/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module shifter_tb;
	
	logic	clk;
	logic	reset;
	
	//input/output variables
	logic	[3:0] col_keys;
	logic   [3:0] col_keys_shifted, col_keys_shifted_expected;

	//32 bit vectornum indicates the number of test vectors applied
	//32 bit errors indicates number of errros found
	logic	[31:0]	vectornum, errors;
	logic	[5:0]	testvectors[10000:0]; //change bit length to match DUT input/output
	
	//instatiate device to be tested
	shifter dut(col_keys, col_keys_shifted);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

	
	initial
		begin
			$readmemb("shifter.tv", testvectors); //change to DUT .tv file
			
			//Initialize 0 vectors tested and errors
			vectornum = 0;
			errors = 0; 
			
			//Pulse reset to begin test
			reset <= 1; # 22; reset <= 0;
		end

	  	//Check test vectors at the falling edge of the clock 
		always @(posedge clk)
			begin
				#1;
				//loads test vectors into inputs and expected outputs
				{col_keys, col_keys_shifted_expected} = testvectors[vectornum]; //change to DUT input/output
			end
	
    
		always @(negedge clk)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (col_keys_shifted != col_keys_shifted_expected) begin
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {col_keys});
					$display(" outputs = %b", {col_keys_shifted});
					errors = errors + 1;
				end

				vectornum = vectornum + 1;
				
				if (testvectors[vectornum] == 8'bX) begin   //change bit length to DUT input/output combined
					$display("%d tests completed with %d errors", vectornum, errors);
					$stop;
				end
			end

endmodule