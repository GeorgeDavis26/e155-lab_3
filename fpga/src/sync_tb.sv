// sync_tb.sv
// syncronizer testbench module to test double flip flop functionality 
// 9/14/2025

module sync_tb;

 	logic 		clk,
 	logic [3:0] d,
 	logic [3:0]	q

    sync dut(clk, d, q);

    //generate clock
    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    initial
        always_ff @(posedge clk) begin
            #3;          //put d assignemnt outside of the clk cycle
            d = 4'b1010; //non-trivial assigment to d to check output 
            #20;
            assert(q == d) else $display("Error: async d not copied to q after 2 clock cycles")
            $stop;
        end
endmodule