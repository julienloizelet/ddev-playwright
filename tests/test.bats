#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=julienloizelet/ddev-playwright

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p "${HOME}/tmp"
  export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site --docroot=web
  assert_success
  run ddev start -y
  assert_success

  export PW_DIR=${TESTDIR}/tests/Playwright
  cp "${DIR}"/tests/project_root/web/home.php web/home.php
  cp -r "${DIR}"/tests/project_root/tests ./
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

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  ddev restart

  echo "# Install Playwright in container" >&3
  ddev playwright-install

  echo "# Run a test" >&3
  ddev playwright test

  echo "# Test permissions of files written by Playwright container" >&3
  if [[ $(stat -L -c "%a %G %U" ${PW_DIR}/.env) != $(stat -L -c "%a %G %U" ${PW_DIR}/.env.example) ]]
    then
      exit 1
  fi

  echo "# Curl VNC service" >&3
  VNC_HTTP_STATUS=$(curl --write-out '%{http_code}' --silent --output /dev/null https://${PROJNAME}.ddev.site:8444)
  if [[ $VNC_HTTP_STATUS == 200 ]]
    then
      echo "# VNC_HTTP_STATUS OK" >&3
    else
      echo "# VNC_HTTP_STATUS KO"
      echo $VNC_HTTP_STATUS
      exit 1
  fi
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get julienloizelet/ddev-playwright with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get julienloizelet/ddev-playwright
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


  echo "# Install Playwright in container" >&3
  ddev playwright-install

  echo "# Run a test" >&3
  ddev playwright test

  echo "# Test permissions of files written by Playwright container" >&3
  if [[ $(stat -L -c "%a %G %U" ${PW_DIR}/.env) != $(stat -L -c "%a %G %U" ${PW_DIR}/.env.example) ]]
    then
      exit 1
  fi

  echo "# Curl VNC service" >&3
  VNC_HTTP_STATUS=$(curl --write-out '%{http_code}' --silent --output /dev/null https://${PROJNAME}.ddev.site:8444)
  if [[ $VNC_HTTP_STATUS == 200 ]]
    then
      echo "# VNC_HTTP_STATUS OK" >&3
    else
      echo "# VNC_HTTP_STATUS KO"
      echo $VNC_HTTP_STATUS
      exit 1
  fi
}


@test "install with yarn" {
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

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  ddev restart

  echo "# Install Playwright in container with yarn" >&3
  ddev playwright-install --pm yarn

  echo "# Run a test" >&3
  ddev playwright test

  echo "# Test yarn lock file" >&3
  cd tests/Playwright
  if [ -f "yarn.lock" ]; then
        echo "Yarn appears to have been used: OK"
  else
        echo "Yarn lock file not found: KO"
        exit 1
  fi
}

@test "install with npm" {
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

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  ddev restart

  echo "# Install Playwright in container with npm" >&3
  ddev playwright-install --pm npm

  echo "# Run a test" >&3
  ddev playwright test

  echo "# Test npm lock file" >&3
  cd tests/Playwright
  if [ -f "package-lock.json" ]; then
        echo "Npm appears to have been used: OK"
  else
        echo "Npm lock file not found: KO"
        exit 1
  fi
}
