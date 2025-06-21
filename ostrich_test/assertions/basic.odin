package assertions

import "core:fmt"
import "core:strings"
import "../core"

// Global assertion state (thread-local for parallel safety)
@(thread_local) current_test_state: struct {
    failed: bool,
    error_message: string,
    assertions_passed: int,
    assertions_failed: int,
}

// Reset assertion state for new test
reset_assertions :: proc() {
    current_test_state.failed = false
    current_test_state.error_message = ""
    current_test_state.assertions_passed = 0
    current_test_state.assertions_failed = 0
}

// Get test result based on assertion state
get_test_result :: proc(test_name: string) -> core.TestResult {
    defer reset_assertions()
    
    if current_test_state.failed {
        return core.TestResult{
            name = test_name,
            status = .FAIL,
            message = current_test_state.error_message,
            assertions_passed = current_test_state.assertions_passed,
            assertions_failed = current_test_state.assertions_failed,
        }
    }
    
    return core.TestResult{
        name = test_name,
        status = .PASS,
        message = "All assertions passed",
        assertions_passed = current_test_state.assertions_passed,
        assertions_failed = current_test_state.assertions_failed,
    }
}

// EXPORTED helper functions for other modules
record_failure :: proc(message: string, location := #caller_location) {
    current_test_state.failed = true
    current_test_state.assertions_failed += 1
    
    if current_test_state.error_message == "" {
        current_test_state.error_message = fmt.tprintf("%s at %s:%d", message, location.file_path, location.line)
    } else {
        current_test_state.error_message = fmt.tprintf("%s\n%s at %s:%d", 
            current_test_state.error_message, message, location.file_path, location.line)
    }
}

// EXPORTED helper function for other modules
record_success :: proc() {
    current_test_state.assertions_passed += 1
}

// Basic assertions
assert_true :: proc(condition: bool, message: string = "", location := #caller_location) {
    if condition {
        record_success()
    } else {
        error_msg := "Expected true, got false"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_false :: proc(condition: bool, message: string = "", location := #caller_location) {
    if !condition {
        record_success()
    } else {
        error_msg := "Expected false, got true"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_equal :: proc(expected: $T, actual: T, message: string = "", location := #caller_location) {
    if expected == actual {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%v', got '%v'", expected, actual)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_not_equal :: proc(not_expected: $T, actual: T, message: string = "", location := #caller_location) {
    if not_expected != actual {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected not '%v', but got '%v'", not_expected, actual)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_nil :: proc(value: $T, message: string = "", location := #caller_location) {
    if value == nil {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected nil, got '%v'", value)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_not_nil :: proc(value: $T, message: string = "", location := #caller_location) {
    if value != nil {
        record_success()
    } else {
        error_msg := "Expected non-nil value, got nil"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}