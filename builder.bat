@echo off

set MOD_NAME=zm_strattester
set OAT_BASE=C:\OAT
set MOD_BASE=%cd%
set WINRAR=C:\Program Files\WinRAR\WinRAR.exe

"%OAT_BASE%\linker.exe" --base-folder "%OAT_BASE%" --asset-search-path "%MOD_BASE%" --source-search-path "%MOD_BASE%\zone_source" --output-folder "%MOD_BASE%\zone" mod

set err=%ERRORLEVEL%

if %err% EQU 0 (

if exist "%MOD_BASE%\mod.iwd" del /Q "%MOD_BASE%\mod.iwd"

pushd "%MOD_BASE%"
"%WINRAR%" a -afzip -r "mod.iwd" "ui\*"
popd

XCOPY "%MOD_BASE%\zone\mod.ff" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\mod.ff" /Y
XCOPY "%MOD_BASE%\mod.json" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\mod.json" /Y
XCOPY "%MOD_BASE%\mod.iwd" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\mod.iwd" /Y
XCOPY "%MOD_BASE%\docs\scriptdata" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\scriptdata" /E /I /Y

del /Q "%MOD_BASE%\mod.iwd"

) ELSE (
COLOR C
echo FAIL!
pause
)
