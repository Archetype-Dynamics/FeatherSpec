package core

import "core:time"

TestStatus :: enum {
    PASS,
    FAIL,
    SKIP,
    ERROR,
    TIMEOUT,
}

TestResult :: struct {
    name: string,
    status: TestStatus,
    message: string,
    duration: time.Duration,
    assertions_passed: int,
    assertions_failed: int,
    location: SourceLocation,
    error_details: string,
}

SourceLocation :: struct {
    file: string,
    line: int,
    procedure: string,
}