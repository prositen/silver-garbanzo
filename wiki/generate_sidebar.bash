#!/usr/bin/env bash

# generate_sidebar.bash <directory>
#
# Generates a _Sidebar.md listing all the md files in the named directort

DIRECTORY=${1:-.}

if [[ -d ${DIRECTORY} ]]; then
    if [ -f ${DIRECTORY}/_Sidebar.md ]; then
        rm ${DIRECTORY}/_Sidebar.md
    fi

    for MDFILE in ${DIRECTORY}/*.md
    do
        NAME="$(basename "$MDFILE")"
        NAME="${NAME%.*}"
        echo ${NAME}
        echo "* [${NAME}](${NAME})" >> ${DIRECTORY}/_Sidebar.md
    done
    git add ${DIRECTORY}/_Sidebar.md
else
    echo "Not a directory."
fi
