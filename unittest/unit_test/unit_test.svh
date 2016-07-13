`ifndef SV_CODE_HEADER_UNIT_TEST
`define SV_CODE_HEADER_UNIT_TEST

//`define MJOLNIR_BASE_CLASS uvm_test
`define MJOLNIR_INFO $display
`define MJOLNIR_DEBUG $display
`define MJOLNIR_FATAL $display
`define MJOLNIR_ERROR $display

`define BUILD_THE_BASE_CLASS_OF_UNIT_TEST(T) extends`` ``T

`ifdef MJOLNIR_BASE_CLASS
`define THE_BASE_CLASS_OF_MJOLNIR_UNITTEST `BUILD_THE_BASE_CLASS_OF_UNIT_TEST(`MJOLNIR_BASE_CLASS)
`else
`define THE_BASE_CLASS_OF_MJOLNIR_UNITTEST
`endif

`define MJOLNIR_NEW_TEST_BEGIN(NAME, TC_ENV) class NAME extends mjolnir_task; \
    TC_ENV self; \
    virtual function string task_name(); \
        return "``NAME``"; \
    endfunction \
    function new(mjolnir_testcase its_belonging); \
        its_belonging.all_tasks.push_back(this); \
        $cast(self, its_belonging); \
    endfunction \
    virtual task test_task(ref mjolnir_unit_test::TEST_RUN_STATUS pass); \
        pass = FAIL; \
        begin

`define MJOLNIR_NEW_TEST_END(NAME) end \
        endtask \
    endclass \
    NAME _``NAME``_internal_obj = new(this);
    
    

`endif
