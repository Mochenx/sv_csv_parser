// Author: Mo Chen
// Apr 18, 2015

`include "unit_test.svh"

virtual class mjolnir_test `THE_BASE_CLASS_OF_MJOLNIR_UNITTEST ;
    pure virtual function void setup();
    pure virtual function void tear_down();
    pure virtual task run(ref TEST_RUN_STATUS pass);
    pure virtual function string test_name();
    pure virtual function string test_status();
endclass


class mjolnir_statistic extends mjolnir_test;
    TEST_RUN_STATUS test_passes[string];
    int test_counter = 0;

    // Virtual functions & tasks inherited from its base
    virtual function void setup();
    endfunction

    virtual function void tear_down();
    endfunction

    virtual task run(ref TEST_RUN_STATUS pass);
    endtask

    virtual function string test_name();
        return "";
    endfunction

    virtual function string test_status();
    endfunction
    /////////////////////////////////////////////////////

    protected function TEST_RUN_STATUS test_conclusion();
        TEST_RUN_STATUS pass = PASS;
        string test_name;

        test_passes.first(test_name);
        do begin
            pass = (!test_passes[test_name])?FAIL:pass;
        end
        while(test_passes.next(test_name));
        return pass;
    endfunction

    protected function string format_test_by_name(string prefix = "test", string test_name);
        string s_rslt;
        $sformat(s_rslt, "\n%s-%s:\t\t%s", prefix, test_name, 
                    (test_passes[test_name] == PASS)?"PASS":"FAIL");
        return s_rslt;
    endfunction

    protected function string format_statistic(string prefix = "test");
        string s_counter;
        string s_test_rslts[$];
        string s_statistic;
        string test_name;

        //$sformat(s_counter, "\nTotally, %0d %s have run", test_counter, prefix);

        //s_statistic = s_counter;
        s_statistic = "";
        test_passes.first(test_name);
        do begin
            s_test_rslts.push_back(format_test_by_name(prefix, test_name));
        end
        while(test_passes.next(test_name));

        foreach(s_test_rslts[i]) begin
            s_statistic = {s_statistic, s_test_rslts[i]}; 
        end
        return s_statistic;
    endfunction

endclass


virtual class mjolnir_task;
    pure virtual function string task_name();
    pure virtual task test_task(ref TEST_RUN_STATUS pass);
endclass


class mjolnir_runner `THE_BASE_CLASS_OF_MJOLNIR_UNITTEST ;
    static mjolnir_test all_tests[$];

    task run();
    endtask
endclass
