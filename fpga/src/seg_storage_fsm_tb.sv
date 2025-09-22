// scanner_fsm_tb.sv
// testbench file for the scanner_fsm module 
// George Davis
// adapted from Troy Kauffman's Keypad tutorial testbench
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module seg_storage_fsm_tb;

    logic           clk, reset, new_hex;
    logic   [3:0]   hex_R_new, hex_R, hex_L;


    seg_storage_fsm dut(.clk(clk), .reset(reset), .new_hex(new_hex), .hex_R_new(hex_R_new), .hex_R(hex_R), .hex_L(hex_L));


    // task to check expected values of state/nextstate and hex_R/ hex_L
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
        input [3:0] exphex_L, exphex_R,
        input string msg
        );
        #1;
        assert (hex_R == exphex_R && hex_L == exphex_L)
            $display("PASSED!: %s -- got hex_R=%h =%h expected hex_R=%h hex_L=%h at time %0t.", msg, hex_R, hex_L, exphex_R, exphex_L, $time);
        else
            $error("FAILED!: %s -- got hex_R=%h =%h expected hex_R=%h hex_L=%h at time %0t.", msg, hex_R, hex_L, exphex_R, exphex_L, $time);
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

            new_hex = 0; #1
            check_state(dut.IDLE, dut.IDLE, "Loop on IDLE");
            check_output(4'b0000, 4'b0000, "Output on IDLE"); #10;
            hex_R_new = 4'b0110; #1
            new_hex = 1; #1
            check_state(dut.IDLE, dut.NEW_L, "Nextstate on IDLE to New_L");

            check_output(4'b0000, 4'b0000, "Output on NEW_L");
            check_state(dut.NEW_L, dut.NEW_R, "Nextstate on New_L to New_R"); #5;

            check_output(4'b0000, 4'b0110, "Output on NEW_R");
            check_state(dut.NEW_R, dut.WAIT, "Nextstate on NEW_R to WAIT"); #10;
            
            check_state(dut.WAIT, dut.WAIT, "Loop on WAIT");
            check_output(4'b0000, 4'b0110, "Output on WAIT"); #5;
            new_hex = 0; #5
            check_state(dut.WAIT, dut.IDLE, "Nextstate on WAIT to IDLE");


            check_output(4'b0000, 4'b0110, "Output on IDLE second time through"); #10;
            hex_R_new = 4'b1001; #1
            new_hex = 1; #10

            check_output(4'b0110, 4'b0110, "Output on NEW_L second time through");
            #10;

            check_output(4'b0110, 4'b1001, "Output on NEW_R second time through");
            #10;
            
            check_output(4'b0110, 4'b1001, "Output on WAIT second time through"); #5;
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

