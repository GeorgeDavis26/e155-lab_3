// lab3_gd_top_tb.sv
// testbench file for the top level module of the keypad decoder lab
// George Davis
// gdavis@hmc.edu
// 9/15/25

`timescale 1 ns/1 ns

module keypad_tb();
    logic           clk;    // system clock
    logic           reset;  // active high reset
    tri     [3:0]   rows;   // 4-bit row input
    tri     [3:0]   cols;   // 4-bit column output
    logic   [3:0]   d0;     // new key
    logic   [3:0]   d1;     // previous key

    // matrix of key presses: keys[row][col]
    logic [3:0][3:0] keys;

    // dut
    keypad dut(.clk(clk), .reset(reset), .rows(rows), .cols(cols), .d0(d0), .d1(d1));

    // ensures rows = 4'b1111 when no key is pressed
    pulldown(rows[0]);
    pulldown(rows[1]);
    pulldown(rows[2]);
    pulldown(rows[3]);

    // keypad model using tranif
    genvar r, c;
    generate
        for (r = 0; r < 4; r++) begin : row_loop
            for (c = 0; c < 4; c++) begin : col_loop
                // when keys[r][c] == 1, connect cols[c] <-> rows[r]
                tranif1 key_switch(rows[r], cols[c], keys[r][c]);
            end
        end
    endgenerate

    // generate clock
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // task to check expected values of d0 and d1
    task check_key(input [3:0] exp_d0, exp_d1, string msg);
        #100;
        assert (d0 == exp_d0 && d1 == exp_d1)
            $display("PASSED!: %s -- got d0=%h d1=%h expected d0=%h d1=%h at time %0t.", msg, d0, d1, exp_d0, exp_d1, $time);
        else
            $error("FAILED!: %s -- got d0=%h d1=%h expected d0=%h d1=%h at time %0t.", msg, d0, d1, exp_d0, exp_d1, $time);
        #50;
    endtask

    // apply stimuli and check outputs
    initial begin
        reset = 1;

        // no key pressed
        keys = '{default:0};

        #22 reset = 0;

        // press key at row=1, col=2
        #50 keys[1][2] = 1;
        check_key(4'h6, 4'h0, "First key press");

        // release button
        keys[1][2] = 0;

        // press another key at row=0, col=0
        keys[2][3] = 1;
        check_key(4'hc, 4'h6, "Second key press");

        // release buttons
        #100 keys = '{default:0};

        #100 $stop;
    end

    // add a timeout
    initial begin
        #5000; // wait 5 us
        $error("Simulation did not complete in time.");
        $stop;
    end
endmodule

module lab3_gd_top_tb;

    logic           reset;
    logic   [3:0]   row_keys;

    logic   [1:0]   control;
    logic   [6:0]   seg;
    logic   [3:0]   col_keys;

    logic   [31:0]  errors;

    logic           clk; // only for sim

    lab3_gd_top_tb dut(clk, reset, row_keys, control, seg, col_keys);

    //generates clock 

    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end


    initial
        begin
            errors = 0;
			//Pulse reset to begin test
			reset <= 1; # 22; reset <= 0;
            
            // output seg tests with changing row_keys input
            row_keys = 4'b1000; // set to fourth row ie. output display should be 1

            wait(seg == 7'b1111001);
            $display("we did it to 7'b11110");
            assert(seg = 7'b1111001) else $error("ERROR: seg not being properly set"); errors = errors + 1;

            row_keys = 4'b0100; // set to a new row ie. should leave HOLD state
               
            wait(seg != 7'b1111001); // make sure seg can jump to a new row/ col
            assert(seg != 7'b1111001) else $error("ERROR: seg not being properly set"); errors = errors + 1;

            // output control tests

            wait(control == 1);
            assert(control == 1) else $error("ERROR: control not being properly set high"); errors = errors + 1;

            wait(control == 0);
            assert(control == 0) else $error("ERROR: control not being properly set low"); errors = errors + 1;

            // col_keys tests

            row_keys = 4'b0000; // set to no buttons pressed therefore should scan through

            wait(col_keys == 4'b0001);
            assert(col_keys == 4'b0001) else $error("ERROR: col_keys is %b" {col_keys}); errors = errors + 1;

            wait(col_keys == 4'b0010);
            assert(col_keys == 4'b0010) else $error("ERROR: col_keys is %b" {col_keys}); errors = errors + 1;

            wait(col_keys == 4'b0100);
            assert(col_keys == 4'b0100) else $error("ERROR: col_keys is %b" {col_keys}); errors = errors + 1;

            wait(col_keys == 4'b1000);
            assert(col_keys == 4'b1000) else $error("ERROR: col_keys is %b" {col_keys}); errors = errors + 1;

            #100000;

            assert(dut.clk == 1) else $error("ERROR: HSOSC not turning on"); errors = errors + 1;


            $error("Tests completed with %b errors", errors);
            $stop;

        end

endmodule