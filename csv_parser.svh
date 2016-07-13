// A Tiny CSV file parser, in SystemVerilog
// Copyright (C) 2015 Mo Chen
// 
// This library is free; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3.0 of the License, or (at your option) any later version.

`ifndef CSV_PARSER_PREFIX 
`define CSV_PARSER_PREFIX .
`endif

`ifndef IN_OTHER_PKG
`define AUTO_BUILD_INC_PATH(T, ORIGINAL_PATH) `"``T``/``ORIGINAL_PATH```"

// This file contains a package named 'csv_parser_pkg'
package csv_parser_pkg;
`endif

`include `AUTO_BUILD_INC_PATH(`CSV_PARSER_PREFIX, lib/sv_coverage.sv)
`include `AUTO_BUILD_INC_PATH(`CSV_PARSER_PREFIX, lib/csv_parser.sv)
`include `AUTO_BUILD_INC_PATH(`CSV_PARSER_PREFIX, lib/csv_title_reader.sv)

`ifndef IN_OTHER_PKG
endpackage

`undef AUTO_BUILD_INC_PATH
`endif

