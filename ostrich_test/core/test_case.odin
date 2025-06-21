package core

import "core:time"

TestFunc :: proc() -> TestResult
SetupFunc :: proc() -> bool
TeardownFunc :: proc() -> bool

TestCase :: struct {
    name: string,
    description: string,
    test_func: TestFunc,
    setup: SetupFunc,
    teardown: TeardownFunc,
    timeout: time.Duration,
    tags: []string,
    skip: bool,
    skip_reason: string,
}

make_test_case :: proc(name: string, description: string, test_func: TestFunc) -> TestCase {
    return TestCase{
        name = name,
        description = description,
        test_func = test_func,
        timeout = 30 * time.Second,
        tags = {},
        skip = false,
    }
}

make_test_case_with_setup :: proc(
    name: string, 
    description: string, 
    test_func: TestFunc,
    setup: SetupFunc,
    teardown: TeardownFunc,
) -> TestCase {
    test_case := make_test_case(name, description, test_func)
    test_case.setup = setup
    test_case.teardown = teardown
    return test_case
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