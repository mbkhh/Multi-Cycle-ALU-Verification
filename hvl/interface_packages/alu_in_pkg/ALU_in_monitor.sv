//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//--------------------------------------


class ALU_in_monitor;

    virtual ALU_in_if bus;
    mailbox mon2env;
    ALU_in_coverage monitor_coverage;

    ALU_in_transaction tr;

    
//-------------------------------------------------new(): construct an object
    function new(
        input virtual ALU_in_if.monitor_mp bus,
        input mailbox mon2env
        );

        this.bus         = bus;
        this.mon2env    = mon2env;

        monitor_coverage   = new();

    endfunction : new
//---------------------------------------------------------------------------

    task run();       
        forever begin
            do_monitor(tr);

            // Input transactions (for debug) =========================
            $display("input transaction monitored @%0t: ",tr.issue_time);
            tr.do_print();
            $display("\n\n*********************\n\n");
            // =================================


            mon2env.put(tr.do_copy());
        end
    endtask : run



//---do_monitor(): Read a transaction from the DUT output and send to scoreboard
    task do_monitor(output ALU_in_transaction tr);
        integer needed_cycle = 0;
        integer flag = 0;
        @(negedge bus.clk);
        
        

        while ((!(bus.operand_valid && bus.ready)) || bus.rst==0) begin
            if(bus.ready && !bus.operand_valid && bus.rst)
                break;
            @(negedge bus.clk);
        end

        
        tr = new();
        if(bus.ready && !bus.operand_valid) begin
            tr.op = 0;
            tr.needed_cycle = 1;
            tr.is_empty = 1;
            tr.a = 0;
            tr.b = 0;
        end else begin 
            tr.op = alu_in_op_t'(bus.op);
            tr.is_empty = 0;
            if(bus.op != rst_op) begin
                while(!flag ) begin
                    if (bus.operand_valid && bus.ready) begin
                        tr.a[(needed_cycle+1)*OPERAND_BUS_WIDTH-1 -: OPERAND_BUS_WIDTH]  = bus.a;
                        // $display("from monitor %d is  %x ,,, %x \t time:%0t" , ((needed_cycle+1)*OPERAND_BUS_WIDTH -1) ,tr.a , bus.a,$time  );
                        tr.b[(needed_cycle+1)*OPERAND_BUS_WIDTH-1 -: OPERAND_BUS_WIDTH]  = bus.b;    
                        needed_cycle = needed_cycle + 1;

                        if(bus.operand_last == 1) begin
                            flag = 1;
                            tr.needed_cycle = needed_cycle;
                        end
                    end
                    @(negedge bus.clk);
                end
            end else begin
                tr.a = 0;
                tr.b = 0;
            end
        end

        monitor_coverage.sample(tr);

        
        
        
    endtask : do_monitor
//---------------------------------------------------------------------------

endclass : ALU_in_monitor










