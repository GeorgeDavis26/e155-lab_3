// debouncer.sv
// module to handle the wait time necessary to accurately read a push button
// george davis gdavis@hmc.edu
// 9/10/2025

module divider (
	input	logic 			clk, reset,
	input	logic 	[31:0]	goal,
    output  logic 			alarm
);
	
	logic	[31:0]	counter = 0;

	always_ff @(posedge clk, posedge reset)
		begin
			if (reset) begin counter = 0; alarm = 0; end
			else if(counter == goal) begin // begin counter <= next_count; enable <= next_enable end
				alarm = ~alarm;		//flip alarm
				counter = 0;		//reset counter
				end
			else counter = counter + 1;
		end
    
// assign next_count = counter=='d500 ? 0 : counter + 1;
// assign next_enable = counter=='d500 ? ~enable : enable;

endmodule


// language server "verilator"