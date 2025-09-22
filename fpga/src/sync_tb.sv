// sync_tb.sv
// syncronizer testbench module to test double flip flop functionality 
// 9/14/2025

module sync_tb;

 	logic 		clk;
 	logic [3:0] d, q;

    logic [31:0] cycnum;

    sync dut(clk, d, q);

    //generates clock 
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end

    always @(posedge clk) begin
        if (cycnum == 0) begin d = 4'b1010; cycnum = cycnum + 1; end
        else if (cycnum == 1) begin cycnum = cycnum + 1; end
        else if (cycnum == 2) begin assert(dut.n1 == 4'b1010) else $error("Error: n1 not picking up d"); cycnum = cycnum + 1; end
        else if (cycnum == 3) begin assert(d == 4'b1010) else $error("Error: d not picking up n1");  cycnum = cycnum + 1; end
        else if (cycnum == 4) begin $display("Tests complete with"); $stop; end
        else    cycnum = 0;
    end
endmodule