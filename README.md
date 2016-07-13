# sv_csv_parser
A CSV file parser, written in SystemVerilog

# How to use csv_parser:
```systemverilog
    csv_record record_row;
    csv_parser parser = new();

    // Quit if load fails
    assert(!parser.load_csv_file(csv_file_name)) else ...;

    // Quit if parsing fails
    assert(parser.parse() == CSV_SUCCESS) else ...;

    
    // Iterate each field of the table
    for(int i=0;i < parser.size();i ++) begin
        record_row = parser.get_record(.row_index(i));
        for(int j=0;j < record_row.size();j ++)
            field = record_row.get_field(.field_index(j));
    end
```

# About csv_title_reader
Class **csv_title_reader** reads, parses given csv file, and builds a **title-value** mapping according to the contents of csv file, 
with recognizing fields of first row as titles for the values below them.


As an example, for a CSV file:
```
ID, Name, Age, 
0,  John, 11
1,  Joe,  12
```

After parsing of **csv_title_reader**, codes as followings would be written for accessing a field:

```systemverilog
    csv_table_with_title the_tab;
    csv_title_reader title_rdr = new();
    string val;

    the_tab = title_rdr.read_n_parse_csv("A CSV File.csv");
    assert(the_tab.get_field(.row_no(1), .field_name("Name"), .value(val)) else ...;
    // val == "Joe"
```
