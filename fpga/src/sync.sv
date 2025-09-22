// sync.sv
// syncronizer module via double flip flop
// adapted from Professor Josh Brake's E155 lecture notes
// 9/13/2025

module sync(
    input 	logic 		clk,
    input 	logic [3:0] d,
    output 	logic [3:0]	q
);

logic [3:0] n1;

always_ff @(posedge clk)
    begin
        n1 <= d;
        q <= n1;
    end
endmodule