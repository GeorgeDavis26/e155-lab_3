// sync.sv
// syncronizer module via double flip flop
// taken from Professor Josh Brake's E155 lecture notes
// 9/13/2025

module sync(
    input logic clk,
    input logic d,
    output logic q
);

logic n1;

always_ff @(posedge clk)
    begin
        n1 <= d;
        q <= n1;
    end
endmodule