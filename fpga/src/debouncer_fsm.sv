// scanner_fsm.sv
// system verilog module to handle the debouncing of a keypad press
// George Davis
// gdavis@hmc.edu
// 9/17/25


module debouncer_fsm(
    input   logic           clk, reset,
    input   logic   [3:0]   q_row_keys, hex_R_out,
    output  logic           button_pressed,
    output  logic   [3:0]   hex_R, hex_L
);  
    logic   [3:0]   pressed_row;

    typedef enum logic [3:0] {IDLE, PRESSED, STORE, WAIT, CHECK, DRIVE_L, DRIVE_R, HOLD} statetype;
	statetype state, nextstate;

    logic   alarm = 0;
    logic 	[31:0]	goal = 'd1200;

    divider divider(clk, reset, goal, alarm);

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= nextstate;
    end


    // next state logic
    always_comb begin
        case(state)
            IDLE:   if (q_row_keys != 4'b0000) nextstate = WAIT; //go to debouncing stall
                    else nextstate = IDLE; //loop since no button was pressed
            PRESSED: nextstate = STORE;
            STORE:   nextstate = WAIT;
            WAIT:   if (alarm) nextstate = CHECK; //go to check state to ensure debouncing successed
                    else nextstate = WAIT;
            CHECK:  if (q_row_keys == pressed_row) nextstate = DRIVE_L; //check to make sure the key hasn't changed ie. debouncing wasn't from a phantom press
                    else nextstate = IDLE; //go back to idle if the debouncer failed
            DRIVE_L:  nextstate = DRIVE_R;
            DRIVE_R:  nextstate = HOLD;
            HOLD:   if (q_row_keys == 4'b0000) nextstate = IDLE; //go to IDLE if button is unpressed
                    else nextstate = HOLD; // loop on hold if the button is still held
            default:    nextstate = IDLE;
        endcase
    end

    //output logic
    always_comb begin
        case(state)
            IDLE:    button_pressed = 0;
            PRESSED: button_pressed = 1;
            STORE:   pressed_row = q_row_keys; //store the pressed row to check later
            DRIVE_L: hex_L = hex_R; 
            DRIVE_R: hex_R = hex_R_out;
        endcase
    end
endmodule