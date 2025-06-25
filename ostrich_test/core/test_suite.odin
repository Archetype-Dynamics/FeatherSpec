package core


make_test_suite :: proc(name: string, description: string) -> TestSuite {
    return TestSuite{
        name = name,
        description = description,
        testCases = make([dynamic]TestCase),
        tags = {},
    }
}

add_test_proc :: proc(suite: ^TestSuite, name: string, testProcedure: TestProc) {
    test_case := make_test_case(name, "", testProcedure)
    append(&suite.testCases, test_case)
}

// Suite lifecycle hooks
with_suite_setup :: proc(suite: ^TestSuite, setup: SetupProc) {
    suite.suite_setup = setup
}

with_suite_teardown :: proc(suite: ^TestSuite, teardown: TeardownProc) {
    suite.suite_teardown = teardown
}

with_before_each :: proc(suite: ^TestSuite, before: SetupProc) {
    suite.before_each = before
}

with_after_each :: proc(suite: ^TestSuite, after: TeardownProc) {
    suite.after_each = after
}