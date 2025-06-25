package core

import "core:time"

make_test_case :: proc(name: string, description: string, testProcedure: TestProc) -> TestCase {
    return TestCase{
        name = name,
        description = description,

        test_proc = testProcedure,
        timeout = 30 * time.Second,
        tags = {},
        skip = false,
    }
}

make_test_case_with_setup :: proc(
    name: string,
    description: string,
    testProcedure: TestProc,
    setup: SetupProc,
    teardown: TeardownProc,
) -> TestCase {
    newTestCase := make_test_case(name, description, testProcedure)
    newTestCase.setup = setup
    newTestCase.teardown = teardown
    return newTestCase
}

// Add tags to test case
with_tags :: proc(test_case: ^TestCase, tags: ..string) {
    test_case.tags = make([]string, len(tags))
    copy(test_case.tags, tags)
}

// Set timeout for test case
with_timeout :: proc(test_case: ^TestCase, timeout: time.Duration) {
    test_case.timeout = timeout
}

// Skip test case
skip_test :: proc(test_case: ^TestCase, reason: string = "") {
    test_case.skip = true
    test_case.skip_reason = reason
}