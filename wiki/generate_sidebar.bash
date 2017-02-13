#!/usr/bin/env bash

# generate_sidebar.bash <directory>
#
# Generates a _Sidebar.md listing all the md files in the named directory
#
# Generates a dirname_index.md in the named directory also listing the md files,
# and for each subdirectory also a link to the corresponding subdir_index.md

DIRECTORY=${1:-.}

function echo_files {
    for MDFILE in $1/*.md
    do
        NAME="$(basename "$MDFILE")"
        NAME="${NAME%.*}"
        if [[ "$NAME" != _* ]]; then
            echo "* [${NAME}](${NAME})" >> $2
        fi
    done
}

function echo_directories {
    for DIR in $1/*/
    do
        if [[ -d ${DIR} ]]; then
            NAME="$(basename "$DIR")"
            echo "* [${NAME}/Index](${NAME}_Index)" >> $2
        fi
    done
}

if [[ -d ${DIRECTORY} ]]; then
    DIR_BASENAME=$(basename ${DIRECTORY})

    SIDEBAR_NAME=${DIRECTORY}/_Sidebar.md
    if [[ "${DIRECTORY}" == "." ]]; then
        INDEX_NAME=Home.md
    else
        INDEX_NAME=${DIRECTORY}/${DIR_BASENAME}_Index.md
    fi

    HOME_NAME=${DIRECTORY}/_Home.md

    for RM_FILE in ${SIDEBAR_NAME} ${INDEX_NAME}; do
        if [ -f ${RM_FILE} ]; then
            rm ${RM_FILE}
        fi
    done

    echo_files ${DIRECTORY} ${SIDEBAR_NAME}
    cp ${SIDEBAR_NAME} ${INDEX_NAME}.tmp
    echo_directories ${DIRECTORY} ${INDEX_NAME}.tmp

    if [ -f ${HOME_NAME} ]; then
        cat ${HOME_NAME} ${INDEX_NAME}.tmp > ${INDEX_NAME}
        rm ${INDEX_NAME}.tmp
    else
        mv ${INDEX_NAME}.tmp ${INDEX_NAME}
    fi

    git add ${SIDEBAR_NAME} ${INDEX_NAME}

else
    echo "Not a directory."
fi
