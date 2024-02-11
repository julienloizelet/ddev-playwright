setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-playwright-test
  export PW_DIR=${TESTDIR}/tests/Playwright
  mkdir -p $TESTDIR
  export PROJNAME=ddev-playwright-test
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-type=php --project-name=${PROJNAME} --docroot=web --create-docroot
  ddev start -y >/dev/null
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

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
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

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
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

  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
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
