package core

import "core:fmt"
import "core:time"
import "core:strings"

TestRunner :: struct {
    config: TestConfig,
    suites: [dynamic]TestSuite,
    results: [dynamic]TestResult,
    start_time: time.Time,
    end_time: time.Time,
    total_tests: int,
    passed_tests: int,
    failed_tests: int,
    skipped_tests: int,
    error_tests: int,
}

TestConfig :: struct {
    verbose: bool,
    parallel: bool,
    timeout: time.Duration,
    filter_pattern: string,
    exclude_tags: []string,
    include_tags: []string,
    fail_fast: bool,
    repeat_count: int,
    reporter: proc(result: TestResult),
}

make_test_runner :: proc(config: TestConfig) -> TestRunner {
    return TestRunner{
        config = config,
        suites = make([dynamic]TestSuite),
        results = make([dynamic]TestResult),
    }
}

add_test :: proc(suite: ^TestSuite, test_case: TestCase) {
    append(&suite.test_cases, test_case)
}

run_all :: proc(runner: ^TestRunner) -> bool {
    runner.start_time = time.now()
    defer {
        runner.end_time = time.now()
    }
    
    all_passed := true
    
    for suite in runner.suites {
        if !run_suite_internal(runner, suite) {
            all_passed = false
            if runner.config.fail_fast {
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
        if !suite.suite_setup() {
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
    
    suite_passed := true
    
    for test_case in suite.test_cases {
        if should_run_test(test_case, runner.config) {
            for i in 0..<runner.config.repeat_count {
                result := run_single_test(test_case, suite, runner.config)
                append(&runner.results, result)
                update_counters(runner, result)
                
                if result.status != .PASS {
                    suite_passed = false
                    if runner.config.fail_fast {
                        return false
                    }
                }
            }
        } else {
            // Add skipped result
            result := TestResult{
                name = test_case.name,
                status = .SKIP,
                message = "Filtered out",
            }
            append(&runner.results, result)
            runner.skipped_tests += 1
        }
    }
    
    return suite_passed
}

@(private)
run_single_test :: proc(test_case: TestCase, suite: TestSuite, config: TestConfig) -> TestResult {
    start_time := time.now()
    
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
            result.duration = time.diff(start_time, time.now())
            return result
        }
    }
    
    defer {
        if test_case.teardown != nil {
            test_case.teardown()
        }
    }
    
    // Run the actual test with timeout
    test_result := test_case.test_func()
    result = test_result
    result.duration = time.diff(start_time, time.now())
    
    // Report result
    if config.reporter != nil {
        config.reporter(result)
    }
    
    return result
}

@(private)
should_run_test :: proc(test_case: TestCase, config: TestConfig) -> bool {
    // Check include tags
    if len(config.include_tags) > 0 {
        has_included_tag := false
        for include_tag in config.include_tags {
            for test_tag in test_case.tags {
                if test_tag == include_tag {
                    has_included_tag = true
                    break
                }
            }
            if has_included_tag do break
        }
        if !has_included_tag do return false
    }
    
    // Check exclude tags
    for exclude_tag in config.exclude_tags {
        for test_tag in test_case.tags {
            if test_tag == exclude_tag {
                return false
            }
        }
    }
    
    // Check name pattern
    if config.filter_pattern != "" {
        if !strings.contains(test_case.name, config.filter_pattern) {
            return false
        }
    }
    
    return true
}

@(private)
update_counters :: proc(runner: ^TestRunner, result: TestResult) {
    runner.total_tests += 1
    switch result.status {
    case .PASS:
        runner.passed_tests += 1
    case .FAIL:
        runner.failed_tests += 1
    case .SKIP:
        runner.skipped_tests += 1
    case .ERROR, .TIMEOUT:
        runner.error_tests += 1
    }
}

// Convenience functions for quick testing
test :: proc(name: string, test_func: TestFunc) -> TestCase {
    return make_test_case(name, "", test_func)
}

suite :: proc(name: string, description: string) -> TestSuite {
    return make_test_suite(name, description)
}

setup :: proc(setup_func: SetupFunc) -> SetupFunc {
    return setup_func
}

teardown :: proc(teardown_func: TeardownFunc) -> TeardownFunc {
    return teardown_func
}

before_each :: proc(before_func: SetupFunc) -> SetupFunc {
    return before_func
}

after_each :: proc(after_func: TeardownFunc) -> TeardownFunc {
    return after_func
}