#!/bin/bash

LIST_FILE_NAME="mylist.txt"
ORIGINAL_DIR_NAME="original"
MERGED_FILE_NAME="merged.mp4"
COMPRESSED_FILE_NAME="compressed.m4v"

COMPRESS_FILE=false

PATH_FOLDER=""

function help() {
    echo "HELP"
    exit 1
}

function compress() {
    if [ "$1" = true ]
        then
            ffmpeg -hwaccel cuda -i "$2" "$3"
        else
            ffmpeg -i "$2" "$3"
        fi;
}

function merge() {
    ffmpeg -f concat -safe 0 -i "$1" -c copy "$2"
}

while getopts "p:ch" option ; 
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
            h | *)
                help
                ;;
        esac
    done

shift $((OPTIND-1))