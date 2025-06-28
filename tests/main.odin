package tests

import "core:os"
import "core:fmt"
import "core:strings"




main :: proc() {
    run_engine_tests()
    run_server_tests()
    run_nlp_tests()
}
