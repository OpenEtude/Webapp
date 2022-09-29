@echo off
setlocal enabledelayedexpansion
for /f %%i in ('%CD%\appv.cmd %CD%') do set CURR_VER=%%i
@rem Set CURR_VER=5.0.50
FOR /F "tokens=1-3 delims=." %%I IN ("%CURR_VER%") DO (
   Set NUM=%%K
   Set /A NUM+=1
   Set NEW_VERSION=%%I.%%J.!NUM!
)
echo Next Build Num is !NEW_VERSION!
echo Looks good, let's see if we can distribute...
 if DEFINED %1 (
	echo ****************************************************************
	echo *              Please provide a commit message!                *
	echo ****************************************************************
 ) else (
 	echo Commit message given...
 	echo. 
 	echo             OK gonna distribute, stay tuned ...
 	echo.
	grails set-version %NEW_VERSION% && git add --all && git commit -m "%NEW_VERSION% : %1 %2 %3 %4 %5 %6 %7" && git push origin master
)


