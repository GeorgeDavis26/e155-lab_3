// lab3_gd_top_tb.sv
// testbench file for the top level module of the keypad decoder lab
// George Davis
// gdavis@hmc.edu
// 9/15/25

`timescale 1 ns/1 ns

module lab3_gd_top_tb;

    logic           reset;
    logic   [3:0]   row_keys;

    logic   [1:0]   control;
    logic   [6:0]   seg;
    logic   [3:0]   col_keys;

    logic   [31:0]  errors;

    logic           clk; // only for sim

    lab3_gd_top dut(clk, reset, row_keys, control, seg, col_keys);

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


          #100000;

            assert(dut.clk == 1) else $error("ERROR: HSOSC not turning on"); errors = errors + 1;

            $error("Tests completed with %b errors", errors);
            $stop;

        end

endmodule
