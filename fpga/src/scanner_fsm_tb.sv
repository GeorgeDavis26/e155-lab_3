// scanner_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// adapted from Troy Kauffman's Keypad tutorial testbench
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module scanner_fsm_tb;

    logic           clk, reset, button_pressed;
    logic   [3:0]   col_keys;


    scanner_fsm dut(.clk(clk), .reset(reset), .button_pressed(button_pressed), .col_keys(col_keys));

    // task to check expected values of d0 and d1
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
        input [3:0] expcol_keys,
        input string msg
        );
        #1;
        assert (col_keys == expcol_keys)
            $display("PASSED!: %s -- got col_keys=%h expected col_keys=%h time %0t.", msg, col_keys, expcol_keys, $time);
        else
            $error("FAILED!: %s -- got col_keys=%h expected col_keys=%h time %0t.", msg, col_keys, expcol_keys, $time);
        #1;
    endtask

    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    initial 
        begin
            reset = 1;
            #22 reset = 0;
            
           ///////////////////////////////////////
            // next state and output logic tests //
            //////////////////////////////////////

            // S0
            wait(dut.enable == 0);
            button_pressed = 1; #5;
            check_state(dut.S0, dut.S0, "Loop on S0"); 
            check_output(4'b0001, "Output on S0"); #10;

            wait(dut.enable == 1);
            check_state(dut.S0,  dut.S0A, "Nextstate on S0 to S0A"); #8;
            check_state(dut.S0A, dut.S0A, "Loop on S0A back to S0A");
            check_output(4'b0001, "Output on S0A"); #10;

            wait(dut.enable == 1);
            button_pressed = 0; #5
            check_state(dut.S0A, dut.S0B, "Nextstate on S0A to S0B"); #10;
            check_state(dut.S0B, dut.S0B, "Loop on S0B back to S0B"); 
            check_output(4'b0001, "Output on S0B"); #10;

            wait(dut.enable == 0);
            check_state(dut.S0B, dut.S1, "Nextstate on S0B to S1");

            #10;

            // S1
            wait(dut.enable == 0);
            button_pressed = 1; #5;
            check_state(dut.S1, dut.S1, "Loop on S1");
            check_output(4'b0010, "Output on S1"); #10;

            wait(dut.enable == 1);
            check_state(dut.S1,  dut.S1A, "Nextstate on S1 to S1A"); #8;
            check_state(dut.S1A, dut.S1A, "Loop on S1A back to S1A"); 
            check_output(4'b0010, "Output on S1A"); #10;

            wait(dut.enable == 1);
            button_pressed = 0; #5
            check_state(dut.S1A, dut.S1B, "Nextstate on S1A to S1B"); #10;
            check_state(dut.S1B, dut.S1B, "Loop on S1B back to S1B"); 
            check_output(4'b0010, "Output on S1B"); #10;

            wait(dut.enable == 0);
            check_state(dut.S1B, dut.S2, "Nextstate on S1B to S2");

            #10;

            // S2
            wait(dut.enable == 0);
            button_pressed = 1; #5;
            check_state(dut.S2, dut.S2, "Loop on S2"); 
            check_output(4'b0100, "Output on S2"); #10;

            wait(dut.enable == 1);
            check_state(dut.S2,  dut.S2A, "Nextstate on S2 to S2A"); #8;
            check_state(dut.S2A, dut.S2A, "Loop on S2A back to S2A");
            check_output(4'b0100, "Output on S2A"); #10;

            wait(dut.enable == 1);
            button_pressed = 0; #5
            check_state(dut.S2A, dut.S2B, "Nextstate on S2A to S2B"); #10;
            check_state(dut.S2B, dut.S2B, "Loop on S2B back to S2B"); 
            check_output(4'b0100, "Output on S2B"); #10;

            wait(dut.enable == 0);
            check_state(dut.S2B, dut.S3, "Nextstate on S2B to S3");

            #10;

            // S3
            wait(dut.enable == 0);
            button_pressed = 1; #5;
            check_state(dut.S3, dut.S3, "Loop on S3");
            check_output(4'b1000, "Output on S3"); #10;

            wait(dut.enable == 1);
            check_state(dut.S3,  dut.S3A, "Nextstate on S3 to S3A"); #8;
            check_state(dut.S3A, dut.S3A, "Loop on S3A back to S3A");
            check_output(4'b1000, "Output on S3A"); #10;

            wait(dut.enable == 1);
            button_pressed = 0; #5
            check_state(dut.S3A, dut.S3B, "Nextstate on S3A to S3B"); #10;
            check_state(dut.S3B, dut.S3B, "Loop on S3B back to S3B");
            check_output(4'b1000, "Output on S3B"); #10;

            wait(dut.enable == 0);
            check_state(dut.S3B, dut.S0, "Nextstate on S3B to S0");



            #50 $stop;
        end
    

    // add a timeout
    initial begin
        #5000; // wait 5 us
        $error("Simulation did not complete in time.");
        $stop;
    end
endmodule


/*
            // test default case to S0
            clk = 1; #1;
            assert(dut.nextstate == dut.S0) else begin
                $error("ERROR: default case not functioning on no inputs");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on S0
            wait(dut.enable == 0); 
            button_pressed = 0;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == dut.S0) else begin
                $error("ERROR: S0 not looping at button being pressed/ held");
                errors = errors + 1;
            end
            assert(col_keys == 4'b0001) else begin
                $error("ERROR: S0 output not functional");
                $error(" outputs = %b", {col_keys});
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on S0
            wait(dut.enable == 1); button_pressed = 1;
            clk = 1; #1;
            assert(dut.nextstate == dut.S1) else begin
                $error("ERROR: S0 not jumping to S1 at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on S1
            wait(dut.enable == 0); button_pressed = 0;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == dut.S1) else begin
                $error("ERROR: S1 not looping at button being pressed/ held");
                errors = errors + 1;
            assert(col_keys == 4'b0010) else begin
                $error("ERROR: S1 output not functional");
                $error(" outputs = %b", {col_keys});
                errors = errors + 1;
            end
            end
            clk = 0; #10;

            // test nextstate on S1
            wait(dut.enable == 1); button_pressed = 1;
            clk = 1; #1;
            assert(dut.nextstate == dut.S3) else begin
                $error("ERROR: S1 not jumping to S2 at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on S2
            wait(dut.enable == 0);  button_pressed = 0;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == dut.S2) else begin
                $error("ERROR: S2 not looping at button being pressed/ held");
                errors = errors + 1;
            end
            assert(col_keys == 4'b0100) else begin
                $error("ERROR: S2 output not functional");
                $error(" outputs = %b", {col_keys});
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on S2
            wait(dut.enable == 1); button_pressed = 1;
            clk = 1; #1;
            assert(dut.nextstate == dut.S3) else begin
                $error("ERROR: S2 not jumping to S3 at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            // test loop on S3
            wait(dut.enable == 0);  button_pressed = 0;
            clk = 1; #1;
            clk = 0; #1;
            clk = 1;
            assert(dut.nextstate == dut.S3) else begin
                $error("ERROR: S3 not looping at button being pressed/ held");
                errors = errors + 1;
            end
            assert(col_keys == 4'b1000) else begin
                $error("ERROR: S3 output not functional");
                $error(" outputs = %b", {col_keys});
                errors = errors + 1;
            end
            clk = 0; #10;

            // test nextstate on S3
            wait(dut.enable == 1);  button_pressed = 1;
            clk = 1; #1;
            assert(dut.nextstate == dut.S1) else begin
                $error("ERROR: S3 not jumping to S0 at button not being pressed");
                errors = errors + 1;
            end
            clk = 0; #10;

            $error("Tests completed with %b errors", errors);
            $stop;
        end        

endmodule

*/
