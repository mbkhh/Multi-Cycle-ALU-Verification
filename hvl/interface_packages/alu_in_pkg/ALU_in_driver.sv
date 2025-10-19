//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//------------------------------------------


class ALU_in_driver;

    mailbox gen2drv;	// For cells sent from generator
    event   drv2gen;	// Tell generator when I am done with cell
    virtual ALU_in_if in_bus;	// Virtual interface for transmitting transactions
    virtual ALU_out_if out_bus;


    ALU_in_transaction tr;

//-------------------------------------------new(): Construct a driver object
    function new (
        input mailbox                       gen2drv, 
	    input event                         drv2gen,
		input virtual ALU_in_if.driver_mp   in_bus,
        input virtual ALU_out_if.monitor_mp out_bus
    );

    this.gen2drv        = gen2drv;
    this.drv2gen        = drv2gen;
    this.in_bus         = in_bus;
    this.out_bus        = out_bus;



    endfunction : new 
//---------------------------------------------------------------------------

//-----------------------------------------------------run(): Run the driver. 
    task run();       
        forever begin
            gen2drv.get(tr);  // Remove transaction from the mailbox 
            
            send(tr);  

            ->drv2gen;	  // Tell the generator we are done
        end
    endtask : run
//---------------------------------------------------------------------------

//-------------------------------------------send(): Send a cell into the DUT
    task send(input ALU_in_transaction tr); 
      
        @(negedge in_bus.clk);
        while (in_bus.ready != 1 || in_bus.rst==0 )begin
            in_bus.op               = 0;
            in_bus.a                = 0;
            in_bus.b                = 0;
            in_bus.operand_last     = 0;            
            in_bus.operand_valid    = 0; 
            @(negedge in_bus.clk);
        end

        @(posedge in_bus.clk)

        if(in_bus.rst == 0 )begin
            in_bus.op               = 0;
            in_bus.a                = 0;
            in_bus.b                = 0;
            in_bus.operand_last     = 0;            
            in_bus.operand_valid    = 0;            
        end else begin
            if(tr.is_empty)
                in_bus.operand_valid    = 0;
            else
                in_bus.operand_valid    = 1;
            in_bus.op               = tr.op;
            if(tr.op != rst_op) begin
                integer i = 0;
                for (i = 0;i < tr.needed_cycle;i = i + 1 ) begin
                    in_bus.a            = tr.a[(i+1)*OPERAND_BUS_WIDTH -1 -: OPERAND_BUS_WIDTH];
                    // $display("from in driver a is :%x \t time:%0t" , in_bus.a, $time);
                    // $display("from %d is  %x \t time:%0t" , ((i+1)*OPERAND_BUS_WIDTH -1) ,tr.a,$time );
                    in_bus.b            = tr.b[(i+1)*OPERAND_BUS_WIDTH -1 -: OPERAND_BUS_WIDTH];
                    if(i == tr.needed_cycle - 1 )begin
                        in_bus.operand_last     = 1;
                    end else begin
                        in_bus.operand_last     = 0;
                    end
                    @(posedge in_bus.clk);
                end
            end
        end       
      
       
    endtask : send
//---------------------------------------------------------------------------

endclass : ALU_in_driver

