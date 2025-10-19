//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//-------------------------------------------



class ALU_in_transaction;

//-------------------The random variables
    rand alu_in_op_t                     op;
    rand bit            [$clog2(OPERAND_MAX_DATA_WIDTH/OPERAND_BUS_WIDTH):0] needed_cycle;
    rand bit            [OPERAND_MAX_DATA_WIDTH-1:0]    a;
    rand bit            [OPERAND_MAX_DATA_WIDTH-1:0]    b;
    rand bit                                            is_empty;
//--------------------------------------
    time issue_time;

//---------------------------constraints

    constraint valid_op_c { 
        op inside {no_op, add_op, and_op, xor_op, mul_op, rst_op}; 
    }
    constraint valid_needed_cycle_c {
        0 < needed_cycle;
        needed_cycle <= OPERAND_MAX_DATA_WIDTH/OPERAND_BUS_WIDTH;
    }
    constraint is_empty_probability_c {
        is_empty dist {1 := 1, 0 := 9}; // 10% chance for 1, 90% for 0
    }

//--------------------------------------

//-----------------------------functions
    function new();

        this.issue_time = $time;

    endfunction 





    virtual function string convert2string();

        string string_out = "ALU_in_transaction:\n";

        string_out = {string_out, $sformatf(" operation = %s\n", op.name())};
        string_out = {string_out, $sformatf(" needed cycle = %x\n", needed_cycle)};
        string_out = {string_out, $sformatf(" is empty = %x\n", is_empty)};
        string_out = {string_out, $sformatf(" a = %x\n", a)};
        string_out = {string_out, $sformatf(" b = %x\n", b)};
        

        return string_out;

    endfunction






    virtual function void do_print();

        $display(convert2string());

    endfunction




    virtual function bit do_compare (input ALU_in_transaction rhs);
   
        if(this.op == rst_op)
            return (this.op == rhs.op);
        else
            return ( (this.op ==   rhs.op) &&(this.a ==    rhs.a) &&(this.b ==    rhs.b) );

    endfunction
    

    

    virtual function ALU_in_transaction do_copy();
        ALU_in_transaction dst;

        dst = new();

        dst.needed_cycle = this.needed_cycle;
        dst.op  = this.op;
        dst.a   = this.a;
        dst.b   = this.b;

        return dst;

    endfunction : do_copy

    
//--------------------------------------

endclass