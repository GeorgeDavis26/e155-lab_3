// switch_encoder.sv
// multiplexer module that chooses which set of switches to apply to the combinational 
// hexidecimal decoding logic and display out of the single set of GPIO pins
// george davis gdavis@hmc.edu
// 9/4/2025

module switch_mux( 
    input   logic           enable,
    input   logic   [3:0]   sA,
    input   logic   [3:0]   sB,
    output  logic   [3:0]   s
);
    //sets multiplexed wire to input switches depending on enable
	assign s = enable ? (sB) : (sA);

endmodule