// Author: Mo Chen
// Apr 18, 2015

`include "unit_test.svh"

class mjolnir_testcase extends mjolnir_statistic;
    mjolnir_task all_tasks[$];
    string testcase_name = "Unnamed Testcase";


    // Virtual functions & tasks inherited from its base
    virtual function void setup();
    endfunction

    virtual function void tear_down();
    endfunction

    virtual function string test_name();
        return testcase_name;
    endfunction
    
    virtual task run(ref TEST_RUN_STATUS pass);
        string s;
        string s_statistic;

        test_counter = 0;
        foreach(all_tasks[i]) begin
            TEST_RUN_STATUS task_pass;
            $sformat(s, "\n----Running task: %s", all_tasks[i].task_name());
            `MJOLNIR_INFO(s);

            setup();
            all_tasks[i].test_task(task_pass);
            test_passes[all_tasks[i].task_name()] = task_pass;
            tear_down();

            test_counter ++;
        end
        pass = test_conclusion();

        s_statistic = format_statistic(test_name());
        `MJOLNIR_INFO(s_statistic);
    endtask

    virtual function string test_status();
        string s_statistic;
        string prefix ;
        $sformat(prefix, "----%s", test_name());

        s_statistic = format_statistic(prefix);
        return s_statistic;
    endfunction
    /////////////////////////////////////////////////////

    function new(string testcase_name="");
        this.testcase_name = (testcase_name == "")?this.testcase_name:testcase_name;
    endfunction
endclass

