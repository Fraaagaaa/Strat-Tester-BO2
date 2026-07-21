@echo off
SET WINRAR="C:\Program Files\WinRAR\rar.exe"
SET MOD_FOLDER="%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling english version...

XCOPY ".\localized\en\st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\en\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling spanish version...

XCOPY ".\localized\es\st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\es\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Espanol.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling portuguese version...

XCOPY ".\localized\pt\st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\pt\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 PT-BR.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling galician version...

XCOPY ".\localized\gl\st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\gl\zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Galego.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"


echo Release completed!

timeout /t 3 /nobreak > nul