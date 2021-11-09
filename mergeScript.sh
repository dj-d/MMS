#!/bin/bash

# TODO: To fix double compression request

LIST_FILE_NAME="mylist.txt"
ORIGINAL_DIR_NAME="original"
MERGED_FILE_NAME="merged.mp4"
COMPRESSED_FILE_NAME="compressed.m4v"

COMPRESS_FILE=false
USE_GPU=false

PATH_FOLDER=""

function help() {
    echo "HELP"
    exit 1
}

# PARAMS
#
# $1 -> Use GPU
# $2 -> Source file
# $3 -> Output file
function compress() {
    if [ "$1" = true ]
        then
            ffmpeg -hwaccel cuda -i "$2" "$3"
        else
            ffmpeg -i "$2" "$3"
        fi;
}

# PARAMS
#
# $1 -> File list
# $2 -> Output file
function merge() {
    ffmpeg -f concat -safe 0 -i "$1" -c copy "$2"
}

# PARAMS
#
# $1 -> Folder path
# $2 -> Use GPU
function explore() {
    for file in "$1"/*
        do
            file_name="$(basename -- "$file")"

            if ! [ -d "$file" ]
                then
                    if [ "$file_name" != $LIST_FILE_NAME ] && [ "$file_name" != $MERGED_FILE_NAME ] && [ "$file_name" != $COMPRESSED_FILE_NAME ]
                        then
                            for video in "$1"/*
                                do
                                    file_name="$(basename -- "$video")"

                                    if [ "$file_name" != "$ORIGINAL_DIR_NAME" ] && [ "$file_name" != $LIST_FILE_NAME ] && [ "$file_name" != $MERGED_FILE_NAME ] && [ "$file_name" != $COMPRESSED_FILE_NAME ]
                                        then
                                            echo "file '$video'" >> $LIST_FILE_NAME
                                        fi
                                done

                            merge $LIST_FILE_NAME $MERGED_FILE_NAME

                            mkdir -p original

                            for video in "$1"/*
                                do
                                    file_name="$(basename -- "$video")"

                                    if [ "$file_name" != "$ORIGINAL_DIR_NAME" ] && [ "$file_name" != $LIST_FILE_NAME ] && [ "$file_name" != $MERGED_FILE_NAME ] && [ "$file_name" != $COMPRESSED_FILE_NAME ]
                                        then
                                            mv "$video" $ORIGINAL_DIR_NAME/.
                                        fi
                                done

                            if $COMPRESS_FILE
                                then
                                    compress $USE_GPU $MERGED_FILE_NAME $COMPRESSED_FILE_NAME
                                fi;
                        fi;
                else
                    if [ "$file_name" != "$ORIGINAL_DIR_NAME" ]
                        then
                            cd "$file" || exit

                            explore "$file"
                        fi;
                fi
        done
}

# PARAMS
#
# $1 -> Folder path
# $2 -> Use GPU
function main() {
    if [ -z "$1" ]
        then
            echo "Empty path"

            exit 0
        fi;
    
    explore "$1" "$2"

    exit 0
}

while getopts "p:cgh" option ; 
    do
        case "${option}" in
            p)
                PATH_FOLDER="${OPTARG}"
                echo "$PATH_FOLDER"
                ;;
            c)
                COMPRESS_FILE=true
                echo "$COMPRESS_FILE"
                ;;
            g)
                USE_GPU=true
                echo "$USE_GPU"
                ;;
            h | *)
                help
                ;;
        esac
    done

shift $((OPTIND-1))

main "$PATH_FOLDER" "$COMPRESS_FILE"