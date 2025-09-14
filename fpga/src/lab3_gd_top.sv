// lab3_gd_top.sv
// top level module for the lab 3 keypad decoder and multiplexing dual hexidecimal display
// george davis gdavis@hmc.edu
// 9/10/2025

module lab3_gd_top (
    input   logic   [3:0]   row_keys,
    output  logic   [1:0]   control,
	output	logic   [6:0]   seg,
    output  logic   [3:0]   col_keys
);

    logic           alarm = 0, button_pressed = 0, reset;
    logic   [3:0]   pressed_row, d_mid, q_row_keys; 
    logic   [3:0]   hex_R = 4'b0010;
    logic   [3:0]   hex_L = 4'b0001;

	// Internal 48MHz high-speed oscillator
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

	typedef enum logic [3:0] {IDLE, WAIT, CHECK, DRIVE, HOLD} statetype;
	statetype state, nextstate;
	
    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= nextstate;
    end

    always_comb begin
        case(state)
            IDLE:   if (q_row_keys != 4'b0000) begin // button was pressed
						button_pressed = 1;
                        pressed_row = q_row_keys; //store the pressed row to check later
                        nextstate = WAIT; //go to debouncing stall
                        end
                    else begin
                        col_keys = col_keys_shifted; //set the output variable to the left shifted 4 bit binary number
                        nextstate = IDLE; //loop since no button was pressed
                    end
            WAIT:   if (alarm) begin //flips on after 20 ms
						button_pressed = 0;
                        nextstate = CHECK; //go to check state to ensure debouncing successed
                    end
                    else nextstate = WAIT;
            CHECK:  if (q_row_keys == pressed_row) begin //check to make sure the key hasn't changed ie. debouncing wasn't from a phantom press
                        nextstate = DRIVE; //go to drive state
                    end
                    else nextstate = IDLE; //go back to idle if the debouncer failed
            DRIVE:  begin 
					hex_L = hex_R;
                    hex_R = hex_R_out;
                    nextstate = HOLD;
					end
            HOLD:   if (q_row_keys == 4'b0000)   nextstate = IDLE; //go to IDLE if button is unpressed
                    else nextstate = HOLD; // loop on hold if the button is still held
        endcase
    end
	
    sync    sync(clk, row_keys, q_row_keys);

    shifter shifter(col_keys, col_keys_shifted);

    keypad_decoder   keypad_decoder(q_row_keys, col_keys, hex_R_out);

    debouncer  debouncer(clk, button_pressed, alarm);
   
    multiplexed_seven_seg multiplexed_seven_seg(clk, hex_R, hex_L, control, seg); //display the two hex numbers stored
    
endmodule