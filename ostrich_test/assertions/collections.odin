package assertions

import "core:fmt"

//Length of all data within a Collection
// When using this for an OstrichDB Collection the expectedLength arg should be less than 500mb. Just use a constant
assert_length :: proc(collection: $T, expectedLength: int, message: string = "", location := #caller_location) {
    actualLength := len(collection)
    if actualLength == expectedLength {
        record_success()
    } else {
        errorMessage := fmt.tprintf("Expected length %d, got %d", expectedLength, actualLength)
        if message != "" {
            errorMessage = fmt.tprintf("%s: %s", message, errorMessage)
        }
        record_failure(errorMessage, location)
    }
}

//I dont see a use for this one. Collections will never truly be empty. Will keep for now - Marshall
assert_empty :: proc(collection: $T, message: string = "", location := #caller_location) {
    if len(collection) == 0 {
        record_success()
    } else {
        errorMessage := fmt.tprintf("Expected empty collection, got length %d", len(collection))
        if message != "" {
            errorMessage = fmt.tprintf("%s: %s", message, errorMessage)
        }
        record_failure(errorMessage, location)
    }
}

//Use this one after the Collection metadata header is supposed to be appended to the collection
assert_not_empty :: proc(collection: $T, message: string = "", location := #caller_location) {
    if len(collection) > 0 {
        record_success()
    } else {
        errorMessage := "Expected non-empty collection, got empty collection"
        if message != "" {
            errorMessage = fmt.tprintf("%s: %s", message, errorMessage)
        }
        record_failure(errorMessage, location)
    }
}

//Passed an OstrichDB ParsedCollection Type for the collection arg as well as an OstrichDB [dynamic]ParsedCluster Type for clusters arg
assert_contains_cluster :: proc(collection: []$T, clusters: T, message: string = "", location := #caller_location) {
    found := false

    for item in collection{
        body: $T
        for bodyElement in body{
            if bodyElement == clusters {
                if len(clusters) != 0 {
                    found = true
                    break
                }
            }
        }
    }

    if found {
        record_success()
    } else {
        errorMessage := "Expected collection to contain clusters '"
        if message != "" {
            errorMessage = fmt.tprintf("%s: %s", message, errorMessage)
        }
        record_failure(errorMessage, location)
    }
}

//Passed an OstrichDB ParsedCollection Type for the collection arg as well as an OstrichDB [dynamic]ParsedCluster Type for clusters arg
assert_not_contains_clusters:: proc(collection: []$T, clusters: T, message: string = "", location := #caller_location) {
    found := false

    for item in collection{
        body: $T
        for bodyElement in body{
            if bodyElement == clusters {
                if len(clusters) != 0 {
                    found = true
                    break
                }
            }
        }
    }

    if !found {
        record_success()
    } else {
        errorMessage := "Expected collection to not contain clusters'"
        if message != "" {
            errorMessage = fmt.tprintf("%s: %s", message, errorMessage)
        }
        record_failure(errorMessage, location)
    }
}
