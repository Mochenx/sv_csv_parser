// Author: Mo Chen
// May 22, 2015

class csv_table_with_title;
    string titles[$];

    protected int unsigned title_to_index_mapping[string];
    protected csv_record record_rows[$];

    function int get_field(int unsigned row_no, string field_name, ref string value);
        csv_record record;

        // Illegal title is given
        if(!title_to_index_mapping.exists(field_name))
            return 0;

        // Row index out-of-range
        if(record_rows.size() <= row_no)
            return 0;
            
        record = record_rows[row_no];
        // Column index out-of-range
        if(title_to_index_mapping[field_name] >= record.size())
            return 0;
        value = record.get_field(title_to_index_mapping[field_name]);
        return 1;
    endfunction

    function int unsigned size();
        return record_rows.size();
    endfunction

    virtual function void push_back(csv_record record);
        record_rows.push_back(record);
    endfunction

    function int append_title(string title, int unsigned column);
        titles.push_back(title);
        title_to_index_mapping[title] = column;
        return titles.size();
    endfunction
endclass


class csv_title_reader;
    protected csv_parser parser;
    
    function new();
        parser = new();
    endfunction

    function csv_table_with_title read_n_parse_csv(string csv_file_name);
        csv_record the_title_of_csv, record;
        csv_table_with_title the_table;
    
        // Quit if load fails
        assert(!parser.load_csv_file(csv_file_name)) else return null;

        // Quit if parsing fails
        assert(parser.parse() == CSV_SUCCESS) else return null;

        the_table = new();
    
        // Build titles of the table
        the_title_of_csv = parser.get_record(.row_index(0));
        for(int i=0;i < the_title_of_csv.size();i ++)
            void'(the_table.append_title(.title(the_title_of_csv.get_field(i)), 
                                   .column(i)));
    
        // Build contents of the table
        for(int i=1;i < parser.size();i ++) begin
            record = parser.get_record(.row_index(i));
            the_table.push_back(record);
        end
        return the_table;
    endfunction
endclass
