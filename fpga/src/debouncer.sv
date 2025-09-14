// debouncer.sv
// module to handle the wait time necessary to accurately read a push button
// george davis gdavis@hmc.edu
// 9/10/2025

module debouncer (
	input	logic 	clk, reset, 
    output  logic 	alarm
);
	
	logic	[21:0]	counter = 0;

	always_ff @(posedge clk, posedge reset)
	begin
		if (reset) counter = 0;
		else if(counter == 'd2400000) begin //flips on after 20 ms
			alarm = ~alarm;		//flip alarm
			counter = 0;		//reset counter
			end
		else counter = counter + 1;
	end
    
endmodule


// language server "verilator"