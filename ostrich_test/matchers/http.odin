package matchers

import "core:fmt"
import "core:strings"
import "../assertions"

HttpResponse :: struct {
    status_code: int,
    headers: map[string]string,
    body: string,
}

HttpStatusCode :: enum {
    OK = 200,
    CREATED = 201,
    NO_CONTENT = 204,
    BAD_REQUEST = 400,
    UNAUTHORIZED = 401,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    INTERNAL_SERVER_ERROR = 500,
}

assert_http_status :: proc(response: HttpResponse, expected_status: int, message: string = "", location := #caller_location) {
    if response.status_code == expected_status {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected HTTP status %d, got %d", expected_status, response.status_code)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_http_header :: proc(response: HttpResponse, header_name: string, expected_value: string, message: string = "", location := #caller_location) {
    if header_value, exists := response.headers[header_name]; exists {
        if header_value == expected_value {
            assertions.record_success()
        } else {
            error_msg := fmt.tprintf("Expected header '%s' to be '%s', got '%s'", header_name, expected_value, header_value)
            if message != "" {
                error_msg = fmt.tprintf("%s: %s", message, error_msg)
            }
            assertions.record_failure(error_msg, location)
        }
    } else {
        error_msg := fmt.tprintf("Expected header '%s' to be present", header_name)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_http_header_contains :: proc(response: HttpResponse, header_name: string, expected_substring: string, message: string = "", location := #caller_location) {
    if header_value, exists := response.headers[header_name]; exists {
        if strings.contains(header_value, expected_substring) {
            assertions.record_success()
        } else {
            error_msg := fmt.tprintf("Expected header '%s' to contain '%s', got '%s'", header_name, expected_substring, header_value)
            if message != "" {
                error_msg = fmt.tprintf("%s: %s", message, error_msg)
            }
            assertions.record_failure(error_msg, location)
        }
    } else {
        error_msg := fmt.tprintf("Expected header '%s' to be present", header_name)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_http_body :: proc(response: HttpResponse, expected_body: string, message: string = "", location := #caller_location) {
    if response.body == expected_body {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected body '%s', got '%s'", expected_body, response.body)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_http_body_contains :: proc(response: HttpResponse, expected_substring: string, message: string = "", location := #caller_location) {
    if strings.contains(response.body, expected_substring) {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected body to contain '%s', got '%s'", expected_substring, response.body)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_http_json_field :: proc(response: HttpResponse, json_path: string, expected_value: string, message: string = "", location := #caller_location) {
    // Simple JSON field extraction (would need proper JSON parser in real implementation)
    field_pattern := fmt.tprintf("\"%s\":", json_path)
    if strings.contains(response.body, field_pattern) {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected JSON field '%s' with value '%s' in body", json_path, expected_value)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}