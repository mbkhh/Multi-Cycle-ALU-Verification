//--------------------------------------
// Last Update  : 2025/6
// Author       : Mohammad Bagher Khandan
//---------------------------------------

class Scoreboard;

    mailbox model2scb;
    mailbox mon_out_2_scb;
    int failed_num = 0;
    int passed_num = 0;

//---------------------------------------new(): Construct a scoreboard object
    function new(mailbox model2scb, mailbox mon_out_2_scb);
        this.model2scb = model2scb;
        this.mon_out_2_scb = mon_out_2_scb;
    endfunction
//---------------------------------------------------------------------------
 
//---------------------------------wrap_up() : Print end of simulation report
    function void wrap_up();
        $display("\n\nscore board Results========================= \n");
        $display("\t%0d passed, %0d failed", passed_num, failed_num);
        $display("\n\nscore board Results========================= \n");

        $stop();
    endfunction : wrap_up
//---------------------------------------------------------------------------

//---------------------------------run() : recieve transaction from generator
    task run();
        ALU_out_transaction tr_expected;
        ALU_out_transaction tr_actual;
        forever begin
            model2scb.get(tr_expected);
            mon_out_2_scb.get(tr_actual);
            check_actual(tr_expected, tr_actual);
        end
    endtask : run
//---------------------------------------------------------------------------

//---------------------------------------------------------------check_actual
    function void check_actual (
        ALU_out_transaction tr_expected,
        ALU_out_transaction tr_actual
        );

        

        if(tr_expected.do_compare(tr_actual)) begin
            passed_num++;
            $display("test pass! %0d ", passed_num);

            // for debug =========
            $display("expected transaction: ");
            tr_expected.do_print();

            $display("actual transaction@%0t: ",tr_actual.issue_time);
            tr_actual.do_print();
            // ================

        end else begin
            failed_num++;
            $display("test failed! %0d ", failed_num);

            $display("expected transaction: ");
            tr_expected.do_print();

            $display("actual transaction@%0t: ",tr_actual.issue_time);
            tr_actual.do_print();
        end
        $display("============================================ \n");

    endfunction : check_actual

//---------------------------------------------------------------------------

endclass : Scoreboard

















