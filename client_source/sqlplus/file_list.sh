#!/bin/bash
set -e

clientPath=${1%/}
projectPath=${2%/}
scanPath=$3
outFileName=$4
sqlParamName=$5

# All parameters are required.
invalidArgs=0
[ -z "$clientPath"   ] && invalidArgs=1
[ -z "$projectPath"  ] && invalidArgs=1
[ -z "$scanPath"     ] && invalidArgs=1
[ -z "$outFileName"  ] && invalidArgs=1
[ -z "$sqlParamName" ] && invalidArgs=1

if [ $invalidArgs -eq 1 ]; then
    echo Usage: ut_run.sh "client_path" "project_path" "scan_path" "out_file_name" "sql_param_name"
    exit 1
fi

fullOutPath="$clientPath/$outFileName"
fullScanPath="$projectPath/$scanPath"

# If scan path was -, bypass the file list generation.
if [ "$scanPath" == "-" ]; then
    echo "begin" > $fullOutPath
    echo "  open :$sqlParamName for select null from dual;" >> $fullOutPath
    echo "end;" >> $fullOutPath
    echo "/" >> $fullOutPath
    exit 0
fi

echo "begin" > $fullOutPath
echo "  open :$sqlParamName for select * from table(ut_varchar2_list(" >> $fullOutPath
for f in $(find $fullScanPath/* -type f | sed "s|$projectPath/||"); do
    echo "      '$f'," >> $fullOutPath
done
echo "      null));" >> $fullOutPath
echo "end;" >> $fullOutPath
echo "/" >> $fullOutPath
