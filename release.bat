@echo off
setlocal

SET "WINRAR=C:\Program Files\WinRAR\WinRAR.exe"
SET "RELEASE_DIR=release"

SET "EN_NAME=Strat Tester BO2"
SET "ES_NAME=Strat Tester BO2 Espanol"
SET "PT_NAME=Strat Tester BO2 PT-BR"
SET "GL_NAME=Strat Tester BO2 Galego"

if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"

if exist "%RELEASE_DIR%\mod.iwd" del /Q "%RELEASE_DIR%\mod.iwd"

"%WINRAR%" a -afzip -r "%RELEASE_DIR%\mod.iwd" "ui\*"

if exist "%RELEASE_DIR%\%EN_NAME%" rmdir /S /Q "%RELEASE_DIR%\%EN_NAME%"
mkdir "%RELEASE_DIR%\%EN_NAME%\zm_strattester"

XCOPY "%RELEASE_DIR%\mod.iwd" "%RELEASE_DIR%\%EN_NAME%\zm_strattester\" /Y
XCOPY "mod.json" "%RELEASE_DIR%\%EN_NAME%\zm_strattester\" /Y
XCOPY "docs\scriptdata" "%RELEASE_DIR%\%EN_NAME%\zm_strattester\scriptdata" /E /I /Y

XCOPY ".\localized\en\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\en\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\en\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\en\zone.str" ".\english\localizedstrings\zone.str" /Y

cmd /c builder

XCOPY "zone\mod.ff" "%RELEASE_DIR%\%EN_NAME%\zm_strattester\" /Y

pushd "%RELEASE_DIR%\%EN_NAME%"
"%WINRAR%" a -r "..\%EN_NAME%.rar" "zm_strattester"
popd

rmdir /S /Q "%RELEASE_DIR%\%EN_NAME%"

:: --- VERSIÓN EN ESPAÑOL ---
if exist "%RELEASE_DIR%\%ES_NAME%" rmdir /S /Q "%RELEASE_DIR%\%ES_NAME%"
mkdir "%RELEASE_DIR%\%ES_NAME%\zm_strattester"

XCOPY "%RELEASE_DIR%\mod.iwd" "%RELEASE_DIR%\%ES_NAME%\zm_strattester\" /Y
XCOPY "mod.json" "%RELEASE_DIR%\%ES_NAME%\zm_strattester\" /Y
XCOPY "docs\scriptdata" "%RELEASE_DIR%\%ES_NAME%\zm_strattester\scriptdata" /E /I /Y

XCOPY ".\localized\es\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\es\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\es\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\es\zone.str" ".\english\localizedstrings\zone.str" /Y

cmd /c builder

XCOPY "zone\mod.ff" "%RELEASE_DIR%\%ES_NAME%\zm_strattester\" /Y

pushd "%RELEASE_DIR%\%ES_NAME%"
"%WINRAR%" a -r "..\%ES_NAME%.rar" "zm_strattester"
popd

rmdir /S /Q "%RELEASE_DIR%\%ES_NAME%"

:: --- VERSIÓN EN PORTUGUÉS ---
if exist "%RELEASE_DIR%\%PT_NAME%" rmdir /S /Q "%RELEASE_DIR%\%PT_NAME%"
mkdir "%RELEASE_DIR%\%PT_NAME%\zm_strattester"

XCOPY "%RELEASE_DIR%\mod.iwd" "%RELEASE_DIR%\%PT_NAME%\zm_strattester\" /Y
XCOPY "mod.json" "%RELEASE_DIR%\%PT_NAME%\zm_strattester\" /Y
XCOPY "docs\scriptdata" "%RELEASE_DIR%\%PT_NAME%\zm_strattester\scriptdata" /E /I /Y

XCOPY ".\localized\pt\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\pt\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\pt\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\pt\zone.str" ".\english\localizedstrings\zone.str" /Y

cmd /c builder

XCOPY "zone\mod.ff" "%RELEASE_DIR%\%PT_NAME%\zm_strattester\" /Y

pushd "%RELEASE_DIR%\%PT_NAME%"
"%WINRAR%" a -r "..\%PT_NAME%.rar" "zm_strattester"
popd

rmdir /S /Q "%RELEASE_DIR%\%PT_NAME%"

:: --- VERSIÓN EN GALEGO ---
if exist "%RELEASE_DIR%\%GL_NAME%" rmdir /S /Q "%RELEASE_DIR%\%GL_NAME%"
mkdir "%RELEASE_DIR%\%GL_NAME%\zm_strattester"

XCOPY "%RELEASE_DIR%\mod.iwd" "%RELEASE_DIR%\%GL_NAME%\zm_strattester\" /Y
XCOPY "mod.json" "%RELEASE_DIR%\%GL_NAME%\zm_strattester\" /Y
XCOPY "docs\scriptdata" "%RELEASE_DIR%\%GL_NAME%\zm_strattester\scriptdata" /E /I /Y

XCOPY ".\localized\gl\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\gl\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\gl\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\gl\zone.str" ".\english\localizedstrings\zone.str" /Y

cmd /c builder

XCOPY "zone\mod.ff" "%RELEASE_DIR%\%GL_NAME%\zm_strattester\" /Y

pushd "%RELEASE_DIR%\%GL_NAME%"
"%WINRAR%" a -r "..\%GL_NAME%.rar" "zm_strattester"
popd

rmdir /S /Q "%RELEASE_DIR%\%GL_NAME%"
del /Q "%RELEASE_DIR%\mod.iwd"

endlocal
