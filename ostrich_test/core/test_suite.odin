package core

TestSuite :: struct {
    name: string,
    description: string,
    test_cases: [dynamic]TestCase,
    suite_setup: SetupFunc,
    suite_teardown: TeardownFunc,
    before_each: SetupFunc,
    after_each: TeardownFunc,
    tags: []string,
}

make_test_suite :: proc(name: string, description: string) -> TestSuite {
    return TestSuite{
        name = name,
        description = description,
        test_cases = make([dynamic]TestCase),
        tags = {},
    }
}

// Removed add_test - it's defined in test_runner.odin

add_test_func :: proc(suite: ^TestSuite, name: string, test_func: TestFunc) {
    test_case := make_test_case(name, "", test_func)
    append(&suite.test_cases, test_case)
}

// Suite lifecycle hooks
with_suite_setup :: proc(suite: ^TestSuite, setup: SetupFunc) {
    suite.suite_setup = setup
}

with_suite_teardown :: proc(suite: ^TestSuite, teardown: TeardownFunc) {
    suite.suite_teardown = teardown
}

with_before_each :: proc(suite: ^TestSuite, before: SetupFunc) {
    suite.before_each = before
}

with_after_each :: proc(suite: ^TestSuite, after: TeardownFunc) {
    suite.after_each = after
}