#!/bin/sh
  
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH=$(dirname "${SCRIPT_PATH}")

CLANG_FORMAT_BIN_PATH="clang-format"
AUTOCORRECT="YES"

pushd "${PROJECT_PATH}" > /dev/null || error "Executing \`pushd\` failed"

if [ "$1" == "lint" ]; then
    AUTOCORRECT="NO"
fi
  
CONTAINS_BAD_FILE='NO'
BAD_FILES=''
  
for folder in Source
do
    OLDIFS=$IFS
    IFS=$'\n'
  
    files=$(find "${PROJECT_PATH}/${folder}" -type f \( -name "*.m" -or -name "*.h" -or  -name "*.mm" \))
  
    for file in $files
    do
        if [ $AUTOCORRECT == "YES" ]; then
             "${CLANG_FORMAT_BIN_PATH}" -i -style=file "$file"
        else
             isvalid=$("${CLANG_FORMAT_BIN_PATH}" -style=file -output-replacements-xml "$file" | grep "<replacement " || true)
             if [ "$isvalid" != "" ]; then
  
                CONTAINS_BAD_FILE='YES'
                if [ "${BAD_FILES}" == "" ]; then
                    BAD_FILES="${file}"
                else
                    BAD_FILES="${BAD_FILES}\n${file}"
                fi
             fi
        fi
    done
  
    IFS=$OLDIFS
done

popd > /dev/null || error "Executing \`popd\` failed"

if [ $CONTAINS_BAD_FILE == 'YES' ]; then
    OLDIFS=$IFS
    IFS=$'\n'
    for file in $BAD_FILES
    do
        echo "Fix code style of $file, by executing 'sh ./scripts/clang-format.sh'"
    done
    IFS=$OLDIFS
    exit 1
fi