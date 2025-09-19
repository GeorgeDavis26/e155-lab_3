// shifter.sv
// module to left shift a 4 bit binary number in a cyclical pattern 
// george davis gdavis@hmc.edu
// 9/10/2025

module scanner_fsm (
    input   logic           clk, reset, button_pressed, 
    output	logic	[3:0]   col_keys
);

    typedef enum logic [3:0] {S0, S1, S2, S3} statetype;
	statetype state, nextstate;

    logic   enable = 0;
    logic 	[31:0]	goal = 'd50;

    divider divider(clk, reset, goal, enable);

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= nextstate;
    end

    //next state logic

    always_comb begin
        case(state)
            S0: if (enable && (button_pressed == 0)) nextstate = S1;
                else nextstate = S0;
            S1: if (enable && (button_pressed == 0)) nextstate = S2;
                else nextstate = S1;
            S2: if (enable && (button_pressed == 0)) nextstate = S3;
                else nextstate = S2;
            S3: if (enable && (button_pressed == 0)) nextstate = S0;
                else nextstate = S3;
            default: nextstate = S0;
        endcase

    end

    // output logic

    always_comb begin
        case(state)
            S0:         col_keys = 4'b0001;
            S1:         col_keys = 4'b0010;
            S2:         col_keys = 4'b0100;
            S3:         col_keys = 4'b1000;
            default:    col_keys = 4'b0001;
        endcase
    end

/*    
    if      (col_keys == 4'b1000)   col_keys_shifted = 4'b0001;
        else if      (col_keys == 4'b0100)   col_keys_shifted = 4'b1000;
        else if      (col_keys == 4'b0010)   col_keys_shifted = 4'b0100;
        else if      (col_keys == 4'b0001)   col_keys_shifted = 4'b0010;
        else                            col_keys_shifted = 4'b0001; //if something goes wrong default to col 0
*/

endmodule
