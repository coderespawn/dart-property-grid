#!/bin/bash

set -e

#####
# Unit Tests

echo "DumpRenderTree test/test_runner.html"
results=`DumpRenderTree test/test_runner.html 2>&1`

echo "$results" | grep CONSOLE

echo $results | grep 'unittest-suite-success' >/dev/null

echo $results | grep -v 'Exception: Some tests failed.' >/dev/null

#####
# Type Analysis

echo
echo "dart_analyzer lib/*.dart"

results=`dart_analyzer lib/*.dart 2>&1`

echo "$results"

if [ -n "$results" ]; then
    echo "Review the above results"
else
    echo "Passed analysis."
fi
