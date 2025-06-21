#!/bin/bash
set -e

echo "🧪 Running OstrichTest Framework Tests"
echo "====================================="

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$DIR")"
cd "$PROJECT_ROOT"

# Run the framework test
cd tests
./framework_test

echo "🎉 All tests completed!"