@echo off
SET WINRAR="C:\Program Files\WinRAR\rar.exe"
SET MOD_FOLDER="%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

XCOPY ".\localized\st_watermark.str" ".\english\localizedstrings\st_watermark.str" /Y

echo Compiling english version...

XCOPY ".\localized\en\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\en\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\en\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\en\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling spanish version...

XCOPY ".\localized\es\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\es\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\es\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\es\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Espanol.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling portuguese version...

XCOPY ".\localized\pt\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\pt\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\pt\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\pt\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 PT-BR.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling galician version...

XCOPY ".\localized\gl\st_hud.str" ".\english\localizedstrings\st_hud.str" /Y
XCOPY ".\localized\gl\st_menu.str" ".\english\localizedstrings\st_menu.str" /Y
XCOPY ".\localized\gl\st_perks.str" ".\english\localizedstrings\st_perks.str" /Y
XCOPY ".\localized\gl\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Galego.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"


echo Release completed!
