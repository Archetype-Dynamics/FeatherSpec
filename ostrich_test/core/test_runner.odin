package core

import "core:fmt"
import "core:time"
import "core:strings"

make_test_runner :: proc(config: TestConfig) -> TestRunner {
    return TestRunner{
        config = config,
        suites = make([dynamic]TestSuite),
        results = make([dynamic]TestResult),
    }
}

add_test :: proc(suite: ^TestSuite, test_case: TestCase) {
    append(&suite.testCases, test_case)
}

run_all :: proc(runner: ^TestRunner) -> bool {
    runner.startTime = time.now()
    defer {
        runner.endTime = time.now()
    }

    all_passed := true

    for suite in runner.suites {
        if !run_suite_internal(runner, suite) {
            all_passed = false
            if runner.config.failFast {
                break
            }
        }
    }

    return all_passed
}

run_suite :: proc(suite: TestSuite, config: TestConfig) -> []TestResult {
    runner := make_test_runner(config)
    append(&runner.suites, suite)
    run_all(&runner)
    return runner.results[:]
}

run_test :: proc(test_case: TestCase, config: TestConfig) -> TestResult {
    suite := make_test_suite("single_test", "Single test execution")
    add_test(&suite, test_case)
    results := run_suite(suite, config)
    return results[0] if len(results) > 0 else TestResult{}
}

@(private)
run_suite_internal :: proc(runner: ^TestRunner, suite: TestSuite) -> bool {
    if runner.config.verbose {
        fmt.printf("Running suite: %s\n", suite.name)
    }

    // Suite setup
    if suite.suite_setup != nil {
        if !suite.suite_setup(){
            if runner.config.verbose {
                fmt.printf("Suite setup failed for: %s\n", suite.name)
            }
            return false
        }
    }

    defer {
        if suite.suite_teardown != nil {
            suite.suite_teardown()
        }
    }

    suitePassed := true

    for testCase in suite.testCases {
        if should_run_test(testCase, runner.config) {
            for i in 0..<runner.config.repeatCount {
                result := run_single_test(testCase, suite, runner.config)
                append(&runner.results, result)
                update_counters(runner, result)

                if result.status != .PASS {
                    suitePassed = false
                    if runner.config.failFast {
                        return false
                    }
                }
            }
        } else {
            // Add skipped result
            result := TestResult{
                name = testCase.name,
                status = .SKIP,
                message = "Filtered out",
            }
            append(&runner.results, result)
            runner.skippedTests += 1
        }
    }

    return suitePassed
}

@(private)
run_single_test :: proc(test_case: TestCase, suite: TestSuite, config: TestConfig) -> TestResult {
    startTime := time.now()

    result := TestResult{
        name = test_case.name,
        status = .PASS,
    }

    if test_case.skip {
        result.status = .SKIP
        result.message = test_case.skip_reason
        return result
    }

    // Before each hook
    if suite.before_each != nil {
        if !suite.before_each() {
            result.status = .ERROR
            result.message = "Before each hook failed"
            return result
        }
    }

    defer {
        if suite.after_each != nil {
            suite.after_each()
        }
    }

    // Test setup
    if test_case.setup != nil {
        if !test_case.setup() {
            result.status = .ERROR
            result.message = "Test setup failed"
            result.duration = time.diff(startTime, time.now())
            return result
        }
    }

    defer {
        if test_case.teardown != nil {
            test_case.teardown()
        }
    }

    // Run the actual test with timeout
    testResult := test_case.test_proc()
    result = testResult
    result.duration = time.diff(startTime, time.now())

    // Report result
    if config.reporter != nil {
        config.reporter(result)
    }

    return result
}

@(private)
should_run_test :: proc(test_case: TestCase, config: TestConfig) -> bool {
    // Check include tags
    if len(config.includeTags) > 0 {
        has_included_tag := false
        for includeTag in config.includeTags {
            for test_tag in test_case.tags {
                if test_tag == includeTag {
                    has_included_tag = true
                    break
                }
            }
            if has_included_tag do break
        }
        if !has_included_tag do return false
    }

    // Check exclude tags
    for excludeTag in config.excludeTags {
        for test_tag in test_case.tags {
            if test_tag == excludeTag {
                return false
            }
        }
    }

    // Check name pattern
    if config.filterPattern != "" {
        if !strings.contains(test_case.name, config.filterPattern) {
            return false
        }
    }

    return true
}

@(private)
update_counters :: proc(runner: ^TestRunner, result: TestResult) {
    runner.totalTests += 1
    switch result.status {
    case .PASS:
        runner.passedTests += 1
    case .FAIL:
        runner.failedTests += 1
    case .SKIP:
        runner.skippedTests += 1
    case .ERROR, .TIMEOUT:
        runner.errorTests += 1
    }
}

// Convenience functions for quick testing
test :: proc(name: string, testProcedure: TestProc) -> TestCase {
    return make_test_case(name, "", testProcedure)
}

suite :: proc(name: string, description: string) -> TestSuite {
    return make_test_suite(name, description)
}

setup :: proc(setup_func: SetupProc) -> SetupProc {
    return setup_func
}

teardown :: proc(teardown_func: TeardownProc) -> TeardownProc {
    return teardown_func
}

before_each :: proc(before_func: SetupProc) -> SetupProc {
    return before_func
}

after_each :: proc(after_func: TeardownProc) -> TeardownProc {
    return after_func
}