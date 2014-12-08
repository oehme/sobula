#!/bin/bash
set -ev
if [ -n "${TRAVIS_TAG}" ]; then
  ./gradlew release"-PbintrayApiKey=${BINTRAY_API_KEY}" "-Psigning.password=${SIGNING_PASSWORD}" "-PsonatypePassword=${SONATYPE_PASSWORD}" "-PreleaseVersion=${TRAVIS_TAG}"
fi