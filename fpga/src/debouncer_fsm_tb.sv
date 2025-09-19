// debouncer_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// gdavis@hmc.edu
//
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module debouncer_fsm_tb;

    logic           clk, reset, button_pressed;
    logic   [3:0]   q_row_keys, hex_R_out, hex_R, hex_L;
    logic   [31:0]  errors;
	
	
    debouncer_fsm dut(clk, reset, q_row_keys, hex_R_out, button_pressed, hex_R, hex_L);

    initial 
        begin
            errors = 0;
            ///////////////////////////////////////
            // next state and output logic tests //
            //////////////////////////////////////

            // test default case to IDLE
            clk = 1; #1;
            assert(dut.nextstate == dut.IDLE) else begin
                $error("ERROR: default case not functioning on no inputs");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test reset to IDLE
            reset = 1;
            clk = 1; #1;
            assert(dut.state == dut.IDLE) else begin
                $error("ERROR: default case not functioning on no inputs");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on IDLE
            q_row_keys = 4'b0000;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == dut.IDLE) else begin
                $error("ERROR: IDLE not looping at button NOT being pressed");
                errors = errors + 1;
            end
            assert(button_pressed == 0) else begin
                $error("ERROR: IDLE output not functional");
                $error(" outputs = %b", {button_pressed});
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on IDLE
            q_row_keys = 4'b1000;
            clk = 1; #1;
            assert(dut.nextstate == dut.PRESSED) else begin
                $error("ERROR: IDLE not jumping to PRESSED at button being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on PRESSED
            clk = 1; #1;
            assert(dut.nextstate == dut.STORE) else begin
                $error("ERROR: PRESSED jumping to STORE at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on STORE
            clk = 1; #1;
            assert(dut.nextstate == dut.WAIT) else begin
                $error("ERROR: STORE jumping to WAIT at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on WAIT
            wait(dut.alarm == 0);
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.state == dut.WAIT) else begin
                $error("ERROR: WAIT not looping at alarm beign LOW");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on WAIT
            wait(dut.alarm == 1);
            assert(dut.nextstate == dut.CHECK) else begin
                $error("ERROR: WAIT not jumping to CHECK at alarm");
                errors = errors + 1;
            end
            #10;

            // test next state to IDLE on CHECK
            q_row_keys = 4'b0100;
            clk = 1; #1;
            assert(dut.state == dut.IDLE) else begin
                $error("ERROR: CHECK not jumping to IDLE at condition failed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on CHECK
            q_row_keys = 4'b1000;//should be the same as pressed_row
            clk = 1; #1;
            assert(dut.nextstate == dut.DRIVE_L) else begin
                $error("ERROR: CHECK not jumping to DRIVE_L at the row check");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test output on DRIVE_L and nextstate of DRIVE_L (same clk edge)
            hex_R = 4'b0001;
            clk = 1; #1;
            assert(dut.nextstate == dut.DRIVE_R) else begin
                $error("ERROR: DRIVE_L not jumping to DRIVE_R");
                errors = errors + 1;
            end
            assert(hex_L == hex_R) else begin
                $error("ERROR: DRIVE_L not settng left hex to right hex");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test output on DRIVE_R and nextstate of DRIVE_R (same clk edge)
            hex_R_out = 4'b0010;
            clk = 1; #1;
            assert(dut.nextstate == dut.HOLD) else begin
                $error("ERROR: DRIVE_L not jumping to DRIVE_R");
                errors = errors + 1;
            end
            assert(hex_R == hex_R_out) else begin
                $error("ERROR: DRIVE_R not settng right hex to new hex");
                errors = errors + 1;
            end
            clk = 0; #10;
        
            // test loop on HOLD
            q_row_keys = 4'b1000;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.state == dut.HOLD) else begin
                $error("ERROR: HOLD not looping at button being held");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on HOLD
            clk = 1; #1;
            assert(dut.nextstate == dut.IDLE) else begin
                $error("ERROR: HOLD not jumping to IDLE at button being unpressed");
                errors = errors + 1;
            end
            clk = 0; #10;


        end        

endmodule