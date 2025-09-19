// sync_tb.sv
// syncronizer testbench module to test double flip flop functionality 
// 9/14/2025

module sync_tb;

 	logic 		clk;
 	logic [3:0] d, q;

    sync dut(clk, d, q);

    initial
        begin
            d = 4'b1010; //non-trivial assigment to d to check output 
			clk = 0; #5
			clk = 1; #5;
			clk = 0; #5;	
			clk = 1; #5;			
			clk = 0; #5;		
            assert(q == d) else $error("Error: async d not copied to q after 2 clock cycles");
            $stop;
        end
endmodule