#!/bin/bash

# Directory that contains generated test files.
testdir=./tmp

# For each file in the test directory, run the code blocks as tests.

function process {
  find $testdir -name "*.md" -type f -print0 | while IFS= read -r -d $'\0' file; do
    pytest --codeblocks $file
    # Experimenting with runmd for JavaScript code blocks.
    # npx runmd $file
  done
}

process
