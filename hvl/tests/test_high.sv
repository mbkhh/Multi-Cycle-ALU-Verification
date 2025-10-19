//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//--------------------------------------

`timescale 1ns/1ns

import class_pkg::*;
import parameters::*;


module test_high (
    ALU_in_if   in_bus,
    ALU_out_if  out_bus
    );

    Environment env;
    ALU_in_transaction tr_random;
    ALU_in_transaction_range tr_range;

    localparam MID_RANGE = 2**(OPERAND_MAX_DATA_WIDTH-1);
    localparam HIGH_RANGE = 2**(OPERAND_MAX_DATA_WIDTH);

    initial begin
        $display("Simulation running ...");
        #10;
        env = new(.in_bus(in_bus), .out_bus(out_bus));
        #10;
        env.build();
        #10;
        env.run();
        #10;
        
    end
    

    initial begin
        #50;
        
        
        tr_range = new();
        tr_range.a_min = HIGH_RANGE-1;
        tr_range.a_max = HIGH_RANGE;
        tr_range.b_min = HIGH_RANGE-1;
        tr_range.b_max = HIGH_RANGE;

        env.gen.blueprint = tr_range;
        #20000;


        env.wrap_up();
        
        

    end


    

    

endmodule

