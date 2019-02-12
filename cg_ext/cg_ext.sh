#!/bin/bash
#
# cg_ext.sh
# Author: Tairan Andreo
# Git: github.com/taandreo/
#
# This program is a script to change the file extension on a large scale.
#
# Version 1.0: Added support for options -V | --version and -h --help.
# Version 2.0: Added support for option -v | --verbose.
# Version 3.0: Added support for -i and -o options. 
# Version 4.0: Added support for -r and -maxdepth options. 

NAME=$(basename "$0")       # Program name

# Flags:

VERBOSE=0
MAX_DEPTH=1
RECURSIVE=0

HELP="Usage: $NAME [OPTIONS] -i .ext -o .ext2

OPTIONS:

    -i              Original extension
    -o              Final extension

    -h, --help      Print this help summary page.
    -V, --version   Print the version.
    -v              Enable Verbose.

    -maxdepth       Define de max depth.
    -r              Enable recursive mode.

    EXAMPLES:
    
    $NAME -i .zip -o .cbz       Change the extension .zip to .cbz for all files in this directory.
    $NAME -i .zip -o .cbz -v    Change the extension .zip to .cbz for all files in this directory and show each altered file.
"

is_ext(){
    regex='^\.[[:alnum:]][.[:alnum:]]*'
    if !([[ "$1" =~ $regex ]])
    then
        echo "Invalid Argument: \"$1\"."
        echo "The argument must be a filename extension."
        exit 1
    fi
}

test_options(){
    if !(test -n "$1")
    then
        echo "-i option required."
    fi

    if !(test -n "$2")
    then
        echo "-o option required."
    fi
    
    if !(test -n "$1" & test -n "$2")
    then
        exit 1
    fi
}

if !(test -n "$1")
then 
    echo "$HELP"
    exit 0
fi

while test -n "$1"
do
    case "$1" in

        -h | --help)
            echo "$HELP"
            exit 0
        ;;

        -V | --version)
            echo -n $NAME
            egrep '^# Version' "$0" | tail -1 | cut -d : -f 1 | tr -d \# # Extract the version from the reader
            exit 0
        ;;
        
        -v)
            VERBOSE=1
        ;;
        
        -i)
            shift
            is_ext "$1" # Checks if the passed argument is a filename extension.  
            INPUT_EXT=$1
        ;;
        
        -o)
            shift
            is_ext "$1" # Checks if the passed argument is a filename extension.
            OUTPUT_EXT=$1
        ;;

        -maxdepth)
            shift
            MAX_DEPTH=$1
        ;;
        
        -r)
            RECURSIVE=1
        ;;
            

        *)
            if test -n "$1"
            then
                echo "Invalid option: $1"
                exit 1
            fi
        ;;
    esac
    shift
done


test_options $INPUT_EXT $OUTPUT_EXT

if test $RECURSIVE = 1
then
    find . -regex "^.*\\$INPUT_EXT\$" > cache_find
else
    find . -maxdepth $MAX_DEPTH -regex "^.*\\$INPUT_EXT\$" > cache_find
fi

while read f
do
    if test $VERBOSE = 1
    then
        echo $f
    fi
    mv -- "$f" "${f%$INPUT_EXT}$OUTPUT_EXT"
done < cache_find

rm -f cache_find
