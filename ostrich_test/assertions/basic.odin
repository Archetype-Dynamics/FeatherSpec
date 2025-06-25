package assertions

import "core:fmt"
import "core:strings"
import "../core"

// Global assertion state (thread-local for parallel safety)
@(thread_local)
currentTestState: struct {
    failed: bool,
    errorMessage: string,
    assertionsPassed: int,
    assertionsFailed: int,
}

// Reset assertion state for new test
reset_assertions :: proc() {
    currentTestState.failed = false
    currentTestState.errorMessage = ""
    currentTestState.assertionsPassed = 0
    currentTestState.assertionsFailed = 0
}

// Get test result based on assertion state
get_test_result :: proc(testName: string) -> core.TestResult {
    defer reset_assertions()

    if currentTestState.failed {
        return core.TestResult{
            name = testName,
            status = .FAIL,
            message = currentTestState.errorMessage,
            assertionsPassed = currentTestState.assertionsPassed,
            assertionsFailed = currentTestState.assertionsFailed,
        }
    }

    return core.TestResult{
        name = testName,
        status = .PASS,
        message = "All assertions passed",
        assertionsPassed = currentTestState.assertionsPassed,
        assertionsFailed = currentTestState.assertionsFailed,
    }
}

// EXPORTED helper functions for other modules
record_failure :: proc(message: string, location := #caller_location) {
    currentTestState.failed = true
    currentTestState.assertionsFailed += 1

    if currentTestState.errorMessage == "" {
        currentTestState.errorMessage = fmt.tprintf("%s at %s:%d", message, location.file_path, location.line)
    } else {
        currentTestState.errorMessage = fmt.tprintf("%s\n%s at %s:%d",
            currentTestState.errorMessage, message, location.file_path, location.line)
    }
}

// EXPORTED helper function for other modules
record_success :: proc() {
    currentTestState.assertionsPassed += 1
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