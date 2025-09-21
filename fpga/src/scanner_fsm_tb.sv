// scanner_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module scanner_fsm_tb;

    logic           clk, reset, button_pressed;
    logic   [3:0]   col_keys;
    logic   [31:0]  errors;

    scanner_fsm dut(clk, reset, button_pressed, col_keys);

    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    initial 
        begin

            errors = 0;
            ///////////////////////////////////////
            // next state and output logic tests //
            //////////////////////////////////////

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
            assert(dut.nextstate == dut.S2) else begin
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