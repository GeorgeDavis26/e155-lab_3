// lab3_gd_top.sv
// top level module for the lab 3 keypad decoder and multiplexing dual hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module lab3_gd_top (
    input   logic           rst,
    input   logic   [3:0]   row_keys,
    output  logic   [1:0]   control,
	output	logic   [6:0]   seg,
    output  logic   [3:0]   col_keys
);

    logic           clk;
    logic           button_pressed, new_hex;
    logic   [3:0]   hex_R_new, q_row_keys, pressed_row; 
    logic   [3:0]   hex_R, hex_L;

    logic           reset;
    
    assign reset = ~rst;


	// Internal 48MHz high-speed oscillator
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk)); //works

    scanner_fsm scanner_fsm(clk, reset, button_pressed, col_keys);


    sync    sync(clk, row_keys, q_row_keys);
/*/
    // pressed row register
    always_ff @(posedge clk, reset) begin
        if (reset || ~button_pressed) pressed_row = 4'b0000;
        else if (q_row_keys != 4'b0000) pressed_row = q_row_keys; 
    end
/*/
    debouncer_fsm debouncer_fsm(clk, reset, q_row_keys, button_pressed, new_hex, pressed_row); //
    keypad_decoder   keypad_decoder(pressed_row, col_keys, hex_R_new);
   
    //seg R and L register
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset) begin
             hex_R <= 4'b0000;
             hex_L <= 4'b0000;
        end
        else if(new_hex) begin
            hex_L <= hex_R;
            hex_R <= hex_R_new;
        end
    end

    multiplexed_seven_seg multiplexed_seven_seg(clk, hex_L, hex_R, control, seg);
    
endmodule


//YOU GOT THIS!!!