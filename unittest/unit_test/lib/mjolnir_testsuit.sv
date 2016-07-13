// Author: Mo Chen
// Apr 18, 2015

`include "unit_test.svh"

class mjolnir_testsuit extends mjolnir_statistic;
    mjolnir_test all_tests[$];
    string testsuit_name = "Unnamed Testsuit";

    // Virtual functions & tasks inherited from its base
    virtual function void setup();
    endfunction

    virtual function void tear_down();
    endfunction

    virtual function string test_name();
        return testsuit_name;
    endfunction

    virtual task run(ref TEST_RUN_STATUS pass);
        TEST_RUN_STATUS test_pass;
        string s;
        string s_statistic;

        $sformat(s, "\nRunning test suit: %s", test_name());
        `MJOLNIR_INFO(s);

        test_counter = 0;
        foreach(all_tests[i]) begin
            $sformat(s, "\n--Running test: %s", all_tests[i].test_name());
            `MJOLNIR_INFO(s);

            all_tests[i].run(test_pass);
            test_passes[all_tests[i].test_name()] = test_pass;

            test_counter ++;
        end
        pass = test_conclusion();

        s_statistic = format_statistic(test_name());
        `MJOLNIR_INFO(s_statistic);
    endtask

    virtual function string test_status();
        string s_all_status[$];
        string s_status;

        foreach(all_tests[i]) begin
            string sub_test_name = all_tests[i].test_name();
            string prefix ;
            $sformat(prefix, "--%s", test_name());
            s_status = {s_status, "\n"};
            s_status = {s_status, format_test_by_name(prefix, sub_test_name)};
            s_status = {s_status, all_tests[i].test_status()};
        end

        return s_status;
    endfunction
    /////////////////////////////////////////////////////

    function void add_test(mjolnir_test new_test);
        all_tests.push_back(new_test);
    endfunction

    function new(string testsuit_name="");
        this.testsuit_name = (testsuit_name == "")?this.testsuit_name:testsuit_name;
    endfunction
    
endclass

