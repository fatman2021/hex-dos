@echo off

rem We use FPC to found out the Platform and OS to create a lib output path
rem fpc -iTP > tmpvar
rem set /p myplatform= < tmpvar
rem fpc -iTO > tmpvar
rem set /p myos= < tmpvar
rem del tmpvar

rem if exist ..\lib\%myplatform%-%myos%\nul.x goto exists

rem echo Creating missing directory ..\lib\%myplatform%-%myos%
rem mkdir ..\lib\%myplatform%-%myos%
rem goto end

rem :exists
rem echo "You've got the correct output lib directory"

rem :end

rem e:\lazarus\fpc\3.0.0\bin\go32v2\fpc -dHX_DOS @extrafpc.cfg corelib\gdi\fpgui_toolkit.pas >compile.log
g:\fpcw -Tgo32v2 @extrafpc.cfg corelib\hxdos\fpgui_toolkit.pas >compilew.log

