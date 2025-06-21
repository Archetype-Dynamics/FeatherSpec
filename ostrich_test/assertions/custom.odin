package assertions

import "core:fmt"
import "core:time"

// Custom assertion for error handling
assert_no_error :: proc(error: $T, message: string = "", location := #caller_location) {
    if error == nil {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected no error, got: %v", error)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_has_error :: proc(error: $T, message: string = "", location := #caller_location) {
    if error != nil {
        record_success()
    } else {
        error_msg := "Expected an error, got nil"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

// Time-based assertions
assert_duration_less :: proc(actual: time.Duration, max_duration: time.Duration, message: string = "", location := #caller_location) {
    if actual < max_duration {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected duration less than %v, got %v", max_duration, actual)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_duration_between :: proc(actual: time.Duration, min_duration: time.Duration, max_duration: time.Duration, message: string = "", location := #caller_location) {
    if actual >= min_duration && actual <= max_duration {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected duration between %v and %v, got %v", min_duration, max_duration, actual)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

// Eventually - retry assertion until it passes or timeout
assert_eventually :: proc(condition: proc() -> bool, timeout: time.Duration = 5*time.Second, interval: time.Duration = 100*time.Millisecond, message: string = "", location := #caller_location) {
    start_time := time.now()
    
    for time.diff(start_time, time.now()) < timeout {
        if condition() {
            record_success()
            return
        }
        time.sleep(interval)
    }
    
    error_msg := fmt.tprintf("Condition did not become true within %v", timeout)
    if message != "" {
        error_msg = fmt.tprintf("%s: %s", message, error_msg)
    }
    record_failure(error_msg, location)
}

// Panic assertion - Note: This is simplified since Odin's panic handling is different
assert_panics :: proc(test_func: proc(), message: string = "", location := #caller_location) {
    // This is a simplified version - Odin doesn't have the same panic/recover mechanism as Go
    // In a real implementation, you'd need to use Odin's error handling mechanisms
    test_func()
    
    error_msg := "Panic assertion not fully implemented in this example"
    if message != "" {
        error_msg = fmt.tprintf("%s: %s", message, error_msg)
    }
    record_failure(error_msg, location)
}

assert_not_panics :: proc(test_func: proc(), message: string = "", location := #caller_location) {
    // This is a simplified version
    test_func()
    record_success()
}