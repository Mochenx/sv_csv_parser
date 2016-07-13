import csv_parser_pkg::*;
import uvm_pkg::*;
import mjolnir_unit_test::*;

class ut_basic_unquoted extends mjolnir_testcase;
    csv_parser parser;
    
    function new(string the_name = "");
        super.new(the_name);
    endfunction


    function void setup();
        parser = new();
    endfunction

    
    `MJOLNIR_NEW_TEST_BEGIN(test_load_csv, ut_basic_unquoted)
        string expt_str = "100, 200, 300, 400, haha\n";
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_unexisted.csv") == 1) else pass = FAIL;
        assert(self.parser.load_csv_file("../cases/test_load_csv.csv") == 0) else pass = FAIL;
        assert(self.parser.file_buffer.size() == 1) else pass = FAIL;
        $display("Expect: %s", expt_str);
        $display("Observe: %s", self.parser.file_buffer[0]);
        assert(expt_str == self.parser.file_buffer[0]) else pass = FAIL;
    `MJOLNIR_NEW_TEST_END(test_load_csv)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_0, ut_basic_unquoted)
        csv_record record_rows;
        string expt_str[] = '{"100", "200", "300", "400", "haha"};
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        record_rows = self.parser.get_record(0);
        assert(expt_str.size() === record_rows.size());
        foreach(expt_str[i]) 
            assert(expt_str[i] == record_rows.get_field(i)) else pass = FAIL;
    `MJOLNIR_NEW_TEST_END(test_parse_0)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_1, ut_basic_unquoted)
        csv_record record_rows;
        string expt_str[2][5] = '{'{"100", "200", "300", "400", "haha"}, 
                                  '{"110", "220", "330", "440", "wowo"}};
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_2.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str[i][j]) 
                assert(expt_str[i][j] == record_rows.get_field(j)) else pass = FAIL;
        end
    `MJOLNIR_NEW_TEST_END(test_parse_1)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_empty, ut_basic_unquoted)
        csv_record record_rows;
        string expt_str[4][5] = '{
                                '{"100", "200", "300", "400", "haha"},
                                '{"110", "220", "330", "440", "wowo"},
                                '{"120", "230", ""   , "450", ""    },
                                '{"130", "",    "340", "460", "heihei"}};
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_empty.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str[i][j]) 
                assert(expt_str[i][j] == record_rows.get_field(j)) else pass = FAIL;
        end
    `MJOLNIR_NEW_TEST_END(test_parse_empty)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_run_twice, ut_basic_unquoted)
        csv_record record_rows;
        string expt_str_0[4][5] = '{
                                  '{"100", "200", "300", "400", "haha"},
                                  '{"110", "220", "330", "440", "wowo"},
                                  '{"120", "230", ""   , "450", ""    },
                                  '{"130", "",    "340", "460", "heihei"}};
        string expt_str_1[2][5] = '{'{"100", "200", "300", "400", "haha"}, 
                                    '{"110", "220", "330", "440", "wowo"}};
        pass = PASS;

        // The round One
        assert(self.parser.load_csv_file("../cases/test_load_csv_empty.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str_0[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str_0[i][j]) 
                assert(expt_str_0[i][j] == record_rows.get_field(j)) else pass = FAIL;
        end

        // The round Two
        assert(self.parser.load_csv_file("../cases/test_load_csv_2.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str_1[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str_1[i][j]) 
                assert(expt_str_1[i][j] == record_rows.get_field(j)) else pass = FAIL;
        end
    `MJOLNIR_NEW_TEST_END(test_parse_run_twice)
endclass

