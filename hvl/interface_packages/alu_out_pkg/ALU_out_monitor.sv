//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//-----------

class ALU_out_monitor;

    virtual ALU_out_if bus;
    mailbox mon2env;
    ALU_out_coverage monitor_coverage;

    ALU_out_transaction tr;

    
//-------------------------------------------------new(): construct an object
    function new(
        input virtual ALU_out_if.monitor_mp bus,
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

            // output transactions (for debug) =========================
            $display("output transaction monitored @%0t: ",tr.issue_time);
            tr.do_print();
            $display("\n\n*********************\n\n");
            // =================================


            mon2env.put(tr.do_copy());
        end
    endtask : run



//---do_monitor(): Read a transaction from the DUT output and send to scoreboard
    task do_monitor(output ALU_out_transaction tr);
        integer flag = 0;
        integer cycle = 0;
        @(negedge bus.clk);
        
        while(bus.result_valid != 1 ) begin
            if(bus.result_rst && bus.rst)
                break;
            @(negedge bus.clk);
        end
        
        tr = new();

        tr.result_rst = bus.result_rst;
        if(!bus.result_rst) begin
            while(!flag ) begin
                
                if (bus.result_valid) begin
                    tr.result[(cycle+1)*RESULT_BUS_WIDTH-1 -: RESULT_BUS_WIDTH]  = bus.result; 
                    cycle = cycle + 1;
                    if(bus.result_last == 1) begin
                        flag = 1;
                    end
                end
                @(negedge bus.clk);
            end
        end 

        monitor_coverage.sample(tr);

        
        
        
    endtask : do_monitor
//---------------------------------------------------------------------------

endclass : ALU_out_monitor










