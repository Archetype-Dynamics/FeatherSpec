package tests

import "core:os"
import "core:fmt"
import "core:strings"
import ostrich_test "../ostrich_test"

main :: proc() {
    fmt.println("🧪 Testing OstrichTest Framework")
    fmt.println("================================")
    
    // Test 1: Quick test
    fmt.println("\n1. Testing quick_test function:")
    result1 := ostrich_test.quick_test("basic math", proc() -> bool {
        return 2 + 2 == 4
    })
    
    // Test 2: Full suite with assertions
    fmt.println("\n2. Testing full test suite:")
    suite := ostrich_test.suite("Framework Tests", "Testing the framework itself")
    
    ostrich_test.add_test(&suite, ostrich_test.test("test_assertions", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        
        ostrich_test.assert_true(true, "True should be true")
        ostrich_test.assert_equal(4, 2 + 2, "Math should work")
        ostrich_test.assert_not_nil(rawptr(uintptr(1)), "Non-zero pointer should not be nil")
        
        return ostrich_test.get_test_result("test_assertions")
    }))
    
    ostrich_test.add_test(&suite, ostrich_test.test("test_string_operations", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        
        text := "hello world"
        ostrich_test.assert_equal(11, len(text), "String length should be correct")
        
        return ostrich_test.get_test_result("test_string_operations")
    }))
    
    // This test should fail to verify error handling
    ostrich_test.add_test(&suite, ostrich_test.test("intentional_failure", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        
        ostrich_test.assert_equal(5, 2 + 2, "This should fail")
        
        return ostrich_test.get_test_result("intentional_failure")
    }))
    
    // Create a simple test config
    config := ostrich_test.TestConfig{
        verbose = true,
        parallel = false,
        timeout = 30_000_000_000, // 30 seconds in nanoseconds
        repeat_count = 1,
        fail_fast = false,
        reporter = proc(result: ostrich_test.TestResult) {
            #partial switch result.status {
            case .PASS:
                fmt.printf("  ✓ %s\n", result.name)
            case .FAIL:
                fmt.printf("  ✗ %s: %s\n", result.name, result.message)
            case .SKIP:
                fmt.printf("  ⊘ %s (skipped)\n", result.name)
            case .ERROR:
                fmt.printf("  ! %s: %s\n", result.name, result.message)
            case .TIMEOUT:
                fmt.printf("  ⏰ %s (timeout)\n", result.name)
            }
        },
    }
    
    results := ostrich_test.run_suite(suite, config)
    
    // Count results
    passed := 0
    failed := 0
    for result in results {
        #partial switch result.status {
        case .PASS: passed += 1
        case .FAIL: failed += 1
        }
    }
    
    fmt.println()
    fmt.println(strings.repeat("=", 50))
    if result1 && passed == 2 && failed == 1 { // We expect 2 passes and 1 intentional failure
        fmt.println("🎉 Framework test completed successfully!")
        fmt.println("✅ Quick test passed")
        fmt.println("✅ Suite test ran (with expected failure)")
        fmt.println("✅ Framework is working correctly!")
        os.exit(0)
    } else {
        fmt.println("❌ Framework test failed")
        fmt.printf("Result1: %v, Passed: %d, Failed: %d\n", result1, passed, failed)
        os.exit(1)
    }
}