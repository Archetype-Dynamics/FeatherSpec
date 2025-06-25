package reporters

import "core:fmt"
import "core:encoding/json"
import "core:time"
import "core:os"
import "../core"

JSONReporter :: struct {
    output_file: string,
}

make_json_reporter :: proc(output_file: string = "test_results.json") -> JSONReporter {
    return JSONReporter{
        output_file = output_file,
    }
}

JSONTestResult :: struct {
    name: string `json:"name"`,
    status: string `json:"status"`,
    message: string `json:"message"`,
    duration_ms: f64 `json:"duration_ms"`,
    assertions_passed: int `json:"assertions_passed"`,
    assertions_failed: int `json:"assertions_failed"`,
}

JSONSummary :: struct {
    total_tests: int `json:"total_tests"`,
    passed: int `json:"passed"`,
    failed: int `json:"failed"`,
    skipped: int `json:"skipped"`,
    errors: int `json:"errors"`,
    duration_ms: f64 `json:"duration_ms"`,
    results: []JSONTestResult `json:"results"`,
}

export_json_results :: proc(reporter: JSONReporter, results: []core.TestResult, total_duration: time.Duration) -> bool {
    json_results := make([]JSONTestResult, len(results))
    defer delete(json_results)

    passed := 0
    failed := 0
    skipped := 0
    errors := 0

    for result, i in results {
        status_str := ""
        switch result.status {
        case .PASS:
            status_str = "pass"
            passed += 1
        case .FAIL:
            status_str = "fail"
            failed += 1
        case .SKIP:
            status_str = "skip"
            skipped += 1
        case .ERROR, .TIMEOUT:
            status_str = "error"
            errors += 1
        }

        json_results[i] = JSONTestResult{
            name = result.name,
            status = status_str,
            message = result.message,
            duration_ms = f64(time.duration_milliseconds(result.duration)),
            assertions_passed = result.assertionsPassed,
            assertions_failed = result.assertionsFailed,
        }
    }

    summary := JSONSummary{
        total_tests = len(results),
        passed = passed,
        failed = failed,
        skipped = skipped,
        errors = errors,
        duration_ms = f64(time.duration_milliseconds(total_duration)),
        results = json_results,
    }

    if json_data, err := json.marshal(summary); err == nil {
        defer delete(json_data)
        return os.write_entire_file(reporter.output_file, json_data)
    }

    return false
}