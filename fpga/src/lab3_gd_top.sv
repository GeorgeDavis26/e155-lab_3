// lab3_gd_top.sv
// top level module for the lab 3 keypad decoder and multiplexing dual hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module lab3_gd_top (
//    input   logic           clk, //uncomment for sims
    input   logic           reset,
    input   logic   [3:0]   row_keys,
    output  logic   [1:0]   control,
	output	logic   [6:0]   seg,
    output  logic   [3:0]   col_keys
);

    logic           button_pressed, clk;
    logic   [3:0]   q_row_keys, hex_R_out; 
    logic   [3:0]   hex_R = 4'b0010;
    logic   [3:0]   hex_L = 4'b0001;


	// Internal 48MHz high-speed oscillator
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk)); 

    debouncer_fsm debouncer_fsm(clk, reset, q_row_keys, button_pressed, new_hex);

    seg_storage_fsm seg_storage_fsm(new_hex, hex_R_new, hex_R, hex_L);
	
    sync    sync(clk, row_keys, q_row_keys);

    scanner_fsm scanner_fsm(clk, reset, button_pressed, col_keys);

    keypad_decoder   keypad_decoder(q_row_keys, col_keys, hex_R_new);
   
    multiplexed_seven_seg multiplexed_seven_seg(clk, hex_L, hex_R, control, seg);
    
endmodule


//YOU GOT THIS!!!