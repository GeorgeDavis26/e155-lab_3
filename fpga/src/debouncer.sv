// debouncer.sv
// module to handle the wait time necessary to accurately read a push button
// george davis gdavis@hmc.edu
// 9/10/2025

module debouncer (
    input   [21:0]	counter_in,
    output	[21:0]	counter_out,
    output  		alarm
);

	if(counter_in == 'd2400000) begin //flips on after 20 ms
		alarm  = ~alarm;		//flip alarm
		counter_out = 0;		//reset counter
		end
	else counter_out = counter_in + 1;
    
endmodule
