// shifter.sv
// module to left Shift a 4 bit binary number in a cyclical pattern 
// george davis gdavis@hmc.edu
// 9/10/2025

module scanner_fsm (
    input   logic           clk, reset, button_pressed, 
    output	logic	[3:0]   col_keys
);

    typedef enum logic [3:0] {S0A, S0B, S0C, S0D, S1A, S1B, S1C, S1D, S2A, S2B, S2C, S2D, S3A, S3B, S3C, S3D} statetype;
	statetype state, nextstate;

    // state register and asynchronous reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0A;
        else begin
            state <= nextstate;
        end
    end

    //next state logic
    always_comb begin
        case(state)
            //S0A: if (~button_pressed) nextstate = S0B;
                 //else   nextstate = S0A;
                 
            S0A: nextstate = S0B;
            S0B: nextstate = S0C;
            S0C: nextstate = S0D;
            S0D: if (~button_pressed) nextstate = S1A;
                 else nextstate = S0D;

            S1A: nextstate = S1B;
            S1B: nextstate = S1C;
            S1C: nextstate = S1D;
            S1D: if (~button_pressed) nextstate = S2A;
                 else nextstate = S1D;

            S2A: nextstate = S2B;
            S2B: nextstate = S2C;
            S2C: nextstate = S2D;
            S2D: if (~button_pressed) nextstate = S3A;
                 else nextstate = S2D;

            S3A: nextstate = S3B;
            S3B: nextstate = S3C;
            S3C: nextstate = S3D;
            S3D: if (~button_pressed) nextstate = S0A;
                 else nextstate = S3D;
        endcase
    end


    // output logic
    always_comb begin
        case(state)
            S0A:         col_keys = 4'b0001;
            S0B:         col_keys = 4'b0001;
            S0C:         col_keys = 4'b0001;
            S0D:         col_keys = 4'b0001;

            S1A:         col_keys = 4'b0010;
            S1B:         col_keys = 4'b0010;
            S1C:         col_keys = 4'b0010;
            S1D:         col_keys = 4'b0010;

            S2A:         col_keys = 4'b0100;
            S2B:         col_keys = 4'b0100;
            S2C:         col_keys = 4'b0100;
            S2D:         col_keys = 4'b0100;

            S3A:         col_keys = 4'b1000;
            S3B:         col_keys = 4'b1000;
            S3C:         col_keys = 4'b1000;
            S3D:         col_keys = 4'b1000;
        endcase
    end

endmodule
