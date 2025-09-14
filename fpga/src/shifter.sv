// lab3_gd.sv
// top level module for the lab 3 keypad decoder and multiplexing dual  hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module shifter (
    input   logic 	[3:0]   col_keys,
    output	logic	[3:0]   col_keys_shifted
);

always_comb begin
    if      (col_keys == 4'b1000) col_keys_shifted = 4'b0001;
    else     col_keys_shifted = col_keys << 1;
end
endmodule
