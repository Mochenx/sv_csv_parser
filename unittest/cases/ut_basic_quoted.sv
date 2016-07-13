class ut_basic_quoted extends mjolnir_testcase;
    csv_parser parser;
    
    function new(string the_name = "");
        super.new(the_name);
    endfunction


    function void setup();
        parser = new();
    endfunction

    
    `MJOLNIR_NEW_TEST_BEGIN(test_parse_quote_0, ut_basic_quoted)
        csv_record record_rows;
        string expt_str[4][5] = '{
                                '{"100", "200", "300"            , "400", "haha kaka"},
                                '{"110", "220", "330"            , "440", "wowo"     },
                                '{"120", "230", ""               , "450", "\""       },
                                '{"130", "  " , "340, \"350\", " , "460", "heihei"   }};
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_quote_0.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str[i][j]) 
                assert(expt_str[i][j] == record_rows.get_field(j)) else begin 
                        pass = FAIL; 
                        $display("Exptect: |%s|, Observe: |%s|", expt_str[i][j], record_rows.get_field(j));
                    end;
        end
    `MJOLNIR_NEW_TEST_END(test_parse_quote_0)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_quote_with_cr_in_quoted, ut_basic_quoted)
        csv_record record_rows;
        string expt_str[4][5] = '{
                                '{"100", "200", "300"            , "400", "haha kaka"},
                                '{"110", "220", "330"            , "440", "wowo"     },
                                '{"120", "230", "\n\n"               , "450", "\""       },
                                '{"130", "  " , "340, \"350\", " , "460", "heihei"   }};
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_quote_1.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() == 0) else pass = FAIL;

        foreach(expt_str[i]) begin
            record_rows = self.parser.get_record(i);
            assert(5 === record_rows.size());
            foreach(expt_str[i][j]) 
                assert(expt_str[i][j] == record_rows.get_field(j)) else begin 
                        pass = FAIL; 
                        $display("Exptect: |%s|, Observe: |%s|", expt_str[i][j], record_rows.get_field(j));
                    end;
        end
    `MJOLNIR_NEW_TEST_END(test_parse_quote_with_cr_in_quoted)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_quote_err_0, ut_basic_quoted)
        csv_record record_rows;
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_quote_2.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() > 0) else pass = FAIL;
    `MJOLNIR_NEW_TEST_END(test_parse_quote_err_0)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_quote_err_1, ut_basic_quoted)
        csv_record record_rows;
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_quote_3.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() > 0) else pass = FAIL;
    `MJOLNIR_NEW_TEST_END(test_parse_quote_err_1)

    `MJOLNIR_NEW_TEST_BEGIN(test_parse_quote_err_2, ut_basic_quoted)
        csv_record record_rows;
        pass = PASS;

        assert(self.parser.load_csv_file("../cases/test_load_csv_quote_4.csv") == 0) else pass = FAIL;
        assert(self.parser.parse() > 0) else pass = FAIL;
    `MJOLNIR_NEW_TEST_END(test_parse_quote_err_2)
endclass
