#!/bin/bash
set -e

echo "🔨 Building OstrichTest Framework"
echo "================================"

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$DIR")"
cd "$PROJECT_ROOT"

# Check if Odin is installed
if ! command -v odin &> /dev/null; then
    echo "❌ Error: Odin compiler not found!"
    echo "Please install Odin from: https://github.com/odin-lang/Odin"
    exit 1
fi

echo "✅ Odin compiler found: $(odin version)"

# Build and run framework test
echo "🧪 Building framework test..."
cd tests
if odin build . -out:framework_test; then
    echo "✅ Framework test built successfully"
    echo "🏃 Running framework test..."
    ./framework_test

    if [ $? -eq 0 ]; then
        echo "✅ Framework test passed!"
    else
        echo "❌ Framework test failed!"
        exit 1
    fi
else
    echo "❌ Framework test build failed!"
    exit 1
fi


cd "$PROJECT_ROOT"
echo "🎉 Build completed successfully!"