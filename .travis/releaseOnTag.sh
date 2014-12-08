#!/bin/bash
set -ev
if [ -n "${TRAVIS_TAG}" ]; then
  ./gradlew release -PbintrayUsername=${BINTRAY_USERNAME} -PbintrayApiKey=${BINTRAY_API_KEY} -Psigning.password=${SIGNING_PASSWORD} -PsonatypeUsername=${SONATYPE_USERNAME} -PsonatypePassword=${SONATYPE_PASSWORD} -PreleaseVersion=${TRAVIS_TAG}
fi