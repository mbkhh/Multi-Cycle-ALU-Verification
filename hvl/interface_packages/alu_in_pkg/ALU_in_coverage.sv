//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//-----------

class ALU_in_coverage;



    localparam MID_RANGE = 2**(OPERAND_MAX_DATA_WIDTH-1);
    localparam HIGH_RANGE = 2**(OPERAND_MAX_DATA_WIDTH);

    covergroup ALU_in_transaction_cg with function sample(ALU_in_transaction tr_in);
    
        option.auto_bin_max=64;
        

        op: coverpoint tr_in.op iff (!tr_in.is_empty) { 
            option.at_least = 10;
            bins noop   = { 3'b000 };
            bins addop  = { 3'b001 };
            bins andop  = { 3'b010 };
            bins xorop  = { 3'b011 };
            bins mulop  = { 3'b100 };
            bins rstop  = { 3'b111 };
            illegal_bins invalid_op = default;
        }

        a: coverpoint tr_in.a iff (!tr_in.is_empty) { 
            option.at_least = 10;
            bins low    = {   [0:MID_RANGE] };
            bins mid    = { [MID_RANGE+1:HIGH_RANGE-1] };
            // bins high   = {      HIGH_RANGE-1};
        }

        b: coverpoint tr_in.b iff (!tr_in.is_empty) { 
            option.at_least = 10;
            bins low    = {   [0:MID_RANGE] };
            bins mid    = { [MID_RANGE+1:HIGH_RANGE-1] };
            // bins high   = {      HIGH_RANGE-1};
        }
        needed_cycle: coverpoint tr_in.needed_cycle iff (!tr_in.is_empty) {
            option.at_least = 30;
            bins all_cycles[] = { [1:(OPERAND_MAX_DATA_WIDTH/OPERAND_BUS_WIDTH)] };
        }

        is_empty: coverpoint tr_in.is_empty {
            option.at_least = 50;
            bins low    =  { 0 };
            bins high    = { 1 };
        }


    endgroup




    function new();
    	ALU_in_transaction_cg = new();
    endfunction





    function void sample(ALU_in_transaction tr_in);

        
        ALU_in_transaction_cg.sample(tr_in);
    endfunction

endclass