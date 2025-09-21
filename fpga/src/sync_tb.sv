// sync_tb.sv
// syncronizer testbench module to test double flip flop functionality 
// 9/14/2025

module sync_tb;

 	logic 		clk;
 	logic [3:0] d, q;

    logic [31:0] errors, testnum;

    sync dut(clk, d, q);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

    initial
        begin
            errors = 0;
            testnum = 0;
            d = 4'b1010; //non-trivial assigment to d to check output 

            always @(negegde clk) begin
                if (testnum == 4) $stop;
                else if(testnum == 0)
                    assert(q == 0) else $error("Error: async d not copied to q after 2 clock cycles");
                else if(testnum == 1)
                    assert(q == 0) else $error("Error: async d not copied to q after 2 clock cycles");
                else if(testnum == 2)
                    assert(q == d) else $error("Error: async d not copied to q after 2 clock cycles");
                else testnum = testnum + 1;
            end
        end
endmodule