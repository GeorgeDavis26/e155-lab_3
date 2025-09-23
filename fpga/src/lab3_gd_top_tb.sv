`timescale 1 ns/1 ns

module keypad_tb();
    logic           clk;    // system clock
    logic           reset;  // active high reset
    tri     [3:0]   row_keys;   // 4-bit row input
    tri     [3:0]   col_keys;   // 4-bit column output
    logic   [3:0]   d0;     // new key
    logic   [3:0]   d1;     // previous key

    // matrix of key presses: keys[row][col]
    logic [3:0][3:0] keys;

    // dut
    lab3_gd_top dut(.rst(rst), .row_keys(row_keys), .control(control), .seg(seg), .col_keys(col_keys));

    // ensures row_keys = 4'b1111 when no key is pressed
    pulldown(row_keys[0]);
    pulldown(row_keys[1]);
    pulldown(row_keys[2]);
    pulldown(row_keys[3]);

    // keypad model using tranif
    genvar r, c;
    generate
        for (r = 0; r < 4; r++) begin : row_keys_loop
            for (c = 0; c < 4; c++) begin : col_keys_loop
                // when keys[r][c] == 1, connect cols[c] <-> rows[r]
                tranif1 key_switch(row_keys[r], col_keys[c], keys[r][c]);
            end
        end
    endgenerate

    // task to check expected values of d0 and d1
    task check_key(input [3:0] exp_hex_R, exp_hex_L, string msg);
        #100;
        assert (dut.hex_R == exp_hex_R && dut.hex_L == exp_hex_L)
            $display("PASSED!: %s -- got hex_R=%h hex_L=%h expected hex_R=%h hex_L=%h at time %0t.", msg, hex_R, hex_L, exp_hex_R, exp_hex_L, $time);
        else
            $error("FAILED!: %s -- got hex_R=%h hex_L=%h expected hex_R=%h hex_L=%h at time %0t.", msg, hex_R, hex_L, exp_hex_R, exp_hex_L, $time);
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