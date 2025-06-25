#!/bin/bash
# scripts/run_tests.sh
# OstrichDB Test Runner Script

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TESTS_DIR="$PROJECT_ROOT/tests"

echo -e "${BLUE}🧪 OstrichDB Test Suite Runner${NC}"
echo -e "${BLUE}================================${NC}"

# Check if Odin is installed
if ! command -v odin &> /dev/null; then
    echo -e "${RED}❌ Error: Odin compiler not found!${NC}"
    echo "Please install Odin from: https://github.com/odin-lang/Odin"
    exit 1
fi

echo -e "${GREEN}✅ Odin compiler found: $(odin version)${NC}"

# Change to tests directory
cd "$TESTS_DIR"

# Clean up any previous test artifacts
echo -e "${YELLOW}🧹 Cleaning up previous test artifacts...${NC}"
rm -rf ./test_user_*
rm -f *.bin
rm -rf ./logs

# Create necessary directories
mkdir -p logs
mkdir -p data

# Parse command line arguments
VERBOSE=false
PATTERN=""
FILTER=""
EXCLUDE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -p|--pattern)
            PATTERN="$2"
            shift 2
            ;;
        -f|--filter)
            FILTER="$2"
            shift 2
            ;;
        -e|--exclude)
            EXCLUDE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -v, --verbose     Enable verbose output"
            echo "  -p, --pattern     Run tests matching pattern"
            echo "  -f, --filter      Run tests with specific tag"
            echo "  -e, --exclude     Exclude tests with specific tag"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Build the test executable
echo -e "${YELLOW}🔨 Building test suite...${NC}"
if ! odin build . -out:ostrich_tests; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"

# Set environment variables for tests
export OSTRICH_ENV=development
export OSTRICH_LOG_LEVEL=ERROR  # Reduce log noise during tests

# Run the tests
echo -e "${YELLOW}🚀 Running tests...${NC}"
echo ""

# Start timing
START_TIME=$(date +%s)

# Run with different options based on arguments
if [ "$VERBOSE" = true ]; then
    ./ostrich_tests --verbose
else
    ./ostrich_tests
fi

# Capture exit code
TEST_EXIT_CODE=$?

# End timing
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo -e "${BLUE}⏱️  Total test time: ${DURATION}s${NC}"

# Cleanup
echo -e "${YELLOW}🧹 Cleaning up test artifacts...${NC}"
rm -rf ./test_user_*
rm -f ./ostrich_tests

# Report results
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    echo -e "${GREEN}✅ Test suite completed successfully${NC}"
else
    echo -e "${RED}💥 Some tests failed!${NC}"
    echo -e "${RED}❌ Test suite failed with exit code: $TEST_EXIT_CODE${NC}"
fi

exit $TEST_EXIT_CODE