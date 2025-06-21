OstrichTest/
├── src/
│   ├── core/                    # Core testing framework
│   │   ├── test_case.odin      # Test case definitions
│   │   ├── test_suite.odin     # Test suite management
│   │   ├── test_runner.odin    # Test execution engine
│   │   └── test_result.odin    # Result handling
│   ├── assertions/             # Assertion library
│   │   ├── basic.odin          # Basic assertions (true/false/equal)
│   │   ├── strings.odin        # String-specific assertions
│   │   ├── numbers.odin        # Numeric assertions
│   │   ├── collections.odin    # Array/slice assertions
│   │   └── custom.odin         # Custom assertion helpers
│   ├── runners/                # Different test runners
│   │   ├── sequential.odin     # Sequential test execution
│   │   ├── parallel.odin       # Parallel test execution
│   │   └── filtered.odin       # Filtered test execution
│   ├── reporters/              # Test result reporting
│   │   ├── console.odin        # Console output
│   │   ├── json.odin           # JSON output
│   │   ├── xml.odin            # JUnit XML output
│   │   └── tap.odin            # TAP (Test Anything Protocol)
│   └── matchers/               # Advanced matching
│       ├── http.odin           # HTTP response matchers
│       ├── file.odin           # File system matchers
│       └── regex.odin          # Regular expression matchers
├── examples/
│   ├── basic/                  # Basic usage examples
│   │   ├── simple_test.odin
│   │   └── README.md
│   ├── database/               # Database testing examples
│   │   ├── ostrichdb_test.odin
│   │   └── README.md
│   ├── api/                    # API testing examples
│   │   ├── http_test.odin
│   │   └── README.md
│   └── performance/            # Performance testing examples
│       ├── benchmark_test.odin
│       └── README.md
├── docs/
│   ├── getting_started.md
│   ├── api_reference.md
│   ├── examples.md
│   └── extending.md
├── scripts/
│   ├── build.sh
│   ├── test.sh
│   └── install.sh
├── ostrich_test.odin           # Main module entry point
├── README.md
├── LICENSE
└── VERSION
