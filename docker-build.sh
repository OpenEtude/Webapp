#!/bin/bash
GRAILS_VERSION=1.3.8
ETUDE_VERSION=1.0.0
REG_URL=754835769352.dkr.ecr.eu-central-1.amazonaws.com/arkilog/etude
chmod +x ./build.sh
docker run --rm -v ${PWD}/:/app -v ~/.grails:/root/.grails -e CI_JOB_ID=$CI_JOB_ID -v ~/.ivy2:/root/.ivy2/ $REG_URL/notaires/cloud/etude-builder
docker build -t notaires/etude:$ETUDE_VERSION .
docker push $REG_URL/notaires/etude:$ETUDE_VERSION
