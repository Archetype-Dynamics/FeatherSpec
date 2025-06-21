package reporters

import "core:fmt"
import "core:time"
import "core:strings"
import "../core"

Reporter :: proc(result: core.TestResult)

ConsoleReporter :: struct {
    verbose: bool,
    use_colors: bool,
}

make_console_reporter :: proc(verbose: bool = true, use_colors: bool = true) -> ConsoleReporter {
    return ConsoleReporter{
        verbose = verbose,
        use_colors = use_colors,
    }
}

console_report :: proc(reporter: ConsoleReporter, result: core.TestResult) {
    if reporter.use_colors {
        console_report_colored(reporter, result)
    } else {
        console_report_plain(reporter, result)
    }
}

@(private)
console_report_colored :: proc(reporter: ConsoleReporter, result: core.TestResult) {
    GREEN :: "\033[32m"
    RED :: "\033[31m"
    YELLOW :: "\033[33m"
    BLUE :: "\033[34m"
    RESET :: "\033[0m"
    
    switch result.status {
    case .PASS:
        if reporter.verbose {
            fmt.printf("  %s✓%s %s (%v)\n", GREEN, RESET, result.name, result.duration)
        }
    case .FAIL:
        fmt.printf("  %s✗%s %s (%v)\n", RED, RESET, result.name, result.duration)
        if result.message != "" {
            fmt.printf("    %sError:%s %s\n", RED, RESET, result.message)
        }
    case .SKIP:
        if reporter.verbose {
            fmt.printf("  %s⊘%s %s (skipped)\n", YELLOW, RESET, result.name)
        }
    case .ERROR:
        fmt.printf("  %s!%s %s (%v) - ERROR\n", RED, RESET, result.name, result.duration)
        if result.message != "" {
            fmt.printf("    %sError:%s %s\n", RED, RESET, result.message)
        }
    case .TIMEOUT:
        fmt.printf("  %s⏰%s %s - TIMEOUT\n", YELLOW, RESET, result.name)
    }
}

@(private)
console_report_plain :: proc(reporter: ConsoleReporter, result: core.TestResult) {
    switch result.status {
    case .PASS:
        if reporter.verbose {
            fmt.printf("  PASS %s (%v)\n", result.name, result.duration)
        }
    case .FAIL:
        fmt.printf("  FAIL %s (%v)\n", result.name, result.duration)
        if result.message != "" {
            fmt.printf("    Error: %s\n", result.message)
        }
    case .SKIP:
        if reporter.verbose {
            fmt.printf("  SKIP %s\n", result.name)
        }
    case .ERROR:
        fmt.printf("  ERROR %s (%v)\n", result.name, result.duration)
        if result.message != "" {
            fmt.printf("    Error: %s\n", result.message)
        }
    case .TIMEOUT:
        fmt.printf("  TIMEOUT %s\n", result.name)
    }
}

print_summary :: proc(reporter: ConsoleReporter, results: []core.TestResult, total_duration: time.Duration) {
    passed := 0
    failed := 0
    skipped := 0
    errors := 0
    
    for result in results {
        switch result.status {
        case .PASS: passed += 1
        case .FAIL: failed += 1
        case .SKIP: skipped += 1
        case .ERROR, .TIMEOUT: errors += 1
        }
    }
    
    total := len(results)
    
    if reporter.use_colors {
        print_summary_colored(passed, failed, skipped, errors, total, total_duration)
    } else {
        print_summary_plain(passed, failed, skipped, errors, total, total_duration)
    }
}

@(private)
print_summary_colored :: proc(passed, failed, skipped, errors, total: int, duration: time.Duration) {
    GREEN :: "\033[32m"
    RED :: "\033[31m"
    YELLOW :: "\033[33m"
    BLUE :: "\033[34m"
    BOLD :: "\033[1m"
    RESET :: "\033[0m"
    
    fmt.println()
    fmt.printf("%s%s%s\n", BOLD, strings.repeat("=", 60), RESET)
    fmt.printf("%sTest Summary%s\n", BOLD, RESET)
    fmt.printf("%s%s%s\n", BOLD, strings.repeat("=", 60), RESET)
    
    fmt.printf("Total Tests: %s%d%s\n", BOLD, total, RESET)
    fmt.printf("%s✓ Passed:%s %d\n", GREEN, RESET, passed)
    fmt.printf("%s✗ Failed:%s %d\n", RED, RESET, failed)
    fmt.printf("%s⊘ Skipped:%s %d\n", YELLOW, RESET, skipped)
    fmt.printf("%s! Errors:%s %d\n", RED, RESET, errors)
    fmt.printf("%s⏱ Duration:%s %v\n", BLUE, RESET, duration)
    
    if failed == 0 && errors == 0 {
        fmt.printf("\n%s🎉 All tests passed!%s\n", GREEN, RESET)
    } else {
        fmt.printf("\n%s💥 %d test(s) failed%s\n", RED, failed + errors, RESET)
    }
}

@(private)
print_summary_plain :: proc(passed, failed, skipped, errors, total: int, duration: time.Duration) {
    fmt.println()
    fmt.println(strings.repeat("=", 60))
    fmt.println("Test Summary")
    fmt.println(strings.repeat("=", 60))
    
    fmt.printf("Total Tests: %d\n", total)
    fmt.printf("Passed: %d\n", passed)
    fmt.printf("Failed: %d\n", failed)
    fmt.printf("Skipped: %d\n", skipped)
    fmt.printf("Errors: %d\n", errors)
    fmt.printf("Duration: %v\n", duration)
    
    if failed == 0 && errors == 0 {
        fmt.println("\nAll tests passed!")
    } else {
        fmt.printf("\n%d test(s) failed\n", failed + errors)
    }
}