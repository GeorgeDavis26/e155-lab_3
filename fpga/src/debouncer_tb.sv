


module debouncer_tb;

    logic           clk, reset;
    logic           alarm = 0;
    logic   [21:0]  counter;
    logic           check;

    debouncer dut(clk, reset, alarm)
    
    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

    initial 
        reset = 1; #1; assert (alarm == 0) else $display("Error: resert does not initialize alarm %b", {counter, reset});

        always_ff @(posedge clk)
        begin
            if(counter == 'd2400000) begin //flips on after 24,000,000 clk cycles
                check = 1;
                counter = 0;
                end
            else counter = counter + 1;
        end

        assert (alarm ==1) ((@posedge check)) else $display("Error: alarm doesn't wait for the correct number of clock cycles")

endmodule