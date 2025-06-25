package core

import "core:time"

TestStatus :: enum {
    PASS,
    FAIL,
    SKIP,
    ERROR,
    TIMEOUT,
}

TestResult :: struct {
    name: string,
    status: TestStatus,
    message: string,
    duration: time.Duration,
    assertionsPassed: int,
    assertionsFailed: int,
    location: SourceLocation,
    errorDetails: string,
}

SourceLocation :: struct {
    file: string,
    line: int,
    procedure: string,
}

TestSuite :: struct {
    name: string,
    description: string,
    testCases: [dynamic]TestCase,
    suite_setup: SetupProc,
    suite_teardown: TeardownProc,
    before_each: SetupProc,
    after_each: TeardownProc,
    tags: []string,
}

TestCase :: struct {
    name: string,
    description: string,
    test_proc: TestProc,
    setup: SetupProc,
    teardown: TeardownProc,
    timeout: time.Duration,
    tags: []string,
    skip: bool,
    skip_reason: string,
}

TestRunner :: struct {
    config: TestConfig,
    suites: [dynamic]TestSuite,
    results: [dynamic]TestResult,
    startTime: time.Time,
    endTime: time.Time,
    totalTests: int,
    passedTests: int,
    failedTests: int,
    skippedTests: int,
    errorTests: int,
}

TestConfig :: struct {
    verbose: bool,
    parallel: bool,
    timeout: time.Duration,
    filterPattern: string,
    excludeTags: []string,
    includeTags: []string,
    failFast: bool,
    repeatCount: int,
    reporter: proc(result: TestResult),
}

TestProc :: proc() -> TestResult
SetupProc :: proc() -> bool
TeardownProc :: proc() -> bool