#!/bin/bash
# Run test suite
# Usage: ./run-tests.sh  <file-list>
# type : host, docker or ci (default: host)
# file-list : a list of test files (default: empty so it will run all the tests)
# Example: ./run-tests.sh "./__tests__/1-some-test.js"

FILE_LIST=${1:-""}

HOSTNAME=$(ddev exec printenv DDEV_HOSTNAME | sed 's/\r//g')
PHP_URL=https://$HOSTNAME
JEST_PARAMS="--bail=true  --runInBand --verbose"
DEBUG_STRING="DEBUG=pw:api"
YARN_PATH="./var/www/html/yarn"
COMMAND="ddev exec -s playwright xvfb-run --auto-servernum -- yarn --cwd ${YARN_PATH} cross-env"
TIMEOUT=60000
HEADLESS=true
SLOWMO=0
# If FAIL_FAST, will exit on first individual test fail
# @see CustomEnvironment.js
FAIL_FAST=true

# Run command
$COMMAND \
PHP_URL="$PHP_URL" \
$DEBUG_STRING \
TIMEOUT=$TIMEOUT \
HEADLESS=$HEADLESS \
FAIL_FAST=$FAIL_FAST \
SLOWMO=$SLOWMO \
yarn --cwd $YARN_PATH test \
    "$JEST_PARAMS" \
    --json \
    --outputFile=./.test-results.json \
    "$FILE_LIST"
