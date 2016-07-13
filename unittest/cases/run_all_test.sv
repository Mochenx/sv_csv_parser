`include "unit_test.svh"

program TB;
import mjolnir_unit_test::*;

class all_tc4csv_parser extends mjolnir_testsuit;
    ut_basic_unquoted test_basic_unquoted;
    ut_basic_quoted test_basic_quoted;
    ut_title_reader test_title_reader;

    function new(string the_name="");
        super.new(the_name);

        test_basic_unquoted = new("Test loading & parsing unquoted fields");
        test_basic_quoted = new("Test loading & parsing quoted fields");
        test_title_reader = new("Test the title reader");
        add_test(test_basic_unquoted);
        add_test(test_basic_quoted);
        add_test(test_title_reader);
    endfunction
endclass

TEST_RUN_STATUS pass;
all_tc4csv_parser my_suit;

initial begin
    my_suit = new("The test suit for CSV Parser");
    my_suit.run(pass);
    $display("==========================================================");
    $display(my_suit.test_status());
    assert(pass == PASS);
    $display("Test for the framework of unittest has done");
    $display("==========================================================");
    $display("The followings are code coverage");
    sv_code_coverage_collector::print();
end
endprogram
