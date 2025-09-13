// seven_seg_disp_tb.sv
// seven_seg_disp testbench file 
// george davis gdavis@hmc.edu
// 8/31/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module seven_seg_disp_tb;
	
	logic	clk;
	logic	reset;
	
	//input/output variables
	logic	[3:0] s;  
	logic   [6:0] seg, seg_expected;


	//32 bit vectornum indicates the number of test vectors applied
	//32 bit errors indicates number of errros found
	logic [31:0]	vectornum, errors;
	logic [10:0]	testvectors[10000:0]; 
	
	//instatiate device to be tested
	seven_seg_disp dut(s, seg);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

	
	initial
		begin
			$readmemb("seven_seg_disp.tv", testvectors); 
			
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
				{s,seg_expected} = testvectors[vectornum];
			end
	
    
		always @(negedge clk)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (seg != seg_expected) begin
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {s});
					$display(" outputs = %b", {seg});
					errors = errors + 1;
				end

				vectornum = vectornum + 1;
				
				if (testvectors[vectornum] == 11'bX) begin
					$display("%d tests completed with %d errors", vectornum, errors);
					$stop;
				end
			end

endmodule