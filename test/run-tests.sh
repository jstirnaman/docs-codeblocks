#!/bin/bash

$(./test/generate-tests.sh -f ./examples -a)

# Directory that contains generated test files.
testdir=./tmp

# For each file in the test directory, run the code blocks as tests.
# See configuration files for included patterns:
#   - pytest.ini
function process {
  echo "Running pytest for Python and shell files in $testdir"
  pytest --codeblocks $testdir
}

process
