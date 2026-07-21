@echo off
SET WINRAR="C:\Program Files\WinRAR\rar.exe"
SET MOD_FOLDER="%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling english version...

XCOPY ".\localized\en_st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\en_zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling spanish version...

XCOPY ".\localized\es_st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\es_zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Espanol.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling portuguese version...

XCOPY ".\localized\pt_st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\pt_zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 PT-BR.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"

echo Compiling galician version...

XCOPY ".\localized\gl_st.str" ".\english\localizedstrings\st.str" /Y
XCOPY ".\localized\gl_zone.str" ".\english\localizedstrings\zone.str" /Y

call builder

%WINRAR% a -ep1 "release\Strat Tester BO2 Galego.rar" "%LOCALAPPDATA%\plutonium\storage\t6\mods\zm_strattester"


echo Release completed!

timeout /t 3 /nobreak > nul