#!/bin/bash
source /root/.sdkman/bin/sdkman-init.sh
APP_VERSION=$(cat "application.properties" | grep app.version | cut -d "=" -f2-)
TSTAMP=$(date +%Y%m%d%H%M%S%Z)
yes | docker run -it -v ${PWD}:/project -v ${HOME}/.grails/:/root/.grails/  -v ${HOME}/.m2/:/root/.m2/ ghcr.io/openetude/grailsbuilder:main grails upgrade && \
docker run -it -v ${PWD}:/project -v ${HOME}/.grails/:/root/.grails/  -v ${HOME}/.m2/:/root/.m2/ ghcr.io/openetude/grailsbuilder:main grails set-version ${APP_VERSION}.${GITHUB_RUN_ID}_${TSTAMP} && \
docker run -it -v ${PWD}:/project -v ${HOME}/.grails/:/root/.grails/  -v ${HOME}/.m2/:/root/.m2/ ghcr.io/openetude/grailsbuilder:main grails prod war