@echo off
cat "%1%\application.properties" | grep app.version | cut -d "=" -f2-
