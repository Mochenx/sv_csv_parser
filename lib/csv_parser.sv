// Author: Mo Chen
// May 22, 2015

// Error Codes
typedef enum int { 
    CSV_SUCCESS =0,
    CSV_EPARSE  =1, //Parse error in strict mode
    CSV_EINVALID=2 //Invalid code,should never be received from csv_error
} CSV_RETURN_VAL; 


//* Character values
typedef enum bit [7:0] { 
    CSV_TAB    = 8'h09,
    CSV_SPACE  = 8'h20,
    CSV_CR     = 8'h0d,
    CSV_LF     = 8'h0a,
    CSV_COMMA  = 8'h2c,
    CSV_QUOTE  = 8'h22
} CSV_CHARACTERS;


typedef enum int { 
    ROW_NOT_BEGUN           =0,
    FIELD_NOT_BEGUN         =1,
    FIELD_BEGUN             =2,
    FIELD_MIGHT_HAVE_ENDED  =3
} CSV_PARSE_STATE;


class csv_record;
    protected string fields[$];
    
    virtual function void push_back(string field);
        fields.push_back(field);
    endfunction

    virtual function string get_field(int unsigned field_index);
        return fields[field_index];
    endfunction

    virtual function int unsigned size();
        return fields.size();
    endfunction
endclass


class csv_parser;
    string file_buffer[$];// File buffer for the raw contents from csv
    protected csv_record record_rows[$];

    // Configurations
    protected CSV_PARSE_STATE state = ROW_NOT_BEGUN;
    protected bit [7:0] delim = CSV_COMMA;
    protected bit [7:0] quote = CSV_QUOTE;

    // Local variables used in parsing
    protected string a_field = "";
    protected int quoted = 0, spaces = 0, entry_pos = 0;

    function new();
    endfunction

    // To make the user know how many functions are supplied by csv_parser, 
    // extern function definition is used here.

    // Public Functions
    extern function int load_csv_file(string file_name);
    extern function CSV_RETURN_VAL parse();
    extern function csv_record get_record(int unsigned row_index=0);
    extern virtual function int unsigned size();

    // Private Functions
    extern protected virtual function int row_not_begun_field_not_begun_proc(bit [7:0] c);
    extern protected virtual function CSV_RETURN_VAL field_begun_proc(bit [7:0] c);
    extern protected virtual function CSV_RETURN_VAL field_might_have_ended_proc(bit [7:0] c);

    extern protected virtual function void submit_row(bit [7:0] c);
    extern protected virtual function void submit_field();
    extern protected virtual function void submit_char(bit [7:0] c);

endclass


function int csv_parser::load_csv_file(string file_name);
    int fd;
    string str;

    fd = $fopen(file_name,"r");
    if(fd == 0) begin
        $display("Fatal Error:Can NOT find the %s to open",file_name);
        return 1;
    end
    file_buffer.delete();

    while ($fgets(str, fd) > 0) begin
        if (str == "")
            continue;
        file_buffer.push_back(str);
    end
    $fclose(fd);
    return 0;
endfunction

function CSV_RETURN_VAL csv_parser::parse();
    int row=0, col=0;
    bit [7:0] c;
    CSV_RETURN_VAL ret_code;
    
    quoted = 0;
    record_rows.delete();

    foreach(file_buffer[row]) begin
        foreach(file_buffer[row][col]) begin
            c = file_buffer[row][col];

            case(state)
            ROW_NOT_BEGUN, FIELD_NOT_BEGUN:
                if(row_not_begun_field_not_begun_proc(c))
                    continue;
            FIELD_BEGUN: begin
                ret_code = field_begun_proc(c);
                if(ret_code != CSV_SUCCESS)
                    return ret_code;
            end
            FIELD_MIGHT_HAVE_ENDED: begin
                ret_code = field_might_have_ended_proc(c);
                if(ret_code != CSV_SUCCESS)
                    return ret_code;
            end
            endcase
        end
    end
    return CSV_SUCCESS;
endfunction

function csv_record csv_parser::get_record(int unsigned row_index=0);
    return record_rows[row_index];
endfunction

function int unsigned csv_parser::size();
    int row_cnt = 0; 

    // Find the first empty row, and only rows before it counts
    foreach(record_rows[i])
        if(record_rows[i].size() == 0) begin
            row_cnt = i ;
            break;
        end
    return row_cnt;
