// seg_storage_fsm.sv
// module to hold the two hex digits to be displayed
// george davis gdavis@hmc.edu
// 9/21/2025

module seg_storage_fsm (
    input   logic           clk, reset,
    input   logic           new_hex, 
    input   logic   [3:0]   hex_R_new,
    output	logic	[3:0]   hex_R, hex_L
);

    typedef enum logic [3:0] {IDLE, NEW_L, NEW_R, WAIT} statetype;
	statetype state, nextstate;

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset) begin
             state <= IDLE;
             interm_hex_L <= 1'h0;
             interm_hex_R <= 1'h0;
        end
        else begin
            state <= nextstate;
            interm_hex_L <= nextinterm_hex_L;
            interm_hex_R <= nextinterm_hex_R;
        end
    end

    //next state logic
    always_comb begin
        case(state)
            IDLE:   if(new_hex)  nextstate = NEW; 
                    else         nextstate = IDLE;
            NEW_L:  begin 
                        nextstate = NEW_R; 
                        nextinterm_hex_L = hex_L; 
                    end
            NEW_R:  begin 
                        nextstate = WAIT;
                        nextinterm_hex_R = hex_R; 
                    end
            WAIT:   if(~new_hex) nextstate = IDLE;
                    else         nextstate = WAIT;
            default: nextstate = IDLE;
        endcase
    end

    assign hex_L = (state == NEW_L) ? interm_hex_R : interm_hex_L;
    assign hex_R = (state == NEW_R) ? new_R_hex : interm_hex_R;

endmodule
