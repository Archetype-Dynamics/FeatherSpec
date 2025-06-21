package ostrich_test

import "core:fmt"
import core       "core"
import assertions "assertions"
import reporters  "reporters"
import matchers   "matchers"

// Core types and functions
TestCase :: core.TestCase
TestSuite :: core.TestSuite
TestResult :: core.TestResult
TestRunner :: core.TestRunner
TestConfig :: core.TestConfig

// Test execution
run_test :: core.run_test
run_suite :: core.run_suite
run_all :: core.run_all

// Test creation helpers
test :: core.test
suite :: core.suite
setup :: core.setup
teardown :: core.teardown
before_each :: core.before_each
after_each :: core.after_each

// Assertions - Basic
assert_true :: assertions.assert_true
assert_false :: assertions.assert_false
assert_equal :: assertions.assert_equal
assert_not_equal :: assertions.assert_not_equal
assert_nil :: assertions.assert_nil
assert_not_nil :: assertions.assert_not_nil

// Assertions - Strings
assert_contains :: assertions.assert_contains
assert_not_contains :: assertions.assert_not_contains
assert_starts_with :: assertions.assert_starts_with
assert_ends_with :: assertions.assert_ends_with
assert_matches :: assertions.assert_matches

// Assertions - Numbers
assert_greater :: assertions.assert_greater
assert_greater_equal :: assertions.assert_greater_equal
assert_less :: assertions.assert_less
assert_less_equal :: assertions.assert_less_equal
assert_between :: assertions.assert_between

// Assertions - Collections
assert_length :: assertions.assert_length
assert_empty :: assertions.assert_empty
assert_not_empty :: assertions.assert_not_empty
assert_contains_element :: assertions.assert_contains_element

// Assertion helpers
reset_assertions :: assertions.reset_assertions
get_test_result :: assertions.get_test_result

// HTTP Matchers
assert_http_status :: matchers.assert_http_status
assert_http_header :: matchers.assert_http_header
assert_http_body :: matchers.assert_http_body

// File Matchers
assert_file_exists :: matchers.assert_file_exists
assert_file_contains :: matchers.assert_file_contains
assert_directory_exists :: matchers.assert_directory_exists

// Reporters
ConsoleReporter :: reporters.ConsoleReporter
make_console_reporter :: reporters.make_console_reporter

// Configuration
Config :: struct {
    verbose: bool,
    parallel: bool,
    timeout_ms: i64,
    reporter: reporters.Reporter,
    filter_pattern: string,
    exclude_tags: []string,
    include_tags: []string,
    fail_fast: bool,
    repeat_count: int,
}

// Default configuration
default_config :: proc() -> Config {
    return Config{
        verbose = false,
        parallel = false,
        timeout_ms = 30000, // 30 seconds
        filter_pattern = "",
        exclude_tags = {},
        include_tags = {},
        fail_fast = false,
        repeat_count = 1,
    }
}

// Quick test runner for simple cases
quick_test :: proc(name: string, test_proc: proc() -> bool) -> bool {
    config := core.TestConfig{
        verbose = true,
        parallel = false,
        timeout = 30_000_000_000, // 30 seconds in nanoseconds
        repeat_count = 1,
        fail_fast = false,
        reporter = nil,
    }
    
    test_case := core.make_test_case(name, "", proc() -> core.TestResult {
        reset_assertions()
        if test_proc() {
            return get_test_result(name)
        } else {
            return core.TestResult{
                name = name,
                status = .FAIL,
                message = "Test function returned false",
            }
        }
    })
    
    result := core.run_test(test_case, config)
    
    // Print result
    if result.status == .PASS {
        fmt.printf("✓ %s\n", result.name)
    } else {
        fmt.printf("✗ %s: %s\n", result.name, result.message)
    }
    
    return result.status == .PASS
}

// Version info
VERSION :: "1.0.0"
FRAMEWORK_NAME :: "OstrichTest"

version :: proc() -> string {
    return VERSION
}

framework_info :: proc() -> string {
    return fmt.tprintf("%s v%s - A comprehensive testing framework for Odin", FRAMEWORK_NAME, VERSION)
}