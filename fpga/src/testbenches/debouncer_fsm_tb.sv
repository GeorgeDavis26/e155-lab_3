// debouncer_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// gdavis@hmc.edu
//
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module debouncer_fsm_tb;

    logic           reset, button_pressed, new_hex;
    logic   [3:0]   q_row_keys;
    logic   [31:0]  errors;
	
	
    debouncer_fsm dut(reset, q_row_keys, button_pressed, new_hex);

    // task to check expected values of state/nextstate and col_keys
    task check_state(
        input [3:0] exp_state, exp_nextstate,
        input string msg
        );
        #1;
        assert (dut.state == exp_state && dut.nextstate == exp_nextstate)
            $display("PASSED!: %s -- got state=%h nextstate=%h expected state=%h nextstate=%h at time %0t.", msg, dut.state, dut.nextstate, exp_state, exp_nextstate, $time);
        else
            $error("FAILED!: %s --got state=%h nextstate=%h expected state=%h nextstate=%h at time %0t.", msg, dut.state, dut.nextstate, exp_state, exp_nextstate, $time);
        #1;
    endtask

    task check_output(
        input        expbutton_pressed, expnew_hex,
        input string msg
        );
        #1;
        assert (button_pressed == expbutton_pressed && new_hex == expnew_hex)
            $display("PASSED!: %s -- got button_pressed=%h and new_hex = %h expected button_pressed=%h new_hex = %h time %0t.", msg, button_pressed, new_hex, expbutton_pressed, expnew_hex, $time);
        else
            $error("FAILED!: %s -- got button_pressed=%h and new_hex = %h expected button_pressed=%h new_hex = %h time %0t.", msg, button_pressed, new_hex, expbutton_pressed, expnew_hex, $time);
        #1;
    endtask

    initial 
        begin
            reset = 1;
            #22 reset = 0;
            
           ///////////////////////////////////////
            // next state and output logic tests //
            //////////////////////////////////////

            q_row_keys = 4'b1000;
//            #10;
//            q_row_keys = 4'b0100;
            #100;
            
            wait(dut.alarm == 1);
            #100;
            q_row_keys = 4'b0000;
            #50 $stop;
        end
    
    // add a timeout
    initial begin
        #5000; // wait 5 us
        $error("Simulation did not complete in time.");
        $stop;
    end

/*/
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
/*/
endmodule