// lab3_gd_top_tb.sv
// testbench file for the top level module of the keypad decoder lab
// George Davis
// gdavis@hmc.edu
// 9/15/25

module lab3_gd_top_tb;

    logic           reset;
    logic   [3:0]   row_keys;

    logic   [1:0]   control;
    logic   [6:0]   seg;
    logic   [3:0]   col_keys;

    logic           clk; 
	logic	[31:0]  i;

    lab3_gd_top_tb dut(reset, row_keys, control, seg, col_keys);

    //generates clock 


    initial
        begin
			//Pulse reset to begin test
			reset <= 1; # 22; reset <= 0;

            row_keys = 4'b1000;

		for (i = 0; i < 10000; i = i + 1) begin // wait 10000 clock cycles
            clk <= 1; #5;
            clk <= 0; #5;
        end

        assert(control = )

        assert(seg == )

        assert(col_keys == 4'b0001 ||
               col_keys == 4'b0010 ||
               col_keys == 4'b0100 ||
               col_keys == 4'b1000 ) else $error("ERROR: col_keys not properly connected");
        end

endmodule