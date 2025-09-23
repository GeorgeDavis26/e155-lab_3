// scanner_fsm.sv
// system verilog module to handle the debouncing of a keypad press
// George Davis
// gdavis@hmc.edu
// 9/17/25


module debouncer_fsm(
    input   logic           clk, reset,
    input   logic   [3:0]   q_row_keys,
    output  logic           button_pressed, new_hex
);  
    logic   [3:0]   pressed_row, next_pressed_row;

    typedef enum logic [3:0] {IDLE, PRESSED, STORE, WAIT, CHECK, DRIVE, HOLD} statetype;
	statetype state, nextstate;

    logic   alarm;
    logic 	[31:0]	goal = 'd4800;

    divider divider(clk, reset, goal, alarm);

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset) begin
             state <= IDLE;
             pressed_row <= 4'b0000;
        end
        else begin
            state <= nextstate;
            pressed_row <= next_pressed_row;
        end
    end

    // next state logic
    always_comb begin
        case(state)
            IDLE:   if (q_row_keys != 4'b0000) begin 
                        nextstate = WAIT; //go to debouncing stall
                        next_pressed_row = q_row_keys;
                    end 
                    else begin 
                        nextstate = IDLE; //loop since no button was pressed
                        next_pressed_row =  4'b0000;
                    end
            PRESSED:begin 
                        nextstate = STORE;
                        next_pressed_row = pressed_row;
                    end
            STORE:  begin 
                        nextstate = WAIT;
                        next_pressed_row = pressed_row;
                    end
            WAIT:   if (alarm) begin 
                        nextstate = CHECK; //go to check state to ensure debouncing succeeded
                        next_pressed_row = pressed_row;
                    end
                    else begin 
                        nextstate = WAIT;
                        next_pressed_row = pressed_row;
                    end
            CHECK:  if (q_row_keys == pressed_row) begin
                        nextstate = DRIVE; //check to make sure the key hasn't changed ie. debouncing wasn't from a phantom press
                        next_pressed_row = pressed_row;
                    end
                    else begin
                        nextstate = IDLE; //go back to idle if the debouncer failed
                        next_pressed_row = pressed_row;
                    end
            DRIVE:  begin 
                        nextstate = HOLD;
                        next_pressed_row = pressed_row;
                    end 
            HOLD:   if (q_row_keys == 4'b0000) begin
                        nextstate = IDLE; //go to IDLE if button is unpressed
                        next_pressed_row = pressed_row;
                    end
                    else begin 
                        nextstate = HOLD; // loop on hold if the button is still held
                        next_pressed_row = pressed_row;
                    end
            default:begin   nextstate = IDLE;
                            next_pressed_row = pressed_row;
                    end
        endcase
    end


    // new module that handles shifting R to L

    //output logic
    assign button_pressed = (state == IDLE) ? 0 : 1;
    assign new_hex = (state == DRIVE) ? 1 : 0;
endmodule