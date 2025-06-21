package matchers

import "core:fmt"
import "core:os"
import "core:strings"
import "../assertions"

assert_file_exists :: proc(file_path: string, message: string = "", location := #caller_location) {
    if _, err := os.stat(file_path); err == 0 {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected file '%s' to exist", file_path)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_file_not_exists :: proc(file_path: string, message: string = "", location := #caller_location) {
    if _, err := os.stat(file_path); err != 0 {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected file '%s' to not exist", file_path)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_directory_exists :: proc(dir_path: string, message: string = "", location := #caller_location) {
    if file_info, err := os.stat(dir_path); err == 0 && file_info.is_dir {
        assertions.record_success()
    } else {
        error_msg := fmt.tprintf("Expected directory '%s' to exist", dir_path)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_file_contains :: proc(file_path: string, expected_content: string, message: string = "", location := #caller_location) {
    if data, ok := os.read_entire_file(file_path); ok {
        defer delete(data)
        content := string(data)
        if strings.contains(content, expected_content) {
            assertions.record_success()
        } else {
            error_msg := fmt.tprintf("Expected file '%s' to contain '%s'", file_path, expected_content)
            if message != "" {
                error_msg = fmt.tprintf("%s: %s", message, error_msg)
            }
            assertions.record_failure(error_msg, location)
        }
    } else {
        error_msg := fmt.tprintf("Could not read file '%s'", file_path)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}

assert_file_size :: proc(file_path: string, expected_size: int, message: string = "", location := #caller_location) {
    if file_info, err := os.stat(file_path); err == 0 {
        actual_size := int(file_info.size)
        if actual_size == expected_size {
            assertions.record_success()
        } else {
            error_msg := fmt.tprintf("Expected file '%s' to be %d bytes, got %d bytes", file_path, expected_size, actual_size)
            if message != "" {
                error_msg = fmt.tprintf("%s: %s", message, error_msg)
            }
            assertions.record_failure(error_msg, location)
        }
    } else {
        error_msg := fmt.tprintf("Could not stat file '%s'", file_path)
        if message != "" {
            error_msg = fmt.tprintf("%s: %s", message, error_msg)
        }
        assertions.record_failure(error_msg, location)
    }
}