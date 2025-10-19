//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//---------------------------------

class ALU_out_coverage;



    localparam MID_RANGE = 2**(RESULT_MAX_DATA_WIDTH-1);
    localparam HIGH_RANGE = 2**(RESULT_MAX_DATA_WIDTH);

    covergroup ALU_out_transaction_cg with function sample(ALU_out_transaction tr_out);
    
        option.auto_bin_max=64;
        


        result: coverpoint tr_out.result { 
            option.at_least = 10;
            bins low    = {   [0:MID_RANGE] };
            bins high    = { [MID_RANGE+1:HIGH_RANGE-1] };
        }
        result_rst: coverpoint tr_out.result_rst { 
            option.at_least = 10;
            bins high    = { 1 };
        }

        

    endgroup




    function new();
    	ALU_out_transaction_cg = new();
    endfunction





    function void sample(ALU_out_transaction tr_out);

        
        ALU_out_transaction_cg.sample(tr_out);
    endfunction

endclass