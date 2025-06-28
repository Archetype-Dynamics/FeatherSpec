package tests

import "core:os"
import "core:fmt"
import "core:strings"
import ostrich_test "../ostrich_test"
import lib"../../src/library"
import "../../src/core/server"
import P"../../src/core/engine/projects"


run_server_tests::proc(){
    using lib
    using server 


    fmt.println("🧪 Testing OstrichDB Server Package")
    fmt.println("================================")

    suite:= ostrich_test.suite("OstrichDB Server Tests", "" )
    os.make_directory("bin")
    //TEST 1: Make a pointer to ProjectContext
    fmt.println("\n1. Testing New ProjectContext Pointer")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_ProjectContext_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:= P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        ostrich_test.assert_not_nil(projectContext, "Pointer should not be nil")

        return ostrich_test.get_test_result("Make_ProjectContext_Pointer")
    }))

    //TEST 2: Start OstrichDB Server 
    fmt.println("\n3. Testing Initializing of Server")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Start_Ostrich_Server", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        server:= new(Server)
        defer free(server)

        result := start_ostrich_server(server)
        ostrich_test.assert_not_nil(result, "Pointer should not be nil")

        return ostrich_test.get_test_result("Test_Start_Ostrich_Server")
    }))

    //TEST 3: apply_cors_headers with no Origin should allow all
    fmt.println("\n4. Testing Cors Headers")
    ostrich_test.add_test(&suite, ostrich_test.test("CORS_NoOrigin_Allows_All", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        headers := make(map[string]string)
        defer delete(headers)
        requestHeaders := make(map[string]string)
        defer delete(requestHeaders)

        server.apply_cors_headers(&headers, requestHeaders, .GET)

        ostrich_test.assert_equal(headers["Access-Control-Allow-Origin"], "*", "should default to '*'")
        ostrich_test.assert_true(strings.contains(headers["Access-Control-Allow-Methods"], "GET"), "methods should include GET")

        return ostrich_test.get_test_result("CORS_NoOrigin_Allows_All")
    }))

    //TEST 4: handle_options_request returns 204
    fmt.println("\n5. Testing Cors Options")
    ostrich_test.add_test(&suite, ostrich_test.test("CORS_HandleOptions_NoContent", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        headers := make(map[string]string)
        defer delete(headers)

        status, _ := server.handle_options_request(.OPTIONS, "", headers)
        ostrich_test.assert_equal(status.statusCode, lib.HttpStatusCode.NO_CONTENT, "OPTIONS should return 204")

        return ostrich_test.get_test_result("CORS_HandleOptions_NoContent")
    }))

    //TEST 5: Test static path match
    ostrich_test.add_test(&suite, ostrich_test.test("Router_StaticPathMatch", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        ok := server.is_path_match("/foo", "/foo")
        ostrich_test.assert_true(ok, "exact paths should match")

        notOk := server.is_path_match("/foo", "/bar")
        ostrich_test.assert_false(notOk, "/foo should not match /bar")

        return ostrich_test.get_test_result("Router_StaticPathMatch")
    }))

    //TEST 6: Test wildcard path match
    ostrich_test.add_test(&suite, ostrich_test.test("Router_WildcardPathMatch", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        ok := server.is_path_match("/api/v1/*", "/api/v1/test")
        ostrich_test.assert_true(ok, "wildcard should match subpaths")

        return ostrich_test.get_test_result("Router_WildcardPathMatch")
    }))

    //TEST 7: Test make_new_http_status fields
    ostrich_test.add_test(&suite, ostrich_test.test("HTTP_NewStatus_Fields", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        status := server.make_new_http_status(.OK, "OK")
        ostrich_test.assert_equal(status.statusCode, lib.HttpStatusCode.OK, "statusCode should be OK")
        ostrich_test.assert_equal(status.text, "OK", "text should be 'OK'")

        return ostrich_test.get_test_result("HTTP_NewStatus_Fields")
    }))

    //TEST 8: Test a basic parse_http_request
    ostrich_test.add_test(&suite, ostrich_test.test("HTTP_ParseRequest_Basic", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        raw := "GET /hello HTTP/1.1\r\nHost: example.com\r\nX-Test: ok\r\n\r\n"
        method, path, hdrs := server.parse_http_request(transmute([]u8)raw)

        ostrich_test.assert_equal(method, lib.HttpMethod.GET, "method should be GET")
        ostrich_test.assert_equal(path, "/hello", "path should be '/hello'")
        ostrich_test.assert_equal(hdrs["Host"], "example.com", "Host header")
        ostrich_test.assert_equal(hdrs["X-Test"], "ok", "X-Test header")

        return ostrich_test.get_test_result("HTTP_ParseRequest_Basic")
    }))

    //TEST 9: Health check
    ostrich_test.add_test(&suite, ostrich_test.test("Handler_HealthCheck", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        headers := make(map[string]string)
        defer delete(headers)

        status, resp := server.handle_health_check(.GET, "", headers)
        ostrich_test.assert_equal(status.statusCode, lib.HttpStatusCode.OK, "health check status should be OK")

        return ostrich_test.get_test_result("Handler_HealthCheck")
    }))

    //TEST 10: Test new server session
    ostrich_test.add_test(&suite, ostrich_test.test("Sessions_NewServerSession", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        sess := server.make_new_server_session()
        ostrich_test.assert_not_nil(sess, "session pointer must not be nil")
        ostrich_test.assert_true(sess.Id > 0, "session Id should be > 0")

        return ostrich_test.get_test_result("Sessions_NewServerSession")
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
}
