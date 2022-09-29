FROM tomcat:7-alpine as tomcat-fresh
RUN rm -Rf $CATALINA_HOME/webapps/* 
RUN apk add --no-cache bash sudo p7zip postgresql-client

FROM tomcat-fresh as war-expanded
COPY target/etude.war $CATALINA_HOME/webapps/ROOT.war
RUN echo "org.apache.catalina.startup.ContextConfig.jarsToSkip=*" >> $CATALINA_HOME/conf/catalina.properties && \
    echo "org.apache.catalina.startup.TldConfig.jarsToSkip=*" >> $CATALINA_HOME/conf/catalina.properties && \
    echo "tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*" >> $CATALINA_HOME/conf/catalina.properties && \
    echo "tomcat.util.scan.DefaultJarScanner.jarsToSkip=*" >> $CATALINA_HOME/conf/catalina.properties && \
    mkdir $CATALINA_HOME/webapps/ROOT/ && \
    unzip $CATALINA_HOME/webapps/ROOT.war -d $CATALINA_HOME/webapps/ROOT && \
    rm -Rf $CATALINA_HOME/webapps/ROOT.war

FROM tomcat-fresh
ENV JAVA_OPTS "-Dorg.quartz.properties=classpath:quartz.properties -Dserver.tomcat.uri-encoding=utf-8 -Dstringchararrayaccessor.disabled=true -Djava.awt.headless=true -Duser.language=fr -Duser.country=FR -Dsqlfile.charset=UTF-8 -Dfile.encoding=UTF-8 -Duser.timezone=Etc/GMT-1 -server -Xms512m -XX:PermSize=128m -Xmx512m -XX:MaxPermSize=128m -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=30 -noverify -Xshare:off -XX:+UseParallelGC"

COPY docker/context.xml docker/server.xml $CATALINA_HOME/conf/
COPY docker/check-restore-and-run.sh docker/cli/ /home/etude/
COPY db/vanilla/ /root/arkilog/database/vanilla/
RUN mkdir -p /home/etude/ && \
    chmod +x -v /home/etude/*.sh && \
	rm -Rf $CATALINA_HOME/lib/tomcat-i18n-ja.jar && \
	rm -Rf $CATALINA_HOME/lib/tomcat-i18n-fr.jar && \
	rm -Rf $CATALINA_HOME/lib/tomcat-i18n-es.jar && \
	rm -Rf $CATALINA_HOME/lib/catalina-tribes.jar && \
	rm -Rf $CATALINA_HOME/lib/catalina-ha.jar && \
	rm -Rf $CATALINA_HOME/lib/catalina-ant.jar && \
	rm -Rf $CATALINA_HOME/lib/websocket-api.jar && \
	rm -Rf $CATALINA_HOME/lib/tomcat7-websocket.jar && \
	rm -Rf $CATALINA_HOME/lib/tomcat-i18n-ru.jar
COPY --from=war-expanded $CATALINA_HOME/webapps/ROOT/ $CATALINA_HOME/webapps/ROOT/
COPY --from=war-expanded $CATALINA_HOME/conf/catalina.properties $CATALINA_HOME/conf/catalina.properties

VOLUME ["$CATALINA_HOME/logs","$CATALINA_HOME/work","$CATALINA_HOME/temp","/root/arkilogbackup/","/root/.java/","/tmp/"]

HEALTHCHECK --interval=5m --timeout=20s --start-period=2m --retries=3 CMD wget --quiet --tries=1 --spider http://localhost:8080/auth/hc || exit 1

WORKDIR /home/etude

CMD ["/usr/local/tomcat/bin/catalina.sh","run"]