🪶 FeatherSpec
FeatherSpec is a robust, expressive, and modular testing suite written in Odin, built to rigorously test Odin-based systems like OstrichDB. Designed for clarity and performance, FeatherSpec provides a clean structure for defining, running, and reporting tests with full support for:

High-level assertions

Tag filtering

Modular matchers

Custom reporters

Seamless integration with OstrichAPI

🧭 Table of Contents
📦 Features

📁 Project Structure

🚀 Getting Started

🧪 Writing Tests

🧰 Assertion API

🧩 Integrating into OstrichDB

⚙️ Configuration

🛠 Scripts

📤 Output Reporters

🧼 Cleanup

📜 License

📦 Features
🧱 Modular assertion library (basic, strings, collections, numbers, time, etc.)

🔄 Lifecycle hooks: setup, before_each, after_each, teardown

🧵 Thread-local assertion state

🧪 Custom matchers for HTTP/file interactions

🖨 Console and JSON reporters

🧼 Fail-fast and tag filtering options

📁 Project Structure
graphql
Copy
Edit
featherspec/
├── assertions/         # Assertion helpers (basic, strings, collections, etc.)
├── core/               # Core types and runner logic
├── matchers/           # File and HTTP matchers
├── reporters/          # Console and JSON reporters
├── main.odin           # Test entry point
scripts/
├── build.sh
├── run_tests.sh
tests/
├── main.odin           # Example test suite
PROJECT_STRUCTURE.md    # Docs
🚀 Getting Started
1. Clone & Build
bash
Copy
Edit
git clone https://github.com/your-org/FeatherSpec.git
cd FeatherSpec
./scripts/build.sh
Ensure the Odin compiler is installed and available in your $PATH.

2. Run Tests
bash
Copy
Edit
./scripts/run_tests.sh
Or run directly:

bash
Copy
Edit
cd featherspec
odin run main.odin
🧪 Writing Tests
Add your tests in tests/main.odin or other files under tests/:

odin
Copy
Edit
package tests

import featherspec

main :: proc() {
    featherspec.run_all()
}

suite_example :: featherspec.suite("Cluster Suite") {
    featherspec.test("Creating a cluster") {
        featherspec.assert_true(true, "Cluster creation should succeed")
    }
}
Use featherspec.suite, featherspec.test, and any featherspec.assert_* helpers.

🧰 Assertion API
Here are some of the built-in assertions:

Basic
assert_true(condition)

assert_equal(expected, actual)

assert_nil(value)

Strings
assert_contains(text, substr)

assert_starts_with(text, prefix)

Collections
assert_length(slice, expected_len)

assert_contains_element(slice, value)

Numbers
assert_less(a, b)

assert_close(a, b, tolerance)

Time
assert_eventually(proc() -> bool, timeout)

Full API lives in featherspec/assertions/.

🧩 Integrating into OstrichDB
To add FeatherSpec to your Ostrich-based project:

1. Add as a Git Submodule
bash
Copy
Edit
git submodule add https://github.com/your-org/FeatherSpec.git featherspec
2. Create a tests/ Folder
bash
Copy
Edit
mkdir tests/
cp featherspec/tests/main.odin tests/
3. Write Feature Tests
odin
Copy
Edit
import featherspec
import ostrichdb_engine

featherspec.suite("DB Engine Tests") {
    featherspec.test("Engine boots") {
        engine := ostrichdb_engine.init()
        featherspec.assert_not_nil(engine)
    }
}
4. Run Tests
bash
Copy
Edit
odin run tests/main.odin
⚙️ Configuration
Override test behavior at runtime:

odin
Copy
Edit
config := featherspec.default_config()
config.verbose = true
config.filter_pattern = "DB"
featherspec.run_all(config)
Supported options:

verbose

parallel

timeout_ms

filter_pattern

include_tags, exclude_tags

fail_fast

repeat_count

🛠 Scripts
./scripts/build.sh: Build test binary

./scripts/run_tests.sh: Run all tests

📤 Output Reporters
FeatherSpec supports pluggable reporters:

ConsoleReporter: Prints to CLI

JsonReporter: Emits structured JSON

You can configure like so:

odin
Copy
Edit
config := featherspec.default_config()
config.reporter = featherspec.make_console_reporter()
featherspec.run_all(config)
🧼 Cleanup
bash
Copy
Edit
rm -rf bin/
rm featherspec/main.odin
📜 License
Licensed under the Business Source License 1.1 (BSL-1.1)
© 2025 Marshall A Burns and Archetype Dynamics, Inc.