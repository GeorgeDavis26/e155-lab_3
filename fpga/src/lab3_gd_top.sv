// lab3_gd_top.sv
// top level module for the lab 3 keypad decoder and multiplexing dual  hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module lab3_gd_top (
    input   logic   [3:0]   row_keys,
    output  logic   [1:0]   control,
	output	logic   [6:0]   seg,
    output  logic   [3:0]   col_keys
);

    logic           alarm = 0,
    logic   [3:0]   pressed_row, d_mid; 
    logic   [3:0]   hex_R = 4'b0010;
    logic   [3:0]   hex_L = 4'b0001;
    input   [21:0]	counter_in = 0;
    output	[21:0]	counter_out = 0;

	// Internal 48MHz high-speed oscillator
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

	typedef enum logic [3:0] {IDLE, WAIT, CHECK, DRIVE, HOLD} statetype;
	statetype state, nextstate;
	
    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= nextstate;
    end

    //double ff synchronizer adapted from prof. brake's lecture notes
    always_ff @(posedge clk)
    begin
        d_mid <= row_keys;
        q_keys <= d_mid;
    end 

    always_comb begin
        case(state)
            IDLE:       if (q_keys != 4'b0000) begin // button was pressed
                            pressed_row = q_keys; //store the pressed row to check later
                            nextstate = WAIT; //go to debouncing stall
                        end
                        else begin
                            shifter shifter(col_keys, col_keys_shifted); //move to check the next column
                            col_keys = col_keys_shifted; //set the output variable to the left shifted 4 bit binary number
                            nextstate = IDLE; //loop since no button was pressed
                        end
            WAIT:       debouncer debouncer(counter_in, counter_out, alarm); //stall for 20ms
                        counter_in = counter_out;
                        if (alarm) begin //flips on after 20 ms
                            alarm = ~alarm;	//filp the alarm back to be used on the next time around
                            nextstate = CHECK; //go to check state to ensure debouncing successed
                        end
                        else nextstate = WAIT;
            CHECK:   if (q_keys = pressed_row) begin //check to make sure the key hasn't changed ie. debouncing wasn't from a phantom press
                            next_state = HOLD; //go to drive state
                        end
                        else next_state = IDLE; //go back to idle if the debouncer failed
            SYNC:    synchronizer synchronizer( )
            DRIVE:      hex_L = hex_R;
                        row_col_decoder row_col_decoder(q_keys, col_keys, hex_R_out) //decode the row that was shorted and col that was set high
                        hex_R = hex_R_out;
            HOLD:   if (q_keys == 4'b0000) next_state = IDLE; //go to IDLE
                    else next_state = DRIVE; // go back to drive if the button is still held
        endcase
    end

    //output logic
    multiplexed_seven_seg multiplexed_seven_seg(clk, hex_R, hex_L, control, seg); //display the two hex numbers stored
    
endmodule