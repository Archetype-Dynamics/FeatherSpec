package tests

import "core:os"
import "core:fmt"
import "core:strings"
import ostrich_test "../ostrich_test"
import lib"../../src/library"
import "../../src/core/nlp"
import P"../../src/core/engine/projects"


run_nlp_tests::proc(){
    using lib
    using nlp 

    fmt.println("🧪 Testing OstrichDB NLP Package")
    fmt.println("================================")

    suite:= ostrich_test.suite("OstrichDB NLP Tests", "" )
    os.make_directory("bin")
    //TEST 1: NLP run_agent
    fmt.println("\n1. Testing NLP Run Agent")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_NLP_RunAgent", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:= P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        _, err := nlp.run_agent(projectContext, "Create a collection called mycol1")
        ostrich_test.assert_nil(err, "Error should be nil")

        return ostrich_test.get_test_result("Test_NLP_RunAgent")
    }))

    //TEST 2: Create a Collection file using NLP
    fmt.println("\n4. Testing Creating A Collection File Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_Collection_File_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        res, err := nlp.run_agent(projectContext, "Create a collection called mycol1")
        _, ok := finalize_request(projectContext, res)
        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Collection_Creation_File_NLP")
    }))

    //TEST 3: Fetch a collection using NLP
    fmt.println("\n12. Testing Fetching A Collection Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Collection_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        res, err := nlp.run_agent(projectContext, "Fetch the collection mycol1")
        _, ok := finalize_request(projectContext, res)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Fetch_Collection_NLP")
    }))

    //TEST 4: Delete a Collection file using NLP
    fmt.println("\n6. Testing Deleting A Collection File Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Collection_File_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        dRes, _ := nlp.run_agent(projectContext, "Delete a collection called mycol1")
        _, ok := finalize_request(projectContext, dRes)
        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Delete_Collection_File_NLP")
    }))

    //TEST 5: Create A New Cluster With NLP
    fmt.println("\n8. Testing Creating A Cluster Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_Cluster_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        res, _ := nlp.run_agent(projectContext, "Create a cluster called my_cluster1 in collection my_col2")
        _, ok := finalize_request(projectContext, res)
        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Create_Cluster")
    }))

    //TEST 6: Fetch a cluster using NLP
    fmt.println("\n12. Testing Fetching A Cluster Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Cluster_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        res, err := nlp.run_agent(projectContext, "Fetch the cluster my_cluster1 in collection my_col2")
        _, ok := finalize_request(projectContext, res)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Fetch_Cluster_NLP")
    }))

    //TEST 7: Delete a Cluster with NLP
    fmt.println("\n10. Testing Deleting A Cluster Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Cluster_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        dRes, _ := nlp.run_agent(projectContext, "Delete the cluster my_cluster1 in collection my_col2")
        _, ok := finalize_request(projectContext, dRes)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Delete_Cluster_NLP")
    }))

    //TEST 8: Create a new record using NLP
    fmt.println("\n12. Testing Creating A New Record Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_New_Record_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        res, err := nlp.run_agent(projectContext, "Create a record called my_record1 with the value of 'true' in my_cluster2 in collection my_col3")
        _, ok := finalize_request(projectContext, res)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Create_New_Record_NLP")
    }))

    //TEST 9: Fetch a record using NLP
    fmt.println("\n12. Testing Fetching A Record Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Record_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        res, err := nlp.run_agent(projectContext, "Fetch the record called my_record1 in my_cluster2 in collection my_col3")
        _, ok := finalize_request(projectContext, res)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Fetch_Record_NLP")
    }))

    //TEST 10: Delete a record using NLP
    fmt.println("\n12. Testing Deleting A Record Using NLP")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Record_NLP", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)

        dRes, _ := nlp.run_agent(projectContext, "Delete the record called my_record1 in my_cluster2 in collection my_col3")
        _, ok := finalize_request(projectContext, dRes)

        ostrich_test.assert_true(ok, "Result of NLP finalize should be true")

        return ostrich_test.get_test_result("Test_Delete_Record_NLP")
    }))

    config := ostrich_test.TestConfig{
        verbose = true,
        parallel = false,
        timeout = 30_000_000_000, // 30 seconds in nanoseconds
        repeatCount = 1,
        failFast = false,
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
    for result in results{
        if result.status == .PASS {
            fmt.println(fmt.tprintf("✅Test: %s passed!", result.name))
        }else if result.status == .FAIL {
                fmt.println(fmt.tprintf("❌Test: %s  failed...", result.name))
        }
    }
    os.exit(0)
}
