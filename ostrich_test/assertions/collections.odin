package assertions

import "core:fmt"
import "core:slice"

assert_length :: proc(collection: $T, expected_length: int, message: string = "", location := #caller_location) {
    actual_length := len(collection)
    if actual_length == expected_length {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected length %d, got %d", expected_length, actual_length)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_empty :: proc(collection: $T, message: string = "", location := #caller_location) {
    if len(collection) == 0 {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected empty collection, got length %d", len(collection))
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_not_empty :: proc(collection: $T, message: string = "", location := #caller_location) {
    if len(collection) > 0 {
        record_success()
    } else {
        error_msg := "Expected non-empty collection, got empty collection"
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_contains_element :: proc(collection: []$T, element: T, message: string = "", location := #caller_location) {
    found := false
    for item in collection {
        if item == element {
            found = true
            break
        }
    }
    
    if found {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected collection to contain element '%v'", element)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_not_contains_element :: proc(collection: []$T, element: T, message: string = "", location := #caller_location) {
    found := false
    for item in collection {
        if item == element {
            found = true
            break
        }
    }
    
    if !found {
        record_success()
    } else {
        error_msg := fmt.tprintf("Expected collection to not contain element '%v'", element)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
    }
}

assert_slice_equal :: proc(expected: []$T, actual: []T, message: string = "", location := #caller_location) {
    if len(expected) != len(actual) {
        error_msg := fmt.tprintf("Expected slice length %d, got %d", len(expected), len(actual))
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        record_failure(error_msg, location)
        return
    }
    
    for i in 0..<len(expected) {
        if expected[i] != actual[i] {
            error_msg := fmt.tprintf("Slices differ at index %d: expected '%v', got '%v'", i, expected[i], actual[i])
            if message != "" {
                error_msg = fmt.tprintf("%s: %s", message, error_msg)
            }
            record_failure(error_msg, location)
            return
        }
    }
    
    record_success()
}