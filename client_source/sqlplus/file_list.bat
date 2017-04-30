@echo off
setlocal EnableDelayedExpansion

set clientPath=%~1
set projectPath=%~2
set scanPath=%~3
set outFileName=%~4
set sqlParamName=%~5

REM All parameters are required.
set invalidArgs=0
if "%clientPath%"   == "" set invalidArgs=1
if "%projectPath%"  == "" set invalidArgs=1
if "%scanPath%"     == "" set invalidArgs=1
if "%outFileName%"  == "" set invalidArgs=1
if "%sqlParamName%" == "" set invalidArgs=1

if %invalidArgs% == 1 (
    echo Usage: ut_run.bat "client_path" "project_path" "scan_path" "out_file_name" "sql_param_name"
    exit /b 1
)

REM Remove trailing slashes.
if %clientPath:~-1%==\  set clientPath=%clientPath:~0,-1%
if %projectPath:~-1%==\ set projectPath=%projectPath:~0,-1%

set fullOutPath="%clientPath%\%outFileName%"
set fullScanPath="%projectPath%\%scanPath%"

REM If scan path was -, bypass the file list generation.
if "%scanPath%" == "-" (
    echo begin>%fullOutPath%
    echo ^  open :%sqlParamName% for select null from dual;>>%fullOutPath%
    echo end;>>%fullOutPath%
    echo />>%fullOutPath%
    exit /b 0
)

echo begin>%fullOutPath%
echo ^  open :%sqlParamName% for select * from table(ut_varchar2_list(>>%fullOutPath%
for /f "tokens=* delims= " %%a in ('dir %fullScanPath%\* /B /S /A:-D') do (
    set "filePath=%%a"
    set filePath=!filePath:%projectPath%\=!
    echo ^      '!filePath!^',>>%fullOutPath%
)
echo ^      null));>>%fullOutPath%
echo end;>>%fullOutPath%
echo />>%fullOutPath%
