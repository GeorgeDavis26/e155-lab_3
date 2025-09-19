// divider_tb.sv
// testbench file for the clock divider module
// George Davis
// gdavis@hmc.edu
// 9/17/25


    `timescale 1ps/1ps //timescale <time_unit>/<time_precision>

module divider_tb;

    logic           clk, reset;
    logic 	[31:0]	goal, errors;
    logic           alarm;
    logic           check;

    divider dut(clk, reset, goal, alarm)

    initial 
        begin
            alarm = 0;
			errors = 0; 

            goal = 10; // will take # 100 after reset set high

            //testing reset functionality 

            reset = 1; #10; //wait full clk cycle to check output

            clk = 1; #1
            assert(dut.counter == 0 && alarm == 0) else begin 
                $display("Error: reset does not initialize alarm and counter");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end
            clk = 0;

            #10

            reset = 0; #10; //wait full clk cycle to check output

            clk = 1; #1
            assert(dut.counter != 0) else begin
                $display("Error: reset does not initialize alarm");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end
            clk = 0;

            #10

            //Testing proper alarm ON/OFF functionality by setting counter

            dut.counter = (goal-2) #10; //skip to just before the alarm goes off

            clk = 1; #1
            assert(alarm == 0) else begin
                $display("Error: Alarm not properly LOW before alarm goes off");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end
            clk = 0;

            #10

            dut.counter = goal; #10; //skip to when the alarm goes off

            clk = 1; #1
            assert(alarm == 1) else begin
                $display("Error: Alarm not properly HIGH as alarm goes off");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end

            #10

            assert(dut.counter = 0) else begin
                else $display("Error: Counter does not reset after the alarm ");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end
            clk = 0;

            #10

            // Testing iterations of the counter on posedge of the clk

            dut.counter = 0 //make sure counter is below thethreshold

            clk = 1; #1
            assert(dut.counter = 1) else begin
                $display("Error: counter not iterating on the posedge of clk");
                $display(" inputs = %b", {clk, reset, goal});
                $display(" counter = %b", {dut.counter});
                $display(" outputs = %b", {alarm});
                errors = errors + 1;
            end
            clk = 0;

            $display("Tests completed with %b errors", errors);
            $stop
        end
endmodule