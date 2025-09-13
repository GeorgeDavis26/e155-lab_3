// lab3_gd.sv
// top level module for the lab 3 keypad decoder and multiplexing dual  hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module shifter (
    input   [3:0]   col_keys,
    output  [3:0]   col_keys_shifted
);
    if      (col_keys == 4'b1000) assign col_keys_shifted = 4'b0001;
    else    assign col_keys_shifted = col_keys << 1;

endmodule
