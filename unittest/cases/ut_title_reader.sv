class ut_title_reader extends mjolnir_testcase;
    csv_title_reader title_reader;
    
    function new(string the_name = "");
        super.new(the_name);
    endfunction


    function void setup();
        title_reader = new();
    endfunction

    
    `MJOLNIR_NEW_TEST_BEGIN(test_titles, ut_title_reader)
        csv_table_with_title the_table;
        string expt_str[3] = '{"title1", "title2", "title 3"};
        pass = PASS;

        the_table = self.title_reader.read_n_parse_csv("../cases/test_title_reader_0.csv");
        assert(the_table != null) else pass = FAIL;
        foreach(expt_str[i])
            assert(expt_str[i] == the_table.titles[i]) else begin 
                    pass = FAIL; 
                    $display("Exptect: |%s|, Observe: |%s|", expt_str[i], the_table.titles[i]);
                end;
    `MJOLNIR_NEW_TEST_END(test_titles)

    `MJOLNIR_NEW_TEST_BEGIN(test_records_with_column_name, ut_title_reader)
        csv_table_with_title the_table;
        string expt_str[3][3] = '{
                        '{"11",     "21", "     31"},
                        '{"12",     "22", "     32"},
                        '{"13",     "23", "     33"}};
        int title_mapping[string];
        string col_val, title_name;

        pass = PASS;
        title_mapping["title1"] = 0;
        title_mapping["title2"] = 1;
        title_mapping["title 3"] = 2;

        the_table = self.title_reader.read_n_parse_csv("../cases/test_title_reader_0.csv");
        assert(the_table != null) else pass = FAIL;
        foreach(expt_str[i]) begin
            title_mapping.first(title_name);
            do begin
            assert(the_table.get_field(i, title_name, col_val)) else pass = FAIL;
                assert(expt_str[i][title_mapping[title_name]] == col_val) else begin 
                        pass = FAIL; 
                        $display("Exptect: |%s|, Observe: |%s|", 
                                expt_str[i][title_mapping[title_name]], col_val);
                    end;
            end
            while(title_mapping.next(title_name));

        end
    `MJOLNIR_NEW_TEST_END(test_records_with_column_name)

    `MJOLNIR_NEW_TEST_BEGIN(test_records_err_0, ut_title_reader)
        csv_table_with_title the_table;
        string expt_str[3][3] = '{
                        '{"11",     "21", "     31"},
                        '{"12",     "22", "unexisted in CSV file"},
                        '{"13",     "23", "     33"}};
        int title_mapping[string];
        int err_mapping[string];
        string col_val, title_name;
        string s;

        pass = PASS;
        title_mapping["title1"] = 0;
        title_mapping["title2"] = 1;
        title_mapping["title 3"] = 2;

        $sformat(s, "%0d-title 3", 1);
        err_mapping[s] = 1;

        the_table = self.title_reader.read_n_parse_csv("../cases/test_title_reader_err_0.csv");
        assert(the_table != null) else pass = FAIL;
        foreach(expt_str[i]) begin
            title_mapping.first(title_name);
            do begin
                $sformat(s, "%0d-%s", i, title_name);
                if(!err_mapping.exists(s))
                    assert(the_table.get_field(i, title_name, col_val)) else pass = FAIL;
                else begin
                    assert(!the_table.get_field(i, title_name, col_val)) else pass = FAIL;
                    break; // To skip the following comparison
                end

                assert(expt_str[i][title_mapping[title_name]] == col_val) else begin 
                        pass = FAIL; 
                        $display("Exptect: |%s|, Observe: |%s|", 
                                expt_str[i][title_mapping[title_name]], col_val);
                    end;
            end
            while(title_mapping.next(title_name));

        end
    `MJOLNIR_NEW_TEST_END(test_records_err_0)
endclass

