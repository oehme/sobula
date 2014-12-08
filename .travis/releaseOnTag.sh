#!/bin/bash
set -ev
if [ -n "${TRAVIS_TAG}" ] && ["${TRAVIS_PULL_REQUEST}" = "false"]; then
  ./gradlew release "-PbintrayApiKey=${BINTRAY_API_KEY}" "-Psigning.password=${SIGNING_PASSWORD}" "-PreleaseVersion=${TRAVIS_TAG}"
fi