endfunction

function int csv_parser::row_not_begun_field_not_begun_proc(bit [7:0] c);
    if((c == CSV_SPACE || c == CSV_TAB) && c!=delim)
        return 1; // Continue
    else if (c == CSV_CR || c == CSV_LF) begin // Carriage Return or Line Feed
        if(state == FIELD_NOT_BEGUN) begin
            `COVER(submit_field();)
            `COVER(submit_row(c);)
        end
        // Don't submit empty rows by default
        return 1; // Continue
    end
    else if (c == delim) // Comma
        `COVER(submit_field();)
    else if (c == quote) begin // Quote
        `COVER(state = FIELD_BEGUN;)
        quoted = 1;
    end
    else begin               // Anything else
      `COVER(state = FIELD_BEGUN;)
      quoted = 0;
      submit_char(c);
    end
    
    return 0;
endfunction

function CSV_RETURN_VAL csv_parser::field_begun_proc(bit [7:0] c);
    if (c == quote) begin // Quote
        if (quoted) begin
            `COVER(submit_char(c);)
            state = FIELD_MIGHT_HAVE_ENDED;
        end
        else // STRICT ERROR - double quote inside non-quoted field
            `COVER(return CSV_EPARSE;)
    end 
    else if (c == delim) begin  // Comma
        if (quoted)
            `COVER(submit_char(c);)
        else 
            `COVER(submit_field();)
    end 
    else if (c == CSV_CR || c == CSV_LF) begin  // Carriage Return or Line Feed
        if (!quoted) begin
            `COVER(submit_field();)
            submit_row(c);
        end 
        else
            `COVER(submit_char(c);)
    end 
    else if (!quoted && (c == CSV_SPACE || c == CSV_TAB)) begin // Tab or space for non-quoted field
        `COVER(submit_char(c);)
        spaces++;
    end 
    else begin  // Anything else
        `COVER(submit_char(c);)
        spaces = 0;
    end
    return CSV_SUCCESS;
endfunction

function CSV_RETURN_VAL csv_parser::field_might_have_ended_proc(bit [7:0] c);
    // This only happens when a quote character is encountered in a quoted field
    if (c == delim) begin  // Comma
        `COVER(entry_pos -= spaces + 1;)  // get rid of spaces and original quote
        submit_field();
    end 
    else if (c == CSV_CR || c == CSV_LF) begin  // Carriage Return or Line Feed
        `COVER(entry_pos -= spaces + 1;)  // get rid of spaces and original quote
        submit_field();
        submit_row(c);
    end 
    else if (c == CSV_SPACE || c == CSV_TAB) begin  // Space or Tab
        `COVER(submit_char(c);)
        spaces++;
    end 
    else if (c == quote) begin  // Quote
        if (spaces) 
            // STRICT ERROR - unescaped double quote
            `COVER(return CSV_EPARSE;)
        else
            // Two quotes in a row
            `COVER(state = FIELD_BEGUN;)
    end
    else begin  // Anything else
        // STRICT ERROR - unescaped double quote
        `COVER(return CSV_EPARSE;)
    end
    return CSV_SUCCESS;
endfunction

function void csv_parser::submit_row(bit [7:0] c);
    csv_record new_row;

    new_row = new();
    record_rows.push_back(new_row);

    state = ROW_NOT_BEGUN;
    entry_pos = 0;
    quoted = 0;
    spaces = 0;
endfunction

function void csv_parser::submit_field();
    csv_record new_row;
    csv_record fields;
    string field_being_pushed = "";

    if(record_rows.size() == 0) begin
        new_row = new();
        record_rows.push_back(new_row);
    end

    fields = record_rows[$];
    if(!quoted)
        entry_pos -= spaces;
    for(int i=0;i < entry_pos;i ++)
        field_being_pushed = {field_being_pushed, a_field[i]};
    fields.push_back(field_being_pushed);
    a_field = "";

    state = FIELD_NOT_BEGUN;
    entry_pos = 0;
    quoted = 0;
    spaces = 0;
endfunction

function void csv_parser::submit_char(bit [7:0] c);
    string s = string'(c);
    a_field = {a_field, s};
    entry_pos ++;
endfunction

