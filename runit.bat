call grails prod war
call rm -v %CATALINA_HOME%\webapps\etude.war
call mv -v target/etude*.war %CATALINA_HOME%\webapps\etude.war
call rm -R %CATALINA_HOME%\webapps\etude
call %CATALINA_HOME%\bin\startup.bat
