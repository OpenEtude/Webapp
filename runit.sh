#!/bin/bash
#eval "$(aws ecr get-login --no-include-email)"
export APPTYPE=etude
export TENANT=sm
export APPVERSION=1.0.0
export IMAGE_URL=754835769352.dkr.ecr.eu-central-1.amazonaws.com/arkilog-beta-etude:1.0.0
docker pull $IMAGE_URL
docker run --rm -it --name $APPTYPE$TENANT \
  --expose 9010 \
  -p 8080:8080 \
  -p 9010:9010 \
  -e RDS_HOSTNAME=192.168.99.100 \
  -e JAVA_OPTS="-Djava.rmi.server.hostname=192.168.99.100 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dserver.tomcat.uri-encoding=utf-8 -Dstringchararrayaccessor.disabled=true -Djava.awt.headless=true -Duser.language=fr -Duser.country=FR -Dsqlfile.charset=UTF-8 -Dfile.encoding=UTF-8 -server -Xms256m -XX:PermSize=64m -Xmx256m -XX:MaxPermSize=64m -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=30 -noverify -Xshare:off -XX:+UseParallelGC" \
  $IMAGE_URL
