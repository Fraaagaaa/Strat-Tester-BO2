@echo off

set OAT_BASE=C:\OAT
set WINRAR=C:\Program Files\WinRAR\WinRAR.exe
set PLUTONIUM_MODS=%LOCALAPPDATA%\Plutonium\storage\t6\mods

set MOD_NAME=zm_strattester
set MOD_BASE=%cd%

"%OAT_BASE%\linker.exe" --base-folder "%OAT_BASE%" --asset-search-path "%MOD_BASE%" --source-search-path "%MOD_BASE%\zone_source" --output-folder "%MOD_BASE%\zone" mod

set err=%ERRORLEVEL%

if %err% EQU 0 (

if exist "%MOD_BASE%\mod.iwd" del /Q "%MOD_BASE%\mod.iwd"

pushd "%MOD_BASE%"
"%WINRAR%" a -afzip -r "mod.iwd" "ui\*" "ui_mp\*"
popd

XCOPY "%MOD_BASE%\zone\mod.ff" "%PLUTONIUM_MODS%\%MOD_NAME%\mod.ff" /Y
XCOPY "%MOD_BASE%\mod.json" "%PLUTONIUM_MODS%\%MOD_NAME%\mod.json" /Y
XCOPY "%MOD_BASE%\mod.iwd" "%PLUTONIUM_MODS%\%MOD_NAME%\mod.iwd" /Y
XCOPY "%MOD_BASE%\docs\scriptdata" "%PLUTONIUM_MODS%\%MOD_NAME%\scriptdata" /E /I /Y

del /Q "%MOD_BASE%\mod.iwd"
rd /s /q "%MOD_BASE%\zone"

) ELSE (
COLOR C
echo FAIL!
pause
)
