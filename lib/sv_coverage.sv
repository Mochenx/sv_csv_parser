// Author: Mo Chen
// May 22, 2015

`ifdef CODE_COVERAGE_MODE
    `define COVER(cmd) begin sv_code_coverage_collector::submit(`__FILE__, `__LINE__, "``cmd``"); cmd end
`else
    `define COVER(cmd) cmd
`endif

class sv_file_coverage;
    string covered_line_no[*];
    int line_no_hit_times[*];

    function void submit(int unsigned line_no, string the_codes);
        if(!covered_line_no.exists(line_no)) begin
            covered_line_no[line_no] = the_codes;
            line_no_hit_times[line_no] = 0;
        end
        line_no_hit_times[line_no] ++;
    endfunction

    function string sprint(string prefix);
        string s_all_lines = "";
        string s;
        int line_no;

        void'(covered_line_no.first(line_no));
        do begin
            $sformat(s, "%s, Line: %0d, Hit: %0d, Codes: %s", 
                        prefix, line_no, line_no_hit_times[line_no], covered_line_no[line_no]);
            s_all_lines = {s_all_lines, s, "\n"};
        end
        while(covered_line_no.next(line_no));

        return s_all_lines;
    endfunction
endclass

class sv_code_coverage_collector;
    static sv_file_coverage coverages[string];

    static function void submit(string file_name, int unsigned line_no, string the_codes);
        sv_file_coverage file_coverage;
        if(!coverages.exists(file_name))
            coverages[file_name] = new();
        file_coverage = coverages[file_name];
        file_coverage.submit(line_no, the_codes);
    endfunction

    static function void print();
        string s = "";
        string s_all_files = "";
        string file_name;

        void'(coverages.first(file_name));
        do begin
            s = coverages[file_name].sprint(file_name);
            s_all_files = {s_all_files, s, "\n"};
        end
        while(coverages.next(file_name));
        $display(s_all_files);
    endfunction
endclass

