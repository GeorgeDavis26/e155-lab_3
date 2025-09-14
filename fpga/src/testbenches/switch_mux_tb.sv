// swtich_encoder_tb.sv
// testbench file for the switch_encoder
// george davis gdavis@hmc.edu
// 8/31/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module switch_mux; 
	
	logic	clk;
	logic	reset;
	
	//input/output variables
    logic           enable;
	logic	[3:0]   sA, sB;
	logic   [3:0]   s, s_expected;

	//32 bit vectornum indicates the number of test vectors applied
	//32 bit errors indicates number of errros found
	logic	[31:0]	vectornum, errors;
	logic	[11:0]	testvectors[10000:0]; //change bit length to match DUT input/output
	
	//instatiate device to be tested
	switch_mux dut(enable, sA, sB, s); //change to DUT input/output

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

	
	initial
		begin
			$readmemb("switch_mux.tv", testvectors); //change to DUT .tv file
			
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
				{sA, sB ,s_expected} = testvectors[vectornum]; //change to DUT input/output
			end
	
    
		always @(negedge clk)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (s != s_expected) begin //change to DUT output
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {in});   //change to DUT input
					$display(" outputs = %b", {out});       //change to DUT output
					errors = errors + 1;
				end

				vectornum = vectornum + 1;
				
				if (testvectors[vectornum] == 12'bX) begin   //change bit length to DUT input/output combined
					$display("%d tests completed with %d errors", vectornum, errors);
					$stop;
				end
			end

endmodule