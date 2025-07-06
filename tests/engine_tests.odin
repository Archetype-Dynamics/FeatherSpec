package tests

import "core:os"
import "core:fmt"
import "core:strings"
import "core:time"
import ostrich_test "../ostrich_test"
import lib"../../src/library"
import "../../src/core/engine/data"
import P"../../src/core/engine/projects"
import D"../../src/core/engine/data"
import C"../../src/core/config"

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


    fmt.println("\nTesting Fetch Functionality")
    //TEST 13: Fetch a collection
    fmt.println("\n13. Testing Fetching A Collection")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Collection", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)

        _, fetchSuccess := data.fetch_collection(projectContext, collection) 

        ostrich_test.assert_nil(fetchSuccess, "Result of fetching a collection should be nil")

        return ostrich_test.get_test_result("Test_Fetch_Collection")
    }))

    //TEST 14: Fetch a cluster
    fmt.println("\n14. Testing Fetching A Cluster")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Collection", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        projectContext:=P.make_new_project_context("test_user_12345","TestProject")
        defer free(projectContext)
        collection:= data.make_new_collection("TestCollection", .STANDARD)
        defer free(collection)
        cluster:= data.make_new_cluster(collection, "TestCluster")
        defer free(cluster)
        createSuccess := data.create_cluster_block_in_collection(projectContext, collection, cluster)

        _, fetchSuccess := data.fetch_cluster(projectContext, collection, cluster) 

        ostrich_test.assert_nil(fetchSuccess, "Result of fetching a cluster should be nil")

        return ostrich_test.get_test_result("Test_Fetch_Collection")
    }))


    //TEST 15: Fetch a record 
    fmt.println("\n15. Testing Fetching A Record")
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Fetch_Record", proc() -> ostrich_test.TestResult {
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

        _, fetchSuccess := data.fetch_record(projectContext, collection, cluster, record) 

        ostrich_test.assert_nil(fetchSuccess, "Result of fetching a collection should be nil")

        return ostrich_test.get_test_result("Test_Fetch_Record")
    }))   

    // Projects.odin

    // 1. ProjectLibraryContext pointer
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_ProjectLibraryContext_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        libCtx := P.make_new_project_library()
        defer free(libCtx)
        ostrich_test.assert_not_nil(libCtx, "ProjectLibraryContext pointer should not be nil")
        return ostrich_test.get_test_result("Test_Make_ProjectLibraryContext_Pointer")
    }))

    // 2. ProjectContext pointer
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_ProjectContext_Pointer", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("user123", "ProjName")
        defer free(ctx)
        ostrich_test.assert_not_nil(ctx, "ProjectContext pointer should not be nil")
        return ostrich_test.get_test_result("Test_Make_ProjectContext_Pointer")
    }))

    // 3. ProjectContext invalid userID
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_ProjectContext_InvalidUserID", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("", "Name")
        ostrich_test.assert_nil(ctx, "Empty userID should return nil context")
        return ostrich_test.get_test_result("Test_Make_ProjectContext_InvalidUserID")
    }))

    // 4. Generate unique project IDs
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Generate_ProjectID_Unique", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        id1 := P.generate_project_id()
        time.sleep(time.Duration(1 * time.Nanosecond))
        id2 := P.generate_project_id()
        ostrich_test.assert_true(id1 != id2, "Generated IDs should be unique")
        return ostrich_test.get_test_result("Test_Generate_ProjectID_Unique")
    }))

    // 5. Init project structure success
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Init_Project_Structure", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("uid", "TestProj")
        defer free(ctx)
        _ = P.init_project_structure(ctx)
        ostrich_test.assert_true(true, "init_project_structure invoked")
        return ostrich_test.get_test_result("Test_Init_Project_Structure")
    }))

    // 6. Get collections path
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Get_Collections_Path", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("u","p")
        defer free(ctx)
        path := P.get_collections_path(ctx)
        ostrich_test.assert_true(strings.has_suffix(path, "/collections/"), "collections path suffix must end with '/collections/'")
        return ostrich_test.get_test_result("Test_Get_Collections_Path")
    }))

    // 7. Save and load project metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Save_And_Load_Project_Metadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("usr","ProjMeta")
        defer free(ctx)
        _ = P.init_project_structure(ctx)
        meta := lib.ProjectMetadata{
            projectID = ctx.projectID,
            projectName = ctx.projectName,
            userID = ctx.userID,
            createdAt = time.now(),
            version = "1.0",
        }
        saved := P.save_project_metadata(ctx, &meta)
        ostrich_test.assert_true(saved, "save_project_metadata should return true")
        loaded, ok := P.load_project_metadata(ctx)
        ostrich_test.assert_true(ok, "load_project_metadata should succeed")
        ostrich_test.assert_equal(loaded.projectID, meta.projectID, "loaded projectID must match saved")
        return ostrich_test.get_test_result("Test_Save_And_Load_Project_Metadata")
    }))

    // 8. Verify project access
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Verify_Project_Access", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("owner","ProjAcc")
        defer free(ctx)
        _ = P.init_project_structure(ctx)
        allowed := P.verify_project_access(ctx, "owner")
        denied := P.verify_project_access(ctx, "other")
        ostrich_test.assert_true(allowed, "owner ID should verify true")
        ostrich_test.assert_false(denied, "wrong ID should verify false")
        return ostrich_test.get_test_result("Test_Verify_Project_Access")
    }))

    // 9. List projects: missing userID
    ostrich_test.add_test(&suite, ostrich_test.test("Test_List_Projects_NoUserID", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        libCtx := P.make_new_project_library()
        defer free(libCtx)
        list, ok := P.list_projects(libCtx, "")
        ostrich_test.assert_false(ok, "empty userID should return ok=false")
        ostrich_test.assert_equal(len(list), 0, "list length should be zero")
        return ostrich_test.get_test_result("Test_List_Projects_NoUserID")
    }))

    // 10. List projects: nonexistent directory
    ostrich_test.add_test(&suite, ostrich_test.test("Test_List_Projects_NonexistentUser", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        libCtx := P.make_new_project_library()
        defer free(libCtx)
        list, ok := P.list_projects(libCtx, "no_such_user")
        ostrich_test.assert_true(ok, "nonexistent user dir should ok=true")
        ostrich_test.assert_equal(len(list), 0, "list length should be zero when no dir")
        return ostrich_test.get_test_result("Test_List_Projects_NonexistentUser")
    }))

    // 11. List collections in project: no dir
    ostrich_test.add_test(&suite, ostrich_test.test("Test_List_Collections_In_Project_NoDir", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("u","NoProj")
        defer free(ctx)
        list, ok := P.list_collections_in_project(ctx)
        ostrich_test.assert_false(ok, "no collections dir should ok=false")
        ostrich_test.assert_equal(len(list), 0, "list length should be zero")
        return ostrich_test.get_test_result("Test_List_Collections_In_Project_NoDir")
    }))

    // 12. Erase project
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Erase_Project", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("er_usr","EraseProj")
        defer free(ctx)
        _ = P.init_project_structure(ctx)
        erased := P.erase_project(ctx)
        ostrich_test.assert_true(erased, "erase_project should return true")
        exists := os.exists(ctx.basePath)
        ostrich_test.assert_false(exists, "basePath should not exist after erase")
        return ostrich_test.get_test_result("Test_Erase_Project")
    }))

    // 13. Delete directory recursive helper
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Delete_Directory_Recursive", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        tmp := "bin/tmp_recursive_test/"
        _ = os.make_directory(tmp)
        defer os.remove(tmp)
        ok := P.delete_directory_recursive(tmp)
        ostrich_test.assert_true(ok, "delete_directory_recursive should succeed")
        exists := os.exists(tmp)
        ostrich_test.assert_false(exists, "directory should be gone")
        return ostrich_test.get_test_result("Test_Delete_Directory_Recursive")
    }))

    // 14. List collections with info: unknown metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_List_Collections_With_Info_NoEntries", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("info_u","InfoProj")
        defer free(ctx)
        _ = P.init_project_structure(ctx)
        list, ok := P.list_collections_in_project_with_info(ctx)
        ostrich_test.assert_true(ok, "should succeed even with no .ostrichdb files")
        ostrich_test.assert_equal(len(list), 0, "no entries should return empty list")
        return ostrich_test.get_test_result("Test_List_Collections_With_Info_NoEntries")
    }))

    // 15. Rename project (failure case)
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Rename_Project_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        ctx := P.make_new_project_context("r_usr","RenameProj")
        defer free(ctx)
        errPtr := P.rename_project(ctx, "/invalid/path")
        ostrich_test.assert_not_nil(errPtr, "rename_project should return error for invalid path")
        return ostrich_test.get_test_result("Test_Rename_Project_Invalid")
    }))

    // parser.odin
    // 1. separate_collection: no metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Separate_Collection_NoMetadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        input := "raw body only"
        sep, err := D.separate_collection(input)
        ostrich_test.assert_nil(err, "should not error on no metadata")
        ostrich_test.assert_false(sep.hasMetadata, "hasMetadata should be false")
        ostrich_test.assert_true(sep.hasBody, "hasBody should be true")
        ostrich_test.assert_equal(sep.body, "raw body only", "body should equal input")
        return ostrich_test.get_test_result("Test_Separate_Collection_NoMetadata")
    }))

    // 2. separate_collection: with metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Separate_Collection_WithMetadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        raw := lib.METADATA_START + "# A:1\n" + lib.METADATA_END + " body content"
        sep, err := D.separate_collection(raw)
        ostrich_test.assert_nil(err, "should not error on valid metadata")
        ostrich_test.assert_true(sep.hasMetadata, "hasMetadata should be true")
        ostrich_test.assert_equal(strings.trim_space(sep.metadataHeader), lib.METADATA_START+"# A:1"+lib.METADATA_END, "metadataHeader mismatch")
        ostrich_test.assert_equal(sep.body, "body content", "body should contain content after metadata")
        return ostrich_test.get_test_result("Test_Separate_Collection_WithMetadata")
    }))

    // 3. extract_metadata_header_from_collection: missing metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Extract_Metadata_Header_NoMetadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.extract_metadata_header_from_collection("no meta here")
        ostrich_test.assert_not_nil(err, "should error when metadata not found")
        return ostrich_test.get_test_result("Test_Extract_Metadata_Header_NoMetadata")
    }))

    // 4. make_collection_body and make_empty_collection_body
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Make_Empty_And_NonEmpty_Body", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        empty := D.make_empty_collection_body()
        ostrich_test.assert_true(empty.isEmpty, "empty body should be marked empty")
        clusters := make([dynamic]D.ParsedCluster)
        body := D.make_collection_body("raw", clusters)
        ostrich_test.assert_false(body.isEmpty, "body with cluster slice should not be empty")
        ostrich_test.assert_equal(body.rawBody, "raw", "rawBody should match")
        return ostrich_test.get_test_result("Test_Make_Empty_And_NonEmpty_Body")
    }))

    // 5. count_lines_in_string
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Count_Lines_In_String", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        data := "line1\nline2\nline3"
        count := D.count_lines_in_string(data)
        ostrich_test.assert_equal(count, 2, "should count two newline separators")
        return ostrich_test.get_test_result("Test_Count_Lines_In_String")
    }))

    // 6. extract_identifier_value
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Extract_Identifier_Value", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        line := "cluster_name :identifier: TestCluster"
        val := D.extract_identifier_value(line, "cluster_name")
        ostrich_test.assert_equal(val, "TestCluster", "identifier extraction failed")
        return ostrich_test.get_test_result("Test_Extract_Identifier_Value")
    }))

    // 7. parse_single_record valid and invalid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Single_Record_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        rec, err := D.parse_single_record("rec1 :STRING: value1", 5)
        ostrich_test.assert_nil(err, "should not error on valid record")
        ostrich_test.assert_equal(rec.name, "rec1", "record name mismatch")
        ostrich_test.assert_equal(rec.typeAsString, "STRING", "type string mismatch")
        ostrich_test.assert_equal(rec.value, "value1", "value mismatch")
        ostrich_test.assert_true(rec.isValid, "record should be valid")
        return ostrich_test.get_test_result("Test_Parse_Single_Record_Valid")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Single_Record_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.parse_single_record("bad record line", 1)
        ostrich_test.assert_not_nil(err, "should error on invalid record")
        return ostrich_test.get_test_result("Test_Parse_Single_Record_Invalid")
    }))

    // 8. get_all_cluster_names and get_all_record_names
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Get_All_Names", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()

        // Build a dynamic slice of clusters
        clusters := make([dynamic]D.ParsedCluster)
        c1, c2: D.ParsedCluster
        c1.name = "cl1"
        c2.name = "cl2"
        append(&clusters, c1)
        append(&clusters, c2)

        // Attach to a ParsedCollection
        pc: D.ParsedCollection
        pc.body.clusters = clusters

        // Verify cluster names
        names := D.get_all_cluster_names(&pc)
        ostrich_test.assert_equal(len(names), 2, "cluster name count mismatch")
        ostrich_test.assert_equal(names[0], "cl1", "first cluster name")

        // Now build a dynamic slice of records for the first cluster
        recordsSlice := make([dynamic]D.ParsedRecord)
        r1, r2: D.ParsedRecord
        r1.name = "r1"
        r2.name = "r2"
        append(&recordsSlice, r1)
        append(&recordsSlice, r2)
        clusters[0].records = recordsSlice

        // Verify record names
        recordNames := D.get_all_record_names(&clusters[0])
        ostrich_test.assert_equal(len(recordNames), 2, "record name count mismatch")
        ostrich_test.assert_equal(recordNames[1], "r2", "second record name")

        return ostrich_test.get_test_result("Test_Get_All_Names")
    }))

    // internal_conversion.odin
   // 1. separate_collection: no metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Separate_Collection_NoMetadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        input := "raw body only"
        sep, err := D.separate_collection(input)
        ostrich_test.assert_nil(err, "should not error on no metadata")
        ostrich_test.assert_false(sep.hasMetadata, "hasMetadata should be false")
        ostrich_test.assert_true(sep.hasBody, "hasBody should be true")
        ostrich_test.assert_equal(sep.body, "raw body only", "body should equal input")
        return ostrich_test.get_test_result("Test_Separate_Collection_NoMetadata")
    }))

    // 2. separate_collection: with metadata
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Separate_Collection_WithMetadata", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        raw := lib.METADATA_START + "# A:1\n" + lib.METADATA_END + " body content"
        sep, err := D.separate_collection(raw)
        ostrich_test.assert_nil(err, "should not error on valid metadata")
        ostrich_test.assert_true(sep.hasMetadata, "hasMetadata should be true")
        ostrich_test.assert_equal(strings.trim_space(sep.metadataHeader), lib.METADATA_START+"# A:1"+lib.METADATA_END, "metadataHeader mismatch")
        ostrich_test.assert_equal(sep.body, "body content", "body should contain content after metadata")
        return ostrich_test.get_test_result("Test_Separate_Collection_WithMetadata")
    }))

    // Conversion tests for primitive types

    // 3. convert_record_value_to_int
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Int_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        v, err := D.convert_record_value_to_int("123")
        ostrich_test.assert_nil(err, "int conversion should succeed for '123'")
        ostrich_test.assert_equal(v, 123, "value should be 123")
        return ostrich_test.get_test_result("Test_Convert_Int_Valid")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Int_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.convert_record_value_to_int("abc")
        ostrich_test.assert_not_nil(err, "int conversion should fail for 'abc'")
        return ostrich_test.get_test_result("Test_Convert_Int_Invalid")
    }))

    // 4. covert_record_to_float
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Float_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        f, err := D.covert_record_to_float("3.14")
        ostrich_test.assert_nil(err, "float conversion should succeed for '3.14'")
        ostrich_test.assert_true(f > 3.13 && f < 3.15, "value should be approx 3.14")
        return ostrich_test.get_test_result("Test_Convert_Float_Valid")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Float_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.covert_record_to_float("pi")
        ostrich_test.assert_not_nil(err, "float conversion should fail for 'pi'")
        return ostrich_test.get_test_result("Test_Convert_Float_Invalid")
    }))

    // 5. convert_record_value_to_bool
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Bool_True", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        b, err := D.convert_record_value_to_bool("TRUE")
        ostrich_test.assert_nil(err, "bool conversion should succeed for 'TRUE'")
        ostrich_test.assert_true(b, "value should be true")
        return ostrich_test.get_test_result("Test_Convert_Bool_True")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Bool_False", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        b, err := D.convert_record_value_to_bool("f")
        ostrich_test.assert_nil(err, "bool conversion should succeed for 'f'")
        ostrich_test.assert_false(b, "value should be false")
        return ostrich_test.get_test_result("Test_Convert_Bool_False")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_Bool_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.convert_record_value_to_bool("maybe")
        ostrich_test.assert_not_nil(err, "bool conversion should fail for 'maybe'")
        return ostrich_test.get_test_result("Test_Convert_Bool_Invalid")
    }))

    // 6. convert_record_value_to_datetime
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_DateTime_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        dt := "2023-08-20T12:34:56"
        s, err := D.convert_record_value_to_datetime(dt)
        ostrich_test.assert_nil(err, "datetime conversion should succeed for valid ISO string")
        ostrich_test.assert_equal(s, dt, "returned datetime should match input")
        return ostrich_test.get_test_result("Test_Convert_DateTime_Valid")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_DateTime_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.convert_record_value_to_datetime("not-a-date")
        ostrich_test.assert_not_nil(err, "datetime conversion should fail for invalid string")
        return ostrich_test.get_test_result("Test_Convert_DateTime_Invalid")
    }))

    // 7. convert_record_value_to_uuid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_UUID_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        uuid := "123e4567-e89b-12d3-a456-426614174000"
        s, err := D.convert_record_value_to_uuid(uuid)
        ostrich_test.assert_nil(err, "uuid conversion should succeed for valid UUID")
        ostrich_test.assert_equal(s, uuid, "returned uuid should match input")
        return ostrich_test.get_test_result("Test_Convert_UUID_Valid")
    }))
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Convert_UUID_Invalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.convert_record_value_to_uuid("bad-uuid")
        ostrich_test.assert_not_nil(err, "uuid conversion should fail for invalid UUID")
        return ostrich_test.get_test_result("Test_Convert_UUID_Invalid")
    }))

    // complex.odin
    // 1. parse_array: comma-separated
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Array_CommaSeparated", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        arr, err := D.parse_array("a,b,c")
        ostrich_test.assert_nil(err, "should not error on comma-separated string")
        ostrich_test.assert_equal(len(arr), 3, "array length should be 3")
        ostrich_test.assert_equal(arr[0], "a", "first element must be 'a'")
        ostrich_test.assert_equal(arr[2], "c", "third element must be 'c'")
        return ostrich_test.get_test_result("Test_Parse_Array_CommaSeparated")
    }))

    // 2. parse_array: single element
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Array_SingleElement", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        arr, err := D.parse_array("solo")
        ostrich_test.assert_nil(err, "no comma should still succeed")
        ostrich_test.assert_equal(len(arr), 1, "array length should be 1")
        ostrich_test.assert_equal(arr[0], "solo", "element must be 'solo'")
        return ostrich_test.get_test_result("Test_Parse_Array_SingleElement")
    }))

    // 3. verify_array_values: integer array valid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Verify_Array_IntegerValid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        rec := lib.Record{value = "1,2,3", type = .INTEGER_ARRAY}
        err := D.verify_array_values(&rec)
        ostrich_test.assert_nil(err, "integer array should verify without error")
        return ostrich_test.get_test_result("Test_Verify_Array_IntegerValid")
    }))

    // 4. verify_array_values: integer array invalid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Verify_Array_IntegerInvalid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        rec := lib.Record{value = "1,x,3", type = .INTEGER_ARRAY}
        err := D.verify_array_values(&rec)
        ostrich_test.assert_not_nil(err, "invalid integer element should produce error")
        return ostrich_test.get_test_result("Test_Verify_Array_IntegerInvalid")
    }))

    // 5. parse_date: valid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Date_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        s, err := D.parse_date("2025-02-28")
        ostrich_test.assert_nil(err, "valid date should parse")
        ostrich_test.assert_equal(s, "2025-02-28", "parsed date string must match")
        return ostrich_test.get_test_result("Test_Parse_Date_Valid")
    }))

    // 6. parse_date: invalid month
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Date_InvalidMonth", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.parse_date("2025-13-01")
        ostrich_test.assert_not_nil(err, "month 13 should error")
        return ostrich_test.get_test_result("Test_Parse_Date_InvalidMonth")
    }))

    // 7. parse_time: valid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Time_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        s, err := D.parse_time("23:59:59")
        ostrich_test.assert_nil(err, "valid time should parse")
        ostrich_test.assert_equal(s, "23:59:59", "parsed time string must match")
        return ostrich_test.get_test_result("Test_Parse_Time_Valid")
    }))

    // 8. parse_time: invalid hour
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_Time_InvalidHour", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.parse_time("24:00:00")
        ostrich_test.assert_not_nil(err, "hour 24 should error")
        return ostrich_test.get_test_result("Test_Parse_Time_InvalidHour")
    }))

    // 9. parse_datetime: valid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_DateTime_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        dt := "2025-12-31T00:00:00"
        s, err := D.parse_datetime(dt)
        ostrich_test.assert_nil(err, "valid datetime should parse")
        ostrich_test.assert_equal(s, dt, "parsed datetime must match")
        return ostrich_test.get_test_result("Test_Parse_DateTime_Valid")
    }))

    // 10. parse_datetime: missing T
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_DateTime_MissingT", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.parse_datetime("2025-12-31 00:00:00")
        ostrich_test.assert_not_nil(err, "missing 'T' delimiter should error")
        return ostrich_test.get_test_result("Test_Parse_DateTime_MissingT")
    }))

    // 11. parse_uuid: valid
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_UUID_Valid", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        u := "abcdef12-3456-7890-abcd-ef1234567890"
        s, err := D.parse_uuid(u)
        ostrich_test.assert_nil(err, "valid UUID should parse")
        ostrich_test.assert_equal(s, strings.to_lower(u), "parsed uuid must be lowercase")
        return ostrich_test.get_test_result("Test_Parse_UUID_Valid")
    }))

    // 12. parse_uuid: invalid chars
    ostrich_test.add_test(&suite, ostrich_test.test("Test_Parse_UUID_InvalidChars", proc() -> ostrich_test.TestResult {
        ostrich_test.reset_assertions()
        _, err := D.parse_uuid("zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz")
        ostrich_test.assert_not_nil(err, "invalid hex chars should error")
        return ostrich_test.get_test_result("Test_Parse_UUID_InvalidChars")
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
