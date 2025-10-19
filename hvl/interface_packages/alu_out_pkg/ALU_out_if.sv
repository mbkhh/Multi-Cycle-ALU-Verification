`timescale 1ns / 1ps

//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//-----------

import parameters::*;


interface ALU_out_if (
    input logic                 clk,
    input logic                 rst
);
    
    logic                        result_valid;
    logic [RESULT_BUS_WIDTH-1:0] result;
    logic                        result_last;
    logic                        result_rst;

    modport dut_mp (
        input clk,
        input rst,  
        output result_valid,
        output result,
        output result_last,
        output result_rst
    );

    modport monitor_mp (
        input clk,
        input rst,
        input result_valid,
        input result,
        input result_last,
        input result_rst
    );

    
endinterface

