@echo off

rem We use FPC to found out the Platform and OS to create a lib output path
c:\PROGRAMS\FPC\BIN\GO32V2\fpc -iTP > tmpvar
set /p myplatform= < tmpvar
c:\PROGRAMS\FPC\BIN\GO32V2\fpc -iTO > tmpvar
set /p myos= < tmpvar
del tmpvar

if exist ..\lib\%myplatform%-%myos%\nul.x goto exists

echo Creating missing directory ..\lib\%myplatform%-%myos%
mkdir ..\lib\%myplatform%-%myos%
goto end

:exists
echo "You've got the correct output lib directory"

:end

f:\FPC\BIN\GO32V2\fpc -Tgo32v2 -dHX_DOS @extrafpc.cfg corelib\hxdos\fpg_tkit.pas -B >cmakhxd.log

