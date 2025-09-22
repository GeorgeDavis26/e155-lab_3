// shifter.sv
// module to left Shift a 4 bit binary number in a cyclical pattern 
// george davis gdavis@hmc.edu
// 9/10/2025

module scanner_fsm (
    input   logic           clk, reset, button_pressed, 
    output	logic	[3:0]   col_keys
);

    typedef enum logic [3:0] {S0, S1, S2, S3, S0A, S1A, S2A, S3A, S0B, S1B, S2B, S3B} statetype;
	statetype state, nextstate;

    logic   enable;
    logic 	[31:0]	goal;

    assign goal = 'd5;

    divider divider(clk, reset, goal, enable);

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else begin
            state <= nextstate;
        end
    end

    //next state logic
    always_comb begin
        case(state)
            S0: if (enable) nextstate = S0A;
                else nextstate = S0;
            S0A: if (~button_pressed) nextstate = S0B;
                else nextstate = S0A;
            S0B: if (~enable) nextstate = S1;
                else nextstate = S0B;       

            S1: if (enable) nextstate = S1A;
                else nextstate = S1;
            S1A: if (~button_pressed) nextstate = S1B;
                else nextstate = S1A;
            S1B: if (~enable) nextstate = S2;
                else nextstate = S1B;     

            S2: if (enable) nextstate = S2A;
                else nextstate = S2;
            S2A: if (~button_pressed) nextstate = S2B;
                else nextstate = S2A;
            S2B: if (~enable) nextstate = S3;
                else nextstate = S2B;     

            S3: if (enable) nextstate = S3A;
                else nextstate = S3;
            S3A: if (~button_pressed) nextstate = S3B;
                else nextstate = S3A;
            S3B: if (~enable) nextstate = S0;
                else nextstate = S3B;     

            default: nextstate = S0;
        endcase
    end


    // output logic

    always_comb begin
        case(state)
            S0:          col_keys = 4'b0001;
            S0A:         col_keys = 4'b0001;
            S0B:         col_keys = 4'b0001;

            S1:          col_keys = 4'b0010;
            S1A:         col_keys = 4'b0010;
            S1B:         col_keys = 4'b0010;

            S2:          col_keys = 4'b0100;
            S2A:         col_keys = 4'b0100;
            S2B:         col_keys = 4'b0100;

            S3:          col_keys = 4'b1000;
            S3A:         col_keys = 4'b1000;
            S3B:         col_keys = 4'b1000;
            default:     col_keys = 4'b0001;
        endcase
    end

endmodule
