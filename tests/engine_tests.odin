package tests

import "core:os"
import "core:fmt"
import "core:strings"
import ostrich_test "../ostrich_test"
import lib"../../src/library"
import "../../src/core/engine/data"
import P"../../src/core/engine/projects"


run_engine_tests::proc(){
    using lib
    using data


    fmt.println("🧪 Testing OstrichDB Engine Package")
    fmt.println("================================")

    suite:= ostrich_test.suite("OstrichDB Engine Tests", "" )
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


    //TEST 2. Initialize Project Structure
    fmt.println("\n2. Testing Initializing A New Projects Structure")
    ostrich_test.add_test(&suite, ostrich_test.test("Initialize_Project_Struture", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:= P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        initProjectResult:= P.init_project_structure(projectContext)
        ostrich_test.assert_true(initProjectResult, "This should be true")

        return ostrich_test.get_test_result("Initialize_Project_Struture")
    }))

    //TEST 3: Make a pointer to a new collection
    fmt.println("\n3. Testing New Collection Pointer Creation")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_Collection_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        collection:= data.make_new_collection("TestCollection",.STANDARD)
        defer free(collection)
        ostrich_test.assert_not_nil(collection, "Pointer should not be nil")

        return ostrich_test.get_test_result("Test_Make_Collection_Pointer")
    }))


    //TEST 4: Create a Collection file
    fmt.println("\n4. Testing Creating A Collection File")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_Collection_File", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        creationError:= data.create_collection_file(projectContext, collection)
        ostrich_test.assert_nil(creationError, "Result of creating a new Collection should be nil")

        return ostrich_test.get_test_result("Test_Collection_Creation_File")
    }))


    //FIX ME: Renaming a collection passes but then trying to delete the renamed collection fails
    //TEST 5: Rename a Collection file
    fmt.println("\n5. Testing Renaming A Collection File")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Rename_Collection_File", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        renameError:= data.rename_collection(projectContext, collection, "TestCollectionRenamed")
        ostrich_test.assert_nil(renameError, "Result of creating a new Collection should be nil")

        return ostrich_test.get_test_result("Test_Rename_Collection_File")
    }))

    //TODO: Not Passing????? - Marshall
    //TEST 6: Delete a Collection file
    fmt.println("\n6. Testing Deleting A Collection File")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Collection_FIle", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollectionRenamed", .STANDARD)
        defer free(collection)
        res, _:= data.get_all_collection_names(projectContext)
         fmt.println("DEBUG: Here are all collections that exists: \n")
        for col in res {
            fmt.println("DEBUG: Collection: ", col)
        }
        deleteError:= data.erase_collection(projectContext, collection)
        ostrich_test.assert_nil(deleteError, "Result of deleting a Collection should be nil")

        return ostrich_test.get_test_result("Test_Delete_Collection_FIle")
    }))

    //TEST 7: Create A Pointer to A Cluster
    fmt.println("\n7. Testing Making A Pointer To Cluster")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_Cluster_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        ostrich_test.assert_not_nil(cluster, "Pointer should not be nil")

        return ostrich_test.get_test_result("Test_Make_Cluster_Pointer")
    }))

    //TEST 8: Create A New Cluster
    fmt.println("\n8. Testing Creating A Cluster")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_Cluster", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        creationError:= data.create_collection_file(projectContext, collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        createSuccess:= data.create_cluster_block_in_collection(projectContext, collection, cluster)
        ostrich_test.assert_nil(createSuccess, "Result of creating a Cluster should be nil")

        return ostrich_test.get_test_result("Test_Create_Cluster")
    }))


    //TEST 9: Rename a Cluster
    fmt.println("\n9. Testing Renaming A Cluster")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Rename_Cluster", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        creationError:= data.create_collection_file(projectContext, collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        renameSuccess:= data.rename_cluster(projectContext, collection, cluster, "ClusterRenamed")
        ostrich_test.assert_nil(renameSuccess, "Result of renaming a Cluster should be nil")

        return ostrich_test.get_test_result("Test_Rename_Cluster")
    }))


    //TEST 10: Delete a Cluster
    fmt.println("\n10. Testing Deleting A Cluster")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Cluster", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        creationError:= data.create_collection_file(projectContext, collection)
        cluster:= data.make_new_cluster(collection, "TestClusterRenamed")
        defer free(cluster)
        deleteSuccess:= data.erase_cluster(projectContext, collection, cluster )
        ostrich_test.assert_nil(deleteSuccess, "Result of deleting a Cluster should be nil")

        return ostrich_test.get_test_result("Test_Delete_Cluster")
    }))


    //TEST 11: Make pointer to new Record
    fmt.println("\n11. Testing Making New Pointer To A Record")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_Record_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        record:= data.make_new_record(collection, cluster, "TestRecord")
        defer free(record)
        ostrich_test.assert_not_nil(record, "Pointer should not be nil")

        return ostrich_test.get_test_result("Test_Make_Record_Pointer")
    }))


    //TEST 12: Create a new record {name :type: value}
    fmt.println("\n12. Testing Creating A New Record")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Create_New_Record", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        creationError:= data.create_collection_file(projectContext, collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        record:= data.make_new_record(collection, cluster, "TestRecord")
        defer free(record)
        record.type = .BOOLEAN
        record.value = "true"

        creationSuccess:= data.create_record_within_cluster(projectContext, collection, cluster, record)

        ostrich_test.assert_nil(creationSuccess, "Result of creating a new record should be nil")

        return ostrich_test.get_test_result("Test_Create_New_Record")
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
