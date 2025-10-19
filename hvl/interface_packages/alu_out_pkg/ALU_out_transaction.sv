//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//------------------------------------



class ALU_out_transaction;

//-------------------The random variables
    
//--------------------------------------
    time issue_time;
    bit [RESULT_MAX_DATA_WIDTH-1:0] result ;
    bit result_rst;

//---------------------------constraints

    

//--------------------------------------

//-----------------------------functions
    function new();

        this.issue_time = $time;

    endfunction 





    virtual function string convert2string();

        return $sformatf("result:0x%x and result_rst : %x",this.result, this.result_rst);

    endfunction






    virtual function void do_print();

        $display(convert2string());

    endfunction




    virtual function bit do_compare (input ALU_out_transaction rhs);
   
        if (this.result_rst == 1)
            return (this.result_rst = rhs.result_rst);
        else
            return (this.result == rhs.result);

    endfunction
    

    

    virtual function ALU_out_transaction do_copy();
        ALU_out_transaction dst;

        dst = new();
        
        dst.result  = this.result;
        dst.result_rst = this.result_rst;

        return dst;

    endfunction : do_copy

    
//--------------------------------------

endclass