#!/bin/bash
APP_VERSION=$(cat "application.properties" | grep app.version | cut -d "=" -f2-)
TSTAMP=$(date +%Y%m%d%H%M%S%Z)
mkdir -p ${HOME}/.ivy2/cache/
mkdir -p ${HOME}/.grails/1.3.8/projects/project/stage/WEB-INF/
cp -pv /project/web-app/WEB-INF/applicationContext.xml ${HOME}/.grails/1.3.8/projects/project/stage/WEB-INF/applicationContext.xml
docker run -it -v ${PWD}:/project -v ${HOME}/.grails/:/root/.grails/  -v ${HOME}/.ivy2/:/root/.ivy2/ \
    ghcr.io/openetude/grailsbuilder:1.3.8-1.2 /bin/bash -c \
    "grails set-version ${APP_VERSION}.${GITHUB_RUN_ID}_${TSTAMP} && grails prod war"