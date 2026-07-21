@echo off

set MOD_NAME=zm_strattester
set OAT_BASE=C:\OAT
set MOD_BASE=%cd%

"%OAT_BASE%\linker.exe" --base-folder "%OAT_BASE%" --asset-search-path "%MOD_BASE%" --source-search-path "%MOD_BASE%\zone_source" --output-folder "%MOD_BASE%\zone" mod

set err=%ERRORLEVEL%

if %err% EQU 0 (
XCOPY "%MOD_BASE%\zone\mod.ff" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\mod.ff" /Y
XCOPY "%MOD_BASE%\mod.json" "%LOCALAPPDATA%\plutonium\storage\t6\mods\%MOD_NAME%\mod.json" /Y
) ELSE (
COLOR C
echo FAIL!
pause
)