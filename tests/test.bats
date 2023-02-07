setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-playwright-test
  mkdir -p $TESTDIR
  export PROJNAME=ddev-playwright-test
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-type=php --project-name=${PROJNAME} --docroot=web --create-docroot
  ddev start -y >/dev/null
  cp "${DIR}"/tests/testdata/web/home.php web/home.php
  cp -r "${DIR}"/tests/testdata/yarn ./
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}

  echo "# Basic Curl check" >&3
  CURLVERIF=$(curl https://${PROJNAME}.ddev.site/home.php | grep -o -E "<h1>(.*)</h1>"  | sed 's/<\/h1>//g; s/<h1>//g;' | tr '\n' '#')
  if [[ $CURLVERIF == "The way is clear!#" ]]
    then
      echo "# CURLVERIF OK" >&3
    else
      echo "# CURLVERIF KO"
      echo $CURLVERIF
      exit 1
  fi

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart

  echo "# Yarn install in Playwright container" >&3
  ddev exec -s playwright yarn install --cwd ./var/www/html/yarn --force
  ddev exec -s playwright yarn global add cross-env
  # Work around to be able to delete all files after test (in teardown method)
  ddev exec -s playwright chmod -R 777 /var/www/html/yarn

  echo "# Run a test" >&3
  ddev exec -s playwright yarn --cwd /var/www/html/yarn test --json --outputFile=./.test-results.json "__tests__/1-simple-test.js"

  echo "# Check that there is no pending test" >&3
  cd ${TESTDIR}/yarn
  PENDING_TESTS=$(grep -oP '"numPendingTests":\K(.*),"numRuntimeErrorTestSuites"' .test-results.json | sed  's/,"numRuntimeErrorTestSuites"//g')
  if [[ $PENDING_TESTS == "0" ]]
  then
  echo "# No pending tests: OK" >&3
  else
    echo "There are pending tests: $PENDING_TESTS (KO)"
    exit 1
  fi
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get julienloizelet/ddev-playwright with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get julienloizelet/ddev-playwright
  ddev restart >/dev/null

  echo "# Basic Curl check" >&3
  CURLVERIF=$(curl https://${PROJNAME}.ddev.site/home.php | grep -o -E "<h1>(.*)</h1>"  | sed 's/<\/h1>//g; s/<h1>//g;' | tr '\n' '#')
  if [[ $CURLVERIF == "The way is clear!#" ]]
    then
      echo "# CURLVERIF OK" >&3
    else
      echo "# CURLVERIF KO"
      echo $CURLVERIF
      exit 1
  fi

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart

  echo "# Yarn install in Playwright container" >&3
  ddev exec -s playwright yarn install --cwd ./var/www/html/yarn --force
  ddev exec -s playwright yarn global add cross-env
  # Work around to be able to delete all files after test (in teardown method)
  ddev exec -s playwright chmod -R 777 /var/www/html/yarn

  echo "# Run a test" >&3
  ddev exec -s playwright yarn --cwd /var/www/html/yarn test --json --outputFile=./.test-results.json "__tests__/1-simple-test.js"

  echo "# Check that there is no pending test" >&3
  cd ${TESTDIR}/yarn
  PENDING_TESTS=$(grep -oP '"numPendingTests":\K(.*),"numRuntimeErrorTestSuites"' .test-results.json | sed  's/,"numRuntimeErrorTestSuites"//g')
  if [[ $PENDING_TESTS == "0" ]]
  then
    echo "# No pending tests: OK" >&3
  else
    echo "There are pending tests: $PENDING_TESTS (KO)"
    exit 1
  fi
}