package assertions

import "core:fmt"

assert_greater :: proc(actual: $T, expected: T, message: string = "", location := #caller_location) {
    if actual > expected {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be greater than %v", actual, expected)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_greater_equal :: proc(actual: $T, expected: T, message: string = "", location := #caller_location) {
    if actual >= expected {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be greater than or equal to %v", actual, expected)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_less :: proc(actual: $T, expected: T, message: string = "", location := #caller_location) {
    if actual < expected {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be less than %v", actual, expected)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_less_equal :: proc(actual: $T, expected: T, message: string = "", location := #caller_location) {
    if actual <= expected {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be less than or equal to %v", actual, expected)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_between :: proc(actual: $T, min: T, max: T, message: string = "", location := #caller_location) {
    if actual >= min && actual <= max {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be between %v and %v", actual, min, max)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_close :: proc(actual: $T, expected: T, tolerance: T, message: string = "", location := #caller_location) {
    diff := actual - expected
    if diff < 0 do diff = -diff
    if diff <= tolerance {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected %v to be close to %v (within %v), difference was %v", actual, expected, tolerance, diff)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}