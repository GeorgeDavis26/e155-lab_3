// lab2_gd_tb.sv
// test bench file for top level module for lab 2 project
// george davis gdavis@hmc.edu
// 8/31/2025

//Referenced E85 Lab_2 testbench provided tutorial by david harris to make this file

	`timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module lab2_gd_tb;
	logic	clk;
	logic	reset;
	
	//input/output variables
	logic	[3:0] sA, sB;
    logic   [1:0] control, control_expected;
	logic   [6:0] seg, seg_expected;
	logic	[4:0] led;

	//32 bit vectornum indicates the number of test vectors applied
	//32 bit errors indicates number of errros found
	logic	[31:0]	vectornum_A, vectornum_B, errors_A, errors_B, errors_led;
	logic	[16:0]	testvectors_A[10000:0], testvectors_B[10000:0];
	
	//instatiate device to be tested
	top dut(clk, sA, sB, control, seg, led);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

	
	initial
		begin
			$readmemb("lab2_gd_segA.tv", testvectors_A);
			$readmemb("lab2_gd_segB.tv", testvectors_B);

			//Initialize 0 vectors tested and errors
			vectornum_A = 0;
			vectornum_B = 0;
			errors_A = 0; 
			errors_B = 0; 
			errors_led = 0; 

			//Pulse reset to begin test
			reset <= 1; # 22; reset <= 0;
		end

		// Simple clock divider down to 60 Hz from 12MHz pin 41
		always @(posedge clk, reset)
			begin
				if(reset) counter = 0; 
				else if(counter == 'd100000) begin
					enable  = ~enable;	//flip enable
					counter = 0;		//reset counter
					end
				else counter = counter + 1;
			end

		//checking outputs for posedge of enable
		//segment B should be driving
		always @(posedge enable)
			begin
				#1;
				//loads test vectors into inputs and expected outputs
				{sA, sB, control_expected, seg_expected, led_expected} = testvectors_B[vectornum_B]; //change to DUT input/output
			end

		always @(negedge enable)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (control != control_expected || seg != seg_expected || led != led_expected) begin 
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {sA, sB});   
					$display(" outputs = %b", {control, seg, led}); 
					errors_B = errors_B + 1;
				end
				sB = sB + 4'b0001;
				vectornum_B = vectornum_B + 1;
				
				if (testvectors_B[vectornum_B] == 17'bX) begin   //change bit length to DUT input/output combined
					$display("%d tests completed for segment B with %d errors", vectornum_B, errors_B);
					//$stop;
				end
			end


		//checking outputs for negedge of enable
		//segment A should be driving
		always @(negedge enable)
			begin
				#1;
				//loads test vectors into inputs and expected outputs
				{sA, sB, control_expected, seg_expected, led_expected} = testvectors_A[vectornum_A]; //change to DUT input/output
			end

		always @(posedge enable)
			if(~reset) begin
				//detect error by comparing actual output expected output from testvectors
				if (control != control_expected || seg != seg_expected || led != led_expected) begin 
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {sA, sB});   
					$display(" outputs = %b", {control, seg, led}); 
					errors_A = errors_A + 1;
				end
				sB = sB + 4'b0001;
				vectornum_B = vectornum_B + 1;
				
				if (testvectors_B[vectornum_B] == 17'bX) begin   //change bit length to DUT input/output combined
					$display("%d tests completed for segment A with %d errors", vectornum_A, errors_A);
					//$stop;
				end
			end

		//testing scheme to check led functionality
		begin
			for(sA = 4'b0000; sA < 4'b1111; sA = sA + 4'b0001)/
				for(sB = 4'b0000; sA < 4'b1111; sA = sA + 4'b0001)
					led_expected = sA + sB;
					if(led != led_expected) begin
					//display input/outputs that generated the error
					$display("Error: inputs = %b", {sA, sB});   
					$display(" outputs = %b", {control, seg, led}); 
					errors_led = errors_led + 1;
					end
		$display("%d led tests completed with %d errors", (sA * sB), errors_led);
		$stop
endmodule 