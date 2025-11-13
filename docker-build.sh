#!/bin/bash
GRAILS_VERSION=1.3.8
ETUDE_VERSION=1.0.0
chmod +x ./build.sh
docker run --rm -v ${PWD}/:/app -v ~/.grails:/root/.grails -e CI_JOB_ID=$CI_JOB_ID -v ~/.ivy2:/root/.ivy2/ notaires/cloud/etude-builder
docker build -t notaires/etude:$ETUDE_VERSION .
