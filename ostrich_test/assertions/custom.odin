package assertions

import "core:fmt"
import "core:time"

//WIll be used A LOT
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


//Will be used when a core OstrichDB proc is expected to return an error. e.g When a user tries to create a data structure that already exists..
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

//No need for time based assertions in OstrichDB tests until we add benchmarking back into the engine... Will keep for now
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
    startTime := time.now()

    for time.diff(startTime, time.now()) < timeout {
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