// scanner_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// adapted from Troy Kauffman's Keypad tutorial testbench
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module seg_storage_fsm_tb;

    logic           clk, reset, button_pressed;
    logic   [3:0]   col_keys;


    seg_storage_fsm_tb dut(.clk(clk), .reset(reset), .new_hex(new_hex), .hex_R_new(hex_R_new), .hex_R(hex_R), .hex_L(hex_L),);

/*/
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
/*/

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

            #50;
            new_hex = 1;
            #10;
            new_hex = 0;

            #500 $stop;
        end
    

    // add a timeout
    initial begin
        #5000; // wait 5 us
        $error("Simulation did not complete in time.");
        $stop;
    end
endmodule

