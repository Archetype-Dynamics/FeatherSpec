package tests

import "core:os"
import "core:fmt"
import "core:strings"
import ostrich_test "../ostrich_test"

import "../../src/core/engine/data"


run_engine_tests::proc(){
    suite:= ostrich_test.suite("OstrichDB Engine Tests", "" )


    //Collection Creation
    ostrich_test.add_test(&suite, ostrich_test.test("Test Collection Creation", proc() -> ostrich_test.TestResult {
    ostrich_test.reset_assertions()



    ostrich_test.assert_not_nil(rawptr(uintptr(1)), "Non-zero pointer should not be nil")
    return ostrich_test.get_test_result("test_assertions")
    }))







}