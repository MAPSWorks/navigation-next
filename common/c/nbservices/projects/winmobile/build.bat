@ECHO OFF
python build\winmobile\build.py %1 %2 %3 %4 %5 %6 %7 %8 %9 "DOXY:%DOXYGEN%"

SET MAINDIR=%CD%

SET /p DIR= <build\winmobile\prof.txt

cd\
cd %DIR%
call setup_nimnb.bat
cd\

cd %MAINDIR%