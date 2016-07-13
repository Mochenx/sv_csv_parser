`ifndef MJOLNIR_UNITTEST_TK_PREFIX 
`define MJOLNIR_UNITTEST_TK_PREFIX .
`endif

`define AUTO_BUILD_INC_PATH(T, ORIGINAL_PATH) `"``T``/``ORIGINAL_PATH```"

package mjolnir_unit_test;

typedef enum {PASS=1, FAIL=0} TEST_RUN_STATUS; 

`include `AUTO_BUILD_INC_PATH(`MJOLNIR_UNITTEST_TK_PREFIX, lib/mjolnir_test.sv)
`include `AUTO_BUILD_INC_PATH(`MJOLNIR_UNITTEST_TK_PREFIX, lib/mjolnir_testcase.sv)
`include `AUTO_BUILD_INC_PATH(`MJOLNIR_UNITTEST_TK_PREFIX, lib/mjolnir_testsuit.sv)

endpackage

`undef AUTO_BUILD_INC_PATH
