// scanner_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module divider_tb;

    logic           clk, reset, button_pressed;
    logic   [3:0]   col_keys;
    logic   [31:0]  errors;

    scanner_fsm_tb dut(clk, reset, button_pressed, col_keys)

    initial 
        begin
            errors = 0;
            ///////////////////////////////////////
            // next state and output logic tests //
            //////////////////////////////////////

            // test default case to IDLE
            clk = 1; #1;
            assert(dut.nextstate == IDLE) else begin
                $display("ERROR: default case not functioning on no inputs");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test reset to IDLE
            reset = 1;
            clk = 1; #1;
            assert(dut.state == IDLE) else begin
                $display("ERROR: default case not functioning on no inputs");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on IDLE
            q_row_keys == 4'b0000;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == IDLE) else begin
                $display("ERROR: IDLE not looping at button NOT being pressed");
                errors = errors + 1;
            end
            assert(button_pressed == 0) else begin
                $display("ERROR: IDLE output not functional");
                $display(" outputs = %b", {button_pressed});
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on IDLE
            q_row_keys == 4'b1000;
            clk = 1; #1;
            assert(dut.nextstate == PRESSED) else begin
                $display("ERROR: IDLE not jumping to PRESSED at button being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on PRESSED
            clk = 1; #1;
            assert(dut.nextstate == STORE) else begin
                $display("ERROR: PRESSED jumping to STORE at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on STORE
            clk = 1; #1;
            assert(dut.nextstate == WAIT) else begin
                $display("ERROR: STORE jumping to WAIT at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on WAIT
            alarm == 0;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.state == WAIT) else begin
                $display("ERROR: WAIT not looping at alarm beign LOW");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on WAIT
            alarm == 1;
            clk = 1; #1;
            assert(dut.nextstate == CHECK) else begin
                $display("ERROR: WAIT not jumping to CHECK at alarm");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test next state to IDLE on CHECK
            pressed_row = 4'b0000;
            dut.q_row_keys = 4'b1111;
            clk = 1; #1;
            assert(dut.state == IDLE) else begin
                $display("ERROR: CHECK not jumping to IDLE at condition failed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on CHECK
            dut.q_row_keys = pressed_row;
            clk = 1; #1;
            assert(dut.nextstate == DRIVE_L) else begin
                $display("ERROR: CHECK not jumping to DRIVE_L at the row check");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test output on DRIVE_L and nextstate of DRIVE_L (same clk edge)
            hex_R = 4'b0001;
            clk = 1; #1;
            assert(dut.nextstate == DRIVE_R) else begin
                $display("ERROR: DRIVE_L not jumping to DRIVE_R");
                errors = errors + 1;
            end
            assert(hex_L == hex_R) else begin
                $display("ERROR: DRIVE_L not settng left hex to right hex");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test output on DRIVE_R and nextstate of DRIVE_R (same clk edge)
            hex_R_out = 4'b0010;
            clk = 1; #1;
            assert(dut.nextstate == HOLD) else begin
                $display("ERROR: DRIVE_L not jumping to DRIVE_R");
                errors = errors + 1;
            end
            assert(hex_R == hex_R_out) else begin
                $display("ERROR: DRIVE_R not settng right hex to new hex");
                errors = errors + 1;
            end
            clk = 0; #10;
        
            // test loop on HOLD
            q_row_keys == 4'b1000;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.state == HOLD) else begin
                $display("ERROR: HOLD not looping at button being held");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on HOLD
            clk = 1; #1;
            assert(dut.nextstate == IDLE) else begin
                $display("ERROR: HOLD not jumping to IDLE at button being unpressed");
                errors = errors + 1;
            end
            clk = 0; #10;


        end        

endmodule