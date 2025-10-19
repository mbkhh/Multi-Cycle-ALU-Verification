`timescale 1ns / 1ps

//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//--------------------------------------


import parameters::*;

interface ALU_in_if (
    input logic                 clk,
    input logic                 rst // active low
);
    logic                         operand_valid;
    logic [2:0]                   op;
    logic [OPERAND_BUS_WIDTH-1:0] a;
    logic [OPERAND_BUS_WIDTH-1:0] b;
    logic                         operand_last;
    logic                         ready;


    modport dut_mp (
        input clk,
        input rst,  
        input operand_valid,
        input op,
        input a,
        input b,
        input operand_last,
        output ready
    );

    modport driver_mp (
        input clk,
        input rst,  
        output operand_valid,
        output op,
        output a,
        output b,
        output operand_last,
        input ready
    );

    modport monitor_mp (
        input clk,
        input rst,  
        input operand_valid,
        input op,
        input a,
        input b,
        input operand_last,
        input ready
    );

    
endinterface

