// shifter.sv
// module to left shift a 4 bit binary number in a cyclical pattern 
// george davis gdavis@hmc.edu
// 9/10/2025

module shifter (
    input   logic 	[3:0]   col_keys,
    output	logic	[3:0]   col_keys_shifted
);

//effectively         col_keys_shifted = col_keys << 1;
// but built to withstand non-onehot encoded inputs
always_comb begin
    if      (col_keys == 4'b1000)   col_keys_shifted = 4'b0001;
    if      (col_keys == 4'b0100)   col_keys_shifted = 4'b1000;
    if      (col_keys == 4'b0010)   col_keys_shifted = 4'b0100;
    if      (col_keys == 4'b0001)   col_keys_shifted = 4'b0010;
    else                            col_keys_shifted = 4'b0001; //if something goes wrong default to row 0
end

endmodule
