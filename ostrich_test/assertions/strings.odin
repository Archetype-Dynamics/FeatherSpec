package assertions

import "core:fmt"
import "core:strings"

assert_contains :: proc(haystack: string, needle: string, message: string = "", location := #caller_location) {
    if strings.contains(haystack, needle) {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%s' to contain '%s'", haystack, needle)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_not_contains :: proc(haystack: string, needle: string, message: string = "", location := #caller_location) {
    if !strings.contains(haystack, needle) {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%s' to not contain '%s'", haystack, needle)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_starts_with :: proc(text: string, prefix: string, message: string = "", location := #caller_location) {
    if strings.has_prefix(text, prefix) {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%s' to start with '%s'", text, prefix)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_ends_with :: proc(text: string, suffix: string, message: string = "", location := #caller_location) {
    if strings.has_suffix(text, suffix) {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%s' to end with '%s'", text, suffix)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_matches :: proc(text: string, pattern: string, message: string = "", location := #caller_location) {
    // Note: This would need a regex implementation in Odin
    // For now, we'll use a simple contains check
    if strings.contains(text, pattern) {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected '%s' to match pattern '%s'", text, pattern)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_string_length :: proc(text: string, expected_length: int, message: string = "", location := #caller_location) {
    actual_length := len(text)
    if actual_length == expected_length {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected string length %d, got %d", expected_length, actual_length)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_string_empty :: proc(text: string, message: string = "", location := #caller_location) {
    if len(text) == 0 {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected empty string, got '%s'", text)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_string_not_empty :: proc(text: string, message: string = "", location := #caller_location) {
    if len(text) > 0 {
        record_success()
    } else {
        error_msg := "Expected non-empty string, got empty string"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}