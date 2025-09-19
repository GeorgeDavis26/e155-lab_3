// keypad_decoder_tb.sv
// keypad_decoder testbench file
// george davis gdavis@hmc.edu
// 8/31/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module keypad_decoder_tb;
	
	logic	clk;
	logic	reset;
	
	//input/output variables
	logic	[3:0] row_keys, col_keys;   //change to DUT input
	logic   [3:0] hex_R, hex_R_expected;  //change to DUT output

    logic	[31:0]	vectornum, errors;
	logic	[11:0]	testvectors[10000:0]; //change bit length to match DUT input/output

    keypad_decoder dut(row_keys, col_keys, hex_R);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end


    initial 
		begin
			$readmemb("keypad_decoder.tv", testvectors);
			
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
				{row_keys, col_keys, hex_R_expected} = testvectors[vectornum];
			end


		always @(negedge clk)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (hex_R != hex_R_expected) begin
					//display input/outputs that generated the error
					$error("Error: inputs = %b", {row_keys, col_keys});
					$error(" outputs = %b", {hex_R});
					errors = errors + 1;
				end

				vectornum = vectornum + 1;
				
				if (testvectors[vectornum] == 12'bX) begin 
					$error("%d tests completed with %d errors", vectornum, errors);
					$stop;
				end
			end


endmodule