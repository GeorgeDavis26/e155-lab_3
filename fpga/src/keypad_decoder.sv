// keypad_decoder.sv
// submodule of lab3_gd top level module
// contains the logic used to decode the 8 input pins connected to the 16 push buttons
// george davis gdavis@hmc.edu
// 9/10/2025

module keypad_decoder(
    input   logic   [3:0]   row_keys, col_keys,
    output  logic   [3:0]   hex_R
);

    //when a key is pressed the column is shorted to the row and current flows
    //detect which key is being pressed by setting a row to logical LOW and all columns to logical HIGH
    //when a column is forced low by the short, that key must have been pressed.

    always_comb 
        begin
            case (row_keys)
                4'b0001:    case(col_keys)
                                4'b0001:    hex_R = 4'hA;
                                4'b0010:    hex_R = 4'h0;
                                4'b0100:    hex_R = 4'hB;
                                4'b1000:    hex_R = 4'hF;
                                default:    hex_R = 4'h0;
                            endcase
                4'b0010:    case(col_keys)
                                4'b0001:    hex_R = 4'h7;
                                4'b0010:    hex_R = 4'h8;
                                4'b0100:    hex_R = 4'h9;
                                4'b1000:    hex_R = 4'hE;
                                default:    hex_R = 4'h0;
                            endcase
                4'b0100:    case(col_keys)
                                4'b0001:    hex_R = 4'h4;
                                4'b0010:    hex_R = 4'h5;
                                4'b0100:    hex_R = 4'h6;
                                4'b1000:    hex_R = 4'hD;
                                default:    hex_R = 4'h0;
                            endcase
                4'b1000:    case(col_keys)
                                4'b0001:    hex_R = 4'h1;
                                4'b0010:    hex_R = 4'h2;
                                4'b0100:    hex_R = 4'h3;
                                4'b1000:    hex_R = 4'hC;
                                default:    hex_R = 4'h0;
                            endcase
                default:    hex_R = 4'h0;
            endcase
        end
endmodule

/*
    always_comb begin
        casez (row_keys)
            4'b0001:    case(col_keys)
                            4'b0001:    hex_R = 4'hE;
                            4'b0010:    hex_R = 4'h0;
                            4'b0100:    hex_R = 4'hF;
                            4'b1000:    hex_R = 4'hD;
                            default:    hex_R = 4'h0;
                        endcase
            4'b0010:    case(col_keys)
                            4'b0001:    hex_R = 4'h7;
                            4'b0010:    hex_R = 4'h8;
                            4'b0100:    hex_R = 4'h9;
                            4'b1000:    hex_R = 4'hC;
                            default:    hex_R = 4'h0;
                        endcase
            4'b0100:    case(col_keys)
                            4'b0001:    hex_R = 4'h4;
                            4'b0010:    hex_R = 4'h5;
                            4'b0100:    hex_R = 4'h6;
                            4'b1000:    hex_R = 4'hB;
                            default:    hex_R = 4'h0;
                        endcase
            4'b1000:    case(col_keys)
                            4'b0001:    hex_R = 4'h1;
                            4'b0010:    hex_R = 4'h2;
                            4'b0100:    hex_R = 4'h3;
                            4'b1000:    hex_R = 4'hA;
                            default:    hex_R = 4'h0;
                        endcase
            default:    hex_R = h'h0;
        endcase
    end
    */
