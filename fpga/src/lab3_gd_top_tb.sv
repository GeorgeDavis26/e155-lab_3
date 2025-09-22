// lab3_gd_top_tb.sv
// testbench file for the top level module of the keypad decoder lab
// George Davis
// gdavis@hmc.edu
// 9/15/25
//adapted from keypad testbench example from the course website
//https://hmc-e155.github.io/tutorials/tutorial-posts/keypad-testbench/index.html

`timescale 1 ns/1 ns

module lab3_gd_top_tb;

    logic           reset;
    logic   [3:0]   row_keys;

    logic   [1:0]   control;
    logic   [6:0]   seg;
    logic   [3:0]   col_keys;

    logic   [31:0]  errors;

    logic [3:0][3:0] keys;

    genvar r, c;

    logic           clk; // only for sim

    lab3_gd_top dut(clk, reset, row_keys, control, seg, col_keys);

    // ensures cols = 4'b1111 when no key is pressed
    pullup(cols[0]);
    pullup(cols[1]);
    pullup(cols[2]);
    pullup(cols[3]);

     // keypad model using tranif
    genvar c, r;
    generate
        for (c = 0; c < 4; c++) begin : row_loop
            for (r = 0; r < 4; r++) begin : col_loop
                // when keys[c][r] == 1, connect cols[r] <-> rows[c]
                tranif1 key_switch(cols[c], rows[r], keys[c][r]);
            end
        end
    endgenerate

    //generates clock 

    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    // tasks to check expected values of seg when control = 0 (LEFT SEGMENT)
    task check_key_0(input [3:0] expseg, string msg);
        #100;
        assert (seg == expseg)
            $display("L PASSED!: %s -- got seg=%h expected seg=%h at time %0t.", msg, seg, , expseg, $time);
        else
            $error("L FAILED!:%s -- got seg=%h expected seg=%h at time %0t.", msg, seg, , expseg, $timee);
        #50;
    endtask

    // tasks to check expected values of seg when control = 0 (LEFT SEGMENT)
    task check_key_1(input [3:0] expseg, string msg);
        #100;
        assert (seg == exp_seg)
            $display("R PASSED!: %s -- got seg=%h expected seg=%h at time %0t.", msg, seg, , expseg, $time);
        else
            $error("R FAILED!: %s -- got seg=%h expected seg=%h at time %0t.", msg, seg, , expseg, $time);
        #50;
    endtask

    initial
        begin
            errors = 0;
			//Pulse reset to begin test
			reset <= 1; # 22; 
            keys = '{default:0};
            reset <= 0;

            
            end
            $error("Tests completed with %b errors", errors);
            $stop;

        end

endmodule

          
/*/  
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

/*